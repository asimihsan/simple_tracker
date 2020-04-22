/*
 * ============================================================================
 *  Copyright 2020 Asim Ihsan. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License in the LICENSE file and at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 * ============================================================================
 */

package main

import (
	"context"
	"encoding/base64"
	"errors"
	"fmt"
	"os"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/kms"
	"github.com/aws/aws-xray-sdk-go/strategy/ctxmissing"
	"github.com/aws/aws-xray-sdk-go/xray"
	"github.com/golang/protobuf/proto"
	"github.com/patrickmn/go-cache"

	simpletracker "lambda/proto"
)

var (
	sess                            *session.Session
	dynamoDbClient                  *dynamodb.DynamoDB
	kmsClient                       *kms.KMS
	userTableName                   string
	sessionTableName                string
	calendarTableName               string
	paginationEphemeralKeyTableName string
	paginationKeyCache 				*cache.Cache
	ErrFailedToBase64DecodeBody     = errors.New("failed to base-64 decode body")
)

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (apiGatewayResponse events.APIGatewayProxyResponse, err error) {
	_ = xray.Capture(ctx, "LambdaHandleRequest", func(ctx1 context.Context) (err error) {
		recordRequestIds(ctx1, request)

		switch request.Path {
		case "/create_user":
			apiGatewayResponse, err = handleCreateUserRequest(ctx1, request)
		case "/login_user":
			apiGatewayResponse, err = handleLoginUserRequest(ctx1, request)
		case "/list_calendars":
			apiGatewayResponse, err = handleListCalendarsRequest(ctx1, request)
		case "/create_calendar":
			apiGatewayResponse, err = handleCreateCalendarRequest(ctx1, request)
		case "/get_calendars":
			apiGatewayResponse, err = handleGetCalendarsRequest(ctx1, request)
		case "/update_calendars":
			apiGatewayResponse, err = handleUpdateCalendarsRequest(ctx1, request)
		case "/delete_calendar":
			apiGatewayResponse, err = handleDeleteCalendarRequest(ctx1, request)
		default:
			apiGatewayResponse = events.APIGatewayProxyResponse{Body: "Unknown API endpoint", StatusCode: 400}
		}
		return
	})
	return
}

func recordRequestIds(ctx context.Context, request events.APIGatewayProxyRequest) {
	apiGatewayRequestId := request.RequestContext.RequestID
	lc, _ := lambdacontext.FromContext(ctx)
	lambdaRequestId := lc.AwsRequestID

	_ = xray.AddAnnotation(ctx, "ApiGatewayRequestId", apiGatewayRequestId)
	_ = xray.AddAnnotation(ctx, "LambdaRequestId", lambdaRequestId)
}

func recordUsername(ctx context.Context, username string) {
	// Due to https://github.com/aws/aws-xray-sdk-go/issues/142 it is not possible to populate the main
	// User annotation for X-Ray traces, so we just make up our own annotation.
	_ = xray.AddAnnotation(ctx, "Username", username)
}

func getRequestBody(request events.APIGatewayProxyRequest) (string, error) {
	if !request.IsBase64Encoded {
		return request.Body, nil
	}
	requestBodyBytes, err := base64.StdEncoding.DecodeString(request.Body)
	if err != nil {
		fmt.Println("failed to base64-decode body")
		return "", ErrFailedToBase64DecodeBody
	}
	return string(requestBodyBytes), nil
}

func handleLoginUserRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	requestBody, err := getRequestBody(request)
	if err != nil {
		fmt.Println("handleLoginUserRequest failed to get body")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to get body", StatusCode: 400}, nil
	}

	loginUserRequest := &simpletracker.LoginUserRequest{}
	if err := proto.Unmarshal([]byte(requestBody), loginUserRequest); err != nil {
		fmt.Println("handleLoginUserRequest failed to parse login user request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to parse login user request proto", StatusCode: 400}, nil
	}
	recordUsername(ctx, loginUserRequest.Username)

	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"

	var loginUserResponse simpletracker.LoginUserResponse

	// 1. Verify username/password combination is valid.
	user, err := handleVerifyUserRequestInner(loginUserRequest, dynamoDbClient, userTableName, ctx)
	if err != nil {
		if err == ErrUserMissingOrPasswordIncorrect {
			fmt.Println("LoginUser handling failed, user missing or password incorrect.")
			loginUserResponse = simpletracker.LoginUserResponse{
				Success:     false,
				ErrorReason: simpletracker.LoginUserErrorReason_USER_MISSING_OR_PASSWORD_INCORRECT,
			}
		} else {
			fmt.Println("LoginUser handling failed, could not verify user.")
			loginUserResponse = simpletracker.LoginUserResponse{
				Success:     false,
				ErrorReason: simpletracker.LoginUserErrorReason_LOGIN_USER_ERROR_REASON_INTERNAL_SERVER_ERROR,
			}
		}
	} else {
		// 2. User/password combination is valid. Create a createdSession.
		fmt.Println("LoginUser successfully validated username and password.")
		createdSession, err := CreateSession(user.Id, dynamoDbClient, sessionTableName, ctx)
		if err != nil {
			fmt.Println("LoginUser failed to create createdSession.")
			loginUserResponse = simpletracker.LoginUserResponse{
				Success:     false,
				ErrorReason: simpletracker.LoginUserErrorReason_LOGIN_USER_ERROR_REASON_INTERNAL_SERVER_ERROR,
			}
		} else {
			// 3. Username/password valid, createdSession created, successful.
			fmt.Println("LoginUser successfully created createdSession.")
			loginUserResponse = simpletracker.LoginUserResponse{
				Success:     true,
				ErrorReason: simpletracker.LoginUserErrorReason_LOGIN_USER_ERROR_REASON_NO_ERROR,
				SessionId:   createdSession.Id,
				UserId:      createdSession.UserId,
			}
		}
	}
	resp, err := proto.Marshal(&loginUserResponse)
	if err != nil {
		fmt.Println("Failed to serialize login user response")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to serialize login user response", StatusCode: 500}, nil
	}

	var statusCode int
	if loginUserResponse.Success == true {
		statusCode = 200
	} else {
		if loginUserResponse.ErrorReason == simpletracker.LoginUserErrorReason_USER_MISSING_OR_PASSWORD_INCORRECT {
			statusCode = 400
		} else {
			statusCode = 500
		}
	}

	return events.APIGatewayProxyResponse{
		Body:            base64.StdEncoding.EncodeToString(resp),
		Headers:         responseHeaders,
		StatusCode:      statusCode,
		IsBase64Encoded: true,
	}, nil
}

func handleCreateUserRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	requestBody, err := getRequestBody(request)
	if err != nil {
		fmt.Println("handleCreateUserRequest failed to get body")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to get body", StatusCode: 400}, nil
	}

	createUserRequest := &simpletracker.CreateUserRequest{}
	if err := proto.Unmarshal([]byte(requestBody), createUserRequest); err != nil {
		fmt.Println("Failed to parse create user request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to parse create user request proto", StatusCode: 400}, nil
	}
	recordUsername(ctx, createUserRequest.Username)

	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"

	createUserResp, err := handleCreateUserRequestInner(
		createUserRequest, dynamoDbClient, userTableName, sessionTableName, ctx)
	if err != nil {
		fmt.Println("CreateUser handling failed.")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "CreateUser handling failed.", StatusCode: 400}, nil
	}
	resp, err := proto.Marshal(createUserResp)
	if err != nil {
		fmt.Println("Failed to serialize create user response")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to serialize create user response", StatusCode: 500}, nil
	}
	return events.APIGatewayProxyResponse{
		Body:            base64.StdEncoding.EncodeToString(resp),
		Headers:         responseHeaders,
		StatusCode:      200,
		IsBase64Encoded: true,
	}, nil
}

func handleListCalendarsRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	requestBody, err := getRequestBody(request)
	if err != nil {
		fmt.Println("handleListCalendarsRequest failed to get body")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to get body", StatusCode: 400}, nil
	}

	listCalendarsRequest := &simpletracker.ListCalendarsRequest{}
	if err := proto.Unmarshal([]byte(requestBody), listCalendarsRequest); err != nil {
		fmt.Println("handleListCalendarsRequest failed to parse list calendars request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to parse list calendars request proto", StatusCode: 400}, nil
	}

	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"

	listCalendarsResp, err := handleListCalendarsRequestInner(
		listCalendarsRequest,
		dynamoDbClient,
		kmsClient,
		sessionTableName,
		calendarTableName,
		paginationKeyCache,
		paginationEphemeralKeyTableName,
		ctx)
	if err != nil {
		fmt.Println("ListCalendars handling failed.")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "ListCalendars handling failed.", StatusCode: 400}, nil
	}
	resp, err := proto.Marshal(listCalendarsResp)
	if err != nil {
		fmt.Println("Failed to serialize create user response")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to serialize create user response", StatusCode: 500}, nil
	}
	return events.APIGatewayProxyResponse{
		Body:            base64.StdEncoding.EncodeToString(resp),
		Headers:         responseHeaders,
		StatusCode:      200,
		IsBase64Encoded: true,
	}, nil
}

func handleCreateCalendarRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	requestBody, err := getRequestBody(request)
	if err != nil {
		fmt.Println("handleCreateCalendarRequest failed to get body")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to get body", StatusCode: 400}, nil
	}

	createCalendarRequest := &simpletracker.CreateCalendarRequest{}
	if err := proto.Unmarshal([]byte(requestBody), createCalendarRequest); err != nil {
		fmt.Println("handleCreateCalendarRequest failed to parse create calendar request request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to parse create calendar request proto", StatusCode: 400}, nil
	}

	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"

	createCalendarResp, err := handleCreateCalendarRequestInner(
		createCalendarRequest,
		dynamoDbClient,
		calendarTableName,
		ctx,
	)
	if err != nil {
		fmt.Println("CreateCalendar handling failed.")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "CreateCalendar handling failed.", StatusCode: 400}, nil
	}
	resp, err := proto.Marshal(createCalendarResp)
	if err != nil {
		fmt.Println("Failed to serialize create calendar response")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to serialize create calendar response", StatusCode: 500}, nil
	}
	return events.APIGatewayProxyResponse{
		Body:            base64.StdEncoding.EncodeToString(resp),
		Headers:         responseHeaders,
		StatusCode:      200,
		IsBase64Encoded: true,
	}, nil
}

func handleGetCalendarsRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	requestBody, err := getRequestBody(request)
	if err != nil {
		fmt.Println("handleGetCalendarsRequest failed to get body")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to get body", StatusCode: 400}, nil
	}

	getCalendarsRequest := &simpletracker.GetCalendarsRequest{}
	if err := proto.Unmarshal([]byte(requestBody), getCalendarsRequest); err != nil {
		fmt.Println("handleGetCalendarsRequest failed to parse request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to parse request proto", StatusCode: 400}, nil
	}

	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"

	getCalendarsResp, err := handleGetCalendarsRequestInner(
		getCalendarsRequest,
		dynamoDbClient,
		calendarTableName,
		ctx,
	)
	if err != nil {
		fmt.Println("GetCalendars handling failed.")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "GetCalendars handling failed.", StatusCode: 400}, nil
	}
	resp, err := proto.Marshal(getCalendarsResp)
	if err != nil {
		fmt.Println("Failed to serialize get calendars response")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to serialize get calendars response", StatusCode: 500}, nil
	}
	return events.APIGatewayProxyResponse{
		Body:            base64.StdEncoding.EncodeToString(resp),
		Headers:         responseHeaders,
		StatusCode:      200,
		IsBase64Encoded: true,
	}, nil
}

func handleUpdateCalendarsRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	requestBody, err := getRequestBody(request)
	if err != nil {
		fmt.Println("handleUpdateCalendarsRequest failed to get body")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to get body", StatusCode: 400}, nil
	}

	updateCalendarsRequest := &simpletracker.UpdateCalendarsRequest{}
	if err := proto.Unmarshal([]byte(requestBody), updateCalendarsRequest); err != nil {
		fmt.Println("handleUpdateCalendarsRequest failed to parse request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to parse request proto", StatusCode: 400}, nil
	}

	_ = xray.AddAnnotation(ctx, "UserId", updateCalendarsRequest.UserId)

	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"

	updateCalendarsResp, err := handleUpdateCalendarsRequestInner(
		updateCalendarsRequest,
		dynamoDbClient,
		sessionTableName,
		calendarTableName,
		ctx,
	)
	if err != nil {
		fmt.Println("UpdateCalendars handling failed.")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "UpdateCalendars handling failed.", StatusCode: 400}, nil
	}
	resp, err := proto.Marshal(updateCalendarsResp)
	if err != nil {
		fmt.Println("Failed to serialize update calendars response")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to serialize update calendars response", StatusCode: 500}, nil
	}
	return events.APIGatewayProxyResponse{
		Body:            base64.StdEncoding.EncodeToString(resp),
		Headers:         responseHeaders,
		StatusCode:      200,
		IsBase64Encoded: true,
	}, nil
}

func handleDeleteCalendarRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	requestBody, err := getRequestBody(request)
	if err != nil {
		fmt.Println("handleDeleteCalendarRequest failed to get body")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to get body", StatusCode: 400}, nil
	}

	deleteCalendarRequest := &simpletracker.DeleteCalendarRequest{}
	if err := proto.Unmarshal([]byte(requestBody), deleteCalendarRequest); err != nil {
		fmt.Println("handleDeleteCalendarRequest failed to parse request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "failed to parse request proto", StatusCode: 400}, nil
	}

	_ = xray.AddAnnotation(ctx, "UserId", deleteCalendarRequest.UserId)
	_ = xray.AddAnnotation(ctx, "CalendarId", deleteCalendarRequest.CalendarId)

	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"

	updateCalendarsResp, err := handleDeleteCalendarRequestInner(
		deleteCalendarRequest,
		dynamoDbClient,
		sessionTableName,
		calendarTableName,
		ctx,
	)
	if err != nil {
		fmt.Println("DeleteCalendar handling failed.")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "DeleteCalendar handling failed.", StatusCode: 400}, nil
	}
	resp, err := proto.Marshal(updateCalendarsResp)
	if err != nil {
		fmt.Println("Failed to serialize delete calendar response")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to serialize delete calendar response", StatusCode: 500}, nil
	}
	return events.APIGatewayProxyResponse{
		Body:            base64.StdEncoding.EncodeToString(resp),
		Headers:         responseHeaders,
		StatusCode:      200,
		IsBase64Encoded: true,
	}, nil
}

func initialize() {
	_ = xray.Configure(xray.Config{
		LogLevel:               "trace",
		ContextMissingStrategy: ctxmissing.NewDefaultLogErrorStrategy(),
	})
	sess = session.Must(session.NewSession())
	dynamoDbClient = dynamodb.New(sess)
	kmsClient = kms.New(sess, aws.NewConfig())
	xray.AWS(dynamoDbClient.Client)
	xray.AWS(kmsClient.Client)

	userTableName = os.Getenv("USER_TABLE_NAME")
	sessionTableName = os.Getenv("SESSION_TABLE_NAME")
	calendarTableName = os.Getenv("CALENDAR_TABLE_NAME")
	paginationEphemeralKeyTableName = os.Getenv("PAGINATION_EPHEMERAL_KEY_TABLE_NAME")

	paginationKeyCache = cache.New(1 * time.Hour, 10 * time.Minute)
}

func main() {
	initialize()
	lambda.Start(handleRequest)
}

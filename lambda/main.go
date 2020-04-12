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
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-xray-sdk-go/strategy/ctxmissing"
	"github.com/aws/aws-xray-sdk-go/xray"
	"github.com/golang/protobuf/proto"

	simpletracker "lambda/proto"
)

var (
	sess             *session.Session
	dynamoDbClient   *dynamodb.DynamoDB
	userTableName    string
	sessionTableName string
)

//var calendarTableName = os.Getenv("CALENDAR_TABLE_NAME")

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (apiGatewayResponse events.APIGatewayProxyResponse, err error) {
	_ = xray.Capture(ctx, "LambdaHandleRequest", func(ctx1 context.Context) (err error) {
		recordRequestIds(ctx1, request)
		switch request.Path {
		case "/create_user":
			apiGatewayResponse, err = handleCreateUserRequest(ctx1, request)
		case "/login_user":
			apiGatewayResponse, err = handleLoginUserRequest(ctx1, request)
		default:
			apiGatewayResponse = events.APIGatewayProxyResponse{Body: "Unknown API endpoint", StatusCode: 200}
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

func handleLoginUserRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"
	loginUserRequest := &simpletracker.LoginUserRequest{}
	if err := proto.Unmarshal([]byte(request.Body), loginUserRequest); err != nil {
		fmt.Println("Failed to parse login user request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to parse login user request proto", StatusCode: 400}, nil
	}
	recordUsername(ctx, loginUserRequest.Username)

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
		Body:            string(resp),
		Headers:         responseHeaders,
		StatusCode:      statusCode,
		IsBase64Encoded: false,
	}, nil
}

func handleCreateUserRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"
	createUserRequest := &simpletracker.CreateUserRequest{}
	if err := proto.Unmarshal([]byte(request.Body), createUserRequest); err != nil {
		fmt.Println("Failed to parse create user request proto")
		_ = xray.AddError(ctx, err)
		return events.APIGatewayProxyResponse{
			Body: "Failed to parse create user request proto", StatusCode: 400}, nil
	}
	recordUsername(ctx, createUserRequest.Username)

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
		Body:            string(resp),
		Headers:         responseHeaders,
		StatusCode:      200,
		IsBase64Encoded: false,
	}, nil
}

func initialize() {
	_ = xray.Configure(xray.Config{
		LogLevel:               "trace",
		ContextMissingStrategy: ctxmissing.NewDefaultLogErrorStrategy(),
	})
	sess = session.Must(session.NewSession())
	dynamoDbClient = dynamodb.New(sess)
	xray.AWS(dynamoDbClient.Client)

	userTableName = os.Getenv("USER_TABLE_NAME")
	sessionTableName = os.Getenv("SESSION_TABLE_NAME")
}

func main() {
	initialize()
	lambda.Start(handleRequest)
}

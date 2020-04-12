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
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/golang/protobuf/proto"
	simpletracker "lambda/proto"

	"github.com/aws/aws-xray-sdk-go/xray"
	"os"
	//"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

var sess = session.Must(session.NewSession())
var dynamoDbClient = dynamodb.New(sess)
var userTableName = os.Getenv("USER_TABLE_NAME")

//var sessionTableName = os.Getenv("SESSION_TABLE_NAME")
//var calendarTableName = os.Getenv("CALENDAR_TABLE_NAME")

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	responseHeaders := make(map[string]string)
	responseHeaders["Content-Type"] = "application/protobuf"
	if request.Path == "/create_user" {
		createUserRequest := &simpletracker.CreateUserRequest{}
		if err := proto.Unmarshal([]byte(request.Body), createUserRequest); err != nil {
			fmt.Println("Failed to parse create user request proto")
			_ = xray.AddError(ctx, err)
			return events.APIGatewayProxyResponse{
				Body: "Failed to parse create user request proto", StatusCode: 400}, nil
		}
		createUserResp, err := handleCreateUserRequest(
			createUserRequest, dynamoDbClient, userTableName, ctx)
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

	return events.APIGatewayProxyResponse{Body: "Unknown API endpoint", StatusCode: 200}, nil

	//fmt.Printf("Processing request data for request %s.\n", request.RequestContext.RequestID)
	//fmt.Printf("Body size = %d.\n", len(request.Body))
	//fmt.Printf("Request path: %s.\n", request.Path)
	//
	//fmt.Println("Headers:")
	//for key, value := range request.Headers {
	//	fmt.Printf("    %s: %s\n", key, value)
	//}
	//
	//if err != nil {
	//	fmt.Println("handleRequest error when creating user")
	//	fmt.Println(err.Error())
	//	return events.APIGatewayProxyResponse{Body: request.Body, StatusCode: 500}, nil
	//}
	//
	//return events.APIGatewayProxyResponse{Body: request.Body, StatusCode: 200}, nil
}

func main() {
	_ = xray.Configure(xray.Config{LogLevel: "trace"})
	xray.AWS(dynamoDbClient.Client)
	lambda.Start(handleRequest)
}

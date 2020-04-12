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

	simpletracker "lambda/proto"
)

func handleVerifyUserRequestInner(
	request *simpletracker.LoginUserRequest,
	dynamoDbClient *dynamodb.DynamoDB,
	userTableName string,
	ctx context.Context,
) (*UserToReturn, error) {
	return VerifyUser(request.Username, request.Password, dynamoDbClient, userTableName, ctx)
}

func handleCreateUserRequestInner(
	request *simpletracker.CreateUserRequest,
	dynamoDbClient *dynamodb.DynamoDB,
	userTableName string,
	sessionTableName string,
	ctx context.Context,
) (*simpletracker.CreateUserResponse, error) {
	user, err := CreateUser(request.Username, request.Password, dynamoDbClient, userTableName, ctx)
	if err != nil {
		fmt.Printf("Failed to create user: %s\n", err.Error())
		if err == ErrUserAlreadyExists {
			return &simpletracker.CreateUserResponse{
				Success:     false,
				ErrorReason: simpletracker.CreateUserErrorReason_USER_ALREADY_EXISTS}, nil
		}
		return &simpletracker.CreateUserResponse{
			Success:     false,
			ErrorReason: simpletracker.CreateUserErrorReason_CREATE_USER_ERROR_REASON_INTERNAL_SERVER_ERROR}, err
	}

	createdSession, err := CreateSession(user.Id, dynamoDbClient, sessionTableName, ctx)
	if err != nil {
		fmt.Printf("Failed to create createdSession: %s\n", err.Error)
		return &simpletracker.CreateUserResponse{
			Success:     false,
			ErrorReason: simpletracker.CreateUserErrorReason_CREATE_USER_ERROR_REASON_INTERNAL_SERVER_ERROR}, err
	}

	return &simpletracker.CreateUserResponse{
		Success:     true,
		ErrorReason: simpletracker.CreateUserErrorReason_CREATE_USER_ERROR_REASON_NO_ERROR,
		SessionId:   createdSession.Id,
		UserId:      createdSession.UserId,
	}, nil
}

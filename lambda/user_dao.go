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
	"errors"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-sdk-go/service/dynamodb/expression"
	"github.com/aws/aws-xray-sdk-go/xray"
	"github.com/google/uuid"
)

var (
	ErrUserAlreadyExists              = errors.New("username already exists")
	ErrUserMissingOrPasswordIncorrect = errors.New("user not found or password incorrect")
)

type User struct {
	Username string
	Password string
	Id       string
}

type UserToReturn struct {
	Username string
	Id       string
}

func VerifyUser(username string,
	password string,
	client *dynamodb.DynamoDB,
	userTableName string,
	ctx context.Context,
) (*UserToReturn, error) {

	var resp *dynamodb.GetItemOutput
	if err := xray.Capture(ctx, "VerifyUser_GetItem", func(ctx1 context.Context) (err error) {
		input := &dynamodb.GetItemInput{
			Key: map[string]*dynamodb.AttributeValue{
				"Username": {
					S: aws.String(username),
				},
			},
			TableName: aws.String(userTableName),
		}

		resp, err = client.GetItemWithContext(ctx1, input)
		if err != nil {
			if awsErr, ok := err.(awserr.Error); ok {
				if reqErr, ok := err.(awserr.RequestFailure); ok {
					// A service error occurred
					fmt.Printf("AWS service error. Code %s, Message: %s, OrigErr %s, StatusCode %s, RequestID %s\n",
						awsErr.Code(), awsErr.Message(), awsErr.OrigErr(), reqErr.StatusCode(), reqErr.RequestID())
				} else {
					// Generic AWS error with Code, Message, and original error (if any)
					fmt.Printf("Generic AWS error. Code %s, Message %s, OrigErr %s\n",
						awsErr.Code(), awsErr.Message(), awsErr.OrigErr())
				}
			} else {
				fmt.Println(err.Error())
			}
			return err
		}
		return nil
	}); err != nil {
		fmt.Println("VerifyUser failed to get item from DynamoDB")
		fmt.Println(err.Error())
		return nil, err
	}

	if len(resp.Item) == 0 {
		// No user found.
		fmt.Println("User not found")

		// To mitigate side-channel timing attacks always calculate a password hash, even if we don't have a
		// database hash to compare it to. We don't return any hash-errors again to mitigate side-channel
		// attacks.
		_ = arbitraryHashPassword(password, ctx)
		return nil, ErrUserMissingOrPasswordIncorrect
	}

	existingPasswordHashCombined := *resp.Item["Password"].S
	userId := *resp.Item["Id"].S

	var match bool
	if err := xray.Capture(ctx, "VerifyUser_ComparePasswords", func(ctx1 context.Context) (err error) {
		match, err = comparePasswordAndHash(password, existingPasswordHashCombined)
		return
	}); err != nil {
		fmt.Println("VerifyUser failed to compare passwords")
		fmt.Println(err.Error())
		return nil, err
	}

	if !match {
		fmt.Println("Password incorrect")
		return nil, ErrUserMissingOrPasswordIncorrect
	}

	return &UserToReturn{Username: username, Id: userId}, nil
}

func arbitraryHashPassword(password string, ctx context.Context) (err error) {
	// To mitigate side-channel timing attacks always calculate a password hash, even if we don't have a
	// database hash to compare it to.
	if err = xray.Capture(ctx, "ArbitraryHashPassword", func(ctx1 context.Context) (err error) {
		_, err = generatePasswordHash(password)
		return
	}); err != nil {
		fmt.Println("Failed to do arbitrary hash password")
		fmt.Println(err.Error())
	}
	return
}

func CreateUser(username string,
	password string,
	client *dynamodb.DynamoDB,
	userTableName string,
	ctx context.Context,
) (*UserToReturn, error) {
	uuid_object := uuid.Must(uuid.NewRandom())
	id, err := uuid_object.MarshalText()
	if err != nil {
		fmt.Printf("CreateUser failed to generate UUID: %s", err.Error())
		_ = xray.AddError(ctx, err)
		return nil, err
	}
	canonical_id := fmt.Sprintf("userid_%s", string(id))

	var password_hashed string
	if err = xray.Capture(ctx, "CreateUser_HashPassword", func(ctx1 context.Context) (err error) {
		password_hashed, err = generatePasswordHash(password)
		return
	}); err != nil {
		fmt.Println("CreateUser failed to hash password")
		fmt.Println(err.Error())
		return nil, err
	}

	user := User{Username: username, Password: password_hashed, Id: canonical_id}
	av, err := dynamodbattribute.MarshalMap(user)
	if err != nil {
		fmt.Println("CreateUser failed to marshal user")
		fmt.Println(err.Error())
		_ = xray.AddError(ctx, err)
		return nil, err
	}

	condition_username_not_exists := expression.Name("Username").AttributeNotExists()
	condition, err := expression.NewBuilder().WithCondition(condition_username_not_exists).Build()
	if err != nil {
		fmt.Println("CreateUser failed to create condition")
		fmt.Println(err.Error())
		_ = xray.AddError(ctx, err)
		return nil, err
	}

	input := &dynamodb.PutItemInput{
		ConditionExpression:       condition.Condition(),
		ExpressionAttributeNames:  condition.Names(),
		ExpressionAttributeValues: condition.Values(),
		Item:                      av,
		TableName:                 aws.String(userTableName),
	}

	if err = xray.Capture(ctx, "CreateUser_PutItem", func(ctx1 context.Context) (err error) {
		_, err = client.PutItemWithContext(ctx1, input)
		if err != nil {
			if awsErr, ok := err.(awserr.Error); ok {
				if awsErr.Code() == dynamodb.ErrCodeConditionalCheckFailedException {
					fmt.Printf("User already exists\n")
					return ErrUserAlreadyExists
				}
				if reqErr, ok := err.(awserr.RequestFailure); ok {
					// A service error occurred
					fmt.Printf("AWS service error. Code %s, Message: %s, OrigErr %s, StatusCode %s, RequestID %s\n",
						awsErr.Code(), awsErr.Message(), awsErr.OrigErr(), reqErr.StatusCode(), reqErr.RequestID())
				} else {
					// Generic AWS error with Code, Message, and original error (if any)
					fmt.Printf("Generic AWS error. Code %s, Message %s, OrigErr %s\n",
						awsErr.Code(), awsErr.Message(), awsErr.OrigErr())
				}
			} else {
				fmt.Println(err.Error())
			}
			return err
		}
		return nil
	}); err != nil {
		fmt.Println("CreateUser failed to put item into DynamoDB")
		fmt.Println(err.Error())
		return nil, err
	}

	fmt.Printf("Successfully added username: %s\n", username)
	return &UserToReturn{Username: username, Id: canonical_id}, nil
}

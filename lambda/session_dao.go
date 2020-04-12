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
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-xray-sdk-go/xray"
	"github.com/google/uuid"
)

type Session struct {
	Id                 string
	UserId             string
	EpochExpirySeconds int64
}

func CreateSession(userId string,
	client *dynamodb.DynamoDB,
	sessionTableName string,
	ctx context.Context) (*Session, error) {

	uuid_object := uuid.Must(uuid.NewRandom())
	id, err := uuid_object.MarshalText()
	if err != nil {
		fmt.Printf("CreateUser failed to generate UUID: %s", err.Error())
		_ = xray.AddError(ctx, err)
		return nil, err
	}
	canonical_id := fmt.Sprintf("sessionid_%s", string(id))

	expiryTime := time.Now().Add(time.Hour * 24)
	expryEpochSecs := expiryTime.Unix()

	session := Session{Id: canonical_id, UserId: userId, EpochExpirySeconds: expryEpochSecs}
	av, err := dynamodbattribute.MarshalMap(session)
	if err != nil {
		fmt.Println("CreateSession failed to marshal session")
		fmt.Println(err.Error())
		_ = xray.AddError(ctx, err)
		return nil, err
	}

	input := &dynamodb.PutItemInput{
		Item:                      av,
		TableName:                 aws.String(sessionTableName),
	}

	if err = xray.Capture(ctx, "CreateSession_PutItem", func(ctx1 context.Context) (err error) {
		_, err = client.PutItemWithContext(ctx1, input)
		if err != nil {
			if awsErr, ok := err.(awserr.Error); ok {
				// Generic AWS error with Code, Message, and original error (if any)
				fmt.Println(awsErr.Code(), awsErr.Message(), awsErr.OrigErr())
				if reqErr, ok := err.(awserr.RequestFailure); ok {
					// A service error occurred
					fmt.Println(reqErr.StatusCode(), reqErr.RequestID())
				}
			} else {
				fmt.Println(err.Error())
			}
			return err
		}
		return nil
	}); err != nil {
		fmt.Println("CreateSession failed to put item into DynamoDB")
		fmt.Println(err.Error())
		return nil, err
	}

	return &session, nil
}

func VerifySession(userId string,
	sessionId string,
	client *dynamodb.DynamoDB,
	sessionTableName string,
	ctx context.Context) (*Session, error) {
	return nil, nil
}

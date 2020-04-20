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
	"crypto/subtle"
	"errors"
	"fmt"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-xray-sdk-go/xray"
	"github.com/google/uuid"
)

var (
	ErrSessionNotFound                   = errors.New("session not found")
	ErrSessionDoesNotMatchProposedUserId = errors.New("session found but does not match proposed user ID")
	ErrSessionCouldNotDeserializeEpoch = errors.New("session found but could not deserialize epoch")
)

type Session struct {
	Id                 string
	UserId             string
	ExpiryEpochSeconds int64
}

func CreateSession(userId string,
	client *dynamodb.DynamoDB,
	sessionTableName string,
	ctx context.Context) (*Session, error) {

	uuid_object := uuid.Must(uuid.NewRandom())
	id, err := uuid_object.MarshalText()
	if err != nil {
		fmt.Printf("CreateSession failed to generate UUID: %s", err.Error())
		_ = xray.AddError(ctx, err)
		return nil, err
	}
	canonical_id := fmt.Sprintf("sessionid_%s", string(id))

	expiryTime := time.Now().Add(time.Hour * 24)
	expiryEpochSecs := expiryTime.Unix()

	session := Session{Id: canonical_id, UserId: userId, ExpiryEpochSeconds: expiryEpochSecs}
	av, err := dynamodbattribute.MarshalMap(session)
	if err != nil {
		fmt.Println("CreateSession failed to marshal session")
		fmt.Println(err.Error())
		_ = xray.AddError(ctx, err)
		return nil, err
	}

	input := &dynamodb.PutItemInput{
		Item:      av,
		TableName: aws.String(sessionTableName),
	}

	if err = xray.Capture(ctx, "CreateSession_PutItem", func(ctx1 context.Context) (err error) {
		_, err = client.PutItemWithContext(ctx1, input)
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
		fmt.Println("CreateSession failed to put item into DynamoDB")
		fmt.Println(err.Error())
		return nil, err
	}

	return &session, nil
}

func VerifySession(
	userId string,
	sessionId string,
	client *dynamodb.DynamoDB,
	sessionTableName string,
	ctx context.Context,
) (*Session, error) {

	var resp *dynamodb.GetItemOutput
	if err := xray.Capture(ctx, "VerifySession_GetItem", func(ctx1 context.Context) (err error) {
		input := &dynamodb.GetItemInput{
			Key: map[string]*dynamodb.AttributeValue{
				"Id": {
					S: aws.String(sessionId),
				},
			},
			TableName: aws.String(sessionTableName),
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
		// No session found.
		fmt.Println("Session not found")
		_ = xray.AddError(ctx, ErrSessionNotFound)
		return nil, ErrSessionNotFound
	}

	existingSessionId := *resp.Item["Id"].S
	existingUserId := *resp.Item["UserId"].S
	expiryEpochSeconds, err := strconv.ParseInt(*resp.Item["ExpiryEpochSeconds"].N, 10, 64)
	if err != nil {
		fmt.Println("Could not deserialize session EpochExpirySeconds")
		_ = xray.AddError(ctx, ErrSessionCouldNotDeserializeEpoch)
		return nil, ErrSessionCouldNotDeserializeEpoch
	}

	if subtle.ConstantTimeCompare([]byte(userId), []byte(existingUserId)) == 0 {
		fmt.Println("Session found but does not match proposed user ID")
		_ = xray.AddError(ctx, ErrSessionDoesNotMatchProposedUserId)
		return nil, ErrSessionDoesNotMatchProposedUserId
	}

	return &Session{
		Id:                 existingSessionId,
		UserId:             existingUserId,
		ExpiryEpochSeconds: expiryEpochSeconds,
	}, nil
}

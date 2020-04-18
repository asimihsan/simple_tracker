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
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"errors"
	"fmt"
	"io"
	"log"
	_ "log"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/kms"
	"github.com/aws/aws-xray-sdk-go/xray"
	"github.com/patrickmn/go-cache"
	"github.com/aws/aws-sdk-go/service/dynamodb/expression"

	simpletracker "lambda/proto"
)

var (
	ErrNoPaginationKeyFoundInDdb = errors.New("no pagination key found in DynamoDB")
	ErrPaginationKeyIsNotCorrectSize = errors.New("pagination key is not 32 bytes large")
	maxResultsLimit int64 = 100
)

type CalendarSummary struct {
	FormatVersion int64
	OwnerUserId   string
	Id            string
	Name          string
	Color         string
	Version       int64
}

type CalendarDetail struct {
	summary         CalendarSummary
	highlightedDays []string
}

func getPaginationKeyId() string {
	utcNow := time.Now().In(time.UTC)
	return fmt.Sprintf("%04d-%02d-%02dT%02d", utcNow.Year(), utcNow.Month(), utcNow.Day(), utcNow.Hour())
}

func getPaginationKey(
	paginationKeyCache *cache.Cache,
	paginationEphemeralKeyTableName string,
	dynamoDbClient *dynamodb.DynamoDB,
	kmsClient *kms.KMS,
	ctx context.Context,
) (key [32]byte, err error) {
	paginationKeyId := getPaginationKeyId()
	existingKey, found := paginationKeyCache.Get(paginationKeyId)
	if found {
		return existingKey.([32]byte), nil
	}

	encryptedPaginationKey, err := getEncryptedPaginationKeyFromDynamoDb(
		paginationKeyId, paginationEphemeralKeyTableName, dynamoDbClient, ctx)
	if err != nil {
		return key, err
	}

	paginationKey, err := decryptKey(paginationKeyId, encryptedPaginationKey, kmsClient, ctx)
	if err != nil {
		return key, err
	}
	if len(paginationKey) != 32 {
		return key, ErrPaginationKeyIsNotCorrectSize
	}

	copy(key[:], paginationKey)
	paginationKeyCache.Set(paginationKeyId, key, cache.DefaultExpiration)
	return key, nil
}

func getEncryptedPaginationKeyFromDynamoDb(
	paginationKeyId string,
	paginationEphemeralKeyTableName string,
	dynamoDbClient *dynamodb.DynamoDB,
	ctx context.Context,
) ([]byte, error) {
	var getResp *dynamodb.GetItemOutput
	if err := xray.Capture(ctx, "getPaginationKeyFromDynamoDb", func(ctx1 context.Context) (err error) {
		input := &dynamodb.GetItemInput{
			Key: map[string]*dynamodb.AttributeValue{
				"DateTime_Shard": {
					S: aws.String(paginationKeyId),
				},
			},
			ConsistentRead: aws.Bool(false),
			TableName:      aws.String(paginationEphemeralKeyTableName),
		}
		getResp, err = dynamoDbClient.GetItemWithContext(ctx1, input)
		if err != nil {
			return err
		}
		if len(getResp.Item) == 0 {
			fmt.Printf("no pagination key found for pagination key %s\n", paginationKeyId)
			return ErrNoPaginationKeyFoundInDdb
		}
		return nil
	}); err != nil {
		return nil, err
	}

	keyBlob := getResp.Item["EncryptedDataKey"].B
	return keyBlob, nil
}

func decryptKey(
	paginationKeyId string,
	encryptedKey []byte,
	kmsClient *kms.KMS,
	ctx context.Context,
) ([]byte, error) {
	var decryptResp *kms.DecryptOutput
	if err := xray.Capture(ctx, "decryptKey", func(ctx1 context.Context) (err error) {
		input := &kms.DecryptInput{
			CiphertextBlob: encryptedKey,
			EncryptionContext: map[string]*string{
				"DateTime_Shard": aws.String(paginationKeyId),
			},
		}
		decryptResp, err = kmsClient.DecryptWithContext(ctx1, input)
		return
	}); err != nil {
		return nil, err
	}
	return decryptResp.Plaintext, nil
}

func encrypt(plaintext []byte, key *[32]byte) (ciphertext []byte, err error) {
	block, err := aes.NewCipher(key[:])
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	nonce := make([]byte, gcm.NonceSize())
	_, err = io.ReadFull(rand.Reader, nonce)
	if err != nil {
		return nil, err
	}

	return gcm.Seal(nonce, nonce, plaintext, nil), nil
}

func decrypt(ciphertext []byte, key *[32]byte) (plaintext []byte, err error) {
	block, err := aes.NewCipher(key[:])
	if err != nil {
		return nil, err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}

	if len(ciphertext) < gcm.NonceSize() {
		return nil, errors.New("malformed ciphertext")
	}

	return gcm.Open(nil, ciphertext[:gcm.NonceSize()], ciphertext[gcm.NonceSize():], nil)
}

func convertDynamoDbItemToCalendarSummary(item map[string]*dynamodb.AttributeValue) (*CalendarSummary, error) {
	if len(item) == 0 {
		return nil, errors.New("Cannot convert empty item to CalendarySummary")
	}
	formatVersion, err := strconv.ParseInt(*item["FormatVersion"].N, 10, 64)
	if err != nil {
		return nil, errors.New("Cannot convert FormatVersion to int64")
	}
	version, err := strconv.ParseInt(*item["Version"].N, 10, 64)
	if err != nil {
		return nil, errors.New("Cannot convert Version to int64")
	}

	return &CalendarSummary{
		FormatVersion: formatVersion,
		OwnerUserId:   *item["OwnerUserId"].S,
		Id:            *item["Id"].S,
		Name:          *item["Name"].S,
		Color:         *item["Color"].S,
		Version:       version,
	}, nil
}


func handleListCalendarsRequestInner(
	request *simpletracker.ListCalendarsRequest,
	dynamoDbClient *dynamodb.DynamoDB,
	kmsClient *kms.KMS,
	calendarTableName string,
	paginationKeyCache *cache.Cache,
	paginationEphemeralKeyTableName string,
	ctx context.Context,
) (*simpletracker.ListCalendarsResponse, error) {
	var limit int64
	if request.MaxResults == nil || request.MaxResults.Value > maxResultsLimit || request.MaxResults.Value <= 0 {
		limit = maxResultsLimit
	} else {
		limit = request.MaxResults.Value
	}

	_, err := getPaginationKey(
		paginationKeyCache, paginationEphemeralKeyTableName, dynamoDbClient, kmsClient, ctx)
	if err != nil {
		log.Printf("ListCalendars could not get pagination key: %s\n", err.Error())
		return nil, err
	}

	var exclusiveStartKey map[string]*dynamodb.AttributeValue = nil
	if request.NextToken != nil {
		log.Printf("ListCalendars next token present")
	}

	resp := &simpletracker.ListCalendarsResponse{
		Success:              false,
		CalendarSummaries:    make([]*simpletracker.CalendarSummary, 0, 1),
		NextToken:            nil,
	}

	result, err := ListCalendars(
		request.UserId,
		limit,
		exclusiveStartKey,
		dynamoDbClient,
		calendarTableName,
		ctx,
	)
	if err != nil {
		return resp, err
	}

	resp.Success = true
	for _, internalCalendarSummary := range(result) {
		externalCalendarSummary := &simpletracker.CalendarSummary{
			FormatVersion:        internalCalendarSummary.FormatVersion,
			OwnerUserid:          internalCalendarSummary.OwnerUserId,
			Id:                   internalCalendarSummary.Id,
			Name:                 internalCalendarSummary.Name,
			Color:                internalCalendarSummary.Color,
			Version:              internalCalendarSummary.Version,
		}
		resp.CalendarSummaries = append(resp.CalendarSummaries, externalCalendarSummary)
	}
	return resp, nil
}

func ListCalendars(
	userId string,
	limit int64,
	exclusiveStartKey map[string]*dynamodb.AttributeValue,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	ctx context.Context,
) ([]*CalendarSummary, error) {
	keyCondition := expression.Key("OwnerUserId").Equal(expression.Value(userId))
	projection := expression.NamesList(
		expression.Name("FormatVersion"),
		expression.Name("OwnerUserId"),
		expression.Name("Id"),
		expression.Name("Name"),
		expression.Name("Color"),
		expression.Name("Version"),
	)
	expr, err := expression.NewBuilder().WithKeyCondition(keyCondition).WithProjection(projection).Build()
	if err != nil {
		return nil, err
	}

	var queryResp *dynamodb.QueryOutput
	if err := xray.Capture(ctx, "ListCalendars_Query", func(ctx1 context.Context) (err error) {
		input := &dynamodb.QueryInput{
			ConsistentRead:            aws.Bool(true),
			ExclusiveStartKey:         exclusiveStartKey,
			ExpressionAttributeNames:  expr.Names(),
			ExpressionAttributeValues: expr.Values(),
			FilterExpression:          expr.Filter(),
			KeyConditionExpression:    expr.KeyCondition(),
			Limit:                     aws.Int64(limit),
			ProjectionExpression:      expr.Projection(),
			ScanIndexForward:          aws.Bool(true),
			TableName:                 aws.String(calendarTableName),
		}

		queryResp, err = dynamoDbClient.QueryWithContext(ctx1, input)
		if err != nil {
			return err
		}
		return nil
	}); err != nil {
		fmt.Println("ListCalendars failed to Query DynamoDB")
		fmt.Println(err.Error())
		return nil, err
	}

	result := make([]*CalendarSummary, len(queryResp.Items))
	for _, item := range queryResp.Items {
		converted, err := convertDynamoDbItemToCalendarSummary(item)
		if err != nil {
			return nil, err
		}
		result = append(result, converted)
	}
	return result, nil
}

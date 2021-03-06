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
	"bytes"
	"compress/zlib"
	"context"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"sort"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-sdk-go/service/dynamodb/expression"
	"github.com/aws/aws-sdk-go/service/kms"
	"github.com/aws/aws-xray-sdk-go/xray"
	"github.com/golang/protobuf/proto"
	"github.com/oklog/ulid"
	"github.com/patrickmn/go-cache"
	"github.com/valyala/gozstd"

	"lambda/lambdalog"
	simpletracker "lambda/proto"
)

var (
	ErrNoPaginationKeyFoundInDdb           = errors.New("no pagination key found in DynamoDB")
	ErrPaginationKeyIsNotCorrectSize       = errors.New("pagination key is not 32 bytes large")
	ErrUpdateCalendarsUnknownActionType    = errors.New("update calendars unknown action type")
	ErrUpdateCalendarsCouldNotGetExistingCalendars = errors.New("update calendars could not get existing calendars")
	ErrCalendarNotFound = errors.New("calendar not found")
	maxResultsLimit                  int64 = 100
	ulidEntropy                            = ulid.Monotonic(rand.Reader, 0)
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
	FormatVersion   int64
	OwnerUserId     string
	Id              string
	Name            string
	Color           string
	Version         int64
	HighlightedDays []byte
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
			lambdalog.LambdaLog.Printf("no pagination key found for pagination key %s\n", paginationKeyId)
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
	sessionTableName string,
	calendarTableName string,
	paginationKeyCache *cache.Cache,
	paginationEphemeralKeyTableName string,
	ctx context.Context,
) (*simpletracker.ListCalendarsResponse, error) {

	resp := &simpletracker.ListCalendarsResponse{
		Success:           false,
		CalendarSummaries: make([]*simpletracker.CalendarSummary, 0, 1),
		NextToken:         nil,
	}

	if _, err := VerifySession(request.UserId, request.SessionId, dynamoDbClient, sessionTableName, ctx); err != nil {
		lambdalog.LambdaLog.Println("Could not verify session.")
		resp.Success = false
		resp.ErrorReason = simpletracker.ListCalendarsErrorReason_LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR
		return resp, nil
	}

	var limit int64
	if request.MaxResults > maxResultsLimit || request.MaxResults <= 0 {
		limit = maxResultsLimit
	} else {
		limit = request.MaxResults
	}

	_, err := getPaginationKey(
		paginationKeyCache, paginationEphemeralKeyTableName, dynamoDbClient, kmsClient, ctx)
	if err != nil {
		lambdalog.LambdaLog.Printf("ListCalendars could not get pagination key: %s\n", err.Error())
		return nil, err
	}

	var exclusiveStartKey map[string]*dynamodb.AttributeValue = nil
	if request.NextToken != nil {
		lambdalog.LambdaLog.Printf("ListCalendars next token present")
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
	for _, internalCalendarSummary := range result {
		externalCalendarSummary := &simpletracker.CalendarSummary{
			FormatVersion: internalCalendarSummary.FormatVersion,
			OwnerUserid:   internalCalendarSummary.OwnerUserId,
			Id:            internalCalendarSummary.Id,
			Name:          internalCalendarSummary.Name,
			Color:         internalCalendarSummary.Color,
			Version:       internalCalendarSummary.Version,
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
		lambdalog.LambdaLog.Println("ListCalendars failed to Query DynamoDB")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}

	result := make([]*CalendarSummary, 0, len(queryResp.Items))
	for _, item := range queryResp.Items {
		converted, err := convertDynamoDbItemToCalendarSummary(item)
		if err != nil {
			return nil, err
		}
		result = append(result, converted)
	}
	return result, nil
}

func handleCreateCalendarRequestInner(
	request *simpletracker.CreateCalendarRequest,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	ctx context.Context,
) (*simpletracker.CreateCalendarResponse, error) {

	resp := &simpletracker.CreateCalendarResponse{}

	if _, err := VerifySession(request.UserId, request.SessionId, dynamoDbClient, sessionTableName, ctx); err != nil {
		lambdalog.LambdaLog.Println("Could not verify session.")
		resp.Success = false
		resp.ErrorReason = simpletracker.CreateCalendarErrorReason_CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR
		return resp, nil
	}

	result, err := CreateCalendar(
		request.UserId,
		request.Name,
		request.Color,
		dynamoDbClient,
		calendarTableName,
		ctx,
	)
	if err != nil {
		return resp, err
	}

	highlightedDays, err := highlightedDaysDeserializeInternal(result.HighlightedDays)
	if err != nil {
		lambdalog.LambdaLog.Println("handleCreateCalendarRequestInner could not deserialize internal highlightedDays")
		resp.Success = false
		resp.ErrorReason = simpletracker.CreateCalendarErrorReason_CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR
		return resp, nil
	}
	highlightedDaysExternal, err := highlightedDaysSerializeExternal(highlightedDays)
	if err != nil {
		lambdalog.LambdaLog.Printf("handleCreateCalendarRequestInner could not serialize highlightedDays for external: %s\n", err.Error())
		resp.Success = false
		resp.ErrorReason = simpletracker.CreateCalendarErrorReason_CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR
		return resp, nil
	}

	resp.Success = true
	resp.ErrorReason = simpletracker.CreateCalendarErrorReason_CREATE_CALENDAR_ERROR_REASON_NO_ERROR
	resp.CalendarDetail = &simpletracker.CalendarDetail{
		Summary:              &simpletracker.CalendarSummary{
			FormatVersion:        result.FormatVersion,
			OwnerUserid:          result.OwnerUserId,
			Id:                   result.Id,
			Name:                 result.Name,
			Color:                result.Color,
			Version:              result.Version,
		},
		HighlightedDays:      highlightedDaysExternal,
	}
	return resp, nil
}

func highlightedDaysSerializeExternal(input []string) (output []byte, err error) {
	listOfStrings := simpletracker.ListOfStrings{
		Strings:              input,
	}
	serializedBytes, err := proto.Marshal(&listOfStrings)
	if err != nil {
		lambdalog.LambdaLog.Printf("Failed to serialize highlightedDays: %s\n", err.Error())
		return
	}
	var b bytes.Buffer
	w, err := zlib.NewWriterLevel(&b, zlib.BestCompression)
	if err != nil {
		lambdalog.LambdaLog.Printf("Failed to create ZLIB compressor: %s\n", err.Error())
		return
	}
	_, err = w.Write(serializedBytes)
	if err != nil {
		lambdalog.LambdaLog.Printf("Failed to ZLIB compress highlighted days: %s\n", err.Error())
		return
	}
	err = w.Close()
	if err != nil {
		lambdalog.LambdaLog.Printf("Failed to close ZLIB compressor for highlighted days: %s\n", err.Error())
		return
	}
	output = b.Bytes()
	return
}

func highlightedDaysDeserializeExternal(input []byte) (output []string, err error) {
	r, err := zlib.NewReader(bytes.NewReader(input))
	if err != nil {
		lambdalog.LambdaLog.Printf("Failed to create ZLIB decompressor: %s\n", err.Error())
		return
	}
	decompressedBytes, err := ioutil.ReadAll(r)
	if err != nil {
		lambdalog.LambdaLog.Printf("Failed to ZLIB decompress highlightedDays: %s\n", err.Error())
		return
	}

	deserialized := simpletracker.ListOfStrings{}
	err = proto.Unmarshal(decompressedBytes, &deserialized)
	if err != nil {
		lambdalog.LambdaLog.Println("Failed to deserialize external highlightedDays")
	}

	return deserialized.Strings, nil
}

func highlightedDaysSerializeInternal(input []string) (output []byte, err error) {
	listOfStrings := simpletracker.ListOfStrings{
		Strings:              input,
	}
	serializedBytes, err := proto.Marshal(&listOfStrings)
	if err != nil {
		lambdalog.LambdaLog.Printf("Failed to serialize highlightedDays: %s\n", err.Error())
		return
	}
	output = gozstd.CompressLevel(nil, serializedBytes, 19)
	return
}

func highlightedDaysDeserializeInternal(input []byte) (output []string, err error) {
	decompressedBytes, err := gozstd.Decompress(nil, input)
	if err != nil {
		lambdalog.LambdaLog.Println("Failed to decompress highlightedDays")
		return
	}

	deserialized := simpletracker.ListOfStrings{}
	err = proto.Unmarshal(decompressedBytes, &deserialized)
	if err != nil {
		lambdalog.LambdaLog.Println("Failed to deserialize external highlightedDays")
	}

	return deserialized.Strings, nil
}

func CreateCalendar(
	userId string,
	name string,
	color string,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	ctx context.Context,
) (*CalendarDetail, error) {

	newCalendarId := ulid.MustNew(ulid.Now(), ulidEntropy).String()
	highlightedDays := make([]string, 0, 1)
	highlightedDaysSerialized, err := highlightedDaysSerializeInternal(highlightedDays)
	if err != nil {
		lambdalog.LambdaLog.Println("CreateCalendar failed to serialize empty highlightedDays")
		_ = xray.AddError(ctx, err)
		return nil, err
	}

	newCalendar := &CalendarDetail{
		FormatVersion:   1,
		OwnerUserId:     userId,
		Id:              newCalendarId,
		Name:            name,
		Color:           color,
		HighlightedDays: highlightedDaysSerialized,
		Version:         0,
	}
	av, err := dynamodbattribute.MarshalMap(newCalendar)
	if err != nil {
		lambdalog.LambdaLog.Println("CreateSession failed to marshal new calendar")
		lambdalog.LambdaLog.Println(err.Error())
		_ = xray.AddError(ctx, err)
		return nil, err
	}

	if err := xray.Capture(ctx, "CreateCalendar_PutItem", func(ctx1 context.Context) (err error) {
		input := &dynamodb.PutItemInput{
			Item:      av,
			TableName: aws.String(calendarTableName),
		}
		_, err = dynamoDbClient.PutItemWithContext(ctx1, input)
		return err
	}); err != nil {
		lambdalog.LambdaLog.Println("CreateCalendar failed to PutItem to DynamoDB")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}

	return newCalendar, nil
}


func handleGetCalendarsRequestInner(
	request *simpletracker.GetCalendarsRequest,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	ctx context.Context,
) (*simpletracker.GetCalendarsResponse, error) {

	resp := &simpletracker.GetCalendarsResponse{
		CalendarDetails:      make([]*simpletracker.CalendarDetail, 0, 1),
	}

	if _, err := VerifySession(request.UserId, request.SessionId, dynamoDbClient, sessionTableName, ctx); err != nil {
		lambdalog.LambdaLog.Println("Could not verify session.")
		resp.Success = false
		resp.ErrorReason = simpletracker.GetCalendarsErrorReason_GET_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR
		return resp, nil
	}

	result, err := GetCalendars(
		request.UserId,
		request.CalendarIds,
		dynamoDbClient,
		calendarTableName,
		true /*highlightedDaysShouldUseExternal*/,
		ctx,
	)
	if err != nil {
		return resp, err
	}

	resp.Success = true
	resp.ErrorReason = simpletracker.GetCalendarsErrorReason_GET_CALENDARS_ERROR_REASON_NO_ERROR
	for _, internalCalendarDetail := range(result) {
		externalCalendarDetail := &simpletracker.CalendarDetail{
			Summary: &simpletracker.CalendarSummary{
				FormatVersion: internalCalendarDetail.FormatVersion,
				OwnerUserid:   internalCalendarDetail.OwnerUserId,
				Id:            internalCalendarDetail.Id,
				Name:          internalCalendarDetail.Name,
				Color:         internalCalendarDetail.Color,
				Version:       internalCalendarDetail.Version,
			},
			HighlightedDays: internalCalendarDetail.HighlightedDays,
		}
		resp.CalendarDetails = append(resp.CalendarDetails, externalCalendarDetail)
	}

	return resp, nil
}

func removeDuplicatesAndSort(input []string) []string {
	seen := map[string]bool{}
	output := make([]string, 0, len(input))

	for _, elem := range input {
		_, ok := seen[elem]
		if ok {
			continue;
		}
		output = append(output, elem)
		seen[elem] = true
	}
	sort.Strings(output)
	return output
}

func GetCalendars(
	userId string,
	calendarIds []string,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	highlightedDaysShouldUseExternal bool,
	ctx context.Context,
) ([]*CalendarDetail, error) {
	var result = make([]*CalendarDetail, 0, 1)

	calendarIdsDeduped := removeDuplicatesAndSort(calendarIds)
	for _, calendarId := range calendarIdsDeduped {
		calendarDetail, err := getCalendarInternal(
			userId,
			calendarId,
			dynamoDbClient,
			calendarTableName,
			highlightedDaysShouldUseExternal,
			ctx,
		)
		if err != nil {
			return result, err
		}
		result = append(result, calendarDetail)
	}

	return result, nil
}

func convertDynamoDbItemToCalendarDetail(
	item map[string]*dynamodb.AttributeValue,
	highlightedDaysShouldUseExternal bool,
) (*CalendarDetail, error) {
	calendarSummary, err := convertDynamoDbItemToCalendarSummary(item)
	if err != nil {
		lambdalog.LambdaLog.Println("getCalendarInternal could not convert response to CalendarSummary")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}

	var highlightedDaysSerialized []byte

	highlightedDaysSerializedInternal := item["HighlightedDays"].B
	highlightedDays, err := highlightedDaysDeserializeInternal(highlightedDaysSerializedInternal)
	if err != nil {
		lambdalog.LambdaLog.Println("getCalendarInternal could not deserialize internal highlightedDays")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}
	highlightedDaysSerializedExternal, err := highlightedDaysSerializeExternal(highlightedDays)
	if err != nil {
		lambdalog.LambdaLog.Println("getCalendarInternal could not serialize highlightedDays to external")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}

	if (highlightedDaysShouldUseExternal) {
		highlightedDaysSerialized = highlightedDaysSerializedExternal
	} else {
		highlightedDaysSerialized = highlightedDaysSerializedInternal
	}

	return &CalendarDetail{
		FormatVersion:   calendarSummary.FormatVersion,
		OwnerUserId:     calendarSummary.OwnerUserId,
		Id:              calendarSummary.Id,
		Name:            calendarSummary.Name,
		Color:           calendarSummary.Color,
		Version:         calendarSummary.Version,
		HighlightedDays: highlightedDaysSerialized,
	}, nil
}

func getCalendarInternal(
	userId string,
	calendarId string,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	highlightedDaysShouldUseExternal bool,
	ctx context.Context,	
) (*CalendarDetail, error) {
	var getResp *dynamodb.GetItemOutput
	if err := xray.Capture(ctx, "getCalendarInternal_GetItem", func(ctx1 context.Context) (err error) {
		input := &dynamodb.GetItemInput{
			Key: map[string]*dynamodb.AttributeValue{
				"OwnerUserId": {
					S: aws.String(userId),
				},
				"Id": {
					S: aws.String(calendarId),
				},
			},
			ConsistentRead: aws.Bool(false),
			TableName:      aws.String(calendarTableName),
		}
		getResp, err = dynamoDbClient.GetItemWithContext(ctx1, input)
		if err != nil {
			return err
		}
		if len(getResp.Item) == 0 {
			lambdalog.LambdaLog.Printf("no calendar found for userId %s calendarId %s\n", userId, calendarId)
			return ErrCalendarNotFound
		}
		return nil
	}); err != nil {
		lambdalog.LambdaLog.Println("getCalendarInternal failed to GetItem from DynamoDB")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}

	calendarDetail, err := convertDynamoDbItemToCalendarDetail(getResp.Item, highlightedDaysShouldUseExternal)
	if err != nil {
		lambdalog.LambdaLog.Println("getCalendarInternal could not convert response to CalendarDetail")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}
	return calendarDetail, nil
}

func handleDeleteCalendarRequestInner(
	request *simpletracker.DeleteCalendarRequest,
	dynamoDbClient *dynamodb.DynamoDB,
	sessionTableName string,
	calendarTableName string,
	ctx context.Context,
) (*simpletracker.DeleteCalendarResponse, error) {

	resp := &simpletracker.DeleteCalendarResponse{}

	if _, err := VerifySession(request.UserId, request.SessionId, dynamoDbClient, sessionTableName, ctx); err != nil {
		lambdalog.LambdaLog.Println("Could not verify session.")
		resp.Success = false
		resp.ErrorReason = simpletracker.DeleteCalendarErrorReason_DELETE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR
		return resp, nil
	}

	err := DeleteCalendar(request.UserId, request.CalendarId, dynamoDbClient, calendarTableName, ctx)
	if err != nil {
		return resp, err
	}

	resp.Success = true
	resp.ErrorReason = simpletracker.DeleteCalendarErrorReason_DELETE_CALENDARS_ERROR_REASON_NO_ERROR
	return resp, nil
}

func DeleteCalendar(
	userId string,
	calendarId string,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	ctx context.Context,
) (error) {
	var deleteResp *dynamodb.DeleteItemOutput
	if err := xray.Capture(ctx, "DeleteCalendar_DeleteItem", func(ctx1 context.Context) (err error) {
		input := &dynamodb.DeleteItemInput{
			Key: map[string]*dynamodb.AttributeValue{
				"OwnerUserId": {
					S: aws.String(userId),
				},
				"Id": {
					S: aws.String(calendarId),
				},
			},
			TableName:      aws.String(calendarTableName),
		}
		deleteResp, err = dynamoDbClient.DeleteItemWithContext(ctx1, input)
		if err != nil {
			return err
		}
		return nil
	}); err != nil {
		lambdalog.LambdaLog.Println("DeleteCalendar failed to DeleteItem from DynamoDB")
		lambdalog.LambdaLog.Println(err.Error())
		return err
	}
	return nil
}

func handleUpdateCalendarsRequestInner(
	request *simpletracker.UpdateCalendarsRequest,
	dynamoDbClient *dynamodb.DynamoDB,
	sessionTableName string,
	calendarTableName string,
	ctx context.Context,
) (*simpletracker.UpdateCalendarsResponse, error) {

	resp := &simpletracker.UpdateCalendarsResponse{
		CalendarDetails:      make([]*simpletracker.CalendarDetail, 0, 1),
	}

	if _, err := VerifySession(request.UserId, request.SessionId, dynamoDbClient, sessionTableName, ctx); err != nil {
		lambdalog.LambdaLog.Println("Could not verify session.")
		resp.Success = false
		resp.ErrorReason = simpletracker.UpdateCalendarsErrorReason_UPDATE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR
		return resp, nil
	}

	result, err := UpdateCalendars(request.UserId, request.Actions, dynamoDbClient, calendarTableName, ctx)
	if err != nil {
		return resp, err
	}

	resp.Success = true
	resp.ErrorReason = simpletracker.UpdateCalendarsErrorReason_UPDATE_CALENDARS_ERROR_REASON_NO_ERROR
	for _, internalCalendarDetail := range(result) {
		externalCalendarDetail := &simpletracker.CalendarDetail{
			Summary: &simpletracker.CalendarSummary{
				FormatVersion: internalCalendarDetail.FormatVersion,
				OwnerUserid:   internalCalendarDetail.OwnerUserId,
				Id:            internalCalendarDetail.Id,
				Name:          internalCalendarDetail.Name,
				Color:         internalCalendarDetail.Color,
				Version:       internalCalendarDetail.Version,
			},
			HighlightedDays: internalCalendarDetail.HighlightedDays,
		}
		resp.CalendarDetails = append(resp.CalendarDetails, externalCalendarDetail)
	}

	return resp, nil
}

func UpdateCalendars(
	userId string,
	actions map[string]*simpletracker.UpdateCalendarAction,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	ctx context.Context,
) ([]*CalendarDetail, error) {
	calendarIds := make([]string, 0, len(actions))
	for _, action := range actions {
		calendarIds = append(calendarIds, action.CalendarId)
	}

	existingCalendars, err := GetCalendars(
		userId,
		calendarIds,
		dynamoDbClient,
		calendarTableName,
		false /*highlightedDaysShouldUseExternal*/,
		ctx,
	)
	if err != nil {
		lambdalog.LambdaLog.Printf("UpdateCalendars could not get existing calendars: %s\n", err.Error())
		return nil, ErrUpdateCalendarsCouldNotGetExistingCalendars
	}
	existingCalendarsLookup := make(map[string]*CalendarDetail)
	for _, existingCalendar := range existingCalendars {
		existingCalendarsLookup[existingCalendar.Id] = existingCalendar
	}

	var result = make([]*CalendarDetail, 0, 1)

	for _, action := range actions {
		var newName *string
		var newColor *string
		var newHighlightedDays *[]byte
		existingCalendar := existingCalendarsLookup[action.CalendarId]

		switch action.ActionType {
		case simpletracker.UpdateCalendarActionType_UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME:
			newName = &action.NewName
			break;
		case simpletracker.UpdateCalendarActionType_UPDATE_CALENDAR_ACTION_TYPE_CHANGE_COLOR:
			newColor = &action.NewColor
			break;
		case simpletracker.UpdateCalendarActionType_UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME_AND_COLOR:
			newName = &action.NewName
			newColor = &action.NewColor
			break;
		case simpletracker.UpdateCalendarActionType_UPDATE_CALENDAR_ACTION_TYPE_ADD_HIGHLIGHTED_DAY:
			newHighlightedDays, err = addHighlightedDay(existingCalendar.HighlightedDays, action.AddHighlightedDay)
			if err != nil {
				lambdalog.LambdaLog.Printf("failed to add highlighted day %s to calendar ID %s: %s\n",
					action.AddHighlightedDay, existingCalendar.Id, err.Error())
				return nil, err
			}
			break;
		case simpletracker.UpdateCalendarActionType_UPDATE_CALENDAR_ACTION_TYPE_REMOVE_HIGHLIGHTED_DAY:
			newHighlightedDays, err = removeHighlightedDay(existingCalendar.HighlightedDays, action.RemoveHighlightedDay)
			if err != nil {
				lambdalog.LambdaLog.Printf("failed to remove highlighted day %s to calendar ID %s: %s\n",
					action.RemoveHighlightedDay, existingCalendar.Id, err.Error())
				return nil, err
			}
			break;
		default:
			lambdalog.LambdaLog.Printf("Unknown action type: %s", action.ActionType)
			return nil, ErrUpdateCalendarsUnknownActionType
		}

		newCalendarDetail, err := updateCalendarInternal(
			userId,
			action.CalendarId,
			action.ExistingVersion,
			newName,
			newColor,
			newHighlightedDays,
			dynamoDbClient,
			calendarTableName,
			ctx,
		)
		if err != nil {
			lambdalog.LambdaLog.Printf("Failed to update calendar ID %s: %s\n", action.CalendarId, err.Error())
			return nil, err
		}
		result = append(result, newCalendarDetail)
	}

	return result, nil
}

func addHighlightedDay(highlightedDaysInternalSerialized []byte, highlightedDay string) (*[]byte, error) {
	highlightedDaysInternal, err := highlightedDaysDeserializeInternal(highlightedDaysInternalSerialized)
	if err != nil {
		lambdalog.LambdaLog.Printf("addHighlightedDay could not deserialize internal highlightedDays: %s", err.Error())
		return nil, err
	}

	highlightedDaysInternal = append(highlightedDaysInternal, highlightedDay)
	highlightedDaysInternal = removeDuplicatesAndSort(highlightedDaysInternal)

	newHighlightedDaysInternalSerialized, err := highlightedDaysSerializeInternal(highlightedDaysInternal)
	if err != nil {
		lambdalog.LambdaLog.Printf("addHighlightedDay could not serialize internal highlightedDays: %s", err.Error())
		return nil, err
	}
	return &newHighlightedDaysInternalSerialized, nil
}

func removeHighlightedDay(highlightedDaysInternalSerialized []byte, highlightedDay string) (*[]byte, error) {
	highlightedDaysInternal, err := highlightedDaysDeserializeInternal(highlightedDaysInternalSerialized)
	if err != nil {
		lambdalog.LambdaLog.Printf("removeHighlightedDay could not deserialize internal highlightedDays: %s", err.Error())
		return nil, err
	}

	highlightedDaysInternal = removeElementFromStringSlice(highlightedDaysInternal, highlightedDay)
	highlightedDaysInternal = removeDuplicatesAndSort(highlightedDaysInternal)

	newHighlightedDaysInternalSerialized, err := highlightedDaysSerializeInternal(highlightedDaysInternal)
	if err != nil {
		lambdalog.LambdaLog.Printf("removeHighlightedDay could not serialize internal highlightedDays: %s", err.Error())
		return nil, err
	}
	return &newHighlightedDaysInternalSerialized, nil
}

func removeElementFromStringSlice(slice []string, item string) []string {
	result := make([]string, 0, len(slice))
	for _, actualItem := range slice {
		if item != actualItem {
			result = append(result, actualItem)
		}
	}
	return result
}

func updateCalendarInternal(
	userId string,
	calendarId string,
	existingVersion int64,
	newName *string,
	newColor *string,
	newHighlightedDays *[]byte,
	dynamoDbClient *dynamodb.DynamoDB,
	calendarTableName string,
	ctx context.Context,
) (*CalendarDetail, error) {
	existingCondition := expression.Name("Version").Equal(expression.Value(existingVersion))
	updateExpression := expression.
		Set(expression.Name("Version"), expression.Value(existingVersion + 1));
	if newName != nil {
		updateExpression = updateExpression.Set(expression.Name("Name"), expression.Value(*newName))
	}
	if newColor != nil {
		updateExpression = updateExpression.Set(expression.Name("Color"), expression.Value(*newColor))
	}
	if newHighlightedDays != nil {
		updateExpression = updateExpression.Set(expression.Name("HighlightedDays"), expression.Value(*newHighlightedDays))
	}
	expr, err := expression.NewBuilder().
		WithCondition(existingCondition).
		WithUpdate(updateExpression).
		Build()
	if err != nil {
		return nil, err
	}

	var updateResp *dynamodb.UpdateItemOutput
	if err := xray.Capture(ctx, "updateCalendarInternal_UpdateItem", func(ctx1 context.Context) (err error) {
		input := &dynamodb.UpdateItemInput{
			ConditionExpression:         expr.Condition(),
			ExpressionAttributeNames:    expr.Names(),
			ExpressionAttributeValues:   expr.Values(),
			Key: map[string]*dynamodb.AttributeValue{
				"OwnerUserId": {
					S: aws.String(userId),
				},
				"Id": {
					S: aws.String(calendarId),
				},
			},
			ReturnValues:                aws.String("ALL_NEW"),
			TableName:                   aws.String(calendarTableName),
			UpdateExpression:            expr.Update(),
		}
		updateResp, err = dynamoDbClient.UpdateItemWithContext(ctx1, input)
		if err != nil {
			return err
		}
		return nil
	}); err != nil {
		lambdalog.LambdaLog.Println("updateCalendarInternal failed to GetItem from DynamoDB")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}
	calendarDetail, err := convertDynamoDbItemToCalendarDetail(updateResp.Attributes, true /*highlightedDaysShouldUseExternal*/)
	if err != nil {
		lambdalog.LambdaLog.Println("updateCalendarInternal could not convert response to CalendarDetail")
		lambdalog.LambdaLog.Println(err.Error())
		return nil, err
	}
	return calendarDetail, nil
}
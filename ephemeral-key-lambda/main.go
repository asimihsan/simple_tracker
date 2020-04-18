package main

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-sdk-go/service/kms"
	"github.com/aws/aws-xray-sdk-go/strategy/ctxmissing"
	"github.com/aws/aws-xray-sdk-go/xray"
)

var (
	sess                              *session.Session
	dynamoDbClient                    *dynamodb.DynamoDB
	kmsClient                         *kms.KMS
	paginationKeyArn                  string
	paginationEphemeralKeyTableName   string
)

type EphemeralKey struct {
	DateTime_Shard     string
	EncryptedDataKey   []byte
	KeyArn             string
	EpochExpirySeconds int64
}

type handler struct {
}

func (h handler) Invoke(ctx context.Context, data []byte) ([]byte, error) {
	//fmt.Printf("data input: %s\n", string(data))

	utcNow := time.Now().In(time.UTC)
	oneDayDuration := time.Hour * 24
	startTime := utcNow.Add(-oneDayDuration)
	endTime := utcNow.Add(oneDayDuration).Add(time.Hour)
	currentTime := startTime
	for currentTime.Before(endTime) {
		currentPartitionKey := fmt.Sprintf("%04d-%02d-%02dT%02d", currentTime.Year(), currentTime.Month(), currentTime.Day(), currentTime.Hour())
		expiryEpochSecs := currentTime.Add(time.Hour * 28).Unix()
		fmt.Printf("currentPartitionKey: %s\n", currentPartitionKey)
		err := process(currentPartitionKey, expiryEpochSecs, ctx)
		if err != nil {
			fmt.Printf("Failed to create ephemeral key for %s\n", currentPartitionKey)
			return []byte(""), err
		}
		currentTime = currentTime.Add(time.Hour)
	}

	return []byte(""), nil
}

func process(currentPartitionKey string, expiryEpochSecs int64, ctx context.Context) error {
	// 1. Check if key already exists
	var getResp *dynamodb.GetItemOutput
	if err := xray.Capture(ctx, "process_GetItem_"+currentPartitionKey, func(ctx1 context.Context) (err error) {
		input := &dynamodb.GetItemInput{
			Key: map[string]*dynamodb.AttributeValue{
				"DateTime_Shard": {
					S: aws.String(currentPartitionKey),
				},
			},
			ConsistentRead: aws.Bool(false),
			TableName:      aws.String(paginationEphemeralKeyTableName),
		}
		getResp, err = dynamoDbClient.GetItemWithContext(ctx1, input)
		return err
	}); err != nil {
		return err
	}

	if len(getResp.Item) > 0 {
		fmt.Printf("process already found key for %s\n", currentPartitionKey)

		keyArn := *getResp.Item["KeyArn"].S
		if paginationKeyArn == keyArn {
			fmt.Printf("key exists and uses same key ARN, won't regenerate\n")
			return nil
		}

		fmt.Printf("key exists and uses different key ARN, will regenerate\n")
	}

	// 2. Ask KMS for a new encrypted data key
	var keyResp *kms.GenerateDataKeyWithoutPlaintextOutput
	if err := xray.Capture(ctx, "process_GenerateDataKey_"+currentPartitionKey, func(ctx1 context.Context) (err error) {
		input := &kms.GenerateDataKeyWithoutPlaintextInput{
			EncryptionContext: map[string]*string{
				"DateTime_Shard": aws.String(currentPartitionKey),
			},
			KeyId:   aws.String(paginationKeyArn),
			KeySpec: aws.String("AES_256"),
		}
		keyResp, err = kmsClient.GenerateDataKeyWithoutPlaintextWithContext(ctx, input)
		return err
	}); err != nil {
		return err
	}

	// 3. Put/clobber key with this date time.
	ephemeralKey := EphemeralKey{
		DateTime_Shard:     currentPartitionKey,
		EncryptedDataKey:   keyResp.CiphertextBlob,
		KeyArn:             paginationKeyArn,
		EpochExpirySeconds: expiryEpochSecs,
	}
	av, err := dynamodbattribute.MarshalMap(ephemeralKey)
	if err != nil {
		fmt.Println("CreateSession failed to ephemeral key")
		fmt.Println(err.Error())
		_ = xray.AddError(ctx, err)
		return err
	}

	if err := xray.Capture(ctx, "process_PutItem_"+currentPartitionKey, func(ctx1 context.Context) (err error) {
		input := &dynamodb.PutItemInput{
			Item:      av,
			TableName: aws.String(paginationEphemeralKeyTableName),
		}
		_, err = dynamoDbClient.PutItemWithContext(ctx1, input)
		return err
	}); err != nil {
		return err
	}

	return err
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

	paginationKeyArn = os.Getenv("PAGINATION_KEY_ARN")
	paginationEphemeralKeyTableName = os.Getenv("PAGINATION_EPHEMERAL_KEY_TABLE_NAME")
}

func main() {
	initialize()
	lambda.StartHandler(handler{})
}

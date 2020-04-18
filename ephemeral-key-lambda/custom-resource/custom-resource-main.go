// I haven't tried this out yet

package customresource

import (
	"context"
	"encoding/json"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	_ "github.com/aws/aws-lambda-go/lambdacontext"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/kms"
	"github.com/aws/aws-xray-sdk-go/strategy/ctxmissing"
	"github.com/aws/aws-xray-sdk-go/xray"
)

var (
	sess                            *session.Session
	dynamoDbClient                  *dynamodb.DynamoDB
	kmsClient                       *kms.KMS
	paginationKeyArn                string
	paginationEphemeralKeyTableName string
)

type cfnResponse struct {
	Status             string `json:"Status"`
	Reason             string `json:"Reason,omitempty"`
	StackId            string `json:"StackId"`
	RequestId          string `json:"RequestId"`
	LogicalResourceId  string `json:"LogicalResourceId"`
	PhysicalResourceId string `json:"PhysicalResourceId"`
	NoEcho             bool   `json:"NoEcho"`
}

type handler struct {
}

func (h handler) Invoke(ctx context.Context, data []byte) ([]byte, error) {
	var requestTemplate interface{}
	err := json.Unmarshal(data, &requestTemplate)
	if err != nil {
		log.Printf("Failed to deserialize JSON request: %s\n", err.Error())
		return nil, err
	}
	requestMap := requestTemplate.(map[string]interface{})

	requestType := requestMap["RequestType"].(string)
	log.Printf("requestType: %s\n", requestType)

	requestId := requestMap["RequestId"].(string)
	logicalResourceId := requestMap["LogicalResourceId"].(string)
	stackId := requestMap["StackId"].(string)

	response := cfnResponse{
		Status:             "SUCCESS",
		Reason:             "",
		StackId:            stackId,
		RequestId:          requestId,
		LogicalResourceId:  logicalResourceId,
		PhysicalResourceId: "paginationKeys",
		NoEcho:             false,
	}
	responseSerialized, err := json.Marshal(response)
	if err != nil {
		log.Printf("Failed to serialize JSON response: %s\n", err.Error())
		return nil, err
	}
	return responseSerialized, nil
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

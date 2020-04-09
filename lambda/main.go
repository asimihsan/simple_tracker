package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	//"github.com/aws/aws-xray-sdk-go/xray"
	"os"
	//"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

var sess = session.Must(session.NewSession())
var dynamoDbClient = dynamodb.New(sess)
var userTableName = os.Getenv("USER_TABLE_NAME");
var sessionTableName = os.Getenv("SESSION_TABLE_NAME");
var calendarTableName = os.Getenv("CALENDAR_TABLE_NAME");

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Printf("Processing request data for request %s.\n", request.RequestContext.RequestID)
	fmt.Printf("Body size = %d.\n", len(request.Body))
	fmt.Printf("Request path: %s.\n", request.Path)

	fmt.Println("Headers:")
	for key, value := range request.Headers {
		fmt.Printf("    %s: %s\n", key, value)
	}

	_, err := CreateUser("username", "password", dynamoDbClient, userTableName, ctx)
	if err != nil {
		fmt.Println("handleRequest error when creating user")
		fmt.Println(err.Error())
		return events.APIGatewayProxyResponse{Body: request.Body, StatusCode: 500}, nil
	}

	return events.APIGatewayProxyResponse{Body: request.Body, StatusCode: 200}, nil
}

func main() {
	//xray.AWS(dynamoDbClient.Client)
	lambda.Start(handleRequest)
}

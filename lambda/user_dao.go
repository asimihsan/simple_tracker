package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

type User struct {
	Username string
	Password string
	Id       string
}

func CreateUser(username string, password string, client *dynamodb.DynamoDB, userTableName string, ctx context.Context) (*User, error) {
	user := User{Username: username, Password: password, Id: "foo"}
	av, err := dynamodbattribute.MarshalMap(user)
	if err != nil {
		fmt.Println("CreateUser failed to marshal user")
		fmt.Println(err.Error())
		return nil, err
	}

	input := &dynamodb.PutItemInput{
		Item:      av,
		TableName: aws.String(userTableName),
	}
	_, err = client.PutItemWithContext(ctx, input)
	if err != nil {
		fmt.Println("Error during PutItem call")
		fmt.Println(err.Error())
		return nil, err
	}
	fmt.Printf("Successfully added username: %s\n", username)
	return &user, nil
}

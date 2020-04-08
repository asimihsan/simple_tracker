import * as cdk from '@aws-cdk/core';

import dynamodb = require('@aws-cdk/aws-dynamodb');
import lambda = require('@aws-cdk/aws-lambda');
import path = require('path');

export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const userTable = new dynamodb.Table(this, 'UserTable', {
      partitionKey: { name: 'username', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST
    });

    const sessionTable = new dynamodb.Table(this, 'SessionTable', {
      partitionKey: { name: 'id', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST
    });

    const calendarTable = new dynamodb.Table(this, 'CalendarTable', {
      partitionKey: { name: 'id', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST
    });

    const lambdaFunction = new lambda.Function(this, 'LambdaFunction', {
      runtime: lambda.Runtime.GO_1_X,
      handler: 'main',
      code: lambda.Code.fromAsset(path.join(__dirname, '../../lambda/build')),
      tracing: lambda.Tracing.ACTIVE
    });

    userTable.grantReadWriteData(lambdaFunction);
    sessionTable.grantReadWriteData(lambdaFunction);
    calendarTable.grantReadWriteData(lambdaFunction);
  }
}

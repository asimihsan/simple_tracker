import * as cdk from '@aws-cdk/core';

import * as apigateway from '@aws-cdk/aws-apigateway';
import * as certificatemanager from '@aws-cdk/aws-certificatemanager';
import * as dynamodb from '@aws-cdk/aws-dynamodb';
import * as lambda from '@aws-cdk/aws-lambda';
import * as route53 from '@aws-cdk/aws-route53';
import * as targets from '@aws-cdk/aws-route53-targets';
import path = require('path');
import { RemovalPolicy } from '@aws-cdk/core';

export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, apiDomainName: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // ------------------------------------------------------------------------
    //  DynamoDB storage.
    // ------------------------------------------------------------------------
    const userTable = new dynamodb.Table(this, 'UserTable', {
      partitionKey: { name: 'Username', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,

      // TODO if Prod make this RETAIN
      removalPolicy: RemovalPolicy.DESTROY,
    });

    const sessionTable = new dynamodb.Table(this, 'SessionTable', {
      partitionKey: { name: 'Id', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,

      // TODO if Prod make this RETAIN
      removalPolicy: RemovalPolicy.DESTROY,

      timeToLiveAttribute: 'ExpiryEpochSeconds'
    });

    const calendarTable = new dynamodb.Table(this, 'CalendarTable', {
      partitionKey: { name: 'OwnerUserId', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'Id', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,

      // TODO if Prod make this RETAIN
      removalPolicy: RemovalPolicy.DESTROY,
    });

    const paginationTokenTable = new dynamodb.Table(this, 'PaginationTokenTable', {
      partitionKey: { name: 'Id', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'SessionIdAndUserId', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,

      // TODO if Prod make this RETAIN
      removalPolicy: RemovalPolicy.DESTROY,

      timeToLiveAttribute: 'ExpiryEpochSeconds'
    });
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    //  Backend Lambda.
    // ------------------------------------------------------------------------
    const lambdaFunction = new lambda.Function(this, 'LambdaFunction', {
      code: lambda.Code.fromAsset(path.join(__dirname, '../../lambda/build')),
      environment: {
        "USER_TABLE_NAME": userTable.tableName,
        "SESSION_TABLE_NAME": sessionTable.tableName,
        "CALENDAR_TABLE_NAME": calendarTable.tableName,
        "PAGINATION_TOKEN_TABLE_NAME": paginationTokenTable.tableName,
      },
      handler: 'main',
      memorySize: 1024,
      runtime: lambda.Runtime.GO_1_X,
      timeout: cdk.Duration.seconds(10),
      tracing: lambda.Tracing.ACTIVE
    });

    userTable.grant(lambdaFunction,
      'dynamodb:GetItem',
      'dynamodb:PutItem',
    )
    sessionTable.grant(lambdaFunction,
      'dynamodb:GetItem',
      'dynamodb:PutItem',
    )
    calendarTable.grant(lambdaFunction,
      'dynamodb:GetItem',
      'dynamodb:Query',
      'dynamodb:UpdateItem',
      'dynamodb:DeleteItem',
    )
    paginationTokenTable.grant(lambdaFunction,
      'dynamodb:GetItem',
      'dynamodb:PutItem',
    )

    // const lambdaFunctionVersion = new lambda.Version(this, 'LambdaFunctionVersion_' + lambdaVersionLabel + "_", {
    //   lambda: lambdaFunction,
    //   provisionedConcurrentExecutions: 0,
    // });
    // const lambdaFunctionAlias = new lambda.Alias(this, 'LambdaFunctionAlias', {
    //   version: lambdaFunctionVersion,
    //   aliasName: 'live',
    // });
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    //  API Gateway endpoint with custom cert.
    // ------------------------------------------------------------------------
    const hostedZone = route53.HostedZone.fromLookup(this, 'HostedZone', {
      domainName: 'ihsan.io',
      privateZone: false
    });
    const certificate = new certificatemanager.DnsValidatedCertificate(this, "ApiCertificate", {
      domainName: apiDomainName,
      region: "us-east-1",
      hostedZone: hostedZone
    });
    const api = new apigateway.LambdaRestApi(this, 'Api', {
      handler: lambdaFunction,
      deployOptions: {
        tracingEnabled: true,
      },
      binaryMediaTypes: ["application/protobuf"],
    });
    const apiGatewayDomain = new apigateway.DomainName(this, 'ApiDomainName', {
      domainName: apiDomainName,
      certificate: certificate,
      endpointType: apigateway.EndpointType.EDGE,
      securityPolicy: apigateway.SecurityPolicy.TLS_1_2
    });
    apiGatewayDomain.addBasePathMapping(api);
    new route53.ARecord(this, "ApiDnsAlias", {
      zone: hostedZone,
      recordName: apiDomainName + ".",
      target: route53.RecordTarget.fromAlias(new targets.ApiGatewayDomain(apiGatewayDomain))
    });
    // ------------------------------------------------------------------------    
  }
}

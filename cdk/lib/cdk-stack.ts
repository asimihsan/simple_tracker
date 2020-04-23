import * as cdk from '@aws-cdk/core';

import * as apigateway from '@aws-cdk/aws-apigateway';
import * as apigatewayv2 from '@aws-cdk/aws-apigatewayv2';
import * as certificatemanager from '@aws-cdk/aws-certificatemanager';
import * as eventstargets from '@aws-cdk/aws-events-targets';
import * as dynamodb from '@aws-cdk/aws-dynamodb';
import * as iam from '@aws-cdk/aws-iam';
import * as kms from '@aws-cdk/aws-kms';
import * as lambda from '@aws-cdk/aws-lambda';
import * as r53targets from '@aws-cdk/aws-route53-targets';
import * as route53 from '@aws-cdk/aws-route53';

import { RemovalPolicy } from '@aws-cdk/core';
import { Rule, Schedule } from '@aws-cdk/aws-events';
import { RetentionDays } from '@aws-cdk/aws-logs';

import path = require('path');

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
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    //  KMS key for encrypting pagination tokens.
    // ------------------------------------------------------------------------
    const paginationKey = new kms.Key(this, 'PaginationKey', {
      enableKeyRotation: true,
      removalPolicy: RemovalPolicy.DESTROY,
    });

    const paginationEphemeralKeyTable = new dynamodb.Table(this, 'PaginationEphemeralKeyTable', {
      partitionKey: { name: 'DateTime_Shard', type: dynamodb.AttributeType.STRING },
      billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,

      // TODO if Prod make this RETAIN
      removalPolicy: RemovalPolicy.DESTROY,

      timeToLiveAttribute: 'ExpiryEpochSeconds',
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
        "PAGINATION_EPHEMERAL_KEY_TABLE_NAME": paginationEphemeralKeyTable.tableName,
      },
      handler: 'main',
      logRetention: RetentionDays.ONE_MONTH,
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
      'dynamodb:DeleteItem',
      'dynamodb:GetItem',
      'dynamodb:PutItem',
      'dynamodb:Query',
      'dynamodb:UpdateItem',
    )
    paginationEphemeralKeyTable.grant(lambdaFunction,
      'dynamodb:GetItem',
    );
    paginationKey.grant(lambdaFunction,
      'kms:Decrypt',
    );

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
    //  Pagination keys.
    // ------------------------------------------------------------------------
    const paginationKeyLambda = new lambda.Function(this, 'PaginationKeyLambda', {
      code: lambda.Code.fromAsset(path.join(__dirname, '../../ephemeral-key-lambda/build')),
      environment: {
        "PAGINATION_KEY_ARN": paginationKey.keyArn,
        "PAGINATION_EPHEMERAL_KEY_TABLE_NAME": paginationEphemeralKeyTable.tableName,
      },
      handler: 'main',
      logRetention: RetentionDays.ONE_MONTH,
      memorySize: 1024,
      runtime: lambda.Runtime.GO_1_X,
      timeout: cdk.Duration.seconds(30),
      tracing: lambda.Tracing.ACTIVE
    });
    paginationKey.grant(paginationKeyLambda,
      'kms:GenerateDataKeyWithoutPlaintext',
    );
    paginationEphemeralKeyTable.grant(paginationKeyLambda,
      'dynamodb:GetItem',
      'dynamodb:PutItem',
    );

    new Rule(this, 'PaginationEphemeralKeyScheduleRule', {
      schedule: Schedule.cron({ minute: '0/15' }),
      targets: [new eventstargets.LambdaFunction(paginationKeyLambda)],
    })
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
      target: route53.RecordTarget.fromAlias(new r53targets.ApiGatewayDomain(apiGatewayDomain))
    });
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    //  TODO experimenting with API Gateway v2.
    // ------------------------------------------------------------------------
    // const apiV2 = new apigatewayv2.CfnApi(this, 'ApiV2', {
    //   name: "ApiV2",
    //   protocolType: 'HTTP',
    //   target: lambdaFunction.functionArn,
    // });
    // const apiV2Stage = new apigatewayv2.CfnStage(this, 'ApiV2Stage', {
    //   apiId: apiV2.ref,
    //   stageName: 'v1',
    //   autoDeploy: true,
    // });
    // const apiV2Integration = new apigatewayv2.CfnIntegration(this, 'ApiV2Integration', {
    //   apiId: apiV2.ref,
    //   integrationType: 'AWS_PROXY',
    //   connectionType: 'INTERNET',
    //   integrationUri: `arn:${this.partition}:apigateway:${this.region}:lambda:path/2015-03-31/functions/${lambdaFunction.functionArn}/invocations`,
    //   integrationMethod: 'POST',
    //   payloadFormatVersion: '1.0',
    // });
    // const apiV2Route = new apigatewayv2.CfnRoute(this, 'ApiV2Route', {
    //   apiId: apiV2.ref,
    //   routeKey: 'POST /',
    //   authorizationType: 'NONE',
    //   target: `integrations/${apiV2Integration.ref}`,
    // });
    // const apiV2DomainName = new apigatewayv2.CfnDomainName(this, 'ApiV2DomainName', {
    //   domainName: apiDomainName,
    //   domainNameConfigurations: [{
    //     certificateArn: certificate.certificateArn,
    //     certificateName: 'ApiV2Certificate',
    //     endpointType: 'REGIONAL',
    //   }]
    // });
    // new route53.ARecord(this, "ApiV2DnsAlias", {
    //   zone: hostedZone,
    //   recordName: apiDomainName + ".",
    //   target: route53.RecordTarget.fromAlias(new ApiGatewayV2Domain(apiV2DomainName))
    // });

    // lambdaFunction.addPermission('grant-invoke-for-apiv2', {
    //   action: 'lambda:InvokeFunction',
    //   principal: new iam.ServicePrincipal('apigateway.amazonaws.com'),
    //   sourceArn: `arn:${this.partition}:execute-api:${this.region}:${this.account}:${apiV2.ref}/${apiV2Stage.stageName}${apiV2Route.routeKey}`,
    // });
    // ------------------------------------------------------------------------
  }
}

// export class ApiGatewayV2Domain implements route53.IAliasRecordTarget {
//   constructor(private readonly domainName: apigatewayv2.CfnDomainName) {

//   }

//   public bind(_record: route53.IRecordSet): route53.AliasRecordTargetConfig {
//     return {
//       hostedZoneId: this.domainName.attrRegionalHostedZoneId,
//       dnsName: this.domainName.attrRegionalDomainName
//     }
//   }
// }

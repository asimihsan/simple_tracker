import * as cdk from '@aws-cdk/core';

import * as apigateway from '@aws-cdk/aws-apigateway';
// import * as apigatewayv2 from '@aws-cdk/aws-apigatewayv2';
import * as certificatemanager from '@aws-cdk/aws-certificatemanager';
import * as cloudfront from '@aws-cdk/aws-cloudfront';
// import * as cfn_origins from '@aws-cdk/aws-cloudfront-origins';
import * as eventstargets from '@aws-cdk/aws-events-targets';
import * as dynamodb from '@aws-cdk/aws-dynamodb';
// import * as iam from '@aws-cdk/aws-iam';
import * as kms from '@aws-cdk/aws-kms';
import * as lambda from '@aws-cdk/aws-lambda';
import * as r53targets from '@aws-cdk/aws-route53-targets';
import * as route53 from '@aws-cdk/aws-route53';
import * as s3 from '@aws-cdk/aws-s3';
import * as s3deploy from '@aws-cdk/aws-s3-deployment';

import { Construct, Duration, RemovalPolicy } from '@aws-cdk/core';
import { Rule, Schedule } from '@aws-cdk/aws-events';
import { RetentionDays } from '@aws-cdk/aws-logs';

import path = require('path');
// import { HttpProxyIntegration } from '@aws-cdk/aws-apigatewayv2';

export interface StaticSiteProps {
  domainName: string;
  siteSubDomain: string;
}

export class StaticSite extends cdk.Stack {
  constructor(scope: cdk.App, id: string, domainName: string, siteSubDomain: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const zone = route53.HostedZone.fromLookup(this, 'Zone', { domainName: domainName });
    const siteDomain = siteSubDomain + '.' + domainName;
    new cdk.CfnOutput(this, 'Site', { value: 'https://' + siteDomain });

    // Content bucket
    const siteBucket = new s3.Bucket(this, 'SiteBucket', {
      bucketName: siteDomain,
      websiteIndexDocument: 'index.html',
      websiteErrorDocument: 'error.html',
      publicReadAccess: true,

      // The default removal policy is RETAIN, which means that cdk destroy will not attempt to delete
      // the new bucket, and it will remain in your account until manually deleted. By setting the policy to
      // DESTROY, cdk destroy will attempt to delete the bucket, but will error if the bucket is not empty.
      removalPolicy: cdk.RemovalPolicy.DESTROY, // NOT recommended for production code
    });
    new cdk.CfnOutput(this, 'Bucket', { value: siteBucket.bucketName });

    // TLS certificate
    const certificate = new certificatemanager.DnsValidatedCertificate(this, 'SiteCertificate', {
      domainName: siteDomain,
      hostedZone: zone,
      region: 'us-east-1', // Cloudfront only checks this region for certificates.
    });
    new cdk.CfnOutput(this, 'Certificate', { value: certificate.certificateArn });

    // CloudFront distribution that provides HTTPS
    const distribution = new cloudfront.CloudFrontWebDistribution(this, 'SiteDistribution', {
      viewerCertificate: cloudfront.ViewerCertificate.fromAcmCertificate(certificate, {
        securityPolicy: cloudfront.SecurityPolicyProtocol.TLS_V1_2_2019,
        aliases: [siteDomain],
        sslMethod: cloudfront.SSLMethod.SNI,
      }),
      priceClass: cloudfront.PriceClass.PRICE_CLASS_ALL,
      originConfigs: [
        {
          s3OriginSource: { s3BucketSource: siteBucket },
          behaviors: [
            {
              compress: true,
              isDefaultBehavior: true,
            },
            {
              pathPattern: 'index.html',
              compress: true,
              maxTtl: Duration.seconds(0),
            },
          ],
        }
      ]
    });
    new cdk.CfnOutput(this, 'DistributionId', { value: distribution.distributionId });

    // Route53 alias record for the CloudFront distribution
    new route53.ARecord(this, 'SiteAliasRecord', {
      recordName: siteDomain,
      target: route53.RecordTarget.fromAlias(new r53targets.CloudFrontTarget(distribution)),
      zone
    });

    // Deploy site contents to S3 bucket
    new s3deploy.BucketDeployment(this, 'DeployWithInvalidation', {
      sources: [s3deploy.Source.asset(path.join(__dirname, '../../static-site/dist/'))],
      destinationBucket: siteBucket,
      distribution,
      distributionPaths: ['/*'],
      memoryLimit: 2048,
    });
  }
}

export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, apiDomainName: string, apiV2DomainName: string, props?: cdk.StackProps) {
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
    // const apiV2Integration = new apigatewayv2.LambdaProxyIntegration({
    //   handler: lambdaFunction,
    //   payloadFormatVersion: apigatewayv2.PayloadFormatVersion.VERSION_1_0,
    // });
    // const apiV2 = new apigatewayv2.HttpApi(this, 'ApiV2', {
    //   defaultIntegration: apiV2Integration
    // });

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

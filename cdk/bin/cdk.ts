#!/usr/bin/env node
import * as cdk from '@aws-cdk/core';
import { CdkStack } from '../lib/cdk-stack';

const app = new cdk.App();

const preprodEnvironment = { account: '519160639284', region: 'us-west-2' }
const preprodDomainName = 'preprod-simple-tracker.ihsan.io'

const prodEnvironment = { account: '519160639284', region: 'us-west-2' }
const prodDomainName = 'prod-simple-tracker.ihsan.io'

new CdkStack(app, 'preprod-SimpleTrackerCdkStack', preprodDomainName, { env: preprodEnvironment });

#!/usr/bin/env node
import * as cdk from '@aws-cdk/core';
import { CdkStack } from '../lib/cdk-stack';

const app = new cdk.App();

const preprodEnvironment = { account: '519160639284', region: 'us-west-2' }
const prodEnvironment = { account: '519160639284', region: 'us-west-2' }

new CdkStack(app, 'preprod-SimpleTrackedCdkStack', { env: preprodEnvironment });

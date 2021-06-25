#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { CdkStack, StaticSite } from '../lib/cdk-stack';

const app = new cdk.App();

const preprodEnvironment = { account: '519160639284', region: 'us-west-2' }
const preprodDomainName = 'preprod-simple-tracker.ihsan.io'
const preprodDomainNameV2 = 'preprod-simple-tracker-v2.ihsan.io'

const prodEnvironment = { account: '519160639284', region: 'us-west-2' }
const prodDomainName = 'prod-simple-tracker.ihsan.io'
const prodDomainNameV2 = 'prod-simple-tracker-v2.ihsan.io'

new CdkStack(
    app,
    'preprod-SimpleTrackerCdkStack',
    preprodDomainName,
    preprodDomainNameV2,
    {
        env: preprodEnvironment,
    }
);

new StaticSite(
    app,
    "preprod-SimpleCalendarTrackerStaticSite",
    "simplecalendartracker.com",
    "preprod-www",
    {
        env: preprodEnvironment,
    }
);

new StaticSite(
    app,
    "prod-SimpleCalendarTrackerStaticSite",
    "simplecalendartracker.com",
    "www",
    {
        env: prodEnvironment,
    }
);

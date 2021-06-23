#!/usr/bin/env bash

set -euxo pipefail

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd "${DIR}"

(cd cdk && cdk deploy preprod-SimpleTrackerCdkStack preprod-SimpleCalendarTrackerStaticSite --strict)

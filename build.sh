#!/usr/bin/env bash

set -euxo pipefail

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd "${DIR}"

rm -rf flutter/lib/proto
mkdir -p flutter/lib/proto

rm -rf lambda/proto
mkdir -p lambda/proto

protoc -I=proto --dart_out=flutter/lib/proto --go_out=. proto/user.proto proto/calendar.proto
protoc -I=proto --dart_out=flutter/lib/proto proto/app_preferences.proto

(cd lambda && GOOS=linux go build -o build/main *.go)
(cd ephemeral-key-lambda && GOOS=linux go build -o build/main *.go)

(cd cdk && npm install)
(cd cdk && npm run build && npm run test)

(cd static-site && npm install)
(cd static-site && npm run build)

# (cd cdk && npm run build && npm run test && cdk deploy preprod-SimpleTrackerCdkStack --strict)
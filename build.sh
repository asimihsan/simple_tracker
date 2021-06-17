#!/usr/bin/env bash

set -euo pipefail

rm -rf flutter/lib/proto
mkdir -p flutter/lib/proto

rm -rf lambda/proto
mkdir -p lambda/proto &&

protoc -I=proto --dart_out=flutter/lib/proto --go_out=lambda/proto proto/user.proto proto/calendar.proto
protoc -I=proto --dart_out=flutter/lib/proto proto/app_preferences.protoc

(cd lambda && docker run -v $(pwd):/mnt/source -t simple-tracker-lambda /bin/bash -c 'cd /mnt/source && /usr/local/go/bin/go build -o build/main *.go')
(cd ephemeral-key-lambda && GOOS=linux go build -o build/main *.go)

# (cd cdk && npm run build && npm run test && cdk deploy preprod-SimpleTrackerCdkStack --strict)
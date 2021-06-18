#!/usr/bin/env bash

set -euxo pipefail

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd "${DIR}"

rm -rf flutter/lib/proto
mkdir -p flutter/lib/proto

rm -rf lambda/proto
mkdir -p lambda/proto &&

protoc -I=proto --dart_out=flutter/lib/proto --go_out=. proto/user.proto proto/calendar.proto
protoc -I=proto --dart_out=flutter/lib/proto proto/app_preferences.proto

(cd lambda && go build -o build/main *.go)

#(cd lambda && docker run -v $(pwd):/mnt/source -t simple-tracker-lambda /bin/bash -c 'cd /mnt/source && /usr/local/go/bin/go build -o build/main *.go')
#(cd ephemeral-key-lambda && GOOS=linux go build -o build/main *.go)

# (cd cdk && npm run build && npm run test && cdk deploy preprod-SimpleTrackerCdkStack --strict)
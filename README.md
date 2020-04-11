# Simple tracker

## Introduction

A minimalistic way of tracking occurrences of events over time. Only tracks whether events happened or not.

## Build / deployment steps

```
rm -rf flutter/lib/proto && mkdir -p flutter/lib/proto && \
rm -rf lambda/proto && mkdir -p lambda/proto && \
protoc -I=proto --dart_out=flutter/lib/proto --go_out=lambda/proto proto/user.proto && \
(cd lambda && GOOS=linux go build -o build/main *.go) && \
(cd cdk && cdk deploy preprod-SimpleTrackedCdkStack)
```

## License

Simple tracker is distributed under the terms of the Apache License (Version 2.0). See [LICENSE](LICENSE) for
details.

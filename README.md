# Simple tracker

## Introduction

A minimalistic way of tracking occurrences of events over time. Only tracks whether events happened or not.

## TODO experimenting with Docker builds of the core Lambda

```
cd lambda
docker build -t simple-tracker-lambda .

# interactive shell
docker run --volume $(pwd):/mnt/source --interactivet simple-tracker-lambda
```

## Build / deployment steps

`lambda` is built using Docker in an Amazon Linux environment to ensure that `gozstd` is built correctly. This is
a one-time step to get the image built:

```
(cd lambda && docker build -t simple-tracker-lambda .)
```

Here is how to build and deploy everything:

```
rm -rf flutter/lib/proto && mkdir -p flutter/lib/proto && \
rm -rf lambda/proto && mkdir -p lambda/proto && \
protoc -I=proto --dart_out=flutter/lib/proto --go_out=lambda/proto proto/user.proto proto/calendar.proto && \
(cd lambda && docker run -v $(pwd):/mnt/source -t simple-tracker-lambda /bin/bash -c 'cd /mnt/source && /usr/local/go/bin/go build -o build/main *.go') && \
(cd ephemeral-key-lambda && GOOS=linux go build -o build/main *.go) && \
(cd cdk && npm run build && npm run test && cdk deploy preprod-SimpleTrackerCdkStack --strict)
```

## License

Simple tracker is distributed under the terms of the Apache License (Version 2.0). See [LICENSE](LICENSE) for
details.

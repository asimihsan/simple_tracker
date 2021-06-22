# Simple tracker

## Introduction

A minimalistic way of tracking occurrences of events over time. Only tracks whether events happened or not.

## Build / deployment steps

### CDK

```
docker build -t simple-tracker --target final .

# build
docker run \
    --volume $(pwd):/mnt/app \
    --volume $HOME/.aws:/root/.aws:ro \
    -it simple-tracker \
    /bin/bash -c '. ~/.bashrc && /mnt/app/build.sh'

# interactive shell
docker run \
    --volume $(pwd):/mnt/app \
    --volume $HOME/.aws:/root/.aws:ro \
    -it simple-tracker \
    /bin/bash

# deploy
docker run \
    --volume $(pwd):/mnt/app \
    --volume $HOME/.aws:/root/.aws:ro \
    -it simple-tracker \
    /bin/bash -c '. ~/.bashrc && /mnt/app/deploy.sh'
```

## References

### Flutter

-   Flutter Favorites: https://pub.dev/flutter/favorites
    -   Rationale: https://flutter.dev/docs/development/packages-and-plugins/favorites

## License

Simple tracker is distributed under the terms of the Apache License (Version 2.0). See [LICENSE](LICENSE) for
details.

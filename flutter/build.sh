#!/usr/bin/env bash

set -euxo pipefail

flutter analyze
flutter test --coverage

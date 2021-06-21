#!/usr/bin/env bash

set -euxo pipefail

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd "${DIR}"

cd flutter

[ -f flutter/build/ios/archive/Runner.xcarchive ] && rm -f flutter/build/ios/archive/Runner.xcarchive
flutter clean

flutter pub get
cd ios
pod install
cd ..
flutter build ios
flutter build ipa

open flutter/build/ios/archive/Runner.xcarchive
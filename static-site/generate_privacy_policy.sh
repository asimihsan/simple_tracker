#!/usr/bin/env bash

set -euxo pipefail

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd "${DIR}"

pandoc ../doc/PRIVACY_POLICY.md -o src/partials/privacy_policy.html
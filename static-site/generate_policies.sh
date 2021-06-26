#!/usr/bin/env bash

set -euxo pipefail

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd "${DIR}"

pandoc ../doc/PRIVACY_POLICY.md -o src/partials/privacy_policy.html
pandoc ../doc/TERMS_OF_USE.md -o src/partials/terms_of_use.html
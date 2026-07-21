#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
FIXTURE_ROOT="${REPO_ROOT}/test/fixtures/host_extension"
HOST_ROOT="${FIXTURE_ROOT}/host"
OUT_ROOT="${FIXTURE_ROOT}/out"

mkdir -p "${OUT_ROOT}"

(
  cd "${HOST_ROOT}"
  dart pub get
)

(
  cd "${REPO_ROOT}"
  dart run tool/check_host_imports.dart \
    --entrypoint "${HOST_ROOT}/lib/extension.dart" \
    --package-config "${HOST_ROOT}/.dart_tool/package_config.json"
)

(
  cd "${HOST_ROOT}"
  dart compile js \
    --server-mode \
    --fatal-warnings \
    -O2 \
    lib/extension.dart \
    --output "${OUT_ROOT}/extension.dart.js"
)

cp "${HOST_ROOT}/bootstrap.cjs" "${OUT_ROOT}/bootstrap.cjs"

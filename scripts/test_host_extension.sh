#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
IMAGE_NAME="flutter-vscode-host-test:local"
TEMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/flutter-vscode-host-test.XXXXXX")"
TEMP_ROOT="$(cd "${TEMP_ROOT}" && pwd -P)"
CACHE_ROOT="${TEMP_ROOT}/vscode-test-cache"

cleanup() {
  rm -rf "${TEMP_ROOT}"
}
trap cleanup EXIT

mkdir -p "${CACHE_ROOT}"

"${REPO_ROOT}/scripts/build_host_fixture.sh"

docker build \
  --file "${REPO_ROOT}/packages/flutter_vscode/tool/extension_host_test/Dockerfile" \
  --tag "${IMAGE_NAME}" \
  "${REPO_ROOT}"

docker run --rm --init --shm-size=1g \
  --volume "${REPO_ROOT}:/workspace:ro" \
  --volume "${CACHE_ROOT}:/vscode-test-cache" \
  --env VSCODE_TEST_CACHE_PATH=/vscode-test-cache \
  --workdir /test-run \
  "${IMAGE_NAME}" \
  sh -c \
  'node --test /workspace/packages/flutter_vscode/tool/extension_host_test/bootstrap_lifecycle.test.cjs \
    /workspace/packages/flutter_vscode/tool/extension_host_test/host_contract.test.cjs &&
   xvfb-run -a node /workspace/packages/flutter_vscode/tool/extension_host_test/run.cjs'

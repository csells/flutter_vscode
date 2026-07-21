#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
IMAGE_NAME="flutter-vscode-host-test:local"
CACHE_VOLUME="flutter-vscode-host-test-cache"

"${REPO_ROOT}/scripts/build_host_fixture.sh"

docker build \
  --file "${REPO_ROOT}/tool/extension_host_test/Dockerfile" \
  --tag "${IMAGE_NAME}" \
  "${REPO_ROOT}"

docker volume create "${CACHE_VOLUME}" >/dev/null

docker run --rm --init --shm-size=1g \
  --volume "${REPO_ROOT}:/workspace:ro" \
  --volume "${CACHE_VOLUME}:/vscode-test-cache" \
  --env VSCODE_TEST_CACHE_PATH=/vscode-test-cache \
  --workdir /test-run \
  "${IMAGE_NAME}" \
  sh -c \
  'node --test /workspace/tool/extension_host_test/bootstrap_lifecycle.test.cjs &&
   xvfb-run -a node /workspace/tool/extension_host_test/run.cjs'

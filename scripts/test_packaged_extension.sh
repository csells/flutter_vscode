#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
IMAGE_NAME="flutter-vscode-host-test:local"
CACHE_VOLUME="flutter-vscode-host-test-cache"
TEMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/flutter-vscode-packaged-cli.XXXXXX")"
PUB_CACHE_ROOT="${TEMP_ROOT}/pub-cache"
PACKAGE_COPY="${TEMP_ROOT}/package"
WORKSPACE="${TEMP_ROOT}/workspace"
PROJECT_ROOT="${WORKSPACE}/activated_extension"
VIEW_FIXTURE_ROOT="${PACKAGE_COPY}/test/fixtures/host_extension"

cleanup() {
  rm -rf "${TEMP_ROOT}"
}
trap cleanup EXIT

mkdir -p "${PACKAGE_COPY}"
mkdir -p "${WORKSPACE}"
tar \
  --exclude=.dart_tool \
  --exclude=.git \
  --exclude=build \
  --exclude=node_modules \
  --exclude=out \
  -C "${REPO_ROOT}" \
  -cf - . | tar -C "${PACKAGE_COPY}" -xf -

PUB_CACHE="${PUB_CACHE_ROOT}" dart pub global activate \
  --source path "${PACKAGE_COPY}"
CLI="${PUB_CACHE_ROOT}/bin/flutter_vscode"

(
  cd "${WORKSPACE}"
  PUB_CACHE="${PUB_CACHE_ROOT}" "${CLI}" create activated_extension
  cd "${PROJECT_ROOT}"
  PUB_CACHE="${PUB_CACHE_ROOT}" "${CLI}" build
  PUB_CACHE="${PUB_CACHE_ROOT}" "${CLI}" package
)

(
  cd "${VIEW_FIXTURE_ROOT}"
  PUB_CACHE="${PUB_CACHE_ROOT}" "${CLI}" build
  PUB_CACHE="${PUB_CACHE_ROOT}" "${CLI}" package
)

docker build \
  --file "${REPO_ROOT}/tool/extension_host_test/Dockerfile" \
  --tag "${IMAGE_NAME}" \
  "${REPO_ROOT}"

docker volume create "${CACHE_VOLUME}" >/dev/null

run_packaged_project() {
  local project_root="$1"
  local command_result="$2"
  local require_view="$3"

  docker run --rm --init --shm-size=1g \
    --volume "${REPO_ROOT}:/workspace:ro" \
    --volume "${project_root}:/packaged-project:ro" \
    --volume "${CACHE_VOLUME}:/vscode-test-cache" \
    --env VSCODE_TEST_CACHE_PATH=/vscode-test-cache \
    --env FLUTTER_VSCODE_PACKAGED_PROJECT=/packaged-project \
    --env FLUTTER_VSCODE_PACKAGED_COMMAND_RESULT="${command_result}" \
    --env FLUTTER_VSCODE_PACKAGED_REQUIRE_VIEW="${require_view}" \
    --workdir /test-run \
    "${IMAGE_NAME}" \
    xvfb-run -a node /workspace/tool/extension_host_test/run_packaged.cjs
}

run_packaged_project "${PROJECT_ROOT}" "Hello from Dart" 0
run_packaged_project "${VIEW_FIXTURE_ROOT}" "pong from Dart" 1

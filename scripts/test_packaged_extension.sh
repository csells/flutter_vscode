#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
IMAGE_NAME="flutter-vscode-host-test:local"
TEMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/flutter-vscode-packaged-cli.XXXXXX")"
TEMP_ROOT="$(cd "${TEMP_ROOT}" && pwd -P)"
CACHE_ROOT="${TEMP_ROOT}/vscode-test-cache"
PUB_CACHE_ROOT="${TEMP_ROOT}/pub-cache"
PACKAGE_COPY="${TEMP_ROOT}/package"
WORKSPACE="${TEMP_ROOT}/workspace"
PROJECT_ROOT="${WORKSPACE}/activated_extension"
VIEW_FIXTURE_ROOT="${TEMP_ROOT}/host-extension-fixture"

cleanup() {
  rm -rf "${TEMP_ROOT}"
}
trap cleanup EXIT

mkdir -p "${PACKAGE_COPY}"
mkdir -p "${WORKSPACE}"
mkdir -p "${VIEW_FIXTURE_ROOT}"
mkdir -p "${CACHE_ROOT}"
# Stage the framework from pub's actual archive selection: the file list
# comes from `dart pub publish --dry-run` itself, so the installed E2E
# exercises exactly what a published package would contain.
PACKAGE_LIST="${TEMP_ROOT}/pub-archive-files.txt"
(cd "${REPO_ROOT}" && dart tool/pub_archive_list.dart) > "${PACKAGE_LIST}"
grep -qx "pubspec.yaml" "${PACKAGE_LIST}"
grep -qx "bin/flutter_vscode.dart" "${PACKAGE_LIST}"
while IFS= read -r archived_file; do
  mkdir -p "${PACKAGE_COPY}/$(dirname "${archived_file}")"
  cp "${REPO_ROOT}/${archived_file}" "${PACKAGE_COPY}/${archived_file}"
done < "${PACKAGE_LIST}"
(
  cd "${REPO_ROOT}/test/fixtures/host_extension"
  tar cf - \
    --exclude=.dart_tool \
    --exclude=build \
    --exclude=node_modules \
    --exclude=out \
    .
) | (cd "${VIEW_FIXTURE_ROOT}" && tar xf -)

test -f "${PACKAGE_COPY}/tool/binding_generator/generator.dart"
test -f "${PACKAGE_COPY}/tool/bindings/inputs/vscode/1.129.1/pins.json"
test ! -e "${PACKAGE_COPY}/test"
test ! -e "${PACKAGE_COPY}/specs"

# The repository fixture normally reaches flutter_vscode by walking back to the
# checkout root. Keep the copied fixture outside the staged package, but bind
# its dependency to the pristine pub-filtered package under test.
PUB_CACHE="${PUB_CACHE_ROOT}" dart pub add \
  --directory="${VIEW_FIXTURE_ROOT}/views/main" \
  --no-precompile \
  "override:flutter_vscode@{path: ${PACKAGE_COPY}}"

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

run_packaged_project() {
  local project_root="$1"
  local command_result="$2"
  local require_view="$3"

  docker run --rm --init --shm-size=1g \
    --volume "${REPO_ROOT}:/workspace:ro" \
    --volume "${project_root}:/packaged-project:ro" \
    --volume "${CACHE_ROOT}:/vscode-test-cache" \
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

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
IMAGE_NAME="flutter-vscode-host-test:local"
EXTENSION_ROOT="${REPO_ROOT}/extensions/coverage_treemap"
TEMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/flutter-vscode-coverage-ext.XXXXXX")"
TEMP_ROOT="$(cd "${TEMP_ROOT}" && pwd -P)"
CACHE_ROOT="${FLUTTER_VSCODE_TEST_CACHE:-${TEMP_ROOT}/vscode-test-cache}"
WORKSPACE="${TEMP_ROOT}/workspace"

cleanup() {
  rm -rf "${TEMP_ROOT}"
}
trap cleanup EXIT

mkdir -p "${CACHE_ROOT}"
mkdir -p "${WORKSPACE}/coverage" "${WORKSPACE}/lib/src"

# A known tracefile: 6 instrumented lines, 3 executed.
cat > "${WORKSPACE}/coverage/lcov.info" <<'EOF'
SF:lib/main.dart
DA:1,4
DA:2,0
DA:3,1
LF:3
LH:2
end_of_record
SF:lib/src/util.dart
DA:1,0
DA:2,0
DA:3,5
LF:3
LH:1
end_of_record
EOF
printf 'void main() {}\n' > "${WORKSPACE}/lib/main.dart"
printf 'int util() => 0;\n' > "${WORKSPACE}/lib/src/util.dart"

(
  cd "${EXTENSION_ROOT}"
  dart "${REPO_ROOT}/bin/flutter_vscode.dart" build
  dart "${REPO_ROOT}/bin/flutter_vscode.dart" package
)

docker build \
  --file "${REPO_ROOT}/tool/extension_host_test/Dockerfile" \
  --tag "${IMAGE_NAME}" \
  "${REPO_ROOT}"

docker run --rm --init --shm-size=1g \
  --volume "${REPO_ROOT}:/workspace:ro" \
  --volume "${WORKSPACE}:/coverage-workspace" \
  --volume "${CACHE_ROOT}:/vscode-test-cache" \
  --env VSCODE_TEST_CACHE_PATH=/vscode-test-cache \
  --env FLUTTER_VSCODE_COVERAGE_PROJECT=/workspace/extensions/coverage_treemap \
  --env FLUTTER_VSCODE_COVERAGE_WORKSPACE=/coverage-workspace \
  --workdir /test-run \
  "${IMAGE_NAME}" \
  xvfb-run -a node /workspace/tool/extension_host_test/run_coverage_extension.cjs

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
IMAGE_NAME="flutter-vscode-host-test:local"
EXTENSION_ROOT="${REPO_ROOT}/extensions/pubspec_lens"
TEMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/flutter-vscode-pubspec-lens.XXXXXX")"
TEMP_ROOT="$(cd "${TEMP_ROOT}" && pwd -P)"
CACHE_ROOT="${FLUTTER_VSCODE_TEST_CACHE:-${TEMP_ROOT}/vscode-test-cache}"
WORKSPACE="${TEMP_ROOT}/workspace"

cleanup() {
  rm -rf "${TEMP_ROOT}"
}
trap cleanup EXIT

mkdir -p "${CACHE_ROOT}"
mkdir -p "${WORKSPACE}/vendor/local_dep"

# One pin of each verdict, plus a skipped path dependency. The
# driver's fake registry answers current_pkg and behind_pkg with
# 1.2.3 and old_pkg with 2.0.0, so: current_pkg ^1.2.3 has nothing to
# suggest (silent), behind_pkg ^1.2.0 admits 1.2.3 but trails it (lens
# only), and old_pkg ^0.9.0 excludes 2.0.0 (lens and diagnostic).
cat > "${WORKSPACE}/pubspec.yaml" <<'EOF'
name: lens_workspace
environment:
  sdk: ^3.12.0

dependencies:
  current_pkg: ^1.2.3
  behind_pkg: ^1.2.0
  old_pkg: ^0.9.0
  local_dep:
    path: ./vendor/local_dep
EOF
cat > "${WORKSPACE}/vendor/local_dep/pubspec.yaml" <<'EOF'
name: local_dep
environment:
  sdk: ^3.12.0
EOF

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
  --volume "${WORKSPACE}:/pubspec-workspace" \
  --volume "${CACHE_ROOT}:/vscode-test-cache" \
  --env VSCODE_TEST_CACHE_PATH=/vscode-test-cache \
  --env FLUTTER_VSCODE_PUBSPEC_LENS_PROJECT=/workspace/extensions/pubspec_lens \
  --env FLUTTER_VSCODE_PUBSPEC_LENS_WORKSPACE=/pubspec-workspace \
  --workdir /test-run \
  "${IMAGE_NAME}" \
  xvfb-run -a node /workspace/tool/extension_host_test/run_pubspec_lens.cjs

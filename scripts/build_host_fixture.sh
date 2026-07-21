#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
FIXTURE_ROOT="${REPO_ROOT}/test/fixtures/host_extension"

(
  cd "${FIXTURE_ROOT}"
  dart "${REPO_ROOT}/bin/flutter_vscode.dart" build
)

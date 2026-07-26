#!/usr/bin/env bash
set -euo pipefail

# Run all tests for the flutter_vscode package.
#
# Usage:
#   ./scripts/test_all.sh
#
# This script assumes:
# - You have Flutter on your PATH
# - Docker is installed and its daemon is running
# - You've cloned this repo and are running from any directory inside it

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."

cd "${REPO_ROOT}"

echo "==> Ensuring package_config.json exists (flutter pub get)..."
flutter pub get

echo
echo "==> Running flutter tests..."
flutter test

echo
echo "==> Running deterministic binding importer checks..."
./scripts/test_binding_importer.sh

echo
echo "==> Running pinned VS Code Extension Host checks..."
./scripts/test_host_extension.sh

echo
echo "==> Installing and exercising a packaged Dart-owned extension..."
./scripts/test_packaged_extension.sh

echo '--- shipped extension: real-host gate'
./scripts/test_coverage_extension.sh

echo
echo "All tests completed successfully."

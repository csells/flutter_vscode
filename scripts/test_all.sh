#!/usr/bin/env bash
set -euo pipefail

# Run all tests and a build_runner smoke check for the flutter_vscode package.
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
echo "==> Running build_runner smoke test (verifies packageConfig/build setup)..."
dart run build_runner build --delete-conflicting-outputs

echo
echo "==> Running builder integration checks..."
dart test tool/check_dart_generator.dart tool/check_ts_generator.dart

echo
echo "==> Running deterministic binding importer checks..."
./scripts/test_binding_importer.sh

echo
echo "==> Running example project tests..."
(
  cd example
  flutter pub get
  flutter test
)

echo
echo "==> Running pinned VS Code Extension Host checks..."
./scripts/test_host_extension.sh

echo
echo "==> Installing and exercising a packaged Dart-owned extension..."
./scripts/test_packaged_extension.sh

echo '--- shipped example extension: real-host gate'
./scripts/test_coverage_extension.sh

echo
echo "All tests and build_runner checks completed successfully."

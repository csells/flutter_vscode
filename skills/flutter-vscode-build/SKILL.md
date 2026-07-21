---
name: flutter-vscode-build
description: >-
  Build or package a Dart-owned flutter_vscode Extension Project. Use before
  F5, after metadata/Host Dart/view changes, or when managed artifacts are stale.
---

# Build a flutter_vscode Extension

Run from the Extension Project root:

```sh
flutter_vscode build
```

The command validates `extension.dart` and the explicit `apiTarget`, enforces
host/shared dependency boundaries, regenerates native host bindings and the VS
Code manifest, compiles Host Dart, builds configured Flutter views, and writes
the launch configuration.

Do not run npm or edit generated JavaScript, TypeScript, `package.json`,
`coverage.json`, `host/lib/generated/**`, `host/bootstrap.cjs`, or `out/**`.

To produce an installable artifact:

```sh
flutter_vscode package
```

Packaging must reject missing, stale, or unexpected managed artifacts and
validate the exact VSIX layout. If it fails, repair author-owned Dart and rerun
`build`; do not patch the archive.

For reproducibility investigations, run `build` twice without source changes
and byte-compare framework-managed outputs.

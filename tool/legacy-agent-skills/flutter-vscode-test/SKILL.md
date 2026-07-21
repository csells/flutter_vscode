---
name: flutter-vscode-test
description: >-
  Test generated controllers and bridge behavior in a legacy flutter_vscode
  v0 project.
---

# Test a Legacy Controller

Use `flutter test` for Dart controller behavior. Fix request IDs with
`VSCodeControllerBase.debugRequestIdFactory`, deliver simulated replies through
`VSCodeControllerBase.handleMessage`, and clear pending requests in `tearDown`.

Test successful results, host errors, timeouts, and fire-and-forget calls. Then
regenerate and compile the real bridge:

```sh
flutter test
dart run build_runner build --delete-conflicting-outputs
npm run compile
```

Finish bridge or manifest changes with an F5 smoke test in an Extension
Development Host; VM tests cannot prove the TypeScript and webview wiring.

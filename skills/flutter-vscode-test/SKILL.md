---
name: flutter-vscode-test
description: >-
  Test Host Dart, generated VS Code behavior, or a Flutter View protocol in a
  flutter_vscode Extension Project.
---

# Test a flutter_vscode Extension

Test at the narrowest real seam that owns the behavior:

- Pure Dart tests for shared logic and protocol validation.
- Flutter tests for view rendering and typed protocol calls.
- A pinned VS Code Extension Host test for activation, commands, providers,
  native object identity, events, and disposal.
- An installed-VSIX test for packaging and auto-activation.

For protocol work, test the handshake and happy call first, then wrong version,
invalid schema, session/nonce mismatch, disallowed operation, duplicate request,
structured operation failure, close/reload, late replies, and zero pending or
subscription counts.

Use red-green-refactor: observe the new test fail for the intended reason, add
the smallest implementation, then run the focused test before broader gates.

Always finish with:

```sh
flutter_vscode build
flutter_vscode package
```

Framework contributors additionally run `flutter analyze` and
`./scripts/test_all.sh`.

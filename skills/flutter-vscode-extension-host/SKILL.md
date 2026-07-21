---
name: flutter-vscode-extension-host
description: >-
  Implement activation, commands, providers, events, or lifecycle behavior in
  Host Dart for a flutter_vscode Extension Project.
---

# Implement Host Dart Behavior

Put Extension Host logic in `host/lib/**`. It runs in VS Code even when no
Flutter view exists.

Use types exported by `host/lib/generated/vscode_facade.g.dart`. These are
mechanically generated `dart:js_interop` bindings that preserve native VS Code
objects. Check `coverage.json` before using a symbol. Do not create a handwritten
shadow binding, generic dispatcher, or inferred `dynamic` fallback.

Register VS Code-owned disposables in `ExtensionContext.subscriptions`. Give
Dart-owned resources idempotent cleanup and handle partial activation.

Keep Flutter, DOM, `package:web`, `dart:io`, isolates, and unsupported platform
libraries out of Host Dart. Put rich UI in `views/`; expose only explicit,
allowlisted value operations over the versioned view protocol.

After editing:

```sh
flutter_vscode build
```

Verify commands/providers before any view opens and again after every view has
closed.

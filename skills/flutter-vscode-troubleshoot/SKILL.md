---
name: flutter-vscode-troubleshoot
description: >-
  Diagnose flutter_vscode build, packaging, Host Dart, generated-binding, or
  Flutter View protocol failures.
---

# Troubleshoot a flutter_vscode Extension

## Build/configuration

- Run from the project root containing `extension.dart`.
- Keep the restricted constant descriptor shape emitted by `create`.
- Retain the explicit `apiTarget`; do not silently substitute another version.
- Fix the author-owned file named by a dependency-boundary diagnostic.

## Missing API

Check `coverage.json` and `host/lib/generated/**`. Pending or excluded symbols
are not available. Do not add raw interop or edit generated files; report the
pinned declaration ID so the framework pipeline can classify it.

## Stale artifacts or VSIX

```sh
flutter_vscode build
flutter_vscode package
```

If packaging still fails, use its exact stale/malformed path diagnostic. Never
patch `package.json`, `out/**`, or the archive manually.

## Flutter View

- Confirm built assets exist beneath `out/views/<name>/`.
- Check CSP, webview-safe URIs, and private `acquireVsCodeApi` initialization.
- Match protocol/version/session/nonce and use only allowlisted operations.
- On close or reload, confirm pending request and subscription counts return to
  zero and late messages are ignored.

Host commands and providers should remain functional without the view and after
it closes; if not, move their lifecycle out of the view session.

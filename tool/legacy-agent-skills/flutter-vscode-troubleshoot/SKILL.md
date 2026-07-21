---
name: flutter-vscode-troubleshoot
description: >-
  Diagnose generated handlers, npm builds, CSP, or webview bridge failures in
  a legacy flutter_vscode v0 project.
---

# Troubleshoot a Legacy Extension

For missing handlers or command timeouts, confirm the dotted
`@VSCodeCommand` ID and regenerate:

```sh
dart run build_runner build --delete-conflicting-outputs
npm run compile
```

Verify `lib/*.handlers.ts`, `out/extension.js`, and
`build/web/main.dart.js` exist. Confirm `VSCodeWebViewHelper.initialize()` runs
before `runApp` and the Extension Host routes `onDidReceiveMessage` to the
generated handler.

For a blank view, inspect the Extension Host and webview consoles, check
`localResourceRoots`, and rebuild with the scaffolded CSP-safe Flutter flags.
`acquireVsCodeApi()` exists only inside a VS Code webview, so a browser preview
cannot prove bridge calls.

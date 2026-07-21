---
name: flutter-vscode-build
description: >-
  Build a legacy flutter_vscode v0 project with its Dart generator, npm, and
  TypeScript/Flutter compile script.
---

# Build a Legacy Extension

Run commands from the extension project root:

```sh
dart run build_runner build --delete-conflicting-outputs
npm run compile
```

Code generation writes the Dart controller implementation and TypeScript
handlers. The npm script compiles the Extension Host and Flutter web assets.
Run both after controller changes; run `npm run compile` after TypeScript,
manifest, or Flutter UI changes and before pressing F5.

Treat `*.vscode.g.part`, `*.handlers.ts`, `out/`, and `build/web/` as generated
artifacts. Fix their Dart, TypeScript, or Flutter inputs instead of editing the
outputs.

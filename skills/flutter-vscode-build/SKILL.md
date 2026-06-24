---
name: flutter-vscode-build
description: >-
  Run the flutter_vscode build pipeline — build_runner, TypeScript compile,
  flutter build web. Use when generated handlers are missing, compile fails,
  or before F5 debugging.
---

# Build Pipeline (flutter_vscode)

Standard compile order for extension projects.

## Full Compile

```bash
dart run build_runner build --delete-conflicting-outputs
npm run compile
```

`npm run compile` typically runs `scripts/compile.sh`:

1. `dart run build_runner build --delete-conflicting-outputs`
2. `tsc -p ./`
3. `flutter build web --no-web-resources-cdn --csp --pwa-strategy none --no-tree-shake-icons`

## When to Run build_runner

Run after **any** change to:
- `@VSCodeController` / `@VSCodeCommand` annotations
- Method signatures on annotated controllers

Outputs:
- `lib/*.vscode.g.part` — Dart implementation
- `lib/*.handlers.ts` — TypeScript dispatch (imported by `extension.ts`)

## When to Run npm run compile

- Before F5 / extension host launch
- After controller or `extension.ts` changes
- After Flutter UI changes

## Verify Outputs

| Artifact | Purpose |
|---|---|
| `lib/*.handlers.ts` | TS command dispatch |
| `out/extension.js` | Compiled extension entry |
| `build/web/main.dart.js` | Flutter webview bundle |

## Common Failures

| Error | Fix |
|---|---|
| `handleCommand` not found | Run build_runner |
| Webview blank | Run `npm run compile`; check `build/web/` exists |
| TS compile error in handlers | Fix Dart controller; regenerate — don't edit handlers |
| `InvalidGenerationSourceError` | Fix annotation rules (abstract, positional, Future<T>) |

## Debug

Press F5 in VS Code with extension project open (Extension Development Host).

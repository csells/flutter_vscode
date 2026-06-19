---
name: flutter-vscode-troubleshoot
description: >-
  Diagnose flutter_vscode extension issues — blank webview, CSP errors,
  missing handlers, command timeouts, acquireVsCodeApi. Use when F5 fails
  or VS Code API calls from Flutter do nothing.
---

# Troubleshoot (flutter_vscode)

## Symptom: Webview Is Blank

1. Run `npm run compile` — confirm `build/web/main.dart.js` exists.
2. Check extension host debug console for `index.html` read errors.
3. Confirm `localResourceRoots` includes `build/web` in `extension.ts`.
4. Verify Flutter build used CSP flags (see `scripts/compile.sh`).

## Symptom: Command Does Nothing

1. Run `dart run build_runner build --delete-conflicting-outputs`.
2. Check `lib/*.handlers.ts` has a `case` for your command id.
3. Use **dotted** command id: `'window.showInputBox'`.
4. Confirm `VSCodeWebViewHelper.initialize()` in `main()`.
5. Run full `npm run compile` and reload extension host.

## Symptom: TimeoutException (30s)

- Extension host did not post `{ requestId, result }` back.
- Handler may be missing or `expectsResponse` mismatch.
- Check generated handler awaits async VS Code API and posts result.

## Symptom: Handler Not Found / default case

- Command id in Dart does not match generated switch case.
- Regenerate with build_runner.

## Symptom: Works in Browser, Not in Webview

- `acquireVsCodeApi()` only exists inside VS Code webview.
- Browser dev uses `window.postMessage` fallback — VS Code APIs won't run.

## Symptom: CSP / CanvasKit Errors

Rebuild with:

```bash
flutter build web --no-web-resources-cdn --csp --pwa-strategy none --no-tree-shake-icons
```

Ensure `web/flutter_bootstrap.js` uses local `canvaskit/`.

## Symptom: InvalidGenerationSourceError

| Message | Fix |
|---|---|
| must be abstract | Add `abstract` to class/method |
| positional parameters only | Remove named/optional params |
| Future<T> explicit | Use `Future<String>` not `Future` |
| cannot declare generic type parameters | Remove method generics |

## Diagnostic Checklist

```bash
dart run build_runner build --delete-conflicting-outputs
npm run compile
ls build/web/main.dart.js out/extension.js lib/*.handlers.ts
```

Press F5 → open webview view → trigger command → check Extension Host console.

## Related Docs

- [Message Contract](../../docs/reference/message-contract.md)
- [Troubleshooting Guide](../../docs/guides/troubleshooting.md)

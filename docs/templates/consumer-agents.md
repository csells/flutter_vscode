# Extension Agent Guidelines

This project is a **flutter_vscode** VS Code extension: Flutter web UI in a
webview, Dart controllers for VS Code API calls, TypeScript extension host.

These rules apply to AI agents and contributors working in **this extension
project** (not the flutter_vscode package itself).

## Skills

Project skills live in `.cursor/skills/`. Use them for common tasks:

| Skill | When to use |
|---|---|
| `flutter-vscode-add-command` | Call a VS Code API from Flutter/Dart |
| `flutter-vscode-contributions` | Edit `package.json` views, commands, menus |
| `flutter-vscode-extension-host` | Code that belongs in `src/extension.ts` |
| `flutter-vscode-build` | build_runner, tsc, flutter build web |
| `flutter-vscode-test` | VM tests for controllers without a webview |
| `flutter-vscode-troubleshoot` | Webview blank, CSP, timeouts, missing handlers |

## Decision Tree

```
User wants VS Code behavior
│
├─ Triggered from Flutter UI (button, form)?
│  └─ Add method to lib/vscode_api.dart with @VSCodeCommand('namespace.method')
│     Run: dart run build_runner build --delete-conflicting-outputs
│     NEVER edit lib/*.handlers.ts by hand
│
├─ Register at extension startup (provider, event listener)?
│  └─ Edit src/extension.ts inside activate()
│
├─ New sidebar / command palette / menu item?
│  └─ Edit package.json contributes section
│
└─ Tree view / terminal / debug / language features?
   └─ Host-only — implement in src/extension.ts (not annotations)
```

## Mandatory Rules

1. **Dotted command ids** — `@VSCodeCommand('window.showInputBox')` always.
2. **Abstract controller** — `@VSCodeController()` on abstract class; abstract methods only.
3. **Positional params only** — map TS options objects to `Map<String, dynamic>` as a single arg.
4. **Regenerate after controller changes** — `dart run build_runner build --delete-conflicting-outputs`
5. **Never edit generated files** — `*.vscode.g.part`, `*.handlers.ts`
6. **Initialize bridge** — `VSCodeWebViewHelper.initialize()` in `main()` before `runApp`
7. **Full compile** — `npm run compile` before F5 (build_runner + tsc + flutter build web)

## File Ownership

| Edit freely | Regenerate only | Scaffold (edit carefully) |
|---|---|---|
| `lib/*.dart` (except `*.g.part`) | `*.vscode.g.part` | `src/extension.ts` |
| Flutter UI under `lib/` | `*.handlers.ts` | `package.json` |
| `test/` | | `web/` |

## Common API Patterns

Use `VSCode.instance.invoke` for quick experiments, or annotations for stable APIs:

```dart
// Dynamic invoke (no build_runner)
await VSCode.instance.invoke<void>(
  'window.showInformationMessage',
  ['Hello'],
  expectsResponse: false,
);

// Annotated controller
@VSCodeCommand('window.showInformationMessage')
Future<void> info(String message);
```

## Build Pipeline

```bash
dart run build_runner build --delete-conflicting-outputs
npm run compile
```

Then F5 in VS Code (Extension Development Host).

## Testing Without Webview

```dart
VSCodeControllerBase.debugRequestIdFactory = () => 'test-req-1';
final future = api.inputBox({'prompt': 'Name?'});
VSCodeControllerBase.handleMessage({
  'requestId': 'test-req-1',
  'result': 'Ada',
});
expect(await future, 'Ada');
```

## When Stuck

1. Confirm build_runner ran after controller edits.
2. Confirm `npm run compile` completed (`build/web/`, `out/extension.js`).
3. Check command id uses correct namespace (`window.`, `workspace.`, `commands.`).
4. Read generated `lib/vscode_api.handlers.ts` — do not edit; verify case exists.
5. Use `flutter-vscode-troubleshoot` skill.

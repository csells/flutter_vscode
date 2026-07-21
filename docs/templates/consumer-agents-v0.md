# Extension Agent Guidelines

This is a legacy `flutter_vscode` v0 Extension Project: Flutter web UI in a
webview, Dart controllers for VS Code API calls, and a TypeScript extension
host. New projects should use the Dart-owned `flutter_vscode create` workflow.

## Skills

Project skills live in `agent-skills/`. Use the matching skill for each task:

| Skill | When to use |
|---|---|
| `flutter-vscode-add-command` | Call a VS Code API from Flutter/Dart |
| `flutter-vscode-contributions` | Edit views, commands, and menus |
| `flutter-vscode-extension-host` | Change `src/extension.ts` host code |
| `flutter-vscode-build` | Run code generation and compile |
| `flutter-vscode-test` | Test Dart controllers without a webview |
| `flutter-vscode-troubleshoot` | Diagnose bridge, CSP, or build failures |

## Decision guide

```text
Flutter UI calls VS Code -> add @VSCodeCommand to lib/vscode_api.dart
Startup provider or event -> edit src/extension.ts activate()
View, command, or menu contribution -> edit package.json
Generated bridge output -> regenerate; never edit by hand
```

## Mandatory rules

1. Use dotted command IDs, such as
   `@VSCodeCommand('window.showInformationMessage')`.
2. Put `@VSCodeController()` on an abstract class with abstract methods.
3. Map TypeScript option objects to one `Map<String, dynamic>` argument.
4. Run code generation after controller changes.
5. Never edit `*.vscode.g.part` or `*.handlers.ts`.
6. Call `VSCodeWebViewHelper.initialize()` before `runApp`.
7. Run the full compile before launching the Extension Development Host.

## Build and test

```sh
dart run build_runner build --delete-conflicting-outputs
npm run compile
flutter test
```

Use `VSCode.instance.invoke` only for quick experiments; prefer an annotated
controller for stable calls. If a bridge call fails, verify its dotted command
ID and regenerate before inspecting generated handlers.

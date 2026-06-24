---
name: flutter-vscode-add-command
description: >-
  Add a VS Code API call from Flutter/Dart using flutter_vscode annotations.
  Use when the user wants to call vscode.window, vscode.workspace, or
  vscode.commands from Flutter UI, add @VSCodeCommand methods, or wire
  extension host APIs through the webview bridge.
---

# Add VS Code Command (flutter_vscode)

Add a VS Code extension API call callable from Flutter webview code.

## Choose an approach

| Approach | When to use |
|---|---|
| **`VSCode.instance.invoke`** | Experiments, one-off calls, prototyping — no `build_runner` |
| **`@VSCodeCommand` annotations** | Stable extension API surface, typed controller, tests |

### Quick invoke (no build_runner)

Requires `src/vscode_invoke.ts` and `routeWebviewMessage` in `extension.ts` (scaffold default).

```dart
import 'package:flutter_vscode/runtime.dart';

final name = await VSCode.instance.invoke<String?>(
  'window.showInputBox',
  [{'prompt': 'Name?'}],
);

await VSCode.instance.invoke<void>(
  'window.showInformationMessage',
  ['Hello!'],
  expectsResponse: false,
);
```

### Annotated controller (typed, codegen)

## Prerequisites

- Controller file exists (usually `lib/vscode_api.dart`) with `@VSCodeController()`
- `VSCodeWebViewHelper.initialize()` in `main()`
- `part 'vscode_api.vscode.g.part';` at top of controller file

## Workflow

1. **Identify the VS Code API** — namespace and method (e.g. `vscode.window.showQuickPick`).
2. **Confirm it is RPC-compatible** — simple call with JSON-serializable args/return.
   - If it registers a provider or returns `Disposable` / `Event`, use
     `flutter-vscode-extension-host` instead.
3. **Add abstract method** to the `@VSCodeController()` class:

```dart
@VSCodeCommand('window.showQuickPick')
Future<String?> quickPick(List<String> items);
```

Rules:
- Use **dotted command id**: `'window.showQuickPick'` not `'showQuickPick'`
- Method must be **abstract**
- **Required positional parameters only**
- Return `void`, `Future<void>`, or `Future<T>` with explicit `T`
- Map TS options objects to `Map<String, dynamic>` as a single positional arg

4. **Run code generation** (mandatory):

```bash
dart run build_runner build --delete-conflicting-outputs
```

5. **Wire Flutter UI** — call factory then method:

```dart
final api = createVSCodeApi();
final choice = await api.quickPick(['A', 'B', 'C']);
```

6. **Compile extension**:

```bash
npm run compile
```

7. **Never edit** `*.handlers.ts` or `*.vscode.g.part` by hand.

## Type Mapping Quick Reference

| VS Code | Dart |
|---|---|
| `string` | `String` |
| `string \| undefined` | `String?` |
| `InputBoxOptions` | `Map<String, dynamic>` |
| `readonly string[]` | `List<String>` |
| `Uri` | `String` (uri string) |
| `Thenable<T>` | `Future<T>` |

Full catalog: `docs/reference/vscode-api-mapping.md` in the flutter_vscode package.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Forgot build_runner | Run build_runner; handlers won't exist |
| Undotted command id | Use `'window.showInputBox'` |
| Named Dart params | Use positional only; options as Map |
| Edited `*.handlers.ts` | Revert; fix Dart and regenerate |
| Complex return type | Use host-side code in `extension.ts` |

## Verify

- Generated `lib/vscode_api.handlers.ts` contains a `case` for the command id
- `npm run compile` succeeds
- F5 smoke test: action triggers VS Code UI

# VS Code API Mapping Reference

> **Legacy v0 reference:** The catalog below describes the original
> annotation/TypeScript webview bridge. New Extension Projects use generated
> Host Dart bindings, Dart-owned `extension.dart` contributions, and the
> `flutter_vscode build` workflow. Check `coverage.json` for the pinned symbols
> currently available; do not translate an unsupported API by inference.

This remains a cheat sheet for maintaining existing annotation-based projects.

## Decision Tree: Where Does Code Go?

```
Need VS Code API?
│
├─ Call from Flutter UI (button tap, form submit)?
│  └─ YES → Add @VSCodeCommand to lib/vscode_api.dart (webview RPC)
│           Run build_runner. Do NOT edit *.handlers.ts.
│
├─ Register provider / listen to events / run at activation?
│  └─ YES → Edit src/extension.ts (extension host)
│           (The current skills/ describe the v1 Dart-host
│           workflow, not this legacy step.)
│
├─ Add sidebar, command palette entry, menu, keybinding?
│  └─ YES → Edit package.json contributions
│           (The current skills/ describe the v1 Dart-host
│           workflow, not this legacy step.)
│
└─ Tree view, terminal, debug adapter, language server?
   └─ Host-only patterns — not supported via annotations today.
      Implement in src/extension.ts; optionally trigger from webview via
      a thin @VSCodeCommand that posts a custom message to the host.
```

## Annotation Rules (Mandatory)

1. **Always use dotted command ids** for VS Code APIs:
   `@VSCodeCommand('window.showInputBox')` not `@VSCodeCommand('showInputBox')`.
2. Controller class must be **abstract** with `@VSCodeController()`.
3. Command methods must be **abstract** with `@VSCodeCommand(...)`.
4. **Required positional parameters only** — no named or optional params.
5. Return types: `void`, `Future<void>`, or `Future<T>` with explicit `T`.
6. After any controller change, run:
   `dart run build_runner build --delete-conflicting-outputs`
7. **Never hand-edit** `*.vscode.g.part` or `*.handlers.ts`.

## Type Mapping (VS Code TypeScript → Dart)

| VS Code / TypeScript | Dart annotation param / return | Notes |
|---|---|---|
| `string` | `String` | |
| `number` | `num` or `int` | JSON numbers deserialize as `int` or `double` |
| `boolean` | `bool` | |
| `string \| undefined` | `String?` | Use nullable return |
| `Uri` | `String` | Pass `uri.toString()`; host receives string |
| `readonly string[]` | `List<String>` | JSON array |
| `InputBoxOptions` | `Map<String, dynamic>` | Single positional options object |
| `QuickPickOptions` | `Map<String, dynamic>` | Combine with items as second param if needed |
| `MessageItem` / complex objects | `Map<String, dynamic>` | Prefer simple types when possible |
| `Thenable<T>` | `Future<T>` | |
| `void` | `void` or `Future<void>` | Fire-and-forget dialogs |

Complex VS Code types that are not JSON-serializable (`Disposable`, `Event`,
`TextEditor`, `Terminal`) **cannot** cross the webview bridge. Use host-side
code in `src/extension.ts` instead.

## Tier 1 — Dialogs and UI Chrome

Callable from Flutter via annotations. Copy patterns into `lib/vscode_api.dart`.

### showInformationMessage

```dart
@VSCodeCommand('window.showInformationMessage')
Future<void> showInfo(String message);
```

VS Code: `vscode.window.showInformationMessage(message: string)`

### showWarningMessage

```dart
@VSCodeCommand('window.showWarningMessage')
Future<void> showWarning(String message);
```

### showErrorMessage

```dart
@VSCodeCommand('window.showErrorMessage')
Future<void> showError(String message);
```

### showInputBox

Simple prompt string (legacy-style single arg):

```dart
@VSCodeCommand('window.showInputBox')
Future<String?> inputBox(String prompt);
```

With options object (preferred for real extensions):

```dart
@VSCodeCommand('window.showInputBox')
Future<String?> inputBoxWithOptions(Map<String, dynamic> options);
```

Dart call site:

```dart
await api.inputBoxWithOptions({
  'prompt': 'Enter your name',
  'placeHolder': 'Jane Doe',
});
```

### showQuickPick

```dart
@VSCodeCommand('window.showQuickPick')
Future<String?> pickItem(List<String> items);
```

Dart call site:

```dart
final choice = await api.pickItem(['Option A', 'Option B', 'Option C']);
```

### showOpenDialog

```dart
@VSCodeCommand('window.showOpenDialog')
Future<List<String>?> openFiles(Map<String, dynamic> options);
```

Example options:

```dart
await api.openFiles({
  'canSelectMany': true,
  'filters': {'dart': ['dart']},
});
```

Returns URI strings (serialized).

### showSaveDialog

```dart
@VSCodeCommand('window.showSaveDialog')
Future<String?> saveFile(Map<String, dynamic> options);
```

### setStatusBarMessage

```dart
@VSCodeCommand('window.setStatusBarMessage')
Future<void> statusMessage(String text);
```

## Tier 2 — Workspace and Configuration

### getConfiguration

```dart
@VSCodeCommand('workspace.getConfiguration')
Future<Map<String, dynamic>> getConfig(String section);
```

Note: Return value is JSON-serialized; structure may differ from full
`WorkspaceConfiguration` object.

### workspaceFolders

```dart
@VSCodeCommand('workspace.workspaceFolders')
Future<List<dynamic>?> workspaceFolders();
```

### findFiles

```dart
@VSCodeCommand('workspace.findFiles')
Future<List<String>> findFiles(
  String include,
  String? exclude,
);
```

Use empty string or `null` for default exclude depending on API overload;
verify against `@types/vscode` when adding.

### readFile / writeFile (workspace.fs)

```dart
@VSCodeCommand('workspace.fs.readFile')
Future<List<int>> readFile(String uriString);

@VSCodeCommand('workspace.fs.writeFile')
Future<void> writeFile(String uriString, List<int> content);
```

## Tier 3 — Commands

### executeCommand

```dart
@VSCodeCommand('commands.executeCommand')
Future<dynamic> runCommand(String command, List<dynamic> args);
```

Example:

```dart
await api.runCommand('workbench.action.files.saveAll', []);
```

Arguments must be JSON-serializable.

### getCommands

```dart
@VSCodeCommand('commands.getCommands')
Future<List<String>> listCommands(bool filterInternal);
```

## Tier 4 — Editor (Read-Oriented)

Prefer snapshots; full `TextEditor` objects do not cross the bridge.

### showTextDocument

```dart
@VSCodeCommand('window.showTextDocument')
Future<void> showDocument(String uriString);
```

Reading active editor state typically requires custom host logic in
`extension.ts` that snapshots editor fields and posts them to the webview.

## Unsupported via Annotations (Use extension.ts)

| Pattern | Why | Workaround |
|---|---|---|
| `onDidChangeActiveTextEditor` | Event subscription | Register in `extension.ts`; `postMessage` to webview |
| `registerTreeDataProvider` | Provider + callbacks | Implement provider in `extension.ts` |
| `createTerminal` | Live handle + streaming | Create terminal in host; expose thin command |
| `registerCompletionItemProvider` | Language feature | Host-only registration |
| `TextEditor.edit()` | Mutable host object | Host applies edits; webview sends intent |
| `Disposable` return values | Not serializable | Host manages lifecycle |
| Debug adapters | Separate contribution | `package.json` + host module |

## Full Controller Example

For stable APIs, prefer annotations. For experiments, use [dynamic invoke](#dynamic-invoke-vscodeinstanceinvoke).

### Dynamic invoke (`VSCode.instance.invoke`)

No annotations or `build_runner` required when `src/vscode_invoke.ts` is present:

```dart
import 'package:flutter_vscode/runtime.dart';

final choice = await VSCode.instance.invoke<String?>(
  'window.showQuickPick',
  [['Option A', 'Option B', 'Option C']],
);

await VSCode.instance.invoke<void>(
  'window.showWarningMessage',
  ['Heads up!'],
  expectsResponse: false,
);
```

### Annotated controller

```dart
import 'package:flutter_vscode/runtime.dart';

part 'vscode_api.vscode.g.part';

@VSCodeController()
abstract class VSCodeApi {
  @VSCodeCommand('window.showInformationMessage')
  Future<void> info(String message);

  @VSCodeCommand('window.showInputBox')
  Future<String?> inputBox(Map<String, dynamic> options);

  @VSCodeCommand('window.showQuickPick')
  Future<String?> quickPick(List<String> items);

  @VSCodeCommand('window.showErrorMessage')
  Future<void> error(String message);

  @VSCodeCommand('commands.executeCommand')
  Future<dynamic> executeCommand(String command, List<dynamic> args);
}

VSCodeApi createVSCodeApi() => _$VSCodeApi();
```

## Flutter Usage

```dart
import 'package:flutter_vscode/flutter_vscode.dart';

void main() {
  VSCodeWebViewHelper.initialize();
  runApp(const MyApp());
}
```

```dart
final api = createVSCodeApi();
final name = await api.inputBox({'prompt': 'Name?'});
if (name != null) {
  await api.info('Hello, $name!');
}
```

## Build Checklist

After changing controllers:

```bash
dart run build_runner build --delete-conflicting-outputs
npm run compile
```

Press F5 in VS Code to test in the extension development host.

## Agent Eval Scenarios

Use these to verify agent-assisted workflows:

1. Add `showWarningMessage` and call from a button.
2. Add `showQuickPick` with three string options.
3. Add `showInputBox` with options map (`prompt`, `placeHolder`).
4. Add `commands.executeCommand` for `workbench.action.openSettings`.
5. Add `window.showOpenDialog` with `canSelectMany: false`.
6. Wire two commands in sequence (pick then toast).
7. Add VM test using `VSCodeControllerBase.debugRequestIdFactory`.
8. Confirm `*.handlers.ts` was regenerated (not hand-edited).
9. Run `npm run compile` without errors.
10. F5 smoke test — webview loads, command round-trip succeeds.

## Related

- [Quickstart](../guides/quickstart.md)
- [Troubleshooting](../guides/troubleshooting.md)
- Package skills: `skills/` in the `flutter_vscode` repository (these now
  document the v1 Dart-host workflow and supersede the v0 steps above)

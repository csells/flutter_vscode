---
name: flutter-vscode-extension-host
description: >-
  Implement extension host logic in src/extension.ts for flutter_vscode
  projects. Use for activation handlers, event listeners, tree views,
  webview message routing, or APIs that cannot cross the webview bridge.
---

# Extension Host Patterns (flutter_vscode)

Code in `src/extension.ts` runs in the **Node extension host** with full
access to `vscode.*`. Flutter/Dart in the webview cannot register providers
or subscribe to events directly.

## When to Use extension.ts vs Annotations

| Need | Where |
|---|---|
| Call VS Code API from Flutter button | `@VSCodeCommand` in `lib/vscode_api.dart` |
| Listen to `onDidChangeActiveTextEditor` | `extension.ts` in `activate()` |
| Register tree view / terminal / provider | `extension.ts` |
| Route webview messages to VS Code | Already wired: `onDidReceiveMessage` → `handleCommand` |

## Default Webview Wiring

Scaffolded `extension.ts` registers a webview view provider and routes
Flutter → VS Code calls:

```typescript
webviewView.webview.onDidReceiveMessage(async (message) => {
  await handleCommand(message, webviewView.webview);
});
```

`handleCommand` is imported from generated `lib/vscode_api.handlers.ts`.
Do not replace this with hand-written per-command switches.

## Post Message to Flutter (Host → Webview)

```typescript
webviewView.webview.postMessage({ type: 'editorChanged', uri: doc.uri.toString() });
```

Handle in Dart by extending message listening (custom code beyond generated
request/response pairs).

## Event Listener Example

```typescript
export function activate(context: vscode.ExtensionContext) {
  context.subscriptions.push(
    vscode.window.onDidChangeActiveTextEditor((editor) => {
      if (editor && provider.view) {
        provider.view.webview.postMessage({
          type: 'activeEditor',
          uri: editor.document.uri.toString(),
        });
      }
    }),
  );
}
```

## Register Custom Host Command

```typescript
context.subscriptions.push(
  vscode.commands.registerCommand('myExtension.doHostWork', async () => {
    const result = await vscode.window.showInputBox({ prompt: 'Host-side input' });
    // ...
  }),
);
```

Expose to Flutter via `@VSCodeCommand('commands.executeCommand')`:

```dart
@VSCodeCommand('commands.executeCommand')
Future<dynamic> runCommand(String command, List<dynamic> args);
```

```dart
await api.runCommand('myExtension.doHostWork', []);
```

## Tree Views / Terminals

Not supported via annotations. Implement provider in `extension.ts` per VS
Code docs; optionally notify webview via `postMessage`.

## Checklist

- [ ] Add `context.subscriptions.push(...)` for disposables
- [ ] Match `package.json` command ids
- [ ] `npm run compile` after edits
- [ ] Reload extension host after `package.json` changes

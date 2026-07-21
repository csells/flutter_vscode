# Dart to VS Code Message Contract

> **Legacy v0 contract:** This is the annotation/TypeScript webview bridge used
> by existing v0 projects. Dart-owned extensions use direct generated host
> interop and the versioned Flutter View protocol in `package:flutter_vscode/view.dart`.

This document defines the wire contract between generated Dart controllers
and generated TypeScript command handlers.

## Outbound Message (Dart -> extension host)

Sent by `VSCodeControllerBase.sendCommand(...)` or `VSCode.instance.invoke(...)`
through the bridge.

```json
{
  "command": "window.showInputBox",
  "params": [{"prompt": "Enter your name"}],
  "requestId": "req_1730842969000_1234"
}
```

- `command` (string): dotted VS Code API path or generated `@VSCodeCommand` id.
- `params` (array): positional arguments in declaration order.
- `requestId` (string): correlation id for request/response mapping.

## Dynamic invoke (`VSCode.instance.invoke`)

Call any dotted VS Code API path without `@VSCodeCommand` annotations:

```dart
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

The extension host must route webview messages through `routeWebviewMessage`
from `src/vscode_invoke.ts` (included in the scaffold). Dotted `command` ids
are dispatched by generic `handleInvoke`; undotted ids fall through to
generated `handleCommand`.

## Inbound Message (extension host -> Dart)

Response payload posted by generated TypeScript handlers.

Success:

```json
{
  "requestId": "req_1730842969000_1234",
  "result": "Alice"
}
```

Failure:

```json
{
  "requestId": "req_1730842969000_1234",
  "error": "Error: command failed"
}
```

- `requestId` (string): required to match a pending request.
- `result` (any): returned value for `Future<T>` commands.
- `error` (string): serialized error message from the extension side.

## Behavioral Rules

- If `requestId` is missing or unknown, runtime ignores the message.
- For commands generated from `void`/`Future<void>`, no response is required.
- For commands generated from `Future<T>`, TypeScript posts `result` back.
- On handler exceptions, TypeScript posts `error` (when `requestId` exists).

## Command Id Resolution in TypeScript

Generated handlers resolve command ids as:

1. If id contains `.`, treat it as a path from `vscode`:
   - `window.showInformationMessage` -> `vscode.window.showInformationMessage`
2. Otherwise, fallback to `vscode.window[commandId]` for compatibility.

Use dotted command ids for predictable behavior.

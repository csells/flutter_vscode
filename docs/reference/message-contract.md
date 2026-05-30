# Dart to VS Code Message Contract

This document defines the wire contract between generated Dart controllers
and generated TypeScript command handlers.

## Outbound Message (Dart -> extension host)

Sent by `VSCodeControllerBase.sendCommand(...)` through the bridge.

```json
{
  "command": "window.showInputBox",
  "params": ["Enter your name"],
  "requestId": "req_1730842969000_1234"
}
```

- `command` (string): command id generated from `@VSCodeCommand`.
- `params` (array): positional arguments in declaration order.
- `requestId` (string): correlation id for request/response mapping.

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

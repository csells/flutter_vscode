# VS Code Integration Rules

## Webview Bridge

- Implement the web bridge with `package:web` and `dart:js_interop`.
- Keep a stub implementation for non-web platforms.
- Use conditional exports for platform-specific bridge wiring.

## Message Handling

- Serialize Dart objects with JSON encoding.
- Convert payloads for JavaScript using JS interop APIs.
- Handle missing `acquireVsCodeApi()` gracefully.

## TypeScript Generation

- Generate handlers that match Dart method signatures.
- Keep Dart/TypeScript interfaces aligned for type safety.
- Generate command resolution code for VS Code APIs such as `vscode.window.*`.

## Related

- [Architecture Index](../architecture/index.md)
- [Code Generation Rules](code-generation.md)

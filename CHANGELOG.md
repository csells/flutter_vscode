## Unreleased

- Add the Dart-owned `flutter_vscode create`, `build`, and `package` workflow.
- Generate a reviewed VS Code 1.129.1 host-binding slice from pinned inputs.
- Pin and project transitive contribution validators with exact JavaScript trim
  semantics.
- Add an optional typed Flutter View protocol with strict session cleanup.
- Verify source and installed VSIX extensions in a pinned real Extension Host.

## 0.1.0

- Add annotation-driven Dart and TypeScript generation for `@VSCodeController` and `@VSCodeCommand`.
- Add runtime bridge APIs for request/response communication between Flutter webview and VS Code host.
- Add scaffold CLI (`generate_vscode_extension`) with idempotent create-or-skip behavior for user-owned files.
- Add PRD traceability and message contract reference docs.
- Expand tests for runtime request lifecycle and scaffold idempotence.

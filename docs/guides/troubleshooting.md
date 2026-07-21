# Troubleshooting

## Build rejects `extension.dart`

Keep the descriptor as the restricted constant map emitted by `create`. Use
literal values only, retain `schemaVersion` and `apiTarget`, and remove unknown
fields. The CLI parses this file without executing project code so identical
source cannot produce environment-dependent manifests.

## Requested VS Code API is missing

Inspect `coverage.json` and generated files under `host/lib/generated/`. A
discovered-but-pending entry is not supported. Do not add raw `dynamic`
interop; update the framework's pinned input, IR, Semantic Override, generator,
and Extension Host test.

## Host dependency boundary fails

The diagnostic names the offending import. Move Flutter, `package:web`, DOM,
I/O, isolate, or other unsupported platform code into an optional view. Keep
`shared/` runtime-neutral.

## Package reports stale artifacts

Run:

```sh
flutter_vscode build
flutter_vscode package
```

Do not repair `package.json`, the bootstrap, generated bindings, `out/`, or the
VSIX by hand.

## Flutter view is blank

Confirm `build` produced `out/views/<name>/`, then inspect the Extension Host
and webview developer consoles for CSP or protocol diagnostics. The view must
use private `acquireVsCodeApi` access, webview-safe asset URLs, and the v1
session/nonce handshake.

## Legacy v0 projects

For annotation/TypeScript projects, rerun `build_runner` and the project’s
legacy npm compile command. Those steps do not apply to the Dart-host workflow.

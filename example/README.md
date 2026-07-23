# flutter_vscode examples

## Current path: a Dart-owned extension (v1)

New extensions are authored entirely in Dart against generated VS Code
host bindings — no author-side TypeScript, Node, or npm. The known-good
workflow from a clean machine:

```sh
dart pub global activate flutter_vscode
flutter_vscode create my_extension
cd my_extension
flutter_vscode build
flutter_vscode package
```

`create` scaffolds an explicit `host/`, `views/`, and `shared/` layout
(a host-only extension simply has no `views/`); `build` compiles Host
Dart and generates every framework-managed artifact including
`package.json`, the bootstrap, and a launch configuration; `package`
produces an installable VSIX. Host behavior — activation, commands,
providers, events — is written in `host/lib/extension.dart` using the
generated API described in
[docs/reference/generated-host-api.md](../docs/reference/generated-host-api.md).
Start with [docs/guides/quickstart.md](../docs/guides/quickstart.md).

## This directory: the legacy v0 webview demo

The Flutter app in `lib/` (with its generated TypeScript under `src/`)
demonstrates the original v0 webview bridge. It still builds and its
tests run in the repository gate, but it is a legacy surface kept for
existing users: new host callbacks or provider logic should not be built
this way. Every v0 entry point in these files is labeled accordingly.

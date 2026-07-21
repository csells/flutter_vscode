# flutter_vscode

Build VS Code extensions with Dart-owned activation, commands, and providers,
plus optional Flutter webviews. Host Dart compiles to JavaScript that runs
inside VS Code's Extension Host; generated bindings preserve native VS Code
objects and callbacks.

This repository currently proves one pinned slice against VS Code 1.129.1. It
is an implementation milestone, not a claim of full API parity.

## Dart-only author workflow

Install the CLI and create a dedicated Extension Project:

```sh
dart pub global activate flutter_vscode
flutter_vscode create my_extension
cd my_extension
flutter_vscode build
flutter_vscode package
```

From a repository checkout, replace the first command with:

```sh
dart pub global activate --source path .
```

`build` generates the VS Code manifest, native interop bindings, CommonJS
bootstrap, host bundle, source map, and launch configuration. `package` writes
`build/my-extension-0.0.1.vsix` and validates its installable layout. Neither
command asks an extension author to install Node, run npm, write TypeScript, or
copy JavaScript files.

The scaffold makes runtime boundaries visible:

```text
extension.dart       Dart-owned metadata and contributions
host/                pure Dart Extension Host behavior
shared/              pure Dart package shared across runtimes
views/               optional Flutter webviews
```

Edit `extension.dart` and `host/lib/extension.dart`, then rerun `build`.
Treat `package.json`, `coverage.json`, `.vscode/launch.json`, generated host
bindings, `out/`, and VSIX files as framework-managed artifacts.

See the [Quickstart](docs/guides/quickstart.md) and
[Generated File Ownership](docs/guides/generated-file-ownership.md).

## Legacy v0 webview workflow

The original `generate_vscode_extension` command, annotation generator, and
TypeScript request/response bridge remain available while the Dart-host path is
built out. That compatibility workflow requires Node/npm and should not be used
as the architecture for new host callbacks or provider logic.

## Repository validation

Contributors need Flutter, Docker, and a running Docker daemon:

```sh
flutter analyze
./scripts/test_all.sh
```

The full gate regenerates bindings, tests both generators, launches the pinned
Extension Host fixture, then creates and installs a clean Dart-owned VSIX in an
isolated VS Code profile.

## Documentation

- [Documentation Index](docs/index.md)
- [Architecture](docs/architecture/index.md)
- [VS Code API Mapping](docs/reference/vscode-api-mapping.md)
- [Agent-Assisted Development](docs/guides/agent-assisted-development.md)
- [Roadmap](docs/reference/roadmap.md)
- [PRD](PRD.md)

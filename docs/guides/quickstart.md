# Quickstart

## 1. Install the CLI

The Dart-host workflow is currently unreleased. Activate the CLI from its
repository checkout:

```sh
dart pub global activate --source path /path/to/flutter_vscode
```

Once this release is available on pub.dev, use
`dart pub global activate flutter_vscode` instead.

## 2. Create an Extension Project

```sh
flutter_vscode create my_extension
cd my_extension
```

The project separates pure host Dart, optional Flutter views, and a pure shared
Dart package. It contains no author-maintained JavaScript, TypeScript, or
`package.json`.

`extension.dart` is the source of truth for metadata and contributions. Its
`apiTarget` selects the exact pinned VS Code API and controls the generated
`engines.vscode` value. Change that target only as an explicit compatibility
decision.

## 3. Implement host behavior

Edit `host/lib/extension.dart`. Host code runs when the extension activates,
even if no Flutter view exists. Keep Flutter, browser-only libraries, `dart:io`,
and other unsupported platform APIs out of `host/` and `shared/`; `build` checks
these boundaries. The generated facade is present immediately after `create`,
so `dart pub get && dart analyze` succeeds in `host/` before the first build.
Use the [Generated Host API](../reference/generated-host-api.md) for supported
Dart patterns and consult `coverage.json` after building for exact coverage.

## 4. Build and debug

```sh
flutter_vscode build
```

This deterministically regenerates the manifest, bindings, bootstrap, host
JavaScript, source map, and `.vscode/launch.json`. Open the project in VS Code
and press F5 to launch the generated debug configuration.

## 5. Package

```sh
flutter_vscode package
```

The command validates framework-managed artifacts and writes the VSIX beneath
`build/`. Install that file with VS Code's **Extensions: Install from VSIX…**
command.

The current proof targets VS Code 1.129.1 and a reviewed command/hover slice.
Do not infer or handwrite bindings for APIs absent from the generated facade.

## Legacy webview scaffold

`dart run flutter_vscode:generate_vscode_extension` remains for existing v0
projects. It uses the older Node/TypeScript bridge and is not the canonical
Dart-host workflow above.

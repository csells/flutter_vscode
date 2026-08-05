# flutter_vscode

Build VS Code extensions in Dart and Flutter. This repository is a pub
workspace: one `dart pub get` at the root resolves every package, and
`flutter analyze` covers the whole tree.

## Layout

| path | what it is |
|---|---|
| [`packages/dart_vscode`](packages/dart_vscode) | published, pure Dart: the generated VS Code API, the view protocol, and the Host Dart runtime |
| [`packages/flutter_vscode`](packages/flutter_vscode) | published: the CLI and the Flutter View runtime, built on `dart_vscode` |
| [`extensions/`](extensions/README.md) | shipped example extensions, built only through the public CLI |
| [`docs/`](docs/index.md) | guides, reference, architecture, and ADRs |
| [`specs/`](specs/vision/vision.md) | vision, architecture notes, and plan history |
| `scripts/` | per-gate real-host scripts the CI workflow runs as steps, plus `ci_gates.sh` to run the whole workflow locally |

Start with the [package README](packages/flutter_vscode/README.md) to build
an extension, or the [quickstart](docs/guides/quickstart.md).

## Relationship to the original pipeline

This tree replaces the v0 annotation/TypeScript pipeline wholesale -- a
full cutover, with no compatibility layer and no migration path from the
v0 surface. The v0 scaffolder, builder surface, and webview bridge are
deleted, and `packages/flutter_vscode/test/v0_removal_test.dart` keeps
them deleted.

## Working in this repository

```sh
dart pub get                                    # resolves every workspace package
flutter analyze                                 # covers the whole tree
cd packages/flutter_vscode && flutter test      # the framework suite
./scripts/ci_gates.sh          # the whole CI workflow, locally, in Docker
```

Each example package owns its own tests; run them in their directory.

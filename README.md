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
| `scripts/` | maintainer gates, including the pinned real-host Extension Host runs |

Start with the [package README](packages/flutter_vscode/README.md) to build
an extension, or the [quickstart](docs/guides/quickstart.md).

## Working in this repository

```sh
dart pub get                                    # resolves every workspace package
flutter analyze                                 # covers the whole tree
cd packages/flutter_vscode && flutter test      # the framework suite
./scripts/test_all.sh                           # every suite plus the real-host gates
```

Each example package owns its own tests; run them in their directory.

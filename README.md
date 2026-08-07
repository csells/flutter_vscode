# flutter_vscode

Build VS Code extensions in Dart and Flutter. This repository is a pub
workspace: one `dart pub get` at the root resolves every package, and
`flutter analyze` covers the whole tree.

## Layout

| path | what it is |
|---|---|
| [`packages/dart_vscode`](packages/dart_vscode) | published, pure Dart: the generated VS Code API, the view protocol, and the Host Dart runtime |
| [`packages/flutter_vscode`](packages/flutter_vscode) | published: the CLI and the Flutter View runtime, built on `dart_vscode` |
| [`extensions/`](extensions/README.md) | the shipped example extensions — Coverage Treemap (Flutter View) and Pubspec Lens (Host-Only, native VS Code UI) — built only through the public CLI |
| [`docs/`](docs/index.md) | guides, reference, architecture, and ADRs |
| [`specs/`](specs/vision/vision.md) | vision, architecture notes, and plan history |
| [`skills/`](skills/README.md) | agent skills for extension authors — copied into an extension project as `agent-skills/` |
| `scripts/` | per-gate real-host scripts the CI workflow runs as steps — each accepts `FLUTTER_VSCODE_GATE_NATIVE=1` on macOS — plus `ci_gates.sh` to run the whole workflow locally |

Start with the [package README](packages/flutter_vscode/README.md) to build
an extension, or the [quickstart](docs/guides/quickstart.md).

## Relationship to the original pipeline

This tree replaces the v0 annotation/TypeScript pipeline wholesale -- a
full cutover, with no compatibility layer and no migration path from the
v0 surface. The v0 scaffolder, builder surface, and webview bridge are
deleted, and `packages/flutter_vscode/test/v0_removal_test.dart` keeps
them deleted.

## Working in this repository

You need a Flutter SDK carrying Dart `^3.12.0` (the floor every workspace
package pins).

```sh
dart pub get                # resolves every workspace package
flutter analyze             # covers the whole tree
cd packages/dart_vscode && dart test              # the API package suite
cd packages/flutter_vscode && flutter test --exclude-tags gate  # fast suite
./scripts/ci_gates.sh       # the whole CI workflow locally: containers
                            # plus, on macOS, the five native desktop gates
```

CI ([`.github/workflows/test.yml`](.github/workflows/test.yml)) runs four
jobs: analyze/format/publishability checks, every package's suite, the
real-host gates against a pinned VS Code, and the same gates natively on
macOS. `ci_gates.sh` runs exactly those jobs locally — the ubuntu jobs in
runner-like Docker containers (so it needs Docker), the macOS job natively
when the host is a Mac.

(Plain `flutter test` in `packages/flutter_vscode` also runs the
gate-tagged workflow test — the full Docker CI run — which is rarely what
you want mid-loop.)

Each example package owns its own tests; run them in their directory.

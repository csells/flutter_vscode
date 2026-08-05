# Project Structure and Dependencies

This page maps the `flutter_vscode` repository for contributors and agents
working on the framework itself: what kind of package this is, where each
area of the tree lives, and how to add dependencies. Extension authors
consuming the framework want the
[consumer template](../templates/consumer-agents.md) instead — the layout
of a generated Extension Project is its concern, not this page's.

## Project Type

This repository is a pub workspace whose root is never published. One
`dart pub get` at the root resolves every member. Two packages publish:
`packages/dart_vscode` (pure Dart: the generated VS Code API, the view
protocol, and the Host Dart runtime) and `packages/flutter_vscode` (the
Extension Project CLI, deterministic binding generation, and the Flutter
View runtime).

## Expected Layout

- `packages/dart_vscode/lib/` the pure-Dart runtime authors' host code
  imports: the generated API layer, `view_protocol`, `host_commands`,
  `host_runtime`, and `flutter_view_host`.
- `packages/flutter_vscode/lib/` the manifest types, the Flutter View
  runtime, and `lib/src/cli/` command modules (create, build, watch,
  package, doctor, test).
- `packages/flutter_vscode/bin/flutter_vscode.dart` the canonical CLI.
- `packages/flutter_vscode/tool/binding_importer/` pinned
  TypeScript-to-IR maintainer tooling.
- `packages/flutter_vscode/tool/binding_generator/` IR/override-to-Dart
  and manifest generation.
- `packages/flutter_vscode/tool/bindings/` pinned inputs, canonical IR,
  and Semantic Overrides.
- `packages/flutter_vscode/test/fixtures/host_extension/` real Extension
  Host and Flutter View fixture.
- `extensions/` shipped example extensions that consume the framework the
  way an Extension Author would ([guardrails](../../extensions/README.md)).
- `scripts/` maintainer gates, including the real-host Extension Host
  runs and the native macOS gate.
- `skills/` consumer agent skills, copied into Extension Projects as
  `agent-skills/` ([index](../../skills/README.md)).

## Dependency Guidance

When adding dependencies, choose stable, actively maintained packages from pub.dev.

Preferred packages for generation and analysis work:

- `analyzer` for static analysis and introspection
- `package:web` for JS interop (avoid `dart:js_util`)

Use:

- `flutter pub add <package_name>` for runtime dependencies
- `flutter pub add dev:<package_name>` for dev dependencies

## Related

- [Code Quality and Dart Practices](code-quality.md)
- [Documentation Index](../index.md)

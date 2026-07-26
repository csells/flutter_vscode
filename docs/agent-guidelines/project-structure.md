# Project Structure and Dependencies

This page maps the `flutter_vscode` repository for contributors and agents
working on the framework itself: what kind of package this is, where each
area of the tree lives, and how to add dependencies. Extension authors
consuming the framework want the
[consumer template](../templates/consumer-agents.md) instead — the layout
of a generated Extension Project is its concern, not this page's.

## Project Type

This repository is a Flutter package, not a standalone app. It provides the
Extension Project CLI, deterministic VS Code binding generation, pure-Dart
host utilities, an optional Flutter View protocol, and legacy v0 generators.

## Expected Layout

- `lib/` public APIs and runtime/protocol implementation.
- `lib/src/cli/` the CLI's in-process command modules (create, build,
  watch, package, doctor, test) wired together by the thin process adapter.
- `bin/flutter_vscode.dart` canonical `create`, `build [--watch]`,
  `package`, `doctor`, and `test` CLI.
- `tool/binding_importer/` pinned TypeScript-to-IR maintainer tooling.
- `tool/binding_generator/` IR/override-to-Dart and manifest generation.
- `tool/bindings/` pinned inputs, canonical IR, and Semantic Overrides.
- `test/fixtures/host_extension/` real Extension Host and Flutter View fixture.
- `extensions/` shipped example extensions that consume the framework the
  way an Extension Author would ([guardrails](../../extensions/README.md)).
- `skills/` consumer agent skills, copied into Extension Projects as
  `agent-skills/` ([index](../../skills/README.md)).
- `example/` legacy v0 integration fixture.
- `bin/generate_vscode_extension.dart` and TypeScript templates: legacy v0.

## Dependency Guidance

When adding dependencies, choose stable, actively maintained packages from pub.dev.

Preferred packages for generation and analysis work:

- `source_gen` and `build_runner` for code generation
- `analyzer` for static analysis and introspection
- `package:web` for JS interop (avoid `dart:js_util`)

Use:

- `flutter pub add <package_name>` for runtime dependencies
- `flutter pub add dev:<package_name>` for dev dependencies

## Related

- [Code Quality and Dart Practices](code-quality.md)
- [Documentation Index](../index.md)

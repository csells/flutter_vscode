# Project Structure and Dependencies

## Project Type

This repository is a Flutter package (library), not a standalone app. It provides code generation and runtime utilities for VS Code extension development.

## Expected Layout

- `lib/` package code (generators, annotations, runtime utilities)
- `example/` example usage
- `bin/` CLI tools, including `generate_vscode_extension`
- `tool/` code generation templates

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

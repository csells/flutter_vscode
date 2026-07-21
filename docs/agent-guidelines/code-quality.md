# Code Quality and Dart Practices

## Analysis and Linting

- Use `very_good_analysis` and follow its rules.
- Follow Effective Dart guidance.

## Design Principles

- Keep the importer, binding generator, CLI orchestration, host interop, and
  cross-runtime protocol in separate modules.
- Keep Flutter View/browser adapters platform-specific and the protocol core
  transport-independent.
- Prefer deep typed interfaces over string-keyed maps and generic dispatchers.

## Naming

- Use `VSCode*` for VS Code-specific bindings and `View*` for cross-runtime
  protocol types.
- Use `*Generator` for generator classes.
- Use `*Element` naming for analyzer element types where applicable.

## Modern Dart

Prefer modern Dart patterns where they improve clarity:

- collection `if` and `for`
- cascade operator (`..`)
- records and pattern matching when appropriate
- `final` by default
- proper `async`/`await` usage with clear error handling

## JS Interop

Use `package:web` and `dart:js_interop`. Do not introduce `dart:js_util`.

## Related

- [Project Structure and Dependencies](project-structure.md)
- [Package Conventions and Documentation](package-conventions.md)

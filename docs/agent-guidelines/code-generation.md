# Code Generation Rules

## Generator Architecture

- Use `GeneratorForAnnotation<T>` for annotation-driven generators.
- Use `Builder` for file-based generators such as TypeScript output.
- Throw `InvalidGenerationSourceError` for user-facing generation errors with actionable messages.

## Analyzer API Usage

- Access parameters through `FunctionTypedElement.formalParameters`.
- Cast `MethodElement` to `FunctionTypedElement` where needed.
- Use `TypeChecker.fromUrl()` for annotation checks.
- Use URL form: `package:package_name/file.dart#ClassName`.

## Output Conventions

- Keep generated output formatted and readable.
- Use `part of` for generated Dart part files that extend user code.
- Keep generated names predictable, such as `_$ClassName`.

## Related

- [Reference Index](../reference/index.md)
- [VS Code Integration Rules](vscode-integration.md)

# Code Generation Rules

## Generator Architecture

- Parse pinned official VS Code inputs into canonical IR before generating host
  bindings or contribution models.
- Pin transitive validation helpers as inputs too. The commands projection
  recognizes the exact upstream `isFalsyOrWhitespace` implementation and
  lowers JavaScript trim behavior as `ecmascript-trim-empty`; do not substitute
  Dart `String.trim()` or infer semantics from the helper name.
- Combine IR only with reviewed, fingerprinted Semantic Overrides. Unknown or
  changed declarations fail closed with the exact path and remediation.
- Generate identical bytes for identical inputs and tool versions; never use
  locale-dependent ordering, clocks, environment values, or inferred types.
- Keep legacy annotation generators on `GeneratorForAnnotation<T>` and legacy
  file generators on `Builder` while v0 remains supported.
- Use actionable, stable error codes at every generator boundary.

## Analyzer API Usage

- Access parameters through `FunctionTypedElement.formalParameters`.
- Cast `MethodElement` to `FunctionTypedElement` where needed.
- Use `TypeChecker.fromUrl()` for annotation checks.
- Use URL form: `package:package_name/file.dart#ClassName`.

## Output Conventions

- Keep generated output formatted and readable.
- Mark framework-managed output as generated and never mix author edits into it.
- Emit a coverage ledger that distinguishes discovery, semantic review, binding
  emission, exclusions, and real-host verification.
- Regenerate twice in CI and compare bytes.

## Related

- [Reference Index](../reference/index.md)
- [VS Code Integration Rules](vscode-integration.md)

# Testing and Error Handling

## Error Handling

- Use `InvalidGenerationSourceError` for user-facing generator failures.
- Return clear runtime error messages where generated/runtime APIs fail.
- Degrade gracefully when optional host APIs are unavailable.

## Testing

- Use `package:test` for Dart unit tests.
- Add generator tests that compare expected output.
- Add integration tests for build_runner and end-to-end generation flow.

## Related

- [Contributing Index](../contributing/index.md)
- [Code Generation Rules](code-generation.md)

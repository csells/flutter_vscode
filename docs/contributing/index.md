# Contributing

This section covers contributor expectations and documentation navigation.

## Contents

- [Agent Guidelines](../agent-guidelines/index.md)
- [Code Quality and Dart Practices](../agent-guidelines/code-quality.md)
- [Testing and Error Handling](../agent-guidelines/testing-and-errors.md)

## Contribution Checklist

- Run analysis with project lint rules.
- Add or update tests when behavior changes.
- Keep generated and runtime contracts aligned.
- Update documentation links when structure changes.

## Local Validation

Install Flutter and Docker, and ensure the Docker daemon is running. Before
submitting changes, run:

```sh
flutter analyze
./scripts/test_all.sh
```

The full gate includes the pinned Node-based binding importer inside Docker,
the source Extension Host fixture, and a clean CLI-created VSIX that is
installed and exercised in an isolated pinned VS Code profile.

## Related

- [Project README](../../README.md)
- [Documentation Index](../index.md)

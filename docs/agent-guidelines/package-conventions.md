# Package Conventions and Documentation

## Build Configuration

- Keep the canonical CLI exposed as `flutter_vscode` in `pubspec.yaml`.
- Treat `package.json`, host bindings/bootstrap, bundles, source maps, launch
  configuration, view build output, coverage, and VSIX files as managed.

## API Design

- Keep Project API Target explicit in Dart-owned configuration.
- Expose native host behavior through generated parity and idiomatic layers.
- Expose a small typed view protocol rather than raw envelopes or arbitrary
  host API dispatch.

## Documentation Standards

- Document public APIs with `///`.
- Keep `README.md` usage examples current.
- Maintain working examples under `example/`.

## Related

- [Guides Index](../guides/index.md)
- [Contributing Index](../contributing/index.md)

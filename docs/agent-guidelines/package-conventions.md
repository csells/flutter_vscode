# Package Conventions and Documentation

## Build Configuration

- Configure build extensions in `build.yaml`.
- Use `.g.part` for generated Dart part files.
- Use `.handlers.ts` for generated TypeScript handlers.

## API Design

- Keep annotation APIs focused:
  - `@VSCodeController` marks controller classes.
  - `@VSCodeCommand` marks command methods.
- Prefer abstract base classes for generated implementations.
- Provide factory helpers for generated instances where needed.

## Documentation Standards

- Document public APIs with `///`.
- Keep `README.md` usage examples current.
- Maintain working examples under `example/`.

## Related

- [Guides Index](../guides/index.md)
- [Contributing Index](../contributing/index.md)

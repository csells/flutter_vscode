---
status: accepted
---

# Provide Parity and Idiomatic API Layers

Extension Authors will normally use an Idiomatic Facade with Dart futures,
streams, nullability, collections, cancellation, named parameters, and typed
resource lifetimes. A complete Parity Layer beneath it will map every stable
symbol in the API Parity Baseline and remain available when a curated Dart shape
does not yet exist.

The Parity Layer prevents ergonomics work from delaying VS Code coverage; the
Idiomatic Facade prevents full coverage from feeling like TypeScript syntax
transliterated into Dart. Both are generated and share the same host interop.

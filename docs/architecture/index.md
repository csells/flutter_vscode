# Architecture

`flutter_vscode` has two Dart runtimes with an explicit boundary between them.

## Extension Host

Pure Dart in `host/` compiles to JavaScript and runs in VS Code's Node
Extension Host. A framework-managed CommonJS bootstrap injects the native
`vscode` module and forwards activation and deactivation. Mechanically generated
`dart:js_interop` bindings preserve native object identity, prototypes,
callbacks, promises, events, and disposables.

Provider and command behavior belongs here. It must continue working when no
Flutter view has opened.

## Flutter Views

Each optional project beneath `views/` is a separate Flutter web runtime. A
view cannot receive live Extension Host objects. It exchanges validated value
snapshots with Host Dart through the versioned view protocol, including a
session/nonce handshake, allowlisted calls, structured errors, and explicit
close/reload cleanup.

## Binding Pipeline

Maintainer tooling parses pinned official VS Code TypeScript and contribution
schema inputs, including transitive validator helpers, into a canonical IR.
The importer projects exact predicates such as ECMAScript string trimming
instead of inferring behavior from function names. The Dart generator combines
that IR with reviewed Semantic Overrides to produce parity bindings, an
idiomatic facade, manifest contributions, and a coverage ledger. Unknown or
changed semantics fail closed; generation does not use inference.

```text
pinned VS Code inputs -> canonical IR + Semantic Overrides -> generated host API
extension.dart        -> validated contributions             -> package.json
host Dart             -> dart compile js                     -> host bundle
Flutter view          -> flutter build web                   -> view assets
```

See the accepted [architecture decisions](../adr/) and the
[first working extension plan](../../specs/plans/first-working-extension.md).

# Author Workflow

A Flutter/Dart developer ships an extension without npm, TypeScript, or
manual file copying:

```sh
dart pub global activate flutter_vscode   # path activation during development
flutter_vscode create my_extension        # host/, views/, shared/ layout
flutter_vscode build
flutter_vscode package                    # installable VSIX
```

- `create` writes an analyzable project immediately (the generated facade
  exists before the first build); a host-only extension simply has no
  `views/`. Extension metadata and contributions are Dart-owned in
  `extension.json`.
- `build` generates every Framework-Managed Artifact — `package.json`,
  bootstrap, launch configuration, host bundle, source maps, and the
  complete typed Parity Layer (`vscode_parity_layer.g.dart`) — enforces
  the host import boundary, and reports malformed Dart with
  filename/line/column and remediation (no internal stacks, no exit
  255). Generated activation registers providers synchronously so lazy
  activation cannot race a first query.
- `package` validates `extension.vsixmanifest` and
  `[Content_Types].xml` as real XML (declarations required, XML
  1.0-forbidden characters rejected) before emitting a VSIX, and
  refuses stale artifacts via build receipts that fingerprint the
  framework, generator, and pinned API inputs.

Proven end to end by `test/cli_*` suites and
`./scripts/test_packaged_extension.sh`, which stages the framework from
`dart pub publish`'s own archive listing, installs both fixture VSIXes
in a pinned VS Code, and asserts the inactive-start → `onLanguage`
activation → single-hover-first flow before any extension command.
Publication readiness is `dart pub publish --dry-run --ignore-warnings`;
publishing itself remains out of scope.

Consumer-facing surfaces must present this v1 path; retained v0
(webview/TypeScript) material must carry legacy labels — enforced by the
legacy-surface gate in `test/repository_gate_test.dart`.

# VS Code API Parity

<!-- GENERATED FILE - DO NOT EDIT. -->
<!-- Regenerate: dart tool/binding_generator/generate.dart
     --parity . -->

Per the project vision, a missing Dart path for a public
VS Code capability is a defect, not an accepted state: every
`pending` row below is unimplemented public surface that the
framework still owes an executable, host-verified binding.
This report is generated from the coverage ledger, which is
itself regenerated and byte-compared by the repository gates,
so these numbers cannot drift from machine state.

Pinned inventory: 2982 declarations discovered; 53 emitted and host-verified; 17 excluded (reviewed or non-public); 2912 pending.

| Container | Emitted | Reviewed excluded | Non-public | Pending |
| --- | ---: | ---: | ---: | ---: |
| `global` | 1 | 0 | 0 | 0 |
| `vscode (root)` | 43 | 6 | 10 | 2603 |
| `vscode.authentication` | 0 | 0 | 0 | 11 |
| `vscode.chat` | 0 | 0 | 0 | 2 |
| `vscode.commands` | 3 | 0 | 0 | 2 |
| `vscode.comments` | 0 | 0 | 0 | 2 |
| `vscode.debug` | 0 | 0 | 0 | 19 |
| `vscode.env` | 0 | 0 | 0 | 22 |
| `vscode.extensions` | 0 | 0 | 0 | 4 |
| `vscode.l10n` | 0 | 0 | 0 | 12 |
| `vscode.languages` | 2 | 0 | 0 | 41 |
| `vscode.lm` | 0 | 0 | 0 | 8 |
| `vscode.notebooks` | 0 | 0 | 0 | 4 |
| `vscode.scm` | 0 | 0 | 0 | 3 |
| `vscode.tasks` | 0 | 0 | 0 | 9 |
| `vscode.tests` | 0 | 0 | 0 | 2 |
| `vscode.version` | 0 | 0 | 0 | 1 |
| `vscode.window` | 2 | 1 | 0 | 94 |
| `vscode.workspace` | 2 | 0 | 0 | 73 |

New bindings enter through reviewed Semantic Overrides and
must carry executable real-host evidence before an entry
may leave `pending`; unclassified public symbols block
releases (ADR 0008).

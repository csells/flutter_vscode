# Shipped Example Extensions

Real, installable VS Code extensions built with `flutter_vscode`. They
are product surfaces: each one is expected to work, ship, and stay
honest about what the framework can do today.

## Guardrails

Every extension here consumes the framework the way an Extension
Author would:

- scaffolded and built only with the `flutter_vscode` CLI
  (`create`/`build`/`package`);
- no imports from the repository's `lib/`, `tool/`, or test fixtures —
  only CLI-generated files and the published package surface
  (`package:flutter_vscode/view.dart` in views);
- when an extension needs something the framework lacks, the gap is
  recorded (futures or a plan) and the framework change lands with its
  own tests first; the extension then consumes it like any author.

These directories are excluded from the pub package archive.

## coverage_treemap

Line coverage from `coverage/lcov.info` painted into the editor, a
status-bar coverage percentage, and an interactive squarified coverage
treemap rendered by a Flutter View.

Build and run it:

```sh
cd extensions/coverage_treemap
flutter_vscode build
```

Open `extensions/coverage_treemap` in VS Code and press F5. In the
Extension Development Host, open a workspace containing
`coverage/lcov.info` (run `flutter test --coverage` in any Flutter
project first), then:

- covered and uncovered lines are highlighted in the active editor;
- the status bar shows the overall percentage;
- **Coverage: Show Treemap** opens the Flutter treemap panel;
- **Coverage: Refresh** and **Coverage: Toggle Line Highlights** do
  what they say;
- editing or regenerating `lcov.info` refreshes automatically.

`flutter_vscode package` writes the installable VSIX under `build/`.

Plan and status: [`specs/plans/coverage-treemap.md`](../specs/plans/coverage-treemap.md).

A Dart-only (host-only) example extension is planned to follow once
this one ships.

# Coverage Treemap Extension Plan

Status: In progress
Date: 2026-07-23

The first shipped example extension, per the owner's direction: a test
coverage dashboard that parses `lcov.info`, paints per-line coverage
into the editor, and renders an interactive coverage treemap in a
Flutter View. It lives in `extensions/` as a product surface (the
vision: examples are shipped product surfaces) and is deliberately a
consumer of the framework, not a fixture of it. A Dart-only example
extension follows once this one works and ships.

Rules (inherited): the exit bar is frozen; reds are commits;
discoveries go to [`futures.md`](futures.md). Marketplace publication
needs a publisher account and is the owner's call; it is recorded here
as the goal but is not an exit-bar item.

## Guardrails

An extension under `extensions/` must consume the framework the way an
Extension Author would:

- scaffolded and built only with the `flutter_vscode` CLI;
- no imports from the repository's `lib/`, `tool/`, or test fixtures —
  only CLI-generated files and the published package surface
  (`package:flutter_vscode/view.dart` in views);
- when the extension needs something the framework lacks, the gap is
  recorded (futures or a plan) and the framework change lands with its
  own tests first — the extension then consumes it like any author.

## Exit bar

- [ ] T-1 The `extensions/` area exists with the guardrails recorded in
  `extensions/README.md`, and the pub archive excludes `extensions/`.
  Check: repository gate suite.
- [ ] T-2 A pure-Dart lcov parser in the extension's shared package,
  red-green: `SF`/`DA`/`LF`/`LH` records, per-file line hit maps,
  per-file and per-directory aggregation, and actionable
  `FormatException`s on malformed input. Check: `dart test` in
  `extensions/coverage_treemap/shared`.
- [ ] T-3 Host behavior compiled by `flutter_vscode build`: reads
  `coverage/lcov.info` from the first workspace folder via
  `workspace.fs`, decorates covered and uncovered lines in the active
  editor, shows a status-bar coverage percentage, refreshes from a
  `FileSystemWatcher` on the coverage file, and contributes commands
  (show treemap, refresh, toggle line highlights). Check: build green.
- [ ] T-4 The treemap Flutter View: a squarified treemap of
  per-directory and per-file coverage, connected over the versioned
  view protocol with a typed coverage-snapshot operation and a refresh
  action (protocol v1 has no host-to-view push; that gap is already
  recorded in futures). Check: build green including the view;
  the shared codec has round-trip tests.
- [ ] T-5 `flutter_vscode package` writes an installable
  `coverage-treemap-<version>.vsix`. Check: package green.
- [ ] T-6 Real-host proof: a scripted gate installs the packaged VSIX
  into the pinned Extension Host against a workspace with a real
  `lcov.info` and executes a smoke command returning parsed-coverage
  evidence. Check: the script exits 0 with assertions on the returned
  snapshot.
- [ ] T-7 Docs: `extensions/README.md` describes the area and each
  extension's build/run/debug story; the root README points at the
  shipped examples. Check: repository gate suite.

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

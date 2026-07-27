# Pubspec Lens Plan

Status: In progress
Date: 2026-07-26

The second shipped example extension and the first Host-Only
Extension: dependency intelligence for `pubspec.yaml`, built without a
Flutter View to demonstrate that VS Code's native UI surface — hovers,
diagnostics, CodeLens, QuickPick, tree views, the status bar — is
fully drivable from plain Dart (ADR 0003 made tangible). The host-side
reuse story mirrors the treemap's fl_chart: `pub_semver` and `yaml`,
both Dart-team packages, do the real semantics.

First-cut scope by owner direction: hover, outdated-pin diagnostics,
a CodeLens update via WorkspaceEdit, and a dependencies tree view.
Completion and add-dependency wait until the first cut earns them.

Rules (inherited): exit bar frozen; reds are commits; the extension
consumes the framework only through the CLI and generated files (the
extensions/ guardrails); discoveries to [`futures.md`](futures.md).

## Exit bar

- [x] PL-1 Pure-Dart analysis in the shared package: parse
  `pubspec.yaml` (via `yaml`) into dependency models with source
  spans; compare pinned constraints against registry versions (via
  `pub_semver`) into per-dependency verdicts (current, outdated with
  the suggested `^latest`, unknown); actionable `FormatException`s on
  malformed input. Check: a red unit suite in the extension's shared
  package covering constraints, spans, verdicts, and malformed input.
  Closed: `parsePubspec` models hosted/sdk/path/git entries with
  zero-based name and constraint spans, `verdictFor` yields
  current/outdated/unknown/skipped (non-hosted dependencies are
  skipped by design), and `parsePackageInfo` reads the pub API's
  `{"latest": {"version": ..., "pubspec": ...}}` shape — 24/24 in the
  shared suite.
- [ ] PL-2 Registry client over `hostFetch`: fetch package metadata
  from the pub.dev API with the base URL read from workspace
  configuration (so gates point it at a local fake registry), an
  in-memory cache, and graceful offline degradation (no diagnostics
  churn on network failure). Check: pure parts unit-tested; the live
  path proven in the PL-4 gate.
- [ ] PL-3 Host features on the native UI surface, via the generated
  layer and `ExtensionCommands`: hover on a dependency shows the
  latest version and description; outdated pins get diagnostics; a
  CodeLens per outdated dependency applies the `^latest` constraint
  through a `WorkspaceEdit`; a dependencies tree view lists direct
  dependencies with their verdicts; a refresh command re-queries.
  Check: the extension builds and packages through the CLI alone.
- [ ] PL-4 Real-host gate: `scripts/test_pubspec_lens.sh` (mirroring
  the coverage-extension gate) installs the packaged VSIX into the
  pinned Extension Host against a workspace whose `pubspec.yaml` has
  known-current and known-outdated pins, serves a fake pub.dev from
  the driver, and asserts the hover content, the diagnostics, the
  CodeLens edit actually rewriting the document, and the tree
  children. Wired into `test_all.sh` with the repository-gate
  assertion updated. Check: the gate exits 0.
- [ ] PL-5 Docs and closure: `extensions/README.md` gains the
  Pubspec Lens section (with the native-UI-vs-Flutter-View dividing
  line stated); the root README's examples section mentions both
  examples; futures' "Dart-only sibling" clause retires (the
  framework-external extension remains). Final bar: fast suites +
  analyze green; the pubspec-lens gate plus the existing three
  real-host gates green at HEAD.

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

1. **Red PL-1** (commit 7c52b3d): `extensions/pubspec_lens` scaffolded
   through the CLI and shaped as the first Host-Only Extension —
   typed descriptor targeting 1.129.1, empty `views/` root, shared
   package depending on `yaml` and `pub_semver`. The shared suite
   landed failing: `parsePubspec`, `verdictFor`, and
   `parsePackageInfo` did not exist.
2. **Green PL-1**: 24/24 in the shared package (`dart test`): hosted
   constraints (caret, exact, bare-any, unparsable-stays-unknown),
   sdk/path/git classification, hosted-map `version:` support,
   zero-based name/constraint spans sized for text edits, actionable
   `FormatException`s (invalid YAML with position, non-map root,
   non-map section), verdict semantics (a pin admitting latest is
   current; outside the pin is outdated with `^latest`), and the pub
   API response model with tolerated missing descriptions. `dart
   analyze` clean.

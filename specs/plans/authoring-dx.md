# Authoring DX Plan

Status: In progress
Date: 2026-07-26

Closes the three authored-surface gaps the coverage-treemap file
review identified: the untyped descriptor map, the host-side
command-registration ceremony, and the twice-written view-contract
codecs (plus the host/view duplication of assembled operations).
Everything an Extension Author owns should read like ordinary Dart.

Rules (inherited): exit bar frozen; reds are commits; no legacy or
compatibility surface — the branch is the product; discoveries to
[`futures.md`](futures.md).

## Exit bar

- [x] AD-1 Typed descriptor: `package:flutter_vscode/manifest.dart`
  ships const-constructible `ExtensionManifest`/`ExtensionCommand`
  types; `extension.dart` declares `const extension =
  ExtensionManifest(...)` with full analyzer completion and
  type-checking; the CLI parser consumes the typed form as data (AST
  over const constructor invocations — project code is still never
  executed) and the map form dies with the branch's no-compat rule
  (`extension.json` stays, it is already data). The scaffold emits
  the typed form; the coverage extension migrates. Check: a red
  parser suite over the typed form; cli_create/build/multi-baseline
  suites green; descriptor type errors surface in `dart analyze` of
  the project, proven by a test.
  Closed: `test/project_descriptor_test.dart` covers the happy parse
  to the exact downstream map (class defaults for `schemaVersion` and
  `commands` mirrored by the parser), actionable rejections
  (retired map literal, references/interpolation/calls/control flow,
  unknown/duplicate/positional/missing arguments, foreign imports),
  and the analyzer proof (`dart analyze` fails a scaffolded project
  whose descriptor mistypes `version`). Analyzability decision: the
  scaffold adds a minimal root `pubspec.yaml` (path dependency on the
  resolved flutter_vscode package root) whose only job is letting the
  author's analyzer resolve `package:flutter_vscode/manifest.dart`
  for completion and type-checking — the build never reads it and
  layout validation needed no changes. `apiTarget` is a required
  constructor argument, moving ADR 0011's no-silent-raise caveat from
  convention into the type; `publisher` and `activationEvents` stay
  required because the CLI never defaulted them. `ExtensionCommand`
  carries only `command`/`title` — the projection's optional fields
  (`category`, `enablement`, `shortTitle`, `icon`) went to futures.
  Suites at close: project_descriptor, cli_create, cli_build,
  cli_multi_baseline, cli_package, cli_modules, binding_evidence,
  plan_truth green; `flutter analyze` clean.
- [ ] AD-2 Host command helper: a generated framework module gives
  authors `registerCommand(name, handler)` over the Generated API
  Layer — handler is ordinary Dart (`FutureOr<Object?>
  Function(List<Object?> arguments)`), the module owns
  toHostCallback/toHostPromise wrapping, JS conversion of arguments
  and results, and `context.subscriptions` registration. The
  coverage extension's `_registerCommand` helper and its remaining
  command-path interop tokens disappear. Check: a red template/module
  suite; the extension builds with the helper; interop-token count
  in `host/lib/extension.dart` recorded before/after.
- [ ] AD-3 Declare-once codecs: `view_protocol.dart` (still one
  self-contained file) gains a value-codec combinator so a contract
  type declares its fields once and derives encode + decode + the
  exact-schema guard from the same declaration; the shared contract
  rewrites onto it with a measured line drop, and the assembled
  `ViewOperation` consts move into the shared package so host and
  view import one declaration instead of maintaining twins. Check: a
  red codec unit suite (round-trips, missing/extra-key rejection,
  null handling); shared-contract tests green with the line delta
  recorded; protocol suites green unmodified.
- [ ] AD-4 Final bar: coverage extension rebuilt and packaged on all
  three improvements; fast suites + analyze green; the real-host
  gates green at HEAD (host fixture, coverage extension,
  breakpoints).

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

1. **AD-1** (red 57e4b28, green df56f2f, migration 39422ae): the red
   `project_descriptor_test.dart` landed against the typed end state
   — 13 of its 16 cases failed on the map-era parser (the three that
   passed asserted literal-rule wording the old parser shared) —
   together with the consumer-suite moves (typed create
   expectations, the analyzable root pubspec, apiTarget rewrite
   patterns, the modules scaffold). Green: `lib/manifest.dart` plus
   the invocation-walking parser, the typed scaffold with its
   analyzability pubspec, and the contract chain reconverged in one
   `--contract` + fixture-rebuild pass; cli_create, cli_build,
   cli_multi_baseline, cli_package, cli_modules, binding_evidence,
   plan_truth, and the new descriptor suite all green with `flutter
   analyze` clean. The migration commit rebuilt the coverage
   extension on the typed form with a byte-identical generated
   `package.json`.

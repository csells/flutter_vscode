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

- [ ] AD-1 Typed descriptor: `package:flutter_vscode/manifest.dart`
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

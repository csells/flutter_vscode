# Parity Layer Plan

Status: In progress
Date: 2026-07-22

Per the updated vision and ADR 0012, the entire pinned stable API surface
is emitted as one mechanically generated, typed Dart layer produced only
by Total Mapping Rules — zero judgment calls, hard generation errors for
anything unmapped. Strategy and per-construct rules:
[`specs/research/js-to-dart-mapping.md`](../research/js-to-dart-mapping.md).
The IR census behind the rules: 6 intersection sites, 21 tuple sites, 26
rest parameters, 28 index signatures, one call-signature interface
(`Event`), `with`×6 and `toString`×1 reserved/core-name manglings, and
the platform-wide `undefined`/`null` conflation documented as `T?`.

Rules of this plan (inherited from the evidence-chain methodology): the
exit bar below is frozen; reds are commits; discoveries go to
[`backlog.md`](backlog.md); behavioral verification of parity members in
a real Extension Host is explicitly NOT part of this bar (ADR 0012 moves
it to the burn-down in [`futures.md`](futures.md)).

## Exit bar

- [ ] P-1 A parity emitter (`generate.dart --parity-layer .`) consumes the
  pinned IR and emits `lib/src/generated/vscode_parity_layer.g.dart`,
  exported as `package:flutter_vscode/vscode_parity.dart`. The module
  object an extension receives at activation is the only root: no new
  globals; constructors and statics reach JS through the module wrapper.
  Check: `flutter test test/parity_layer_test.dart` (regeneration
  byte-compare).
- [ ] P-2 Totality accounting: every declaration in the IR is either
  emitted or recorded in a generated ledger naming its rule (permitted
  erasure classes: symbol-keyed members, Thenable-as-JSPromise,
  non-public); a declaration in neither set fails the test. Check: the
  suite's totality assertions over `tool/bindings/parity-ledger.json`.
- [ ] P-3 The generated layer analyzes cleanly (`dart analyze
  --fatal-infos` on the generated library runs inside the suite) and
  regenerates byte-identically.
- [ ] P-4 Per-construct rules hold, asserted structurally on the real
  output: LUB union erasure at external boundaries, overload expansion
  with deterministic `$n` suffixes bound via `@JS`, numeric-enum `int`
  typedefs with module-rooted value accessors, type-literal extension
  types, `[]`/`[]=` index signatures, typed tuple accessors over
  `JSArray`, implements-both intersections, `JSPromise<T>` for
  Thenable/Promise, reserved-word `$` mangling, readonly-as-getter,
  `T?` optionality, call-signature interfaces over `JSFunction`.
- [ ] P-5 Unmapped constructs fail generation with a
  `ParityGenerationException` naming the declaration and missing rule
  (proven with a synthetic IR fragment).

## TDD Ledger

Entries appended as items close; reds are commits.

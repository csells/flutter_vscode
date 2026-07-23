# Backlog

Discoveries made during a frozen round land here instead of growing that
round's exit bar. Items graduate into an active plan with their own
machine checks; nothing in this file blocks a round's closure.

## Now: the complete typed Parity Layer (active)

Per the updated vision and ADR 0012, the entire pinned stable API surface
is emitted as one mechanically generated, typed Dart layer produced only
by Total Mapping Rules — zero judgment calls, hard generation errors for
anything unmapped. Strategy and per-construct rules:
`specs/research/js-to-dart-mapping.md`. Exit bar (each item machine
checked, red-green):

- [ ] P-1 A parity emitter (`generate.dart --parity-layer .`) consumes the
  pinned IR and emits `lib/src/generated/vscode_parity_layer.g.dart`,
  exported as `package:flutter_vscode/vscode_parity.dart`. The module
  object an extension receives at activation is the only root: no new
  globals, constructors and statics reach JS through the module wrapper.
  Check: emitter tests + byte-compare regeneration test.
- [ ] P-2 Totality accounting: every public declaration in the IR is
  either emitted or recorded in a generated erasure ledger naming its
  rule (the only permitted erasure classes are symbol-keyed members and
  the documented `undefined`/`null` conflation); non-public declarations
  are excluded mechanically. A declaration in neither set fails the test.
  Check: `flutter test test/parity_layer_test.dart` (totality assertions).
- [ ] P-3 The generated layer analyzes cleanly (`dart analyze` over the
  generated library is part of the suite) and regenerates
  byte-identically.
- [ ] P-4 Per-construct rules hold, asserted structurally on the real
  output: LUB union erasure at external boundaries, overload expansion
  with deterministic `$n` suffixes bound via `@JS`, string-literal and
  numeric-enum typedefs with module-rooted value accessors, type-literal
  extension types with object-literal constructors, `[]`/`[]=` index
  signatures, typed tuple accessors over `JSArray`, implements-both
  intersections (6 sites), `JSPromise<T>` for Thenable/Promise,
  reserved-word `$` mangling, readonly-as-getter, `T?` optionality.
- [ ] P-5 Unmapped constructs fail generation with an actionable error
  naming the declaration and missing rule (proven with a synthetic IR
  fragment).

Behavioral verification of parity members in a real Extension Host is
NOT part of this bar (ADR 0012 moves it to the burn-down below).

## Future (explicitly deferred)

- **Idiomatic Facade** over the Parity Layer: Dart-first ergonomics,
  Semantic Overrides, reviewed design — built up incrementally after the
  Parity Layer ships.
- **Behavioral verification burn-down**: real-host evidence for parity
  members, grouped by capability fixture (trees/filesystems,
  terminals/tasks, language features, testing, SCM, notebooks,
  authentication, debugging, webviews).
- Runtime semantics for the View protocol: cancellation, host-to-view
  requests, events/streams, handles, backpressure (protocol v1 today has
  none of these; disposal is session-level only).
- Product workflow: `doctor`, `test`, `upgrade`; generated-file ownership
  and repair; v0 migration after real usage (the legacy
  `generate_vscode_extension` executable still ships with a legacy
  notice until then).
- Hardening: two extensions in one host, failure injection, protocol
  abuse, breakpoint/source-map behavior, startup/memory,
  Windows/macOS/Linux, remote-host harness.
- Platform reach: Web Extension Host before 1.0 (ADR 0009).
- Documentation from executable behavior; support policy last, from
  measurements.

## Engineering debt (from the audits)

- The CLI (`bin/flutter_vscode.dart`) and the generator
  (`tool/binding_generator/generator.dart`) remain monoliths; named as a
  maintainability follow-up.
- Webview CSP content is not gate-asserted: only `Webview.cspSource`
  usage is proven.
- `scripts/check_round5_exit.sh` cannot itself verify the two
  consecutive `test_all.sh` runs its R5-13 item names; those remain
  procedural evidence.
- The R5-7 static check verifies absence of rsync rather than positively
  parsing the staging pipeline.
- The ECMAScript whitespace predicate exists in two implementations held
  together by mirrored tests.
- The host-side view transport lives in the test fixture rather than as
  a framework module.
- A registered-shape hash is key-order sensitive (bounded: child
  cross-checks still bind content).
- The only Extension Host proof platform is Linux-in-Docker; every gate
  re-downloads VS Code.
- No real extension exists outside the repository fixtures.

## Upstream contribution (owner's call)

When the owner decides to engage upstream, open a pull request from
`csells:project-hardening` to `SlowGen/flutter_vscode`. How that
contribution is validated is entirely SlowGen's choice; this project's
deliverable is a branch whose gates pass locally
(`scripts/test_all.sh`, `scripts/check_round5_exit.sh`).

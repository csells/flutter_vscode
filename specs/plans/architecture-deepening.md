# Architecture Deepening Plan

Status: In progress
Date: 2026-07-24

Implements all six candidates from the 2026-07-24 architecture review
(deep-module vocabulary: module/interface/seam/depth/locality/
leverage). These are deepening refactors: behavior is pinned before
each change — generated artifacts stay byte-identical where an item is
a pure refactor, the protocol wire is pinned by its 67-test suite, and
CLI behavior by retained subprocess smoke tests. Reds are therefore
structural: each lands a failing suite against the interface the item
promises, while the existing pins prove no behavior moved.

Rules (inherited): the exit bar is frozen; reds are commits;
discoveries go to [`futures.md`](futures.md).

## Exit bar

- [ ] A-1 The Author Toolchain gains an in-process interface: the deep
  CLI modules (packaging/VSIX validation, safe layout walks, baseline
  selection, build orchestration, doctor, test) move to
  `lib/src/cli/`, and `bin/flutter_vscode.dart` shrinks to a process
  adapter (arg dispatch + exit-code mapping). New in-process unit
  suites cover the moved modules directly, including the previously
  bin/-private `_validateAssembledVsix`, `_safeFiles`, and
  `_validateRealProjectPaths`; doctor and layout validation share one
  source of truth; the `_projectFile` twin and the triple apiTarget
  default collapse. A reduced subprocess suite still proves the
  adapter end to end. Check: new unit suites green in-process; all
  existing cli_*_test suites green; bin/ line count materially down.
- [ ] A-2 One session core behind both View Protocol roles: the
  mirrored machinery (envelope send, parse+dispatch, pending-completer
  registry, seen-id dedup, cancellation sets, structured-error send,
  idempotent close/terminate) moves into a shared core; Host and View
  become thin role adapters (handshake direction, exposed futures,
  allowlist placement). The four-field active-frame predicate exists
  once. Typed frames land with it: sealed per-kind frame types own
  parse/serialize so envelope keys are written in one module. Check:
  the full protocol suite green unchanged; a new core-focused suite;
  grep gates: no hand-written `'nonce'` map literals outside the frame
  module.
- [ ] A-3 An `IrTypeMapper` module extracted from the parity emitter:
  the IR index + type mapping (byId/childrenByParent/mapType/
  substitute/scopesFor/dartName/memberName/hashName/
  nullableForGeneric/tupleElements) becomes a standalone module both
  emitters take as a dependency; the public mutable
  `eraseScopeReferences` flag becomes a call parameter. Check: parity
  and dart-layer byte-compares green (outputs unchanged); a new
  mapper unit suite; the dart-layer emitter no longer touches parity
  mutable state (grep gate).
- [ ] A-4 generator.dart unjailed: the IR validation/canonicalization
  projection, the coverage ledger, the manifest/contribution
  projection, and the four embedded source templates move to sibling
  modules under `tool/binding_generator/`; `generator.dart` keeps the
  entangled walking-slice orchestration band. Check: walking-slice
  byte-compare and full binding_generator suite green (outputs
  unchanged); generator.dart line count under 2,500.
- [ ] A-5 A view shell module: `ViewShell` (or equivalent) in
  `package:flutter_vscode/view.dart` owns session connect, the theme
  stream, host-event subscriptions, and rendered-reporting behind one
  interface with one disposal; void-codec helpers erase the repeated
  encode-null/decode-guard pairs; Coverage Treemap's view adopts it
  and its hand-managed lifecycles disappear. Check: a new shell unit
  suite over the in-memory transport; treemap view analyze + tests
  green; the extension's main.dart no longer cancels protocol
  subscriptions by hand.
- [ ] A-6 The fixture composes `FlutterViewHost`: the template's
  interface grows the injection points the adversity harness needs
  (extra HTML metas, script hooks — the incoming-frame observer
  already exists), the fixture consumes the composed skeleton, and
  only adversity machinery (fault injection, render observer, reload
  probe) remains fixture-owned. If a needed injection point would
  widen the template's interface beyond its production purpose, stop,
  record the boundary in futures, and close this item with what
  composed cleanly. Check: `./scripts/test_host_extension.sh` green;
  the fixture no longer re-implements panel/session/CSP-HTML
  wholesale.

Final gate for the plan: fast suites + `flutter analyze` clean, and
the three real-host gates (`test_host_extension.sh`,
`test_coverage_extension.sh`, `test_breakpoints.sh`) green at HEAD.

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

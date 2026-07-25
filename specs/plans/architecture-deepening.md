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
- [x] A-2 One session core behind both View Protocol roles: the
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
  Closed (red 7407aca, green 4e9d669): a sealed `ViewProtocolFrame`
  hierarchy owns parse (sole home of the exact-schema validation,
  codes and messages preserved) and `toWire()` (sole producer of wire
  maps) inside a marker-delimited region of the still-single
  `lib/src/view_protocol.dart` (the CLI copies that one file verbatim
  into projects); the locality gate holds every envelope key literal
  inside it. `_ViewSessionCore` owns subscription/receive lifecycle,
  typed-frame send, the pending-response registry, inbound dedup and
  cancel marks, the shared inbound-operation skeleton with
  structured-error framing, and the idempotent close/terminate
  scaffolds; the roles keep handshake direction, exposed futures,
  allowlist placement, role vocabulary, and their genuinely different
  close choreography. The predicate exists once, on the frame. One
  deliberate tightening: the v2-only kinds (hostCall/hostResult/
  hostError/cancel/event) now validate their fields at parse like
  their v1 counterparts, so malformed ones fail closed instead of
  surfacing as untyped cast failures at dispatch. The 67-test suite
  passed unmodified; the checked-in Host fixture mirror was refreshed
  verbatim; the durable contract artifact awaits the mechanical
  `--contract` regeneration.
- [x] A-3 An `IrTypeMapper` module extracted from the parity emitter:
  the IR index + type mapping (byId/childrenByParent/mapType/
  substitute/scopesFor/dartName/memberName/hashName/
  nullableForGeneric/tupleElements) becomes a standalone module both
  emitters take as a dependency; the public mutable
  `eraseScopeReferences` flag becomes a call parameter. Check: parity
  and dart-layer byte-compares green (outputs unchanged); a new
  mapper unit suite; the dart-layer emitter no longer touches parity
  mutable state (grep gate).
  Closed (red 4fc4e94, green 0744a1b): `ir_type_mapper.dart` (759
  lines) owns the ctor-built indexes, `mapType` with its union/alias/
  LUB helpers, substitution, scope collection, name mangling, and the
  tuple/literal-wrapper registries plus intersection operand sets;
  erasure is a per-call `mapType` parameter threaded through both
  emitters (required-named in the dart layer), so the mutable flag and
  the save/restore dance are gone. One judgment call the item
  anticipated: intersection bodies stay emitter-built — from the
  mapper's registered operand sets, deferred to just before assembly —
  because they redeclare conflict members with the emitter's member
  rules and read dispositions. `emitParityLayer`/`emitDartLayer` are
  unchanged; ParityEmitter shrank from 1,709 to 1,086 lines and the
  dart layer now consumes the mapper plus only emit/dispositions/
  isEmitted from the parity emitter instead of the 18-member
  whole-object seam. Both byte-compares held unchanged; the three
  contract source maps receipt the module, with the durable artifact
  awaiting mechanical `--contract` regeneration at merge.
- [x] A-4 generator.dart unjailed: the IR validation/canonicalization
  projection, the coverage ledger, the manifest/contribution
  projection, and the four embedded source templates move to sibling
  modules under `tool/binding_generator/`; `generator.dart` keeps the
  entangled walking-slice orchestration band. Check: walking-slice
  byte-compare and full binding_generator suite green (outputs
  unchanged); generator.dart line count under 2,500.
  Closed: `ir_validator.dart` (IR validation/canonicalization plus the
  declaration fingerprint, re-exported for existing importers),
  `coverage_ledger.dart`, `manifest_projection.dart` (including the
  project descriptor checks), `validators.dart` (the shared leaf
  scalars), and `templates.dart` (the five embedded source templates —
  host exports, bootstrap.cjs, walking-slice parity/facade/runtime —
  as literal-preserving functions) now sit beside a 2,373-line
  `generator.dart` holding the orchestration and walking-slice band;
  cross-file entry points kept their names minus the underscore;
  outputs stayed byte-identical under the cli byte-compare pin; the
  three contract source maps receipt the new modules, with the durable
  artifact awaiting mechanical `--contract` regeneration at merge.
- [x] A-5 A view shell module: `ViewShell` (or equivalent) in
  `package:flutter_vscode/view.dart` owns session connect, the theme
  stream, host-event subscriptions, and rendered-reporting behind one
  interface with one disposal; void-codec helpers erase the repeated
  encode-null/decode-guard pairs; Coverage Treemap's view adopts it
  and its hand-managed lifecycles disappear. Check: a new shell unit
  suite over the in-memory transport; treemap view analyze + tests
  green; the extension's main.dart no longer cancels protocol
  subscriptions by hand.
  Closed (red 1528ffc, green 9ce3843): `ViewShell` in the new
  `lib/src/view_shell.dart` (158 lines, exported from `view.dart`)
  owns session connect, the current-theme snapshot plus a deduplicated
  broadcast theme stream behind one upstream subscription, shell-owned
  event forwards behind `events()`, rendered reporting, and a single
  idempotent `dispose()` that returns transport subscriptions to zero.
  Injectable `ViewShellSessionSource`/`ViewShellThemeSource` seams
  keep the core widget-free and unit-testable over the in-memory
  transport; 22-line conditional web/stub defaults acquire the live
  webview transport and document (the bootstrap `connect` gained an
  `operations` pass-through). `ViewOperation.noArgs`/`noResult` supply
  the void codec sides. Coverage Treemap's view adopts the shell:
  `main.dart` (440 → 430 lines) holds no `StreamSubscription` fields
  and cancels nothing by hand — one `dispose()` replaces the
  hand-wired session, two hand-cancelled subscriptions, and the
  second theme stream. The shared contract folds its duplicate void
  pairs into one `encodeNoValue`/`decodeNoValue` pair (196 → 185
  lines) consumed by the host role. The Host fixture protocol mirror
  was refreshed verbatim; the durable contract artifact awaits the
  mechanical `--contract` regeneration.
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

1. **Red A-4** (commit b67d475): `binding_generator_layout_test`
   landed against the promised module layout — all six cases failed:
   no `ir_validator.dart`, `coverage_ledger.dart`,
   `manifest_projection.dart`, `templates.dart`, or `validators.dart`
   beside the generator, and `generator.dart` at 6,057 lines.
2. **Green A-4** (commit 82088b2): pure motion along the mapped seams
   moved the IR projection, the coverage ledger, the manifest
   projection, the shared leaf validators, and the five embedded
   templates out of `generator.dart` (now 2,373 lines); the pins held
   — the walking-slice byte-for-byte regeneration and the 202-test
   generator suite ran unchanged, 259 tests green across the affected
   suites with `flutter analyze` clean. `binding_evidence_test`'s
   hash pins await the mechanical `--contract` regeneration when this
   branch merges.
3. **A-2** (red 7407aca, green 4e9d669): the 67-test protocol suite ran
  unmodified and green through the migration; the new
  `view_protocol_core_test.dart` adds 15 tests (per-kind parse/
  serialize round-trips in exact key order, the pinned validation
  codes and messages, the active-frame predicate, a view-side
  duplicate-inbound-ID path through the shared core, and the wire-key
  locality gate). Literal tallies in `lib/src/view_protocol.dart`:
  `'nonce'` 39 → 4 lines, `'version'` 36 → 3, `'session'` 36 → 4,
  `'flutter-vscode.view'` 21 → 1 — all inside the frame region. Role
  classes: Host 644 → 469 lines, View 582 → 382, atop a 310-line
  shared core and a 583-line frame module in the same single file.
4. **A-5** (red 1528ffc, green 9ce3843): the red `view_shell_test.dart`
   landed against the promised interface and failed to compile — no
   `ViewShell`, no source seams, no `ViewOperation.noArgs`/`noResult`.
   Green passes its 9 tests over the in-memory transport with an
   injected theme source: connect exposes the session and initial
   theme and passes view operations through; the theme stream dedupes
   behind one shared upstream subscription; `events()` round-trips a
   host `emitEvent` and `reportRendered` reaches the host future; one
   `dispose()` cancels everything (view subscriptions 0, upstream
   released, transport release invoked once, host closes clean); both
   void codec sides round-trip and the decode guard rejects non-null.
   The 67-test protocol and 15-test core suites ran unmodified and
   green; treemap view `dart analyze` + `flutter test` and shared
   `dart test` green; `flutter analyze` clean at the root.
5. **A-3** (red 4fc4e94, green 0744a1b): the 15-test
  `ir_type_mapper_test` landed against the promised module and failed
  to compile — no `ir_type_mapper.dart` beside the emitters — with the
  grep gate over the dart layer's `eraseScopeReferences =`
  save/restore committed in the same red. Green moved the indexes,
  type rules, name mangling, and registries into the 759-line mapper
  and threaded erasure as a call parameter through both emitters. The
  pins held: parity and dart-layer byte-compares ran unchanged, 99
  tests green across the five affected suites plus the 202-test
  generator suite and the 4-test cli byte-compare, `flutter analyze`
  clean. Line moves: parity_layer.dart 1,709 → 1,086; dart_layer.dart
  1,034 → 1,103 (+69, the price of explicit per-call erasure over
  ambient mutable state). `binding_evidence_test`'s hash pins await
  the mechanical `--contract` regeneration when this branch merges.

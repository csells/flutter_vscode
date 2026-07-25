# Single Layer Plan

Status: In progress
Date: 2026-07-25

Collapses the three generated API layers into one, per the owner's
deletion-test argument: the mechanical Dart layer does not need to
ship *on top of* a separate Parity artifact (it can carry the same
implementation), and with a total mechanical layer the hand-reviewed
walking-slice facade has no remaining role a framework module or the
evidence chain cannot serve better. End state: **one generated API
artifact** (`vscode_dart_layer.g.dart`, self-contained: substrate
types + ergonomic types + raw escape hatches), the runtime and
host-exports modules (not API layers), and hand-written framework
modules for judgment-shaped helpers.

Frozen invariant from the owner: **100% of the existing layer-3
suites pass unmodified** — `test/dart_layer_test.dart` and
`test/dart_layer_emitter_unit_test.dart` are not edited in this
round. Layer-1/layer-2 tests move or retire only where their subject
moves or dies; no assertion is weakened silently.

Rules (inherited): exit bar frozen; reds are commits; ADR history is
amended, never rewritten; discoveries go to
[`futures.md`](futures.md).

## Exit bar

- [ ] SL-1 One self-contained artifact: `emitDartLayer` inlines the
  substrate (current parity emission) into
  `vscode_dart_layer.g.dart` — no `import 'vscode_parity_layer...'`
  — with `tool/bindings/parity-ledger.json` retained as the substrate
  totality ledger (the L3 suite reads it). The standalone parity
  artifact and its `package:flutter_vscode/vscode_parity.dart` export
  retire; `package:flutter_vscode/vscode_dart.dart` is the one API
  export. `flutter_vscode build` emits the one artifact into
  projects. Layer-2 tests move: the emitter-level structure, totality,
  and rule suites (`parity_layer_test`, `parity_emitter_unit_test`)
  retarget in-memory emission or the merged artifact — the checked-in
  standalone-artifact byte-compare retires with its artifact; the
  two-axis live-coverage completeness checks (C-3/C-4/V-4) survive
  intact. Check: L3 suites green unmodified; moved L2 suites green;
  analyze clean.
- [ ] SL-2 Facade retirement: the walking-slice facade and its
  parity-slice sibling stop being emitted (runtime and host-exports
  templates remain — they are runtime, not API). The fixture host,
  the example extension host, the scaffold (`create`), and the
  FlutterViewHost template consume the single layer plus runtime and
  framework modules. The binding-observation mechanism retires with
  the facade; the Semantic Override series remains the ADR-0008
  release-gate classification. `coverage.json` and the contract
  chain re-derive mechanically from the new reality (receipts drop
  facade artifacts; walking-slice behavioral checks in the harness
  rewrite against the single layer). Check: fixture and example
  build; contract regenerates to convergence; binding_evidence,
  repository_gate, and CLI suites green (moved where their subject
  moved).
- [ ] SL-3 Reports and prose truth: `docs/reference/parity.md`
  regenerates with honest accounting for the single-layer world (the
  two-axis live-coverage definition is unchanged; per-member
  host-verified framing follows the evidence that actually exists);
  `CONTEXT.md` updates Parity Layer/Idiomatic Facade terms to the
  single-layer reality; architecture docs (binding-pipeline,
  author-workflow, host-execution, view-protocol, evidence-chain,
  index) describe one generated API layer. Check: report regen pin
  green; plan_truth green; grep gates for retired names in living
  docs.
- [ ] SL-4 Decisions: new ADR 0013 records the single-layer decision
  (supersedes ADR 0006's generated-facade half; the Idiomatic Facade
  future becomes hand-written framework modules over the single
  layer, in the FlutterViewHost/ViewShell mold); dated amendment
  notes on 0006 and 0012 point at 0013. Check: originals untouched
  below their amendment lines.
- [ ] SL-5 Final bar: full fast suite green (with L3 suites verified
  byte-unmodified via git), `flutter analyze` clean, and all three
  real-host gates green at HEAD (`test_host_extension.sh`,
  `test_coverage_extension.sh`, `test_breakpoints.sh`).

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

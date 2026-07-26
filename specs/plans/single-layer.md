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

- [x] SL-1 One self-contained artifact: `emitDartLayer` inlines the
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
  Closed (red 95e3bc0, green 8047cca): `emitDartLayer` captures the
  substrate emission's declaration body and writes it between the
  imports and the dart-layer sections of `vscode_dart_layer.g.dart`
  (735,407 bytes — within 202 bytes of the two artifacts it replaces,
  the delta being the merged header and retired import);
  `--dart-layer` writes both totality ledgers byte-identically and
  `--parity-layer` retires. `lib/vscode_parity.dart` and the
  standalone artifact are deleted; `vscode_dart.dart` exports only the
  merged artifact; build emits one API artifact and the fixture and
  example hosts compile against it through their unchanged `parity`
  alias. The contract chain receipts the merged fixture artifact as
  `generatedDartLayer` in all three synchronized copies and
  regenerated to convergence. `parity_layer_test` retargets P-4 and
  P-1 to the in-memory substrate emission (byte-compare/analyze duty
  now lives in frozen D-1/D-3); `parity_emitter_unit_test` passed
  unmodified. L3 suites verified byte-unmodified via git diff; 333
  tests green across the affected suites plus the 9-case build suite;
  `flutter analyze` clean.
- [x] SL-2 Facade retirement: the walking-slice facade and its
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
  Closed (red 4c5b2b8, green 18ee663): the generator emits only the
  runtime module, host exports, bootstrap, manifest, and coverage
  ledger — the walking-slice strategy and relation validation still
  runs on every generate, so the reviewed classifications keep their
  ADR-0008 gate without generated-code backing. The observation
  mechanism retired with its only caller (runtime, bootstrap,
  launcher, verifier, and their tests shed the observed-ID half; the
  source-receipt half stays at full strength). Every consumer moved
  onto the single layer with `toHostCallback` preserving the
  mapped-stack behavior the real-host gate asserts, and
  `FlutterViewHost.open`'s interface is unchanged. Coverage decision
  (the smallest honest re-derivation): `coverage.json` keeps its
  shape and summary counts; `binding.artifacts` now cites
  `vscode_dart_layer.g.dart` (where the emitted binding actually
  lives) and `hostEvidence.meaning` / the contract's
  `evidence.meaning` state receipted-gate attribution without
  per-member observation, so `parity.md` regenerated byte-identically
  (its prose reframing is SL-3's). Contract chain regenerated to
  convergence with the `generatedFacade`/`generatedParity` receipts
  retired. 532 fast-suite tests green, `flutter analyze` clean, the
  frozen L3 suites byte-unmodified via git diff; the three real-host
  Docker gates must run at the SL-5 bar.
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

1. **SL-1** (red 95e3bc0, green 8047cca): the red
   `single_layer_test.dart` landed against the promised end state —
   substrate types inside the dart-layer artifact, no parity import,
   `lib/vscode_parity.dart` gone, one artifact under
   `lib/src/generated`, no `vscode_parity_layer.g.dart` in built
   project trees — and failed 4 of its 5 cases. Green: the frozen L3
   suites (`dart_layer_test`, `dart_layer_emitter_unit_test`) passed
   with zero edits (verified via `git diff` against the branch base);
   the retargeted `parity_layer_test` keeps P-1 (substrate ledger
   regeneration), P-2, all P-4 structural rules, C-3/C-4/V-4, and P-5
   at full strength over the in-memory emission, retiring only the
   standalone-artifact byte-compare, analyze, and export cases whose
   subject died; 333 tests green across the twelve affected suites,
   the 9-case `cli_build_test` green, contract chain converged,
   `flutter analyze` clean.
2. **SL-2** (red 4c5b2b8, green 18ee663): the red `single_layer_test`
   group landed against the promised end state — no
   `vscode_facade.g.dart` / `vscode_parity.g.dart` in built project
   trees, no facade emission in the generator or templates, no facade
   import in the fixture, example, scaffold, or FlutterViewHost
   template — and failed all 3 cases. Green: `binding_generator_test`
   retired 11 emission/observation cases and retargeted 2 (202 → 191,
   all strategy-validation and IR suites intact); the CLI observation
   probe retired with its mechanism while the transport-rejection
   behavior stays pinned in `host_webview_transport_test`; the
   evidence suite keeps the receipt-integrity cases and retargets the
   observation case to a no-residue check; `host_contract.test.cjs`
   retired 5 evidence cases and added a source-count case. 532 tests
   green across the fast suite, fixture and example rebuilt from the
   migrated sources, contract chain converged, `parity.md`
   byte-stable, `flutter analyze` clean, frozen L3 suites verified
   byte-unmodified.

# Docs Truth Plan

Status: In progress — owner approved 2026-07-25; DT-2 re-resolved by
owner directive during execution: the view-protocol reference page is
the only protocol reference and message-contract.md is deleted (no
legacy framing on this branch)
Date: 2026-07-25

Brings the documentation corpus to truth at HEAD. The original
default-battery audit (46 pages, 42 findings) predated the
single-layer round, whose SL-3 wave rewrote eight of the audited
pages; this re-scope keeps only what remains open at HEAD, per-item
verified. The `.improve-docs/` baseline predates SL-3 — DT-0 refreshes
it so deltas measure this round's work, not the single-layer round's.

Rules (inherited): the exit bar is frozen; edits land on a branch in
grouped commits; generated pages are regenerated, never hand-edited;
no history rewrites in ADRs — amendments only; discoveries go to
[`futures.md`](futures.md).

## Exit bar

- [x] DT-0 Fresh baseline: re-run the census and polish/drift scoring
  over the corpus at HEAD into `.improve-docs/baseline.json` before
  any edit, so per-dimension deltas attribute honestly. Check: the
  report's deltas reference the new baseline date.
- [ ] DT-1 Front door: README and quickstart document the full CLI
  surface (`doctor`, `test`, `build --watch` — all absent from the
  README today), both pinned baselines with `apiTarget` selection
  (1.130.0 appears only in the new-baseline guide today), and name
  ViewShell in the view walkthrough. The one-layer presentation and
  example section are already true — do not re-litigate. Check:
  repository_gate_test green; fresh-eyes pass records no stale claim.
- [x] DT-2 Reference: wire-v2 protocol documentation exists — either
  message-contract.md is rewritten from its v0/legacy-bridge content
  or a new view-protocol reference page lands beside it with the
  legacy page linked as historical (owner's call at approval);
  version-2 envelope, hostCall/hostResult/hostError/cancel/event,
  `noArgs`/`noResult`, ViewShell. startup.md gains a link from
  reference/index.md (de-orphan). generated-host-api.md is already
  current. Check: claims verified against lib/src/view_protocol.dart;
  link-check clean.
  Closed: `docs/reference/view-protocol.md` lands as the
  author-facing wire-v2 contract — envelope, handshake, typed calls
  both directions, `noArgs`/`noResult`, events, cancellation,
  rendered, shutdown/closing, and the per-role fail-closed rules —
  with every claim read out of `lib/src/view_protocol.dart` and the
  snippets trimmed from the shipped coverage_treemap wiring. An owner
  directive during execution superseded the approval-time resolution:
  the branch carries no legacy framing, so message-contract.md is
  deleted outright rather than kept as a linked legacy record, and
  reference/index.md drops its legacy-flagged entries (roadmap,
  prd-traceability, message-contract, vscode-api-mapping — the pages
  other than message-contract.md still exist and keep inbound links
  elsewhere) while gaining the new page and startup.md (both
  de-orphaned). Two directory links the checker could not vouch for
  (architecture/index.md's ADR link, roadmap.md's plans link) became
  inline paths, so link-check reports zero broken links; DT-6's new
  docs/adr/index.md is where ADR navigation returns as links.
- [ ] DT-3 Guides: troubleshooting.md names the v2 handshake, leads
  with `flutter_vscode doctor`, and replaces the pre-totality
  missing-API remedy (the generated layer is total; "pending" means
  unverified, not unsupported); agent-assisted-development.md's
  working model reflects the total generated layer and the full CLI
  (test/doctor in the run loop). Check: every named error code and
  remedy matches the CLI at HEAD.
- [x] DT-4 Agent surface: project-structure.md teaches the current
  CLI and layout (extensions/, skills/, lib/src/cli/);
  consumer-agents.md mandates doctor/test in validation; the build,
  test, and troubleshoot skills teach the shipped surface (the
  extension-host skill is already current); a new
  flutter-vscode-view skill covers ViewShell.connect, runFlutterView,
  the theme bridge, and host push events. Check: every command/API
  named in skills exists at HEAD.
  Closed (cb7c8ac, a4e713f): project-structure.md carries the five
  CLI commands as bin/flutter_vscode.dart dispatches them and the
  lib/src/cli/, extensions/, and skills/ layout entries;
  consumer-agents.md mandates the doctor/build/test/package ladder,
  names the total vscode_dart_layer.g.dart in place of the
  implemented-symbol framing, and drops the stale v1-call wording.
  The build skill gains the doctor preflight and --watch, the test
  skill teaches flutter_vscode test's real discovery (shared/test and
  host/test via dart test, views/<name>/test via flutter test), and
  the troubleshoot skill leads with doctor while naming only error
  codes grep-verified against lib/src/cli/ and the CLI adapter. The
  new flutter-vscode-view skill grounds every identifier in
  lib/src/view_shell.dart, view_theme_web.dart, view_protocol.dart,
  and the shipped treemap_panel view; skills/README.md registers it.
  plan_truth (5) and repository_gate (14) green; flutter analyze
  clean.
- [x] DT-5 ADR residue: ADR 0012's amendment gains the release-gate
  correction (per-symbol reviewed classification survives at baseline
  import per ADR 0008 as amended; the no-rule block applies at layer
  generation); ADR 0011 gains the missing-apiTarget fallback caveat.
  The 0006/0012 one-layer amendments already landed in SL-4. Check:
  originals untouched below amendment lines.
- [x] DT-6 Structure (amended by owner directive: no legacy content
  survives — we build on a branch): docs/architecture/index.md is a
  true pointer to specs/architecture/; docs/adr/index.md lists all
  thirteen ADRs and is linked from docs/index.md; the legacy pages
  (consumer-agents-v0.md, vscode-api-mapping.md, and — via DT-2's
  amended resolution — message-contract.md) are deleted outright with
  their referrers cleaned, not linked as variants. Structural moves
  landed in their own commits. Check: link-check clean, zero legacy
  orphans.
- [ ] DT-7 Polish on touched pages: openers 40–80 words naming thing,
  audience, and place; motivation and cross-links; no reflow of
  untouched pages. Check: fresh-eyes review; per-dimension deltas vs
  the DT-0 baseline.

Verification gate: link-check clean; plan_truth_test,
repository_gate_test, the parity-report regeneration pin, and
`flutter analyze` green; the report records deltas against the DT-0
baseline and remaining distance to the bar.

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

1. **DT-0** (2026-07-25): baseline re-snapshotted at HEAD b3081d8
   (38 docs pages) into `.improve-docs/baseline.json`, superseding the
   pre-single-layer snapshot so this round's deltas attribute honestly.
2. **DT-4** (cb7c8ac, a4e713f, 2026-07-25): a docs item has no
   executable red; every claim was instead ground-truthed against
   HEAD before writing — the CLI surface against
   bin/flutter_vscode.dart and lib/src/cli/, suite discovery against
   test_command.dart, watch semantics against watch_command.dart,
   every troubleshoot error code grepped to its CliException site,
   and the view skill's identifiers against view_shell.dart, the
   theme bridge, view_protocol.dart, and the shipped treemap_panel
   consumer. Two pages and four skills updated, one skill added and
   registered; the extension-host skill was verified current and left
   untouched. plan_truth (5) and repository_gate (14) green at
   recording time; flutter analyze clean (the nested fixture and
   example-extension packages needed only local dependency
   resolution, no source change).

2. **DT-5/DT-6** (2026-07-25): the 0012 release-gate-composition and
   0011 apiTarget-fallback amendments landed append-only; the
   architecture index reduced to a pointer, the thirteen-ADR index
   landed and is linked from the docs root — and mid-round the owner
   directed the legacy purge: no legacy framing anywhere, so
   vscode-api-mapping.md and consumer-agents-v0.md are deleted with
   referrers cleaned, and DT-2's resolution amends from
   keep-as-legacy-record to delete message-contract.md outright.
2. **DT-2** (2026-07-25): `docs/reference/view-protocol.md` lands as
   the one protocol reference; an owner directive during execution
   superseded the approval-time resolution, so message-contract.md is
   deleted rather than kept as a linked legacy record and
   reference/index.md drops its legacy-flagged entries while gaining
   the new page and startup.md; link-check reports zero broken links
   and neither page is an orphan.

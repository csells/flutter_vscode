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
- [ ] DT-4 Agent surface: project-structure.md teaches the current
  CLI and layout (extensions/, skills/, lib/src/cli/);
  consumer-agents.md mandates doctor/test in validation; the build,
  test, and troubleshoot skills teach the shipped surface (the
  extension-host skill is already current); a new
  flutter-vscode-view skill covers ViewShell.connect, runFlutterView,
  the theme bridge, and host push events. Check: every command/API
  named in skills exists at HEAD.
- [ ] DT-5 ADR residue: ADR 0012's amendment gains the release-gate
  correction (per-symbol reviewed classification survives at baseline
  import per ADR 0008 as amended; the no-rule block applies at layer
  generation); ADR 0011 gains the missing-apiTarget fallback caveat.
  The 0006/0012 one-layer amendments already landed in SL-4. Check:
  originals untouched below amendment lines.
- [ ] DT-6 Structure: docs/architecture/index.md becomes a true
  pointer to specs/architecture/ (still a full narrative page today);
  a new docs/adr/index.md lists all thirteen ADRs and is linked from
  docs/index.md; consumer-agents-v0.md is linked as the legacy
  variant. Structural moves in their own commits. Check: link-check
  reports zero orphans among these pages.
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
2. **DT-2** (2026-07-25): `docs/reference/view-protocol.md` lands as
   the one protocol reference; an owner directive during execution
   superseded the approval-time resolution, so message-contract.md is
   deleted rather than kept as a linked legacy record and
   reference/index.md drops its legacy-flagged entries while gaining
   the new page and startup.md; link-check reports zero broken links
   and neither page is an orphan.

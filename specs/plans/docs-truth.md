# Docs Truth Plan

Status: Proposed — queued behind [single-layer.md](single-layer.md)
by owner direction (the docs will document ONE generated layer);
DT items describing three layers re-scope at execution time
Date: 2026-07-25

Brings the documentation corpus to truth at HEAD. A four-auditor
default-battery audit (polish bar + code-consistency drift) over 46
pages (docs/, README, skills/) found 42 findings — 24 major, 0
critical — with one root cause: the corpus teaches the pre-deepening
framework (two generated layers, create/build/package only, one
pinned baseline, protocol v1, no ViewShell, no shipped example).
Baseline: mean polish 6.9/10; 16 pages major drift, 8 minor, 22
clean; 0 broken links; 12 orphan pages. Audit artifacts live in
`.improve-docs/` (findings.json, scores.json, baseline.json).

Rules (inherited): the exit bar is frozen; edits land on a branch in
grouped commits; generated pages are regenerated, never hand-edited;
no history rewrites in ADRs — amendments only; discoveries go to
[`futures.md`](futures.md).

## Exit bar

- [ ] DT-1 Front door truth: README and quickstart present the three
  generated layers, the full CLI surface (create, build [--watch],
  package, doctor, test), both pinned baselines with `apiTarget`
  selection, the ViewShell/runFlutterView view walkthrough, and the
  shipped example extension. Check: repository_gate_test stays green;
  fresh-eyes pass records no stale claim on either page.
- [ ] DT-2 Reference truth: generated-host-api.md documents the
  Dart-ergonomics layer beside the facade and Parity Layer;
  message-contract.md describes wire v2 (version-2 envelope,
  hostCall/hostResult/hostError/cancel/event, noArgs/noResult,
  ViewShell); reference/index.md links startup.md. Check: claims
  verified against lib/src/view_protocol.dart and the generated
  layers; link-check clean.
- [ ] DT-3 Guides truth: agent-assisted-development.md's working
  model covers total parity + Dart layers (absent-from-facade no
  longer means unsupported); troubleshooting.md names the v2
  handshake, leads with `flutter_vscode doctor`, and corrects the
  missing-API remedy. Check: every named error code and remedy
  matches the CLI at HEAD.
- [ ] DT-4 Agent surface truth: agent-guidelines/project-structure.md
  teaches the current CLI and layout (extensions/, skills/,
  lib/src/cli/); templates/consumer-agents.md mandates doctor/test;
  the four stale skills (build, test, troubleshoot, extension-host)
  teach the shipped surface; a new flutter-vscode-view skill covers
  ViewShell.connect, runFlutterView, the theme bridge, and host push
  events. Check: every command/API named in skills exists at HEAD.
- [ ] DT-5 ADR amendments: dated amendment notes on 0006 and 0012
  record the third mechanical layer and its totality ledger; 0012's
  note also corrects the release-gate claim (per-symbol reviewed
  classification survives at baseline import per ADR 0008 as amended;
  the no-rule block applies at layer generation); 0011 notes the
  missing-apiTarget fallback caveat. Check: original decision text
  untouched; notes dated.
- [ ] DT-6 Structure: docs/architecture/index.md becomes a true
  pointer to specs/architecture/ (its own narrative is superseded);
  a new docs/adr/index.md lists all twelve ADRs and is linked from
  docs/index.md; consumer-agents-v0.md is linked as the legacy
  variant. Structural moves land in their own commits, content edits
  separately. Check: link-check reports zero orphans among these
  pages.
- [ ] DT-7 Polish on touched pages: openers reach 40–80 words naming
  thing, audience, and place; motivation sentences and cross-links
  added; no reflow of untouched pages. Check: fresh-eyes review of
  changed pages; per-dimension deltas vs baseline.json in the run
  report.

Verification gate for the round: link-check clean; plan_truth_test,
repository_gate_test, the parity-report regeneration pin, and
`flutter analyze` green; the improve-docs report records per-POV
deltas against the baseline and the remaining distance to the bar.

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

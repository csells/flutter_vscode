# V0 Removal Plan

Status: In progress
Date: 2026-07-25

Deletes the legacy v0 pipeline, per the owner's directive: we build on
a branch and carry no legacy surface. The docs died in the docs-truth
round; this round deletes the code so reality matches the docs.

Rules (inherited): exit bar frozen; reds are commits; discoveries to
[`futures.md`](futures.md).

## Exit bar

- [ ] V0-1 The v0 pipeline is gone: `bin/generate_vscode_extension.dart`,
  the annotation/builder surface in `lib/` (annotations, builder,
  flutter_vscode, runtime, vscode, vscode_codegen_helpers,
  vscode_controller_base, vscode_generator, vscode_ts_generator,
  vscode_validation, vscode_webview_helper, webview_bridge*),
  `build.yaml`, `example/`, and `tool/legacy-agent-skills/` are
  deleted; pubspec drops the executable and every dependency only the
  v0 pipeline used (build, source_gen, build_runner, build_test —
  verified unused by v1 before dropping). Check: an absence gate in
  the repository suite; `flutter analyze` clean.
- [ ] V0-2 The test and gate surface follows its subject:
  generate_vscode_extension_test, vscode_controller_base_test,
  webview_bridge_test, and the tool/check_*_generator checks retire
  with the code they tested (none of their assertions guard v1
  behavior — verified before deletion); `scripts/test_all.sh` drops
  the build_runner smoke, generator checks, and example steps;
  repository_gate_test's legacy-label pins (example/README routing,
  PRD historical label, example main.dart label) retire with their
  subjects; PRD.md (the v0-era product document, already unlinked)
  is deleted. Check: full fast suite green; test_all.sh's remaining
  steps enumerated in the plan note.
- [ ] V0-3 Final bar: full fast suite + analyze green; the three
  real-host gates green at HEAD; `.pubignore`/receipts carry no dead
  entries; a repo-wide sweep finds zero references to the deleted
  surfaces outside archives and history.

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

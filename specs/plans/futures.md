# Futures

Deferred work and the discovery inbox: findings made during a frozen
round land here instead of growing that round's exit bar. Items graduate
into a named plan under `specs/plans/` with their own machine-checked
exit bar; nothing here blocks a round's closure or commits to a
sequence or schedule. Rough dependency order below.

## Product

- **Idiomatic Facade** over the Parity Layer: Dart-first ergonomics,
  Semantic Overrides, reviewed design — built up incrementally after the
  Parity Layer ships.
- **Behavioral verification burn-down**: real-host evidence for parity
  members, grouped by capability fixture (trees/filesystems,
  terminals/tasks, language features, testing, SCM, notebooks,
  authentication, debugging, webviews). The next burn-down instrument
  is member-level live accounting via generated observation hooks: the
  emitter tags each generated member so the live gate can record which
  members actually executed, turning the per-member `pending` rows in
  `docs/reference/parity.md` into mechanically observed dispositions
  (family-level and construct-class-level accounting shipped in the
  live-coverage round).
- Runtime semantics for the View protocol: cancellation, host-to-view
  requests, events/streams, handles, backpressure (protocol v1 today has
  none of these; disposal is session-level only). Graduated to
  [developer-experience.md](developer-experience.md) D-4.
- Product workflow: `doctor` and `test` graduated to
  [developer-experience.md](developer-experience.md) D-7; `upgrade`
  depends on multi-baseline support (D-8). Generated-file ownership and
  repair, plus v0 migration after real usage, remain here (the legacy
  `generate_vscode_extension` executable still ships with a legacy
  notice until then).
- Hardening: two extensions in one host, failure injection, protocol
  abuse, breakpoint/source-map behavior, startup/memory,
  Windows/macOS/Linux, remote-host harness.
- Platform reach: Web Extension Host before 1.0 (ADR 0009).
- Documentation from executable behavior; support policy last, from
  measurements.

- Parity leftovers: an alias-cycle guard in the emitter and a typed
  rest-param surface (rest params erase to `List<JSAny?>`). (Narrowing,
  string-literal wrappers, stable typedefs, per-family live probes, and
  the emitter unit suite shipped in the parity-runtime round.)
- The generated parity ledger and layer add ~530 KB to the pub archive;
  revisit placement if package size matters.

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
  a framework module — and the first shipped extension had to carry its
  own copy. Graduated to
  [developer-experience.md](developer-experience.md) D-1.
- A registered-shape hash is key-order sensitive (bounded: child
  cross-checks still bind content).
- The only Extension Host proof platform is Linux-in-Docker; every gate
  re-downloads VS Code.
- The only real extension so far ships in-repo under `extensions/`
  (Coverage Treemap); a framework-external extension still does not
  exist.

## Upstream contribution (owner's call)

When the owner decides to engage upstream, open a pull request from
`csells:project-hardening` to `SlowGen/flutter_vscode`. How that
contribution is validated is entirely SlowGen's choice; this project's
deliverable is a branch whose gates pass locally
(`scripts/test_all.sh`, `scripts/check_round5_exit.sh`).

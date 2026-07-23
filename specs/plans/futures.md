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

# Backlog

Discoveries made during a frozen hardening round land here instead of
growing that round's exit bar. Items graduate into a future plan with
their own machine checks; nothing in this file blocks a round's closure.

## From the fourth audit (out of Round 5 scope by design)

- Protocol v1 has no cancellation frame and only session-level disposal;
  host-to-view requests do not exist. First From-Proof milestone.
- Dynamic `call/get/set/construct/subscribe` access (the vision's second
  integration speed) does not exist yet.
- CLI lacks `test`, `upgrade`, and `doctor`; debugging has a generated
  launch configuration but no exercised F5/breakpoint path.
- The only Extension Host proof platform is Linux-in-Docker; macOS and
  Windows are unprobed, and every gate re-downloads VS Code.
- The walking slice's per-symbol economics are unproven at the scale of
  the 2,912 pending declarations.
- The ECMAScript whitespace predicate exists in two implementations held
  together by mirrored tests.
- The host-side view transport lives in the test fixture rather than as a
  framework module.
- A registered-shape hash is key-order sensitive, so a reordered-but-
  consistent shape document is accepted (bounded: child cross-checks still
  bind content).
- No real extension exists outside the repository fixtures.

## From the Round-5 owner amendment (2026-07-22)

- Upstream contribution: when the owner decides to engage upstream, open
  a pull request from `csells:project-hardening` to
  `SlowGen/flutter_vscode`. How that contribution is validated is
  entirely SlowGen's choice. This project's deliverable is a branch
  whose gates pass locally (`scripts/test_all.sh`,
  `scripts/check_round5_exit.sh`).

## Roadmap (relocated from the archived first-extension plan)

The archived plan's "From the Proof to the Vision" dependency order,
preserved as the sequencing narrative for future milestone plans:

1. Runtime semantics: events, cancellation, progress, streams, callback
   retention, ownership scopes, structured errors, session cleanup.
2. API factory: emit and verify the entire pinned stable API and
   contribution surface; explicit dynamic call/get/set/construct/
   subscribe access; then the Idiomatic Facade above it.
3. Capability fixtures: trees/filesystems, terminals/tasks, language
   features, testing, SCM, notebooks, authentication, debugging,
   webviews — Extension Host tests grouped by semantic pattern.
4. Product workflow: doctor, test, upgrade; generated-file ownership and
   repair; actionable diagnostics; v0 migration after real usage.
5. Hardening: two extensions in one host, failure injection, protocol
   abuse, breakpoint/source-map behavior, startup/memory,
   Windows/macOS/Linux, remote-host harness.
6. Platform reach: Web Extension Host before 1.0 (ADR 0009).
7. Documentation from executable behavior.
8. Support policy last, from measurements: version windows, upgrade
   guarantees, proposed-API experiments, performance budgets.

Still deferred from that plan: past-version support windows, v0.1
migration guarantees, remote/browser/multi-OS gates, Marketplace
publishing automation, full API classification, production
performance/security budgets.

## From the fifth audit (2026-07-22)

- The CLI (`bin/flutter_vscode.dart`, ~1,365 lines) and the generator
  (`tool/binding_generator/generator.dart`, ~5,973 lines) remain
  monoliths; the plan named their decomposition a maintainability
  follow-up.
- Webview CSP content is not gate-asserted: only `Webview.cspSource`
  usage is proven, so a silently weakened policy would pass.
- `scripts/check_round5_exit.sh` cannot itself verify the two
  consecutive `test_all.sh` runs its R5-13 item names; those remain
  procedural evidence.
- The R5-7 static check verifies absence of rsync rather than positively
  parsing the staging pipeline.
- The legacy `generate_vscode_extension` executable still ships to
  consumers; it now prints a legacy notice, and removal awaits the v0
  migration milestone (roadmap step 4).

# Futures

Deferred work and the discovery inbox: findings made during a frozen
round land here instead of growing that round's exit bar. Items graduate
into a named plan under `specs/plans/` with their own machine-checked
exit bar; nothing here blocks a round's closure or commits to a
sequence or schedule. Rough dependency order below.

## Product

- **Idiomatic helpers** over the Generated API Layer: per ADR 0013
  the reviewed, judgment-shaped surface grows as hand-written
  framework modules in the `FlutterViewHost`/`ViewShell` mold (with
  their own tests), not as a second generated facade; candidates
  graduate here as real extensions surface the need — a broader
  options-to-named-parameters surface remains the largest known one.
- **Behavioral verification burn-down**: real-host evidence for
  generated-layer members, grouped by capability fixture
  (trees/filesystems, terminals/tasks, language features, testing,
  SCM, notebooks, authentication, debugging, webviews). The old
  per-member binding-observation mechanism retired with the facade
  (single-layer round); a future member-level instrument would be
  designed fresh against the one artifact — until then the two-axis
  live coverage (API Family × Construct Class) is the measured floor.
- Runtime semantics for the View protocol: handles and backpressure
  (cancellation, host-to-view requests, and event streams shipped in
  the archived developer-experience round's D-4; disposal is now
  per-request).
- Product workflow: `upgrade` — now unblocked, since `doctor`/`test`
  and multi-baseline support both shipped in the archived
  developer-experience round. Generated-file ownership and repair
  remain here. The owner-directed v0-pipeline deletion (2026-07-25)
  left this inbox: the [v0-removal round](v0-removal.md) deleted the
  code, and `test/v0_removal_test.dart` keeps it deleted.
- Hardening: two extensions in one host, failure injection, protocol
  abuse, memory profiling, Windows/macOS/Linux, remote-host harness
  (breakpoint/source-map behavior and startup measurement shipped in
  the archived developer-experience round).
- Platform reach: Web Extension Host before 1.0 (ADR 0009).
- Documentation from executable behavior; support policy last, from
  measurements.

- Parity leftovers: an alias-cycle guard in the emitter and a typed
  rest-param surface (rest params erase to `List<JSAny?>`). (Narrowing,
  string-literal wrappers, stable typedefs, per-family live probes, and
  the emitter unit suite shipped in the parity-runtime round.)
- The one generated API artifact (~735 KB) ships in the pub archive;
  both totality ledgers are pubignored. Revisit placement if package
  size matters.

## Engineering debt (from the audits)

- `VSCodeViewBootstrap` memoizes a failed connect future, so a view
  retrying after a connect failure never actually reconnects;
  `ViewShell.connect` runs once before `runApp` today, which masks it.

- `generator.dart` (1,750 lines after the facade emission left with
  the single-layer round) keeps the entangled walking-slice band —
  selection model and override-classification validation; deepening
  it further is possible but unforced.
- The CSP served into a live webview is not parsed by any real-host
  gate; the policy itself is framework-owned and byte-asserted via the
  emitted view-host module template.
- `scripts/check_round5_exit.sh` cannot itself verify the two
  consecutive `test_all.sh` runs its R5-13 item names; those remain
  procedural evidence.
- The R5-7 static check verifies absence of rsync rather than positively
  parsing the staging pipeline.
- The ECMAScript whitespace predicate exists in two implementations held
  together by mirrored tests.
- A registered-shape hash is key-order sensitive (bounded: child
  cross-checks still bind content).
- The only committed Extension Host proof platform is Linux-in-Docker;
  most gates re-download VS Code each run (the coverage-extension gate
  accepts a persistent cache via FLUTTER_VSCODE_TEST_CACHE).
- The only real extension so far ships in-repo under `extensions/`
  (Coverage Treemap); a framework-external extension still does not
  exist.

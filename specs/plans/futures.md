# Futures

Deferred work and the discovery inbox: findings made during a frozen
round land here instead of growing that round's exit bar. Items graduate
into a named plan under `specs/plans/` with their own machine-checked
exit bar; nothing here blocks a round's closure or commits to a
sequence or schedule. Rough dependency order below.

## Product

- **Marketplace publishing** (owner's account required): publish
  Coverage Treemap under a real publisher ID — the single biggest
  visibility step available; bundle the release-prep items (`upgrade`,
  support policy, docs-from-executable-behavior) at the same
  milestone.
- **More real extensions**: the Dart-only sibling extension, then one
  outside the repository — the engine for idiomatic helpers,
  behavioral evidence, and protocol discoveries alike.

- **Idiomatic helpers** over the Generated API Layer: per ADR 0013
  the reviewed, judgment-shaped surface grows as hand-written
  framework modules in the `FlutterViewHost`/`ViewShell` mold (with
  their own tests), not as a second generated facade; candidates
  graduate here as real extensions surface the need — a broader
  options-to-named-parameters surface remains the largest known one.
- **Behavioral evidence grows through real extensions**: each new
  extension exercises more API families in real hosts; the two-axis
  live coverage (API Family × Construct Class) is the measured floor.
  No dedicated per-member instrument is planned — extensions produce
  better evidence than observation hooks did.
- Runtime semantics for the View protocol: handles and backpressure
  (cancellation, host-to-view requests, and event streams shipped in
  the archived developer-experience round's D-4; disposal is now
  per-request).
- The `create` scaffold's hello command still demonstrates raw
  `toHostCallback`; adopting the generated `ExtensionCommands` helper
  there (and in the README snippet that mirrors it) is a cheap DX
  follow-up from the authoring-dx round.
- Generated-file ownership and repair (doctor detects; repair is the
  follow-up). The v0-removal round deleted the legacy pipeline;
  `test/v0_removal_test.dart` keeps it deleted.
- Desktop platform proof: a macOS gate first (the breakpoint round
  already runs the harness headed on macOS), Windows next — every
  real user develops on desktop, and the live-only bugs found so far
  all surfaced there. Remote-host and multi-extension hardening
  remain backlog behind it.
- Platform reach: Web Extension Host before 1.0 (ADR 0009).

- Optional command-contribution fields in the typed manifest: the
  generator's projection still validates `category`, `enablement`,
  `shortTitle`, and `icon`, but `ExtensionCommand` carries only
  `command` and `title` — extend the type (and its parser mirror in
  `lib/src/cli/project_descriptor.dart`) when a real extension needs
  one of the optional fields.
- Views and configuration contributions in the typed manifest: the
  pubspec-lens round needed both — a tree view must be contributed
  before `registerTreeDataProvider` renders anywhere, and the
  configuration API rejects writes to unregistered keys. The
  contribution pipeline is schema-pinned (the inventory carries
  exactly the commands contribution schema), so this is a real
  binding-importer + generator + manifest-type round, not a field
  addition. Until it lands, the PL-4 gate's driver contributes
  `pubspecLens.registryUrl` and the `pubspecLens.dependencies` view
  on the extension's behalf.

## Engineering debt (from the audits)

- The CSP served into a live webview is not parsed by any real-host
  gate; the policy itself is framework-owned and byte-asserted via the
  emitted view-host module template.

- Gate cache unification: extend the coverage-extension gate's
  FLUTTER_VSCODE_TEST_CACHE support to every real-host gate so runs
  stop re-downloading VS Code — minutes saved per run, trivial
  change.

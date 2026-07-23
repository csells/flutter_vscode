# Parity Runtime Verification Plan

Status: In progress
Date: 2026-07-23

Graduates the parity follow-ups from `futures.md` per owner direction:
runtime proof lives in the real Extension Host (no fake-module harness —
fakes prove marshaling, not VS Code), the two helper families ADR 0012
originally promised ship for real, the emitter gains rule-level unit
tests, and "behavioral burn-down" is pinned to a machine-checked
definition: at least one live-executed representative per API family.

Rules (inherited): the exit bar is frozen; reds are commits; discoveries
go to [`futures.md`](futures.md).

## Exit bar

- [ ] V-1 Registered type literals get derived stable typedefs
  (deterministic name from the owning declaration path, e.g.
  `PositionWith$change`) so fixture and author code never references a
  shape-hash name. Check: emitter unit tests + parity suite.
- [ ] V-2 The promised helper families ship: every class `Ctor` type
  gains `isInstance`/`cast` narrowing built on the SDK's `instanceOf`
  against the module-rooted class function, and unions consisting only
  of string literals emit zero-cost typed wrappers (`static const` per
  literal; named aliases keep their alias name; generic positions keep
  erasure). ADR 0012's amendment note is superseded accordingly. Check:
  emitter unit tests, parity suite, and a live narrowing probe in V-4.
- [ ] V-3 A table-driven emitter unit suite exercises every Total
  Mapping Rule and every totality throw site through the public
  `emitParityLayer` with minimal synthetic IRs — rule-level failure
  localization the byte-compare cannot give. Check:
  `flutter test test/parity_emitter_unit_test.dart`.
- [ ] V-4 Per-family live execution: the real-host parity smoke
  exercises at least one representative member of EVERY namespace family
  in the pinned API plus the core value-class families (default-ctor
  construction via `CancellationTokenSource`/`EventEmitter` round-trips,
  a `WorkspaceEdit` applied to a real document, clipboard round-trip,
  output channel, provider/controller registrations disposed). A
  repository test derives the required family list from the IR's
  namespaces so a future API family cannot be silently skipped. Check:
  `./scripts/test_host_extension.sh` green with the family assertions;
  the completeness test in the parity suite.
- [ ] V-5 The burn-down definition is recorded: `docs/reference/parity.md`
  states that family-level live coverage is measured by the smoke and
  member-level evidence by the capability fixtures; futures.md drops the
  graduated items. Check: report regeneration test.

## TDD Ledger

Tallies are values at recording time; the executing suites are the
current authority. Entries appended as items close; reds are commits.

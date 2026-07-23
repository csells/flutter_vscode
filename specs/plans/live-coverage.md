# Construct-Class Live Coverage Plan

Status: In progress
Date: 2026-07-23

Per the domain language, live coverage has two axes: API Families
(wiring/reachability — floor of one, already enforced) and Construct
Classes (do the mappings work against real objects). This plan fills the
empty construct-class rows and makes both axes machine-derived.

## Exit bar

- [ ] C-1 The canonical Construct Class list is code
  (`parityConstructClasses` in the emitter library) with an explicit
  live-exemption map (each exemption naming its reason, e.g. zero sites
  in the pinned baseline). Check: the two-axis completeness test.
- [ ] C-2 Every Construct Class has an emitter unit case, including the
  previously missing intersection, call-signature, and external-setter
  cases. Check: completeness assertion over the unit suite source.
- [ ] C-3 Every non-exempt Construct Class has a tagged live probe
  (`cc:<class>`) in the real-host smoke, including the new rows: tuples
  via `workspace.fs.readDirectory(extensionUri)`, the
  Memento-intersection via `context.globalState`
  (setKeysForSync/update/get), an external setter via
  `createQuickPick().value`, index operators against real
  `workspace.getConfiguration()`, real-union narrowing via
  `tabGroups...activeTab.input` and `TabInputText.isInstance`, and
  reverse-direction callback arguments via `withProgress` with a `lit$`
  progress report. Check: `./scripts/test_host_extension.sh` green with
  the new assertions; two-axis completeness test.
- [ ] C-4 `docs/reference/parity.md` states the two-axis definition with
  both lists machine-derived (families from the IR, classes from the
  emitter constant); member-level live accounting via generated
  observation hooks is recorded in futures as the next burn-down
  instrument. Check: report regeneration test.

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

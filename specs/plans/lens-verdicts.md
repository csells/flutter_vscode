# Lens Verdicts Plan

Status: Open
Date: 2026-07-27

Pubspec Lens only speaks when a constraint *excludes* the latest
release. Because caret constraints admit every minor and patch below
the next major, the extension stays silent on the common case: a
pinned lower bound that trails what pub.dev publishes. In the owner's
live session four of five dependencies (`path ^1.8.0` vs 1.9.1,
`http ^1.5.0` vs 1.6.0, `test ^1.24.0` vs 1.31.2) were silently
"current", and the one flagged dependency was the lone major bump.
That reads as a broken lens, not a conservative one.

This round makes a trailing lower bound its own verdict, so the lens
offers the bump while the Problems panel keeps meaning "this
constraint blocks the latest release".

Rules (inherited): exit bar frozen; reds are commits; no legacy or
compatibility surface — the branch is the product; discoveries to
[`futures.md`](futures.md).

## Decisions

- **Two signals, not one.** `outdated` (the constraint excludes the
  latest — nothing will resolve to it) keeps the diagnostic *and* the
  lens. `behind` (the constraint admits the latest but the pinned
  lower bound trails it) gets the lens only. Squiggles stay reserved
  for constraints that actually block.
- **Never suggest a downgrade.** A constraint whose lower bound sits
  at or above the latest published version has nothing to suggest and
  is `current` — including the ahead-of-registry case (`^2.0.0` while
  the registry says 1.6.0), which the old rule called `outdated` and
  offered to "fix" by rewriting the pin *backwards*.
- **The lower bound is the comparison point**, read structurally from
  `pub_semver` (`VersionRange.min`, `VersionUnion.ranges.first.min`;
  `Version` is its own `min`), not by re-parsing constraint text.
- A constraint with no lower bound (`any`, or a bare `name:`) is
  `behind` with a `^latest` suggestion; the host's existing
  constraint-span guard means no lens renders for a bare entry, since
  there is no written constraint to replace.

## Exit bar

- [ ] LV-1 Verdict semantics: `VerdictKind` gains `behind`;
  `verdictFor` compares the constraint's lower bound against the
  registry's latest and never suggests a downgrade. Check: a red
  shared-model suite over the new kinds — the trailing caret
  (`^3.1.0` vs 3.1.3), the blocking pin, the exact-latest pin, the
  ahead-of-registry pin, and the bare/`any` entry — with the existing
  unknown/skipped cases green and unmodified.
- [ ] LV-2 Host surfaces: hover, tree labels, and the smoke report
  carry `behind` (the enum's exhaustive switches force each site);
  diagnostics stay `outdated`-only and the CodeLens follows
  `suggestedConstraint`, so both actionable verdicts get a lens.
  Check: the extension builds and packages; `flutter analyze` clean.
- [ ] LV-3 Real-host proof: the gate's workspace grows a pin that is
  exactly current (silent) alongside the trailing and blocking pins;
  the driver asserts two lenses (selected by package, not by
  position), exactly one diagnostic, the silent pin's absence from
  both, and applies the *trailing* lens to prove the bump lands.
  Check: `scripts/test_pubspec_lens.sh` exits 0.
- [ ] LV-4 Final bar: docs state the two-tier rule; full fast suite
  and `flutter analyze` green; the pubspec-lens gate green at HEAD.

## TDD Ledger

Tallies are recording-time values. Entries appended as items close.

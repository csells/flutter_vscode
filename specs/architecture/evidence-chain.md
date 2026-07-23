# Evidence Chain

Five hardening rounds taught one structural lesson: claims recorded as
prose rot; claims enforced by machines survive. Everything here exists to
keep "verified" meaning something.

## Receipts and the durable Host Contract

`tool/bindings/contracts/checkpoint4-extension-host.json` attests the
real-host evidence run: API and runtime targets, 44 source receipts
(exact SHA-256 of every load-bearing file — generator, writer, CLI,
fixtures, lockfiles, the verifier, its test, and the contract writer
itself), and the attributed binding IDs. It is written only by the
mechanical regenerator (`tool/binding_generator/contract.dart`, invoked
as `generate.dart --contract .`); hand-editing evidence is not a
supported workflow. `test/binding_evidence_test.dart` proves the
checked-in artifact byte-equals regeneration and that the overrides pin
matches its bytes; the real-host launcher verifies all receipts before
VS Code starts and again before accepting evidence
(`tool/extension_host_test/run.cjs`, `host_contract.cjs`). Observed
binding IDs must exactly match the attributed set — recorded only by
generated operations after native success.

## Gate hierarchy

1. Focused suites (`flutter test`, importer `npm test`, Node harness
   tests) — including `test/plan_truth_test.dart` (prose-truth ratchet)
   and `test/repository_gate_test.dart` (CI-definition pins, generated
   convergence, lockfile-in-HEAD, legacy-surface labeling, cache
   freshness).
2. `./scripts/test_host_extension.sh` — the pinned real Extension Host in
   Docker, receipt-verified, with adversarial webview probes.
3. `./scripts/test_packaged_extension.sh` — installed-VSIX proof for both
   fixtures, staged from `dart pub`'s own archive listing
   (`tool/pub_archive_list.dart`), hover-first lazy activation asserted.
4. `./scripts/test_all.sh` — everything above plus build_runner, builder
   checks, and example tests.
5. `./scripts/check_round5_exit.sh` — the closure authority: evaluates
   the archived plan's exit bar, including executing the packaged gate
   and the regenerator no-op check.

## Methodology (inherited, binding on future rounds)

- **Frozen exit bars.** A hardening round freezes its machine-checkable
  exit bar before work starts; discoveries go to
  `specs/plans/futures.md`, never into the running bar. Only the round's
  script may declare it done. Owners may amend a bar; amendments are
  recorded visibly with what was lost.
- **Reds are commits.** Failing tests are committed before their fixes so
  chronology is `git log`, not narrative. Where a red is inexpressible
  in-repo, the ledger says exactly that.
- **Prose truth.** Documents may not carry present-tense claims a machine
  cannot vouch for. `test/plan_truth_test.dart` enforces digest truth and
  self-consistency for the archived plan and pins its bytes: the archive
  is frozen history, so any edit fails the ratchet deliberately.
- **Status validity.** A completion claim holds only while its named
  check script exits 0 at HEAD.

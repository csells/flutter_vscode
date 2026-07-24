# Binding Pipeline

Public VS Code bindings are generated mechanically from pinned official
inputs plus reviewed Semantic Overrides. No LLM, probabilistic mapping,
silent omission, or guessed `dynamic` types participate; anything the
pipeline cannot express fails closed.

## Stages

1. **Pins** — `tool/bindings/inputs/vscode/<version>/pins.json` pins six
   official inputs (`vscode.d.ts`, manifest schema/validator sources, the
   `commands` contribution schema source, transitive helper, license)
   with exact product version, commit, canonical source URL, checksum,
   and license. The manifest has one exact producer schema; input paths
   must resolve (realpath) inside the pin directory
   (`tool/binding_importer/src/pins.cjs`, `test/pins.test.cjs`).
2. **Importer** — `tool/binding_importer` (maintainer-only, pinned
   TypeScript parser) normalizes the pinned sources into canonical IR at
   `tool/bindings/ir/vscode-<version>.json`. The IR is lossless for every
   supported declaration shape — generic scopes alpha-normalized,
   visibility propagated, member order preserved via stored canonical
   type-literal shapes — and inexpressible syntax is rejected, never
   erased (`tool/binding_importer/test/inventory.test.cjs`).
3. **Overrides** — `tool/bindings/overrides/vscode-<version>.json` holds
   reviewed classifications (`entries` with strategies and declaration
   fingerprints, `targets`, Host Contract pins). Baseline updates fail
   closed: new, shape-changed, or removed public symbols require reviewed
   classification (`src/baseline*.cjs`, seed-validated by
   `npm run check:baseline-series`); ADR 0008 blocks releases on
   unclassified public symbols.
4. **Generator** — `tool/binding_generator/generator.dart` consumes IR +
   overrides and accepts only IR the producer could emit: it recomputes
   identities and hashes (including every registered type-literal shape
   hash, cross-validated member-by-member against child declarations),
   preserves graph relationships, correlates raw and canonical fields,
   and rejects impossible combinations. The walking slice is derived
   entirely from IR + override strategies — no shadow name/count profile
   in generator source (`test/binding_generator_test.dart`).
5. **Outputs** — walking-slice parity/runtime/facade, bootstrap,
   manifest, and coverage ledger into the extension project;
   byte-identical on regeneration
   (`test/binding_generator_cli_test.dart`).
6. **Complete Parity Layer** — `tool/binding_generator/parity_layer.dart`
   (`generate.dart --parity-layer .`) emits the total typed mapping of
   every public declaration (ADR 0012) as
   `lib/src/generated/vscode_parity_layer.g.dart`, with a totality
   ledger covering all IR declarations; `flutter_vscode build` emits the
   same layer into every Extension Project, and the real-host gate
   executes it (`test/parity_layer_test.dart`, the fixture parity
   smoke). Constructs without a Total Mapping Rule fail generation.

## Regeneration commands

Run from the repository root, in this order when in doubt:

```sh
# IR from pinned inputs (maintainer, after pin/importer changes):
(cd tool/binding_importer && node src/cli.cjs \
  --pins ../bindings/inputs/vscode/1.129.1/pins.json \
  --output ../bindings/ir/vscode-1.129.1.json)

# Walking slice + coverage into the fixture:
dart tool/binding_generator/generate.dart \
  --inventory tool/bindings/ir/vscode-1.129.1.json \
  --overrides tool/bindings/overrides/vscode-1.129.1.json \
  --project test/fixtures/host_extension/extension.json \
  --output-root test/fixtures/host_extension

# CLI-owned fixture artifacts (view protocol copy, bundle):
bash scripts/build_host_fixture.sh

# Durable Host Contract artifact + overrides pin (after any receipted
# source changes):
dart tool/binding_generator/generate.dart --contract .

# Generated parity report (after coverage changes):
dart tool/binding_generator/generate.dart --parity .
```

If gates complain about stale generated artifacts, the failing test names
which command to run; the checked-in files and their pins are always the
current authority, never prose.

## Coverage honesty

`coverage.json` and `docs/reference/parity.md` distinguish emitted,
reviewed-excluded, non-public, and pending symbols. Live coverage is
measured on two machine-derived axes, generated into the parity
report: the API Family axis is derived from the pinned IR (at least
one representative of every namespace family executes against live
VS Code), and the Construct Class axis from the emitter's canonical
constant (every Total Mapping Rule construct class carries a
`cc:`-tagged live probe unless it has a recorded live exemption with
its reason). Runtime evidence is one aggregate real-host contract with
mechanically attributed binding IDs — not independent behavioral
contracts — and the docs say so. A missing Dart path for a public
capability is a defect (vision rule, stated in the parity report).

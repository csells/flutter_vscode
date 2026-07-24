# Onboarding a New VS Code Baseline

How a maintainer adds a pinned VS Code release beside the existing
baselines. Checked-in baselines form an immutable, numerically ordered
series seeded at 1.129.1 (ADR 0008): a new release is *added*, never a
replacement, and earlier baselines stay supported. This procedure is
the one used to onboard 1.130.0.

Machine checks back every step: `test/cli_multi_baseline_test.dart`
proves the structural invariants and that a scaffolded project builds
against each pinned baseline, and `./scripts/test_binding_importer.sh`
runs the importer suite plus the whole-series validation in the pinned
Node container.

## 1. Choose the release and resolve its commit

Pick an exact stable version newer than the newest checked-in baseline
and resolve its tag commit:

```sh
curl -s https://api.github.com/repos/microsoft/vscode/git/ref/tags/<version>
```

The `object.sha` of the tag is the pin commit for every input.

## 2. Fetch and pin the six official inputs

Create `tool/bindings/inputs/vscode/<version>/` and fetch each input
from `https://raw.githubusercontent.com/microsoft/vscode/<commit>/...`
at the canonical repository paths (`tool/binding_importer/src/pins.cjs`
holds the kind-to-path map and rejects any other source URL):

- `vscode.d.ts` — `src/vscode-dts/vscode.d.ts`
- `extension-manifest-schema.ts` —
  `src/vs/workbench/services/extensions/common/extensionsRegistry.ts`
- `extension-validator.ts` —
  `src/vs/platform/extensions/common/extensionValidator.ts`
- `menusExtensionPoint.ts` —
  `src/vs/workbench/services/actions/common/menusExtensionPoint.ts`
- `strings.ts` — `src/vs/base/common/strings.ts`
- `LICENSE.txt` — `LICENSE.txt`

Copy the previous baseline's `pins.json` beside them and update the
product version, the commit, every source URL, and every `sha256`
(`shasum -a 256 <file>`). The `parser.version` must equal the
TypeScript version pinned in `tool/binding_importer/package.json`; the
importer refuses a mismatch.

## 3. Import the canonical IR

```sh
cd tool/binding_importer
npm ci
node src/cli.cjs \
  --pins ../bindings/inputs/vscode/<version>/pins.json \
  --output ../bindings/ir/vscode-<version>.json
```

The importer verifies every pinned checksum before parsing and fails
closed on inexpressible syntax. The output lands at
`tool/bindings/ir/vscode-<version>.json`.

## 4. Review the delta into Semantic Overrides

Author `tool/bindings/overrides/vscode-<version>.json`. Start from the
previous baseline's file with `vscodeVersion` advanced; the root
evidence hashes only change when the manifest schema, validator, or
contribution schema inputs changed. Then classify the API delta —
the series validation rejects every new, shape-changed, or removed
public symbol that lacks a reviewed entry with the candidate
declaration's current fingerprint (removals need strategy
`reviewedRemoval` plus a reason).

For 1.130.0 the entire delta was source metadata: `vscode.d.ts` and
the schema/validator inputs were byte-identical to 1.129.1 and only
`strings.ts` changed outside the extracted validation projection, so
the seed's reviewed classifications carried over unchanged.

A larger delta can also surface a construct the Complete Parity Layer
has no Total Mapping Rule for; generation then fails with a
`ParityGenerationException` naming the declaration. Add a total,
judgment-free rule with emitter unit cases (ADR 0012,
`specs/research/js-to-dart-mapping.md`) — never a special case for one
symbol.

## 5. Validate the series

```sh
cd tool/binding_importer
npm run check:baseline-series
```

This validates the seed and every adjacent baseline pair, and rejects
orphaned IR or override files. CI reaches the same validation through
`./scripts/test_binding_importer.sh` (Docker, pinned Node).

If the round touched any file receipted by the durable Host Contract
(the CLI, generator, or fixture sources), regenerate the contract —
it repins `artifactSha256` into every checked-in override file:

```sh
dart tool/binding_generator/generate.dart --contract .
```

## 6. Prove selection end to end

`flutter_vscode build` selects binding inputs by the project
descriptor's `apiTarget` and enumerates the pinned baselines in its
unknown-target error. Run the multi-baseline suite, which builds a
scaffolded project against every pinned baseline:

```sh
flutter test test/cli_multi_baseline_test.dart
```

## Related

- [Binding pipeline](../../specs/architecture/binding-pipeline.md)
- [ADR 0008: block releases on unclassified API symbols](../adr/0008-block-releases-on-unclassified-api-symbols.md)
- [ADR 0012: generate the complete parity layer with total mapping rules](../adr/0012-generate-the-complete-parity-layer-with-total-mapping-rules.md)

- One generated API artifact (ADR 0013): `vscode_dart.dart` carries
  the Parity Layer substrate and Dart-ergonomics surface; the
  walking-slice facade and binding-observation mechanism retire,
  substrate totality intact; judgment lives in framework
  modules (`FlutterViewHost`, `ViewShell`).

## Unreleased

- Support plural pinned VS Code baselines: 1.130.0 ships beside the
  1.129.1 seed, the project descriptor's `apiTarget` selects among
  them, an unknown target fails with an error naming every pinned
  target, and `docs/guides/new-baseline.md` documents onboarding a
  new release.
- Add the Dart-owned `flutter_vscode create`, `build`, and `package` workflow.
- Generate a reviewed VS Code 1.129.1 host-binding slice from pinned inputs.
- Pin and project transitive contribution validators with exact JavaScript trim
  semantics.
- Add an optional typed Flutter View protocol with strict session cleanup.
- Verify source and installed VSIX extensions in a pinned real Extension Host.
- Map synchronous and asynchronous Host Dart failures back to exact Dart source
  frames and roll back partial activation registrations.
- Enforce fingerprinted VS Code baseline updates and executable binding evidence.
- Harden scaffolding and packaging with hover-first activation, pre-build
  analysis, XML validation, and framework/generator/input-bound build receipts.
- Exercise adversarial Flutter View frames, reload with pending work, measured
  shutdown counts, and an independent render observation in a real webview.
- Store canonical type-literal shapes in the pinned IR and recompute every
  registered shape hash on the Dart side, closing lossless-IR and
  opaque-hash gaps.
- Regenerate the durable Host Contract evidence artifact mechanically
  (`generate.dart --contract`); hand-edited evidence is no longer a
  supported workflow, and pin-manifest inputs must resolve inside their
  manifest directory.
- Publish a generated VS Code API parity burn-down
  (`docs/reference/parity.md`) treating missing Dart paths for public
  capabilities as defects.
- Label all legacy v0 webview/TypeScript surfaces (PRD, example, API
  mapping) as historical and remove the dead `bin/init.dart` scaffolder.
- Run analysis, the full gate, the publish dry run, and a cleanliness
  check in CI on pull requests.
- Ship the complete typed Parity Layer
  (`package:flutter_vscode/vscode_parity.dart`): a mechanically
  generated typed mapping of the entire pinned VS Code API (2,982
  declarations) produced only by Total Mapping Rules, rooted in the
  activation module object, with object-literal factories, module-rooted
  constructors, typed tuples, and a totality ledger; `build` emits it
  into every Extension Project and the real-host gate exercises it.
- Ship the mechanical Dart-ergonomics layer over the Parity Layer
  (`package:flutter_vscode/vscode_dart.dart`): a second generated,
  total, judgment-free rule set — ordinary `String`/`num`/`bool` at
  helper boundaries, `Future` from `JSPromise`, broadcast
  `onDidXStream` accessors beside `Event` members, `lit$` factories
  that include inherited interface members, and alias-named literal
  wrappers — entered with `VscodeApi(rawVscode).dart`, accounted for by
  a full totality ledger, and emitted by `build` into every Extension
  Project beside the parity layer.

## 0.1.0

- Add annotation-driven Dart and TypeScript generation for `@VSCodeController` and `@VSCodeCommand`.
- Add runtime bridge APIs for request/response communication between Flutter webview and VS Code host.
- Add scaffold CLI (`generate_vscode_extension`) with idempotent create-or-skip behavior for user-owned files.
- Add PRD traceability and message contract reference docs.
- Expand tests for runtime request lifecycle and scaffold idempotence.

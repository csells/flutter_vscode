# First Working Extension Plan

Status: Implemented and verified
Date: 2026-07-20

## Execution Evidence

- Checkpoint 1 passes in VS Code 1.129.1 with Dart-owned activation, command,
  hover provider, event unsubscribe, native identity, promise/error bridging,
  activation-failure cleanup, and repeated teardown.
- Checkpoint 2 deterministically imports pinned official sources and transitive
  validators into canonical IR. The ledger records 2,979 discovered entries:
  53 emitted and host-verified, 17 reviewed exclusions, and 2,909 pending. It
  makes no full-parity claim.
- Checkpoint 3 creates, builds, packages, installs, auto-activates, and exercises
  a host-only extension without author-managed Node or npm.
- Checkpoint 4 packages a real Flutter View with a typed, allowlisted v1
  protocol; the Host and View report zero live requests/subscriptions at close.
- Final gates: `scripts/test_all.sh` passes 112 Dart/Flutter tests, 33 importer
  tests, deterministic generation/build checks, real Extension Host tests, and
  two clean installed-VSIX tests. `flutter analyze` reports no issues.

## Goal and Stop Rule

Make one VS Code extension work end to end with its host behavior written in
Dart. Prove activation, a command, a provider callback, an event, native VS Code
values, and cleanup in one pinned local Extension Host. Then mechanize that
exact path and package it once.

Do not design a multi-version support policy before the first checkpoint is
green. The first proof targets one stable VS Code API release, one matching VS
Code test build, and one local Node Extension Host. It makes no compatibility
promise beyond that combination.

This plan is the shortest executable path from the current implementation to
the [project vision](../vision/vision.md). Broader API parity, host matrices, and
support guarantees follow the working system rather than precede it.

## Current Gap

Consumer Dart currently runs only inside a Flutter webview. Editable TypeScript
owns activation and command registration, and an unversioned JSON bridge
supports only request/response calls. It cannot preserve live object identity
or naturally express host events, provider callbacks, cancellation, and
disposal. Scaffolding also asks Extension Authors to run npm and copy generated
files, while CI never launches the assembled extension.

Keep that v0 path working while building the new host path beside it. Do not
grow the webview bridge into the host runtime: provider callbacks and activation
must work when no view exists.

## Architecture Constraints

- Compile a pure-Dart host entrypoint with `dart compile js` and load it
  in-process in VS Code's Node Extension Host.
- Generate a small CommonJS bootstrap that imports `vscode`, installs any
  required runtime shim, loads the Dart bundle, and forwards `activate` and
  `deactivate`.
- Use `dart:js_interop` directly inside host Dart. VS Code classes such as
  `Uri`, `Position`, `Range`, `MarkdownString`, and `Hover` remain native JS
  objects with their prototypes and identity intact. Dart-friendly builders may
  lower to those objects; they are not JSON copies.
- Keep each optional Flutter View in its own runtime. Only bidirectional
  communication between Host Dart and a Flutter View crosses a versioned
  protocol; view DTOs are snapshots, not host objects.
- Generate public bindings mechanically from pinned official inputs plus
  reviewed Semantic Overrides. No LLM, probabilistic mapping, silent omission,
  or guessed `dynamic` types participate in generation.
- Require no author-managed Node or npm. Maintainer tooling and CI may use
  pinned Node packages without adding them to the Author Toolchain.
- Namespace exported globals by extension ID and enforce that host/shared Dart
  cannot import Flutter, browser-only libraries, or unsupported platform APIs.

The vision's “all Dart-to-host interactions share one versioned protocol” line
must become “all cross-runtime interactions share one versioned protocol.”
Direct host interop is the mechanism that preserves VS Code object semantics.

## Checkpoint 1: One Local Walking Skeleton

Create `test/fixtures/host_extension/` by hand as an internal fixture. It needs
only:

- `host/lib/extension.dart`;
- a framework-owned bootstrap;
- the smallest framework-owned `package.json` that VS Code can load;
- an isolated private interop kernel for the few APIs under test; and
- an Extension Host test entrypoint.

The private kernel is disposable proof code, not a public API. Checkpoint 2
must replace and delete it. This prevents a handwritten shadow binding layer
from becoming permanent while allowing the execution topology to be tested
before building the generator.

The repository test performs this chain:

```text
compile host Dart -> assemble extension-development folder ->
launch one pinned VS Code build -> activate -> exercise -> shut down
```

Use the real Extension Host boundary and assert:

1. `extensions.getExtension(id).activate()` resolves before any webview opens.
2. `commands.executeCommand` invokes Dart and returns an exact Dart-produced
   value.
3. Opening a real document and invoking `vscode.executeHoverProvider` reaches a
   Dart callback with `TextDocument`, `Position`, and `CancellationToken`, then
   returns the expected native `Hover`, `MarkdownString`, and optional `Range`.
4. A real workspace or window event reaches Dart once; after unsubscribe, a
   second trigger is not delivered.
5. Repeated observations of the same document preserve JS object identity.
6. JS promises become Dart futures, Dart futures become JS thenables, and
   synchronous throws, rejected promises, and activation failure retain useful
   messages and Dart stack frames.
7. Registrations owned by `ExtensionContext.subscriptions` are left to VS Code;
   Dart-owned resources use idempotent cleanup. Bootstrap tests cover partial
   activation and repeated teardown without double disposal.

Write the failing tests first, but land the harness and minimum implementation
together with default CI green. The throwaway Node experiment established that
Dart-compiled JavaScript can call injected JavaScript, export a callback, and
bridge a future; this checkpoint must prove those mechanics inside VS Code.

Exit gate: one local, pinned Extension Host activates Dart, executes the command
and hover provider, delivers and unsubscribes the event, and shuts down cleanly.
No Flutter View, CLI suite, VSIX, remote host, or OS matrix blocks this gate.

## Checkpoint 2: Mechanize the Proven Slice

Pin these upstream inputs with version, source URL, commit, checksum, and
license metadata:

- stable `vscode.d.ts`;
- the extension manifest schema; and
- contribution-point schemas used to validate generated `package.json`.

Build a deterministic pipeline:

1. A maintainer-only importer uses the pinned TypeScript compiler parser to
   normalize `vscode.d.ts` into a language-neutral API IR.
2. The inventory assigns stable IDs to namespaces, members, type members,
   overloads, call signatures, deprecations, and exclusions.
3. Each entry records separate states such as discovered, semantics-reviewed,
   binding-emitted, and host-verified. Unreviewed entries stay visible; they do
   not masquerade as parity.
4. A Dart generator consumes the IR and versioned Semantic Overrides to emit
   the Parity Layer, native JS interop declarations, an initial Idiomatic
   Facade, and the coverage ledger.
5. CI regenerates twice and byte-compares generated source and metadata. New or
   ambiguous symbols fail closed until a general rule or reviewed override
   classifies them.

Generate only the transitive API slice exercised by Checkpoint 1, but inventory
the entire pinned file. The implemented closure must be fully reviewed,
non-`dynamic`, and host-verified. Do not claim full API parity while other
entries remain unreviewed.

Replace the fixture's private interop kernel and handwritten manifest fields
with generated output. Re-run every Checkpoint 1 assertion unchanged.

Exit gate: the same local extension works solely through mechanically generated
bindings and manifest data, regeneration is deterministic, and the temporary
kernel is gone.

## Checkpoint 3: Package One Dart-Owned Extension

Add only the CLI surface needed to create the first distributable:

```sh
dart pub global activate flutter_vscode
flutter_vscode create my_extension
flutter_vscode build
flutter_vscode package
```

During repository development, tests activate the package from its local path.
`create` emits an explicit `host/`, `views/`, and `shared/` layout; a Host-Only
Extension simply has no `views/`. Extension metadata and the command/provider
contributions are Dart-owned. The build generates `package.json`, the bootstrap,
launch configuration, host bundle, and source maps as Framework-Managed
Artifacts.

`build` enforces the host dependency boundary and reports errors in Dart terms.
`package` assembles and validates one installable VSIX without requiring an
author to invoke npm. Repository CI may use `@vscode/test-electron`; author-side
testing will later launch the installed `code` binary with a managed test
entrypoint rather than expose Node tooling.

Test the workflow from a clean temporary directory. Assert that consumer-owned
files contain no `.js`, `.ts`, or hand-maintained `package.json`, generated
content matches regeneration, the VSIX installs, and the installed extension
passes the command and hover checks on the one pinned local VS Code build.

Exit gate: a Flutter/Dart developer can create, build, install, and run this one
host-only extension without npm, TypeScript, or manual file copying.

## Checkpoint 4: Add One Optional Flutter View

Only after host-only activation works, add a Flutter View to the fixture. Start
protocol v1 with the minimum real boundary:

- versioned session and nonce handshake;
- calls, results, and structured errors;
- schema validation and operation allowlisting;
- close/reload cleanup for pending calls; and
- CSP, private `acquireVsCodeApi` handling, and webview-safe asset URLs.

The Dart-authored command opens the view. The view reports ready, makes one
typed call to Host Dart, renders the returned value, and closes with instrumented
pending-request and subscription counts at zero. Host commands and providers
must continue working when the view was never opened or has been closed.

Events, cancellation, streams, handles, backpressure, and the full negative
protocol matrix are subsequent hardening work, not prerequisites for the first
round-trip.

Exit gate: one packaged extension proves both execution boundaries without
moving provider logic into the webview.

## From the Proof to the Vision

After the four checkpoints are green, continue in dependency order:

1. **Runtime semantics:** finish events, cancellation, progress, streams,
   callback retention, ownership scopes, structured errors, and session cleanup.
2. **API factory:** emit and verify the entire pinned stable API and contribution
   surface. Add explicit dynamic `call/get/set/construct/subscribe` access over
   the same host interop semantics, then layer the Idiomatic Facade above it.
3. **Capability fixtures:** cover trees/filesystems, terminals/tasks, language
   features, testing, SCM, notebooks, authentication, debugging, and webviews
   with Extension Host tests grouped by semantic pattern.
4. **Product workflow:** add `doctor`, `test`, and `upgrade`; generated-file
   ownership and repair; actionable diagnostics; and migration from the v0
   scaffold after actual downstream usage is known.
5. **Hardening:** test two generated extensions in one host, failure injection,
   protocol abuse, Dart breakpoint/source-map behavior, startup/memory behavior,
   Windows/macOS/Linux, and a concrete remote-host harness.
6. **Platform reach:** add the Web Extension Host before 1.0 without weakening
   the Node-host path.
7. **Documentation:** update examples, README, architecture, quickstart,
   troubleshooting, API mapping, templates, and agent skills from executable
   behavior.
8. **Support policy:** only now define version windows, upgrade guarantees,
   proposed-API experiments, performance budgets, and release support from
   measurements of the working system.

Full parity means the pinned stable baseline has no unimplemented or
unclassified public symbols and every semantic category has an executable host
test. Updating VS Code then becomes a pinned-input update, IR diff, reviewed
Semantic Overrides, deterministic regeneration, and regression tests—not an
inference exercise.

## Deferred Until the Walking Skeleton Works

- past-version support and compatibility windows;
- v0.1 migration guarantees;
- remote, browser, and multi-OS gates;
- a complete CLI and Marketplace publishing automation;
- full API classification and contribution coverage;
- production performance and security budgets.

The accepted [architecture decisions](../../docs/adr/) remain direction, but
none of these deferred policies may delay Checkpoint 1.

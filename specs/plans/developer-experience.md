# Developer Experience Plan

Status: In progress — the D-1 round is open; D-2..D-10 remain proposed
Date: 2026-07-23

Captures the framework-compelling/dev-friendly direction agreed with
the owner, plus the gaps that building the first real extension
(Coverage Treemap) surfaced within hours of real usage. Each item
graduates here from [`futures.md`](futures.md) or from a build
discovery; when a round opens, its items freeze into that round's exit
bar with the usual rules (reds are commits, machine-checked closure).

## D-1 One-call Flutter View hosting

The single biggest authoring gap: opening a view today takes ~80
author-owned lines (panel + hand-copied webview transport + session +
hand-rolled CSP HTML). Graduate the host-side webview transport out of
the test fixture into the framework and ship a `FlutterViewHost`-style
API: one call takes a view name and operation bindings, and owns panel
creation, resource roots, session identifiers, CSP-correct HTML, and
disposal. Coverage Treemap's `host_webview_transport.dart` +
`_viewHtml` are the reference implementation to delete. The view side
gets a matching `runFlutterView(app)` boot helper that disables the
web URL strategy before `runApp` (discovered shipping Coverage
Treemap: `MaterialApp`'s history integration throws a cross-origin
`SecurityError` in webviews and the engine never renders a frame) and
connects the session.
Check: the extension and the host fixture both consume the framework
module; the copies are gone.

D-1 round exit bar:

- [ ] D-1a `build` emits `host/lib/generated/flutter_view_host.g.dart`
  (transport + `FlutterViewHost.open` + CSP HTML) for view-bearing
  projects only, byte-equal to the framework template. Check:
  cli_build_test.
- [ ] D-1b The host fixture consumes the emitted module; its local
  transport copy is deleted. Check: `./scripts/test_host_extension.sh`.
- [ ] D-1c Coverage Treemap consumes `FlutterViewHost.open`; its
  transport and HTML copies are deleted. Check:
  `./scripts/test_coverage_extension.sh`.
- [ ] D-1d `runFlutterView(app)` ships in
  `package:flutter_vscode/view.dart` (URL strategy + runApp); the
  extension's view uses it. Check: view analyze + the same gates.
- [ ] D-1e The README's Flutter View walkthrough is rewritten on the
  new APIs. Check: prose matches the shipped surface.

## D-2 Mechanical ergonomics layer over the Parity Layer

Not the reviewed Idiomatic Facade — a second *generated, total,
judgment-free* rule set that layers Dart-first types over the parity
surface: ordinary `String`/`int`/`bool` at every boundary, `Future<T>`
from `JSPromise<T>`, `Stream<T>` from `Event<T>`, named optional
parameters from options interfaces, and `lit$` factories that include
inherited interface members (discovered building Coverage Treemap:
`DecorationRenderOptions.lit$` cannot set `backgroundColor` because it
lives on the superinterface). Kills most `.toJS` noise while keeping
the zero-judgment guarantee; the hand-reviewed facade remains a later,
separate product for the places that need taste.
Check: emitter unit cases per new rule; the extension's host rewritten
on the layer with a large measured drop in interop noise.

## D-3 The dev loop: watch, reload, breakpoints

`flutter_vscode build --watch` plus automatic Extension Development
Host reload, and a gated proof that F5 breakpoints bind to Dart source
lines through the emitted source maps (graduates the deferred
breakpoint/source-map hardening item). Edit-rebuild-restart is the
difference between a demo and a daily tool.
Check: a scripted gate sets a breakpoint via the debug adapter in the
pinned host and observes a stop on a Dart line.

## D-4 View protocol v2: push, streams, cancellation

Graduates the protocol futures item, now with a concrete requirement:
Coverage Treemap's host cannot tell its view that coverage changed —
the view must poll or the user must click Refresh. Add host-to-view
requests/events (streams), protocol-level cancellation, and
per-request disposal, versioned alongside v1.
Check: protocol suite plus the extension's watcher pushing a fresh
snapshot to an open panel in the real-host gate.

## D-5 Theme bridge

Generate a Flutter theme from VS Code's webview CSS variables so views
look native in dark/light/high-contrast without hand-tuning (Coverage
Treemap hardcodes a dark palette today).
Check: the view renders with host-derived colors in the real-host
gate; toggling the host theme changes the view.

## D-6 Startup honesty

Measure webview cold-start for a minimal Flutter View in the pinned
host (wall-clock to first frame), publish the number in docs, and
evaluate wasm/deferred loading against it. Flutter-web weight is the
first objection every evaluator raises; meet it with data.
Check: the measurement runs in a gate and the doc cites its output.

## D-7 `doctor` and `test` commands

Graduates the product-workflow futures item (minus `upgrade`, which
depends on D-8): `doctor` validates the toolchain and project layout
with actionable errors; `test` gives Extension Authors a first-class
way to run shared/host suites (the boundary checker now skips package
`test/` directories — shipped during the Coverage Treemap round).
Check: CLI tests for both commands; quickstart documents the flow.

## D-8 Multi-baseline support

The machinery to *add* a pinned VS Code release rather than replace
it: N pinned IRs, `apiTarget` selecting among them, and a documented
procedure for onboarding a new release. "Supported releases, plural"
is the difference between a demo and a dependency, and unlocks a real
`upgrade` story.
Check: two baselines in-tree; a fixture builds against each.

## D-9 Nested-package analysis honesty

Discovered during the view build: the root `analysis_options.yaml`'s
`very_good_analysis` include silently fails to resolve for nested
packages (it is only a dev dependency of the root), so `dart analyze`
in `extensions/*`, fixtures, and view packages does not actually
enforce the strict lint set. Make the gates mean what they say
(per-package options, a shared include that resolves, or a repo check
that proves the lint set is active).
Check: a deliberately violating probe file fails analysis in a nested
package.

## D-10 Host network story

Host Dart has no HTTP client: Node's `fetch` is reachable but unbound.
Decide and ship the supported path (a total-rule binding or a runtime
helper), unblocking the pub.dev-explorer class of extensions.
Check: a fixture host performs a real request in the packaged gate
against a local server.

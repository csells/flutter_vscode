# View Protocol (v1)

Each optional Flutter View runs in its own webview runtime. The only
thing that crosses between Host Dart and a View is protocol v1
(`lib/src/view_protocol.dart`); view DTOs are protocol-safe snapshots,
never live host objects. Host commands and providers work when no view
exists.

## What v1 provides

- Versioned session + nonce handshake: `ready` → `readyAck` carrying a
  newly generated active nonce, installed before it is advertised
  (including on reload) so a synchronous peer cannot lose its first
  valid frame.
- View-to-Host typed calls against an explicit operation allowlist, with
  results and structured errors (eight stable codes); exact per-kind
  frame schemas; session and nonce mismatches fail closed.
- One idempotent terminal cleanup path shared by close, shutdown, peer
  close, stream completion/error, and delivery failure; concurrent
  closes join the same future; measured close reports count live
  requests and subscriptions after awaited cancellation and transport
  shutdown — never constant zeros.
- Delivery honesty: every transport send returns an awaitable; the Host
  adapter awaits VS Code's asynchronous `postMessage` acceptance and a
  `false` acceptance rejects the send; the void Flutter View API
  promises only synchronous handoff.
- Reload truth: stale responses are abandoned by generation; Host
  handler futures stay counted until application settlement.
- Webview safety: CSP with `Webview.cspSource` and a nonce'd script tag,
  private `acquireVsCodeApi` handling, webview-safe asset URLs.

Proven by `test/view_protocol_test.dart` (in-memory pair that
JSON-round-trips payloads), `test/host_webview_transport_test.dart`
(real dart2js/Node seam), and the real-host adversarial probes
(frames corrupted before native `postMessage`, reload with live work,
independent render observation).

## Explicitly deferred (backlog)

Host-to-View requests, protocol-level cancellation, events/streams,
handles, backpressure, and general handler cancellation. CSP *content*
is not yet gate-asserted (only that `cspSource` is exercised).

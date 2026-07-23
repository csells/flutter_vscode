# Backlog

Discoveries made during a frozen hardening round land here instead of
growing that round's exit bar. Items graduate into a future plan with
their own machine checks; nothing in this file blocks a round's closure.

## From the fourth audit (out of Round 5 scope by design)

- Protocol v1 has no cancellation frame and only session-level disposal;
  host-to-view requests do not exist. First From-Proof milestone.
- Dynamic `call/get/set/construct/subscribe` access (the vision's second
  integration speed) does not exist yet.
- CLI lacks `test`, `upgrade`, and `doctor`; debugging has a generated
  launch configuration but no exercised F5/breakpoint path.
- The only Extension Host proof platform is Linux-in-Docker; macOS and
  Windows are unprobed, and every gate re-downloads VS Code.
- The walking slice's per-symbol economics are unproven at the scale of
  the 2,912 pending declarations.
- The ECMAScript whitespace predicate exists in two implementations held
  together by mirrored tests.
- The host-side view transport lives in the test fixture rather than as a
  framework module.
- A registered-shape hash is key-order sensitive, so a reordered-but-
  consistent shape document is accepted (bounded: child cross-checks still
  bind content).
- No real extension exists outside the repository fixtures.

## From the Round-5 owner amendment (2026-07-22)

- CI has never executed in the project's history. The hardened workflow
  is parsed-but-unexecuted YAML; its first run is an obvious failure
  surface (Flutter setup, Docker-in-runner, VS Code download). The
  correct home is the upstream repository: open the pull request from
  `csells:project-hardening` to `SlowGen/flutter_vscode` (whose Actions
  are already enabled) when the owner chooses to engage upstream, and
  restore an independent-witness requirement at that point. Until then,
  every gate execution ever recorded was self-attested by the agent or
  owner running it.

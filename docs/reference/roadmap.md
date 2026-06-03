# Roadmap

Post-MVP priorities for `flutter_vscode`. MVP (v0.1) acceptance is documented in [PRD Traceability](prd-traceability.md).

## Next up: tiered integration testing

Reliable end-to-end confidence without running a full greenfield `flutter create` on every change. Three tiers; automate what does not need a GUI, keep a short manual gate for webview UX.

### Tier 1 — Build pipeline smoke (CI / every PR)

**Goal:** Prove scaffold → codegen → TypeScript → Flutter web all succeed.

**Fixture:** `example/` (path dependency on package root).

**Steps:**

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `npm ci` or `npm install`
4. `npm run compile`

**Assertions:**

- `build/web/main.dart.js` or `build/web/index.html` exists
- `out/extension.js` exists
- Generated `lib/*.handlers.ts` and `lib/*.vscode.g.part` exist and reference expected commands

**Deliverables:**

- `scripts/integration_test.sh --build-only` (default mode)
- Wire into `.github/workflows/test.yml` (alongside or inside `./scripts/test_all.sh`)
- `docs/guides/integration-testing.md` (usage and failure interpretation)

### Tier 2 — Extension host + manual webview checklist (local)

**Goal:** Confirm activation, webview load, and command round-trips after Tier 1 passes.

**Launch:**

```bash
code --extensionDevelopmentPath="$(pwd)/example" --disable-extensions
```

Or F5 from `example/` using `.vscode/launch.json`.

**Manual checklist (~2 minutes):**

1. Activity bar → open the Flutter webview → UI renders (not “index.html not found”).
2. Trigger a `Future<String>` command from the Flutter UI → input box → info toast with result.
3. DevTools console: no CSP or `acquireVsCodeApi` errors.
4. Optional: exercise an additional command type from the fixture (void / error paths).

**Deliverables:**

- `scripts/integration_test.sh --launch` (runs Tier 1, prints checklist, opens VS Code when `code` is on PATH)
- Fixture UI includes an obvious ready signal (e.g. debug banner or `data-integration-ready`) so load state is unambiguous

### Tier 3 — Greenfield regression (pre-release / weekly)

**Goal:** Match a new user path: `flutter create` → deps → `generate_vscode_extension` → diverse commands → compile.

**Approach:** Ephemeral temp directory (not daily local default); overlay committed fixture after scaffold.

**Steps:**

1. `flutter create --platforms=web` in a temp dir
2. Patch `pubspec.yaml` (`flutter_vscode` path dep, `build_runner`)
3. `dart run flutter_vscode:generate_vscode_extension`
4. Overlay `tool/integration_fixture/` (`lib/vscode_api.dart`, `lib/main.dart` with void, `Future<T>`, and error-style commands)
5. Tier 1 compile + assertions
6. Remove temp dir

**Deliverables:**

- `tool/integration_fixture/` (shared with `example/` where practical)
- `scripts/integration_test.sh --greenfield`

### Automation boundaries

| Behavior | Planned coverage |
|----------|------------------|
| Generators, validation, message contract | Existing Dart tests + builder checks |
| Full compile and artifacts | Tier 1 |
| VS Code host APIs from generated handlers | Future `@vscode/test-electron` (host-only; no webview widget clicks) |
| Flutter UI inside webview | Tier 2 manual checklist |
| Pixel-perfect UI | Out of scope unless invested later |

Headless CI for `@vscode/test-electron` requires Xvfb on Linux (`xvfb-run`); defer until Tier 1 is stable.

### Script entry point (planned)

```
scripts/integration_test.sh
  --build-only     # default; CI-safe; uses example/
  --launch         # Tier 1 + checklist + optional code launch
  --greenfield     # Tier 3 temp project
```

Daily workflow: `./scripts/integration_test.sh` (or `--build-only` in CI). Use `--launch` when changing webview, bridge, or `src/extension.ts`. Use `--greenfield` before release or after scaffold changes.

## Other post-MVP items

| Area | Item | Notes |
|------|------|--------|
| 5.1 Codegen | Exotic annotation misuse edge cases | Lower priority; partially covered by builder integration checks |
| 5.2 Scaffold | Merge/update policies beyond create-only | Selective refresh for existing projects |
| 5.3 Bridge | Web tests for `webview_bridge_web.dart` / `VSCodeWebViewHelper` JSON parsing | Complements Tier 1; does not replace Tier 2 |
| 5.4 Build | Automated extension-host E2E | Tier 1 + optional `@vscode/test-electron`; webview UX stays Tier 2 |
| Product | Additional scaffolds/templates | Dashboards, inspectors, wizards (PRD §9) |
| Product | Generator validation / health-check CLI | PRD §9 |
| Product | Tutorials and richer examples | PRD §9 |
| Product | Flutter web hot-reload in webviews | Platform-dependent; PRD §9 |
| Release | LICENSE + pub.dev publish for v0.1 | Packaging hygiene |

## Status

| Milestone | Status |
|-----------|--------|
| v0.1 MVP | Complete ([traceability](prd-traceability.md)) |
| Tiered integration testing | Planned (this section) |
| v0.1 pub release | Planned |

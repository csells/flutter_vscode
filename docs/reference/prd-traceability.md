# PRD Traceability and MVP Acceptance

This checklist maps PRD requirements to concrete implementation artifacts.
Use it as the release gate for the v0.1 MVP.

## Goals Coverage

- **Reduce extension boilerplate**
  - Implemented by scaffold CLI in `bin/generate_vscode_extension.dart`.
  - Acceptance: running `dart run flutter_vscode:generate_vscode_extension` creates a runnable baseline project with webview contributions and handler routing.
- **Strongly typed Dart/TS bridge**
  - Implemented by annotations and generators in `lib/annotations.dart`, `lib/src/vscode_generator.dart`, and `lib/src/vscode_ts_generator.dart`.
  - Acceptance: adding an annotated Dart command and running `build_runner` updates generated Dart and TS artifacts.
- **Webview constraints just work**
  - Implemented by generated web assets and compile script defaults in scaffolded `web/*` and `scripts/compile.sh`.
  - Acceptance: no remote CDN dependency and CSP-compatible build output in VS Code webview host.
- **Predictable build/run workflow**
  - Implemented by `scripts/compile.sh`, `build.yaml`, and README workflow.
  - Acceptance: `build_runner` + TypeScript compile + `flutter build web` produce loadable extension artifacts.
- **Maintainable architecture**
  - Implemented by separated generator/runtime/bridge modules under `lib/src`.
  - Acceptance: code structure and docs reflect ownership boundaries and expected edit points.

## PRD Requirement Matrix

### 5.1 Annotation-Based Code Generation

- **Status:** Complete for MVP
- **Implemented:**
  - `@VSCodeController` and `@VSCodeCommand` annotations.
  - Dart part generation and `.handlers.ts` generation.
  - Shared validation in `lib/src/vscode_validation.dart`.
  - Builder integration checks in `tool/check_dart_generator.dart` and `tool/check_ts_generator.dart`.
- **Remaining (post-MVP):**
  - Additional edge-case coverage for exotic annotation misuse patterns.
- **Primary files:** `lib/annotations.dart`, `lib/src/vscode_generator.dart`, `lib/src/vscode_ts_generator.dart`, `lib/src/vscode_validation.dart`.

### 5.2 Scaffold CLI

- **Status:** Complete for MVP
- **Implemented:**
  - Generates `.vscode/launch.json`, `scripts/compile.sh`, `src/extension.ts`, `lib/vscode_api.dart`, `package.json`, `tsconfig.json`, and `web/*`.
  - Idempotent create-only writes via `_WritePolicy.createOnly` and `_ScaffoldSummary`.
  - Package template resolution from the installed `flutter_vscode` package root.
  - Webview view registration and generated handler routing in default scaffold output.
  - Scaffold smoke tests in `test/generate_vscode_extension_test.dart`.
- **Remaining (post-MVP):**
  - Merge/update policies beyond create-only for selective refresh workflows.
- **Primary files:** `bin/generate_vscode_extension.dart`, `tool/extension.ts.template`, `test/generate_vscode_extension_test.dart`.

### 5.3 Bidirectional Communication

- **Status:** Complete for MVP
- **Implemented:**
  - Request/response routing in `VSCodeControllerBase`.
  - Webview helper listener and bridge with VS Code API fallback.
  - Generated TS command handler entrypoint.
  - Runtime tests in `test/vscode_controller_base_test.dart`.
  - Message contract in `docs/reference/message-contract.md`.
- **Remaining (post-MVP):**
  - Browser/webview integration tests for `VSCodeWebViewHelper` message parsing.
  - See [Roadmap](roadmap.md) for the tiered integration testing plan.
- **Primary files:** `lib/src/vscode_controller_base.dart`, `lib/src/vscode_webview_helper.dart`, `lib/src/webview_bridge_web.dart`.

### 5.4 Webview-Safe Build and Assets

- **Status:** Complete for MVP
- **Implemented:**
  - Scaffolded `web/index.html`, `web/flutter_bootstrap.js`, `web/manifest.json`.
  - Compile script includes webview-safe `flutter build web` flags.
  - Example project and quickstart document the F5 verification flow.
- **Remaining (post-MVP):**
  - Tiered integration testing (build smoke in CI, manual webview checklist, greenfield regression). See [Roadmap](roadmap.md).
- **Primary files:** `bin/generate_vscode_extension.dart`, `example/scripts/compile.sh`, `README.md`, `docs/guides/quickstart.md`.

## MVP Acceptance Criteria (v0.1)

v0.1 is ready when all checks pass:

1. Scaffold command creates baseline extension files without unexpectedly overwriting existing user files. **Met**
2. Annotation misuse produces actionable generator errors (what failed and how to fix). **Met**
3. Generated Dart and TS command wiring stays consistent for void and value-returning commands. **Met**
4. Runtime request lifecycle handles success, error, and timeout cleanup. **Met**
5. Example project succeeds with:
   - `dart run build_runner build`
   - `npm run compile`
   - VS Code extension host run (F5) with webview loaded.
   **Met** (documented manual verification; automated E2E deferred post-MVP)
6. README and docs include quickstart, troubleshooting, and generated-file ownership rules. **Met**
7. Changelog and package metadata reflect a non-placeholder release baseline. **Met**

Automated enforcement: `./scripts/test_all.sh` and `.github/workflows/test.yml`.

## Post-MVP roadmap

Planned work after v0.1 is tracked in [Roadmap](roadmap.md). **Next priority:** tiered integration testing (`scripts/integration_test.sh`, `example/` CI build smoke, manual webview checklist, optional greenfield fixture).

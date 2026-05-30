# PRD Traceability and MVP Acceptance

This checklist maps PRD requirements to concrete implementation artifacts.
Use it as the release gate for the v0.1 MVP.

## Goals Coverage

- **Reduce extension boilerplate**
  - Implemented by scaffold CLI in `bin/generate_vscode_extension.dart`.
  - Acceptance: running `dart run flutter_vscode:generate_vscode_extension` creates a runnable baseline project.
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

- **Status:** In progress
- **Implemented:**
  - `@VSCodeController` and `@VSCodeCommand` annotations.
  - Dart part generation and `.handlers.ts` generation.
- **Remaining for MVP:**
  - Stronger misuse validation and clearer actionable generation errors.
  - Edge-case tests for invalid command signatures and annotation misuse.
- **Primary files:** `lib/annotations.dart`, `lib/src/vscode_generator.dart`, `lib/src/vscode_ts_generator.dart`.

### 5.2 Scaffold CLI

- **Status:** In progress
- **Implemented:**
  - Generates `.vscode/launch.json`, `scripts/compile.sh`, `src/extension.ts`, `lib/vscode_api.dart`, `package.json`, `tsconfig.json`, and `web/*`.
  - Existing scaffold smoke test in `test/generate_vscode_extension_test.dart`.
- **Remaining for MVP:**
  - Idempotent write strategy (create/merge/skip) to avoid clobbering user edits by default.
  - Per-file creation/update/skip summary in CLI output.
- **Primary files:** `bin/generate_vscode_extension.dart`, `test/generate_vscode_extension_test.dart`.

### 5.3 Bidirectional Communication

- **Status:** In progress
- **Implemented:**
  - Request/response routing in `VSCodeControllerBase`.
  - Webview helper listener and bridge with VS Code API fallback.
  - Generated TS command handler entrypoint.
- **Remaining for MVP:**
  - Message contract docs and explicit edge-case tests.
  - Runtime safeguards for pending request lifecycle.
- **Primary files:** `lib/src/vscode_controller_base.dart`, `lib/src/vscode_webview_helper.dart`, `lib/src/webview_bridge_web.dart`.

### 5.4 Webview-Safe Build and Assets

- **Status:** In progress
- **Implemented:**
  - Scaffolded `web/index.html`, `web/flutter_bootstrap.js`, `web/manifest.json`.
  - Compile script includes webview-safe `flutter build web` flags.
- **Remaining for MVP:**
  - Validate generated assets and flow via documented end-to-end verification steps.
  - Ensure docs explain required commands and expected outputs.
- **Primary files:** `bin/generate_vscode_extension.dart`, `example/scripts/compile.sh`, `README.md`.

## MVP Acceptance Criteria (v0.1)

v0.1 is ready when all checks pass:

1. Scaffold command creates baseline extension files without unexpectedly overwriting existing user files.
2. Annotation misuse produces actionable generator errors (what failed and how to fix).
3. Generated Dart and TS command wiring stays consistent for void and value-returning commands.
4. Runtime request lifecycle handles success, error, and timeout cleanup.
5. Example project succeeds with:
   - `dart run build_runner build`
   - `npm run compile`
   - VS Code extension host run (F5) with webview loaded.
6. README and docs include quickstart, troubleshooting, and generated-file ownership rules.
7. Changelog and package metadata reflect a non-placeholder release baseline.

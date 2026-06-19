# flutter_vscode

Build VS Code extensions with Flutter web UI and Dart-first controller logic.
`flutter_vscode` provides annotations, code generation, runtime bridge APIs,
and a scaffold command so you can avoid hand-written webview wiring.

## What this package provides

- Annotation-driven Dart and TypeScript generation with `@VSCodeController` and `@VSCodeCommand`.
- Runtime request/response messaging between Flutter webview code and VS Code extension host.
- Scaffold CLI: `dart run flutter_vscode:generate_vscode_extension`.
- Webview-safe default build assets and compile script.
- **Agent toolkit:** curated skills and `AGENTS.md` template so AI agents handle VS Code API translation (see [Agent-Assisted Development](docs/guides/agent-assisted-development.md)).

## Prerequisites

- Flutter SDK (includes Dart)
- Node.js + npm
- VS Code

## Quickstart

1. Add dependency and generator tools:

```yaml
dependencies:
  flutter_vscode: ^0.1.0

dev_dependencies:
  build_runner: ^2.10.4
```

2. Generate extension scaffold:

```bash
dart run flutter_vscode:generate_vscode_extension
```

3. Install dependencies:

```bash
flutter pub get
npm install
```

4. Define controller API in Dart:

```dart
import 'package:flutter_vscode/runtime.dart';

part 'vscode_api.vscode.g.part';

@VSCodeController()
abstract class VSCodeApi {
  @VSCodeCommand('window.showInformationMessage')
  Future<void> info(String message);

  @VSCodeCommand('window.showInputBox')
  Future<String?> inputBox(String prompt);
}

VSCodeApi createVSCodeApi() => _$VSCodeApi();
```

5. Initialize runtime bridge in your Flutter app:

```dart
void main() {
  VSCodeWebViewHelper.initialize();
  runApp(const MyApp());
}
```

6. Build generated code + extension:

```bash
dart run build_runner build --delete-conflicting-outputs
npm run compile
```

7. Open the extension project in VS Code and press F5.

## Agent-assisted development

The scaffold command copies an agent toolkit into your extension project:

- `AGENTS.md` — rules for AI agents working in your extension
- `.cursor/skills/` — flutter_vscode skills (add commands, build, troubleshoot)

Describe VS Code behavior in plain language; your agent adds annotations and
runs the build pipeline. See [Agent-Assisted Development](docs/guides/agent-assisted-development.md)
and [VS Code API Mapping](docs/reference/vscode-api-mapping.md).

To install skills globally: `cp -r skills/* ~/.cursor/skills/`

## Build pipeline

The default compile flow is:

1. `dart run build_runner build --delete-conflicting-outputs`
2. `tsc -p ./`
3. `flutter build web --no-web-resources-cdn --csp --pwa-strategy none --no-tree-shake-icons`

## Generated file ownership

- Safe to regenerate:
  - `*.vscode.g.part`
  - `*.handlers.ts`
- Created once by scaffold (not overwritten by default on rerun):
  - `AGENTS.md`
  - `.cursor/skills/`
  - `src/extension.ts`
  - `package.json`
  - `tsconfig.json`
  - `web/index.html`, `web/flutter_bootstrap.js`, `web/manifest.json`
  - `lib/vscode_api.dart`
- Merge behavior:
  - `.gitignore` entries are appended when missing.

## Example project

The `example/` directory is the integration fixture. Run its tests with:

```bash
cd example && flutter test
```

They are also included in `./scripts/test_all.sh`.

## Troubleshooting

- If commands are missing, rerun `dart run build_runner build`.
- If VS Code host fails to load webview, ensure `npm run compile` has completed.
- If extension cannot call VS Code APIs, verify command ids and generated handlers.
- For runtime payload details, see `docs/reference/message-contract.md`.

## Documentation

- [Documentation Index](docs/index.md)
- [Roadmap](docs/reference/roadmap.md)
- [Architecture](docs/architecture/index.md)
- [Guides](docs/guides/index.md)
- [Reference](docs/reference/index.md)
- [PRD](PRD.md)

# Dart-Host v1 Agent Skills

These portable guides describe the current Dart-owned Extension Project
workflow created by `flutter_vscode create`. Each directory contains one plain
Markdown `SKILL.md` that can be used by any coding agent.

They do not apply to the legacy annotation/TypeScript scaffold. The legacy
`generate_vscode_extension` command owns a separate, maintainer-controlled
snapshot under `tool/legacy-agent-skills/`.

## Install in an Extension Project

From this package repository, copy the v1 consumer guide and live skills:

```sh
cp docs/templates/consumer-agents.md ./AGENTS.md
mkdir -p agent-skills
cp -r skills/* agent-skills/
```

## Wire into your agent tool

`agent-skills/` is tool-neutral. If your product expects skills in a different
path, copy or symlink:

```sh
# Example: Cursor (optional)
mkdir -p .cursor/skills
cp -r agent-skills/* .cursor/skills/
```

`AGENTS.md` at the project root is the main entry point most tools recognize.

## Skills

| Directory | Use when |
|---|---|
| `flutter-vscode-add-command` | Add a Dart-owned command and an optional typed view operation |
| `flutter-vscode-contributions` | Declare generated manifest contributions in `extension.dart` |
| `flutter-vscode-extension-host` | Implement activation and native VS Code behavior in Host Dart |
| `flutter-vscode-view` | Author a Flutter View: ViewShell, VS Code theming, typed operations, and host push events |
| `flutter-vscode-build` | Run `flutter_vscode doctor`, deterministic `build [--watch]`, and `package` workflows |
| `flutter-vscode-test` | Run `flutter_vscode test` author suites plus Extension Host and VSIX checks |
| `flutter-vscode-troubleshoot` | Diagnose bindings, managed artifacts, packaging, or view protocol failures |

## Related

- [Agent-Assisted Development](../docs/guides/agent-assisted-development.md)
- [Generated Host API](../docs/reference/generated-host-api.md)
- [Consumer AGENTS.md template](../docs/templates/consumer-agents.md)

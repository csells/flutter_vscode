# flutter_vscode Consumer Skills

Curated Cursor/agent skills for building extensions with `flutter_vscode`.
Copy into your extension project or install globally.

## Install (per project)

```bash
mkdir -p .cursor/skills
cp -r skills/* .cursor/skills/
cp docs/templates/consumer-agents.md ./AGENTS.md
```

## Install (global, Cursor)

```bash
mkdir -p ~/.cursor/skills
cp -r skills/* ~/.cursor/skills/
```

## Skills

| Directory | Use when |
|---|---|
| `flutter-vscode-add-command` | Call VS Code APIs from Flutter via annotations |
| `flutter-vscode-contributions` | Edit `package.json` contributions |
| `flutter-vscode-extension-host` | Code in `src/extension.ts` |
| `flutter-vscode-build` | build_runner + npm compile pipeline |
| `flutter-vscode-test` | VM tests for controllers |
| `flutter-vscode-troubleshoot` | Debug webview / handler issues |

## Related

- [Agent-Assisted Development](../docs/guides/agent-assisted-development.md)
- [VS Code API Mapping](../docs/reference/vscode-api-mapping.md)
- [Consumer AGENTS.md template](../docs/templates/consumer-agents.md)

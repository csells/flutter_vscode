# flutter_vscode Agent Skills

Portable workflow guides for building extensions with `flutter_vscode`. Each
skill is a `SKILL.md` file — plain markdown usable with any AI coding agent.

## Install (per extension project)

**Automatic:** `dart run flutter_vscode:generate_vscode_extension` copies skills
to `agent-skills/` in your project.

**Manual from this package repo:**

```bash
cp docs/templates/consumer-agents.md ./AGENTS.md
mkdir -p agent-skills
cp -r skills/* agent-skills/
```

## Wire into your agent tool

`agent-skills/` is tool-neutral. If your product expects skills in a different
path, copy or symlink:

```bash
# Example: Cursor (optional)
mkdir -p .cursor/skills
cp -r agent-skills/* .cursor/skills/
```

`AGENTS.md` at the project root is the main entry point most tools recognize.

## Skills

| Directory | Use when |
|---|---|
| `flutter-vscode-add-command` | Call VS Code APIs from Flutter via annotations or invoke |
| `flutter-vscode-contributions` | Edit `package.json` contributions |
| `flutter-vscode-extension-host` | Code in `src/extension.ts` |
| `flutter-vscode-build` | build_runner + npm compile pipeline |
| `flutter-vscode-test` | VM tests for controllers |
| `flutter-vscode-troubleshoot` | Debug webview / handler issues |

## Related

- [Agent-Assisted Development](../docs/guides/agent-assisted-development.md)
- [VS Code API Mapping](../docs/reference/vscode-api-mapping.md)
- [Consumer AGENTS.md template](../docs/templates/consumer-agents.md)

# Agent-Assisted Development

Build flutter_vscode extensions with AI agents handling VS Code API translation
while you focus on Flutter UI and product behavior.

## Model

```
You describe intent → Agent adds annotations + UI → build_runner + compile → F5
```

Annotations (`@VSCodeController`, `@VSCodeCommand`) are the **agent output
format** — not something you should translate from VS Code docs by hand.

## Setup

### 1. Scaffold your extension

```bash
dart run flutter_vscode:generate_vscode_extension
```

This creates `AGENTS.md` and copies skills to `.cursor/skills/` automatically.

### 2. Install skills in Cursor

Skills ship in the `flutter_vscode` package under `skills/`:

| Skill | Purpose |
|---|---|
| `flutter-vscode-add-command` | Add VS Code API calls from Flutter |
| `flutter-vscode-contributions` | `package.json` views, commands, menus |
| `flutter-vscode-extension-host` | `src/extension.ts` host patterns |
| `flutter-vscode-build` | build_runner + compile pipeline |
| `flutter-vscode-test` | VM tests without webview |
| `flutter-vscode-troubleshoot` | Diagnose common failures |

Copy to `~/.cursor/skills/` for global use or `.cursor/skills/` per project.

### 3. Point your agent at project rules

Ensure `AGENTS.md` is in your extension project root (see
[consumer template](../templates/consumer-agents.md)).

## Example Prompts

**Add a dialog:**

> Add a quick pick with three deployment targets. When selected, show an
> information message with the choice. Use our vscode_api controller.

**Add workspace integration:**

> Add a command to read `myExtension.serverUrl` from workspace configuration
> and display it in the Flutter UI.

**Add palette command:**

> Register a "Refresh" command in the command palette that reloads data in
> the Flutter webview.

## Manual Fallback (No Agent)

Use [VS Code API Mapping](../reference/vscode-api-mapping.md) as a copy-paste
catalog of annotation patterns. The scaffold `lib/vscode_api.dart` includes
starter examples.

## Agent Eval Checklist

Verify your agent workflow with these scenarios:

1. Add `showWarningMessage` and call from a button
2. Add `showQuickPick` with three options
3. Add `showInputBox` with options map
4. Chain pick → toast in Flutter UI
5. Run build_runner without being reminded
6. Do not edit `*.handlers.ts`
7. `npm run compile` succeeds
8. F5 smoke test passes

## Mixed Audience

| You | Use |
|---|---|
| AI-assisted | Skills + AGENTS.md + natural language prompts |
| Manual coding | API mapping reference + scaffold examples |

## Related

- [VS Code API Mapping](../reference/vscode-api-mapping.md)
- [Quickstart](quickstart.md)
- [Troubleshooting](troubleshooting.md)

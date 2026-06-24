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

This creates `AGENTS.md`, `agent-skills/`, and `src/vscode_invoke.ts` automatically.

## Dynamic invoke vs annotations

| | `VSCode.instance.invoke` | `@VSCodeCommand` |
|---|---|---|
| build_runner | Not required | Required after changes |
| Typed API | Runtime / manual generics | Generated controller |
| Best for | Prototyping, agent experiments | Stable extension API |

```dart
await VSCode.instance.invoke<void>(
  'window.showWarningMessage',
  ['Check this before shipping'],
  expectsResponse: false,
);
```

### 2. Wire skills into your agent tool

Skills ship in the `flutter_vscode` package under `skills/` and are copied to
`agent-skills/` in scaffolded projects. They are plain markdown — not tied to
one vendor.

| Skill | Purpose |
|---|---|
| `flutter-vscode-add-command` | Add VS Code API calls from Flutter |
| `flutter-vscode-contributions` | `package.json` views, commands, menus |
| `flutter-vscode-extension-host` | `src/extension.ts` host patterns |
| `flutter-vscode-build` | build_runner + compile pipeline |
| `flutter-vscode-test` | VM tests without webview |
| `flutter-vscode-troubleshoot` | Diagnose common failures |

**Per project (default after scaffold):** use `agent-skills/` in your extension
root. Point your agent at `AGENTS.md` and the relevant `SKILL.md` files.

**Manual install from the package repo:**

```bash
cp docs/templates/consumer-agents.md ./AGENTS.md
mkdir -p agent-skills
cp -r /path/to/flutter_vscode/skills/* agent-skills/
```

**Tool-specific wiring (optional):** if your product expects skills elsewhere,
copy or symlink from `agent-skills/`:

| Product | Typical skills location |
|---|---|
| Cursor | `.cursor/skills/` or `~/.cursor/skills/` |
| Other agents | Follow that product's docs for custom rules / skills |

`AGENTS.md` at the project root is the primary, tool-agnostic entry point.

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
| AI-assisted | `AGENTS.md` + `agent-skills/` + natural language prompts |
| Manual coding | API mapping reference + scaffold examples |

## Related

- [VS Code API Mapping](../reference/vscode-api-mapping.md)
- [Quickstart](quickstart.md)
- [Troubleshooting](troubleshooting.md)

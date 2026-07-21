# Agent-Assisted Development

Use an agent to translate product intent into Dart-owned extension metadata,
Host Dart behavior, and optional Flutter UI without introducing an author-side
Node or TypeScript layer.

## Setup

```sh
dart pub global activate flutter_vscode
flutter_vscode create my_extension
cd my_extension
```

Point the agent at the project `AGENTS.md` and `agent-skills/`. If those files
are not present yet, copy the [consumer template](../templates/consumer-agents.md)
and the repository `skills/` tree.

## Working model

```text
intent -> check pinned API coverage -> edit author-owned Dart -> build -> test
```

An agent should first verify that the requested VS Code symbols exist in the
generated bindings and `coverage.json`. It must not infer a likely binding,
handwrite a shadow API, or edit generated interop to make an unsupported symbol
compile. Expanding the API is a framework contribution: update pinned official
inputs, IR, reviewed Semantic Overrides, generation, and host tests.

For a supported feature, the agent edits:

- `extension.dart` for metadata and contributions;
- `host/lib/**` for activation, commands, providers, events, and native VS Code
  object lifecycles;
- `shared/lib/**` for runtime-neutral values; and
- `views/**` for optional Flutter UI and typed, allowlisted host calls.

It then runs:

```sh
flutter_vscode build
```

The agent must not edit `package.json`, generated host bindings, the CommonJS
bootstrap, JavaScript bundles, source maps, or VSIX contents.

## Example prompts

> Add a contributed command named “Show Greeting,” register it in Host Dart,
> and return the selected editor language when the currently generated API
> supports that operation.

> Add an optional Flutter view. Keep provider logic in Host Dart, expose one
> allowlisted value operation to the view, and verify protocol cleanup when the
> panel closes.

> Check whether the pinned API target supports a tree data provider. If it does
> not, report the missing IR entries instead of inventing bindings.

## Review checklist

1. `extension.dart` retains the explicit `apiTarget`.
2. Host behavior works before any view opens and after a view closes.
3. Cross-runtime messages use typed protocol operations and value snapshots.
4. Host/shared dependency checks pass.
5. A second `flutter_vscode build` reproduces managed artifacts.
6. `flutter_vscode package` validates the VSIX.
7. No author-owned `.js`, `.ts`, or `package.json` was added.

The original annotation/TypeScript agent workflow remains documented in the
[legacy API mapping](../reference/vscode-api-mapping.md) for existing v0
projects.

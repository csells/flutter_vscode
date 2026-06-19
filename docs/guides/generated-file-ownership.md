# Generated File Ownership

This guide explains what you should edit manually and what should be regenerated.

## Regenerate (do not hand-edit)

- `*.vscode.g.part`: generated Dart controller implementations.
- `*.handlers.ts`: generated TypeScript command handlers.

If these files drift from source annotations, rerun:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Scaffolded once (safe by default on rerun)

`generate_vscode_extension` creates these files and skips them if they already exist:

- `src/extension.ts`
- `package.json`
- `tsconfig.json`
- `web/index.html`
- `web/flutter_bootstrap.js`
- `web/manifest.json`
- `lib/vscode_api.dart`
- `AGENTS.md`
- `.cursor/skills/` (consumer agent skills)

This behavior prevents clobbering local customizations.

## Merge behavior

- `.gitignore` is appended with missing extension-related entries.

## Recommended workflow

1. Treat annotated Dart source as the source of truth.
2. Regenerate code after changing commands/signatures.
3. Keep custom extension host logic in `src/extension.ts`.

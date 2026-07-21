---
name: flutter-vscode-contributions
description: >-
  Change package.json contributions in a legacy flutter_vscode v0 extension.
---

# Add a Legacy Contribution

Edit `package.json` to add commands, menus, keybindings, views, or view
containers. Keep each command ID identical everywhere it appears: the
contribution, `registerCommand`, and any controller call.

For the scaffolded Flutter view, keep its contribution ID equal to
`FlutterWebviewProvider.viewType` in `src/extension.ts`.

After editing the manifest, run:

```sh
npm run compile
```

Reload the Extension Development Host so VS Code reads the new manifest. Do
not put contribution metadata in generated `*.handlers.ts` files.

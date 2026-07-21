---
name: flutter-vscode-extension-host
description: >-
  Implement TypeScript Extension Host behavior in a legacy flutter_vscode v0
  project.
---

# Implement Legacy Extension Host Behavior

Put activation, providers, events, and other native VS Code behavior in
`src/extension.ts`. Register disposables with `context.subscriptions`.

Flutter-to-host controller calls are dispatched by generated
`lib/*.handlers.ts`; keep the scaffolded `onDidReceiveMessage` routing intact.
Use `webview.postMessage` for explicit host-to-Flutter notifications.

After TypeScript changes, run:

```sh
npm run compile
```

Use F5 to verify the behavior in an Extension Development Host. Never edit a
generated handler to add host behavior; change its annotated Dart controller
or write deliberate TypeScript in `src/extension.ts`.

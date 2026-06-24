---
name: flutter-vscode-contributions
description: >-
  Edit package.json contributions for flutter_vscode extensions — activity bar
  views, webview views, commands, menus, keybindings. Use when adding sidebar
  panels, command palette entries, or context menus.
---

# package.json Contributions (flutter_vscode)

Configure how the extension appears in VS Code. Contributions live in
`package.json` under `"contributes"`.

## Webview Sidebar (Default Scaffold)

The scaffold registers an activity bar container and webview view:

```json
"contributes": {
  "viewsContainers": {
    "activitybar": [
      {
        "id": "flutterVSCode",
        "title": "Flutter VS Code",
        "icon": "$(flutter)"
      }
    ]
  },
  "views": {
    "flutterVSCode": [
      {
        "type": "webview",
        "id": "flutterVSCode.view",
        "name": "Flutter VS Code"
      }
    ]
  }
}
```

The view `id` must match `FlutterWebviewProvider.viewType` in `src/extension.ts`.

## Add a Command Palette Entry

```json
"commands": [
  {
    "command": "myExtension.refresh",
    "title": "Refresh",
    "category": "My Extension"
  }
]
```

Register handler in `src/extension.ts`:

```typescript
context.subscriptions.push(
  vscode.commands.registerCommand('myExtension.refresh', () => {
    // host-side logic
  }),
);
```

## Wire Command to Webview

To trigger Flutter logic from a palette command, post a message to the webview
from `extension.ts` and handle it in Dart via `VSCodeWebViewHelper` / custom
listener.

## Menus

```json
"menus": {
  "view/title": [
    {
      "command": "myExtension.refresh",
      "when": "view == flutterVSCode.view",
      "group": "navigation"
    }
  ]
}
```

## Keybindings

```json
"keybindings": [
  {
    "command": "myExtension.refresh",
    "key": "ctrl+shift+r",
    "mac": "cmd+shift+r",
    "when": "view == flutterVSCode.view"
  }
]
```

## Checklist

- [ ] `command` id is unique and matches `registerCommand` in `extension.ts`
- [ ] Webview view `id` matches TypeScript provider `viewType`
- [ ] Run `npm run compile` after changes
- [ ] Reload extension development host (F5) to pick up manifest changes

## Related

- VS Code contribution points: https://code.visualstudio.com/api/references/contribution-points
- Flutter API calls from UI: use `flutter-vscode-add-command` skill

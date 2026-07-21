---
name: flutter-vscode-add-command
description: >-
  Add a VS Code API call to a legacy flutter_vscode v0 controller or invoke it
  through the TypeScript webview bridge.
---

# Add a Legacy VS Code Command

For stable calls, add an abstract method to the class annotated with
`@VSCodeController()` in `lib/vscode_api.dart`:

```dart
@VSCodeCommand('window.showInputBox')
Future<String?> inputBox(Map<String, dynamic> options);
```

Use a dotted VS Code API path, required positional parameters, and an explicit
return type. Option objects cross the bridge as `Map<String, dynamic>`.

After changing annotations, regenerate and compile:

```sh
dart run build_runner build --delete-conflicting-outputs
npm run compile
```

Never edit `*.vscode.g.part` or `*.handlers.ts`. Use
`VSCode.instance.invoke` only for a short experiment; keep durable calls in an
annotated controller.

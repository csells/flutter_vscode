---
name: flutter-vscode-contributions
description: >-
  Add or change VS Code contributions in a Dart-owned flutter_vscode Extension
  Project. Use for command-palette entries and other generated manifest data.
---

# Add a Contribution

Edit `extension.dart`, never generated `package.json`.

For a command:

```dart
'commands': <Map<String, Object?>>[
  <String, Object?>{
    'command': 'my-extension.refresh',
    'title': 'Refresh',
    'category': 'My Extension',
  },
],
```

Then register the same identifier in `host/lib/extension.dart` through the
generated commands binding. Keep identifiers and titles nonblank; command IDs
must be unique. If using an icon object, provide both `light` and `dark` paths.

Run `flutter_vscode build`. The generator validates contributions against the
mechanically projected schema for the project’s pinned API target. If a desired
contribution point is not generated, report the missing schema coverage instead
of inserting raw JSON or editing `package.json`.

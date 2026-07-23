// LEGACY v0 EXAMPLE: this app demonstrates the original webview bridge,
// which is retained for existing users but is not the architecture for
// new extensions. Build new extensions with the Dart-owned host path:
// see example/README.md and docs/guides/quickstart.md
// (`flutter_vscode create` / `build` / `package`).

import 'package:flutter/material.dart';
import 'package:flutter_vscode/flutter_vscode.dart';
import 'package:flutter_vscode_example/example_app.dart';

/// Example Flutter app hosted inside a VS Code webview (legacy v0 path).
void main() {
  VSCodeWebViewHelper.initialize();
  runApp(const ExampleApp());
}

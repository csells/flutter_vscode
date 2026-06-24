import 'package:flutter/material.dart';
import 'package:flutter_vscode/flutter_vscode.dart';
import 'package:flutter_vscode_example/example_app.dart';

/// Example Flutter app hosted inside a VS Code webview.
void main() {
  VSCodeWebViewHelper.initialize();
  runApp(const ExampleApp());
}

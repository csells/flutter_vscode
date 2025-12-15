import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vscode/flutter_vscode.dart';
import 'package:flutter_vscode_example/api_controller.dart';

/// Example Flutter app hosted inside a VS Code webview.
void main() {
  // Initialize VS Code webview message handling
  VSCodeWebViewHelper.initialize();
  runApp(const MyApp());
}

/// Root widget for the example Flutter VS Code extension UI.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter VS Code Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final api = createApiController();
                  final response = await api.showInputBox('Enter your name');
                  unawaited(api.showInformationMessage('Hello, $response!'));
                },
                child: const Text('Show Input Box'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vscode_example/api_controller.dart';

/// Root widget for the example Flutter VS Code extension UI.
class ExampleApp extends StatelessWidget {
  /// Creates an [ExampleApp] widget instance.
  const ExampleApp({super.key});

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
                  final response = await api.showInputBox(
                    {'prompt': 'Enter your name', 'placeHolder': 'Jane Doe'},
                  );
                  if (response != null) {
                    unawaited(
                      api.showInformationMessage('Hello, $response!'),
                    );
                  }
                },
                child: const Text('Show Input Box'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final api = createApiController();
                  final choice = await api.showQuickPick(
                    ['Deploy staging', 'Deploy production', 'Cancel'],
                  );
                  if (choice != null) {
                    unawaited(api.showInformationMessage('Selected: $choice'));
                  }
                },
                child: const Text('Show Quick Pick'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

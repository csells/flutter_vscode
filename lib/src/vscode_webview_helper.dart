import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter_vscode/src/vscode_controller_base.dart';
import 'package:web/web.dart' as web;

/// Helper class to initialize VS Code webview message handling.
class VSCodeWebViewHelper {
  static bool _initialized = false;
  static bool debugLogInvalidMessages = false;

  /// Initializes the message handler for VS Code webview communication.
  /// This should be called early in your Flutter app (e.g., in main()).
  static void initialize() {
    if (_initialized) return;
    _initialized = true;

    // Listen for messages from VS Code
    web.window.addEventListener(
      'message',
      ((web.MessageEvent event) {
        final data = event.data;
        if (data != null) {
          try {
            // Convert JS object to Dart Map via JSON stringify/parse
            final jsonString = _jsonStringify(data);
            final message = jsonDecode(jsonString) as Map<String, dynamic>;
            VSCodeControllerBase.handleMessage(message);
          } on Object {
            // Ignore invalid messages, optionally logging in debug asserts.
            assert(() {
              if (debugLogInvalidMessages) {
                // ignore: avoid_print
                print(
                  'flutter_vscode: ignored non-JSON or invalid host message.',
                );
              }
              return true;
            }());
          }
        }
      }).toJS,
    );
  }
}

@JS('JSON.stringify')
external String _jsonStringify(JSAny? value);

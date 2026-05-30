import 'dart:convert';
import 'dart:js_interop';

import 'package:meta/meta.dart';
import 'package:web/web.dart' as web;

/// Web implementation of the VS Code webview bridge.
///
/// In a VS Code webview, messages must be sent via `acquireVsCodeApi().postMessage(...)`.
/// This class uses that API when available and falls back to `window.postMessage`
/// (useful for running the Flutter app in a normal browser during development).
class WebViewBridge {
  WebViewBridge() {
    debugLastBridgeHadVsCodeApi = _vscodeApi != null;
  }

  final VsCodeApi? _vscodeApi = _tryAcquireVsCodeApi();

  /// Exposes whether the last created bridge instance could access VS Code API.
  @visibleForTesting
  static bool? debugLastBridgeHadVsCodeApi;

  /// Sends a message to the VS Code extension or falls back to window.postMessage.
  ///
  /// If the VS Code API is available, the message is sent via `acquireVsCodeApi().postMessage()`.
  /// Otherwise, it falls back to `window.postMessage()` for browser compatibility.
  void postMessage(dynamic message) {
    final api = _vscodeApi;
    // Convert Dart object to JS object via JSON
    final jsonString = jsonEncode(message);
    final jsMessage = _jsonParse(jsonString);
    if (api != null) {
      api.postMessage(jsMessage);
      return;
    }

    // Browser fallback
    web.window.postMessage(jsMessage, '*'.toJS);
  }
}

/// JS interop type for VS Code API returned by `acquireVsCodeApi()`.
///
/// This class represents the VS Code API object that provides access to
/// webview messaging functionality within a VS Code extension.
@JS()
@staticInterop
class VsCodeApi {
  /// Creates a VS Code API instance.
  ///
  /// This factory should not be called directly; instances are obtained
  /// via `acquireVsCodeApi()` from the VS Code webview context.
  external factory VsCodeApi();
}

/// Extension providing postMessage functionality for [VsCodeApi].
extension VsCodeApiExtension on VsCodeApi {
  /// Sends a message to the VS Code extension.
  external void postMessage(JSAny? message);
}

@JS('acquireVsCodeApi')
external JSObject? _acquireVsCodeApi();

/// JS interop wrapper for JSON.parse.
@JS('JSON.parse')
external JSAny? _jsonParse(String json);

VsCodeApi? _tryAcquireVsCodeApi() {
  try {
    final api = _acquireVsCodeApi();
    return api as VsCodeApi?;
  } on Object {
    // acquireVsCodeApi not available (caught any exception)
  }
  return null;
}

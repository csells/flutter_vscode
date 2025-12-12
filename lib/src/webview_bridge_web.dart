// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js_util' as js_util;

/// Web implementation of the VS Code webview bridge.
///
/// In a VS Code webview, messages must be sent via `acquireVsCodeApi().postMessage(...)`.
/// This class uses that API when available and falls back to `window.postMessage`
/// (useful for running the Flutter app in a normal browser during development).
class WebViewBridge {
  final Object? _vscodeApi = _tryAcquireVsCodeApi();

  void postMessage(dynamic message) {
    final api = _vscodeApi;
    if (api != null) {
      js_util.callMethod(api, 'postMessage', [message]);
      return;
    }

    // Browser fallback
    html.window.postMessage(message, '*');
  }
}

Object? _tryAcquireVsCodeApi() {
  try {
    return js_util.callMethod(html.window, 'acquireVsCodeApi', const []);
  } catch (_) {
    return null;
  }
}


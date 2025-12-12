/// Fallback bridge for non-web platforms (no-op).
class WebViewBridge {
  void postMessage(dynamic message) {
    // Intentionally no-op. This package's runtime bridge is only meaningful
    // inside a VS Code webview (Flutter web).
  }
}


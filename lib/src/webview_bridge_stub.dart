/// Fallback bridge for non-web platforms (no-op).
///
/// This class provides a stub implementation for platforms that don't support
/// webview communication. All methods are intentionally no-ops.
class WebViewBridge {
  /// No-op implementation of postMessage for non-web platforms.
  ///
  /// This method does nothing since webview communication is only available
  /// on web platforms within a VS Code webview context.
  void postMessage(dynamic message) {
    // Intentionally no-op. This package's runtime bridge is only meaningful
    // inside a VS Code webview (Flutter web).
  }
}

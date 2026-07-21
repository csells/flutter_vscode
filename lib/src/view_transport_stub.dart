import 'package:flutter_vscode/src/view_protocol.dart';

/// Acquires and owns the transport for one VS Code-hosted Flutter View.
final class VSCodeViewBootstrap {
  /// Acquires the VS Code webview transport exactly once.
  factory VSCodeViewBootstrap.acquire() {
    throw UnsupportedError(
      'VSCodeViewBootstrap requires a compiled VS Code webview runtime.',
    );
  }

  /// Metadata key containing the Host-created session identifier.
  static const sessionMetaName = 'flutter-vscode-session';

  /// Metadata key containing the Host-created bootstrap nonce.
  static const bootstrapNonceMetaName = 'flutter-vscode-bootstrap-nonce';

  /// Connects the Flutter View using Host-provided metadata.
  Future<FlutterViewSession> connect() {
    throw UnsupportedError(
      'VSCodeViewBootstrap requires a compiled VS Code webview runtime.',
    );
  }

  /// Removes the owned browser message listener.
  Future<void> close() {
    throw UnsupportedError(
      'VSCodeViewBootstrap requires a compiled VS Code webview runtime.',
    );
  }
}

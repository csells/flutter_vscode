import 'dart:async';
import 'dart:math';

import 'package:flutter_vscode/src/webview_bridge.dart';
import 'package:meta/meta.dart';

/// Base class for generated VS Code controllers.
///
/// This class provides the common functionality for sending messages
/// to the VS Code extension and handling responses.
abstract class VSCodeControllerBase {
  static final WebViewBridge _bridge = WebViewBridge();
  static final Map<String, Completer<dynamic>> _pendingRequests = {};
  static final Random _random = Random();

  /// Optional factory used in tests to control generated request IDs.
  @visibleForTesting
  static String Function()? debugRequestIdFactory;

  /// Sends a command to the VS Code extension and optionally waits for a response.
  static Future<T> sendCommand<T>(
    String command,
    List<dynamic> params, {
    bool expectsResponse = false,
  }) async {
    final requestId = _generateRequestId();

    final message = {
      'command': command,
      'params': params,
      'requestId': requestId,
    };

    if (expectsResponse) {
      final completer = Completer<T>();
      _pendingRequests[requestId] = completer;

      _bridge.postMessage(message);

      return completer.future;
    } else {
      _bridge.postMessage(message);
      // For void methods, we need to return a completed future
      // This is a bit of a hack, but works for Future<void>
      return (null as dynamic) as T;
    }
  }

  /// Generates a unique request ID for message tracking.
  static String _generateRequestId() {
    final factory = debugRequestIdFactory;
    if (factory != null) {
      return factory();
    }
    return 'req_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }

  /// Handles incoming messages from the VS Code extension.
  /// This should be called by the webview's message handler.
  static void handleMessage(Map<String, dynamic> message) {
    final requestId = message['requestId'] as String?;
    if (requestId != null && _pendingRequests.containsKey(requestId)) {
      final completer = _pendingRequests.remove(requestId)!;

      if (message.containsKey('error')) {
        completer.completeError(Exception(message['error']));
      } else {
        completer.complete(message['result']);
      }
    }
  }

  /// Exposes the pending request map for tests.
  @visibleForTesting
  static Map<String, Completer<dynamic>> get debugPendingRequests =>
      _pendingRequests;
}

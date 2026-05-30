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
  static final Map<String, _PendingRequest> _pendingRequests = {};
  static final Random _random = Random();

  /// Default timeout used for request/response commands.
  @visibleForTesting
  static Duration debugResponseTimeout = const Duration(seconds: 30);

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
      final timeoutTimer = Timer(debugResponseTimeout, () {
        final pending = _pendingRequests.remove(requestId);
        if (pending != null && !pending.completer.isCompleted) {
          pending.completer.completeError(
            TimeoutException(
              'Timed out waiting for VS Code response for "$command".',
              debugResponseTimeout,
            ),
          );
        }
      });
      _pendingRequests[requestId] = _PendingRequest(completer, timeoutTimer);

      _bridge.postMessage(message);

      return completer.future;
    } else {
      _bridge.postMessage(message);
      return _completedFuture<T>();
    }
  }

  static Future<T> _completedFuture<T>() => Future<void>.value() as Future<T>;

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
      final pending = _pendingRequests.remove(requestId)!;
      pending.timer.cancel();
      final completer = pending.completer;

      if (message.containsKey('error')) {
        completer.completeError(Exception(message['error']));
      } else {
        completer.complete(message['result']);
      }
    }
  }

  /// Exposes the pending request map for tests.
  @visibleForTesting
  static Map<String, Completer<dynamic>> get debugPendingRequests {
    return Map<String, Completer<dynamic>>.fromEntries(
      _pendingRequests.entries.map(
        (entry) => MapEntry(entry.key, entry.value.completer),
      ),
    );
  }

  /// Clears pending requests and cancels their timeout timers.
  @visibleForTesting
  static void debugClearPendingRequests() {
    for (final pending in _pendingRequests.values) {
      pending.timer.cancel();
    }
    _pendingRequests.clear();
  }
}

class _PendingRequest {
  _PendingRequest(this.completer, this.timer);

  final Completer<dynamic> completer;
  final Timer timer;
}

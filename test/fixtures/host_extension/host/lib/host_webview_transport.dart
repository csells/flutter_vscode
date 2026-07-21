import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_vscode_host_fixture/generated/view_protocol.g.dart';
import 'package:flutter_vscode_host_fixture/generated/vscode_facade.g.dart';

/// Adapts one native VS Code webview to the shared protocol transport.
final class HostWebviewTransport implements ViewTransport {
  /// Starts listening to messages from the supplied VS Code webview.
  HostWebviewTransport(this._webview) {
    _messageRegistration = _webview.listenOnDidReceiveMessage(
      ((JSAny? message) {
        if (_closed) {
          return;
        }
        try {
          _messages.add(message.dartify());
        } on Object {
          // Feed malformed external input through the protocol validator.
          _messages.add(null);
        }
      }).toJS,
    );
  }

  final Webview _webview;
  final StreamController<Object?> _messages =
      StreamController<Object?>.broadcast(sync: true);
  final Completer<Never> _failure = Completer<Never>();
  final Set<Future<void>> _pendingSends = {};
  Disposable? _messageRegistration;
  var _closed = false;

  @override
  Stream<Object?> get messages => _messages.stream;

  /// Number of native message subscriptions still owned by this adapter.
  int get subscriptionCount => _messageRegistration == null ? 0 : 1;

  /// Number of native post-message promises that have not settled.
  int get pendingSendCount => _pendingSends.length;

  /// Completes with the first terminal native delivery failure.
  Future<Never> get failure => _failure.future;

  @override
  void send(Object? message) {
    if (_closed) {
      return;
    }
    late final Future<void> delivery;
    try {
      delivery = _webview.postMessageFuture(message.jsify()).then<void>((
        accepted,
      ) {
        if (!accepted) {
          throw StateError('VS Code rejected a Host-to-View message.');
        }
      });
    } on Object catch (error, stackTrace) {
      _recordFailure(error, stackTrace);
      return;
    }
    _pendingSends.add(delivery);
    unawaited(
      delivery.then<void>(
        (_) => _pendingSends.remove(delivery),
        onError: (Object error, StackTrace stackTrace) {
          _pendingSends.remove(delivery);
          _recordFailure(error, stackTrace);
        },
      ),
    );
  }

  void _recordFailure(Object error, StackTrace stackTrace) {
    if (!_failure.isCompleted) {
      _failure.completeError(error, stackTrace);
    }
  }

  /// Waits until every native post-message promise has settled.
  Future<void> drain() async {
    while (_pendingSends.isNotEmpty) {
      final pending = _pendingSends.toList();
      await Future.wait(
        pending.map(
          (send) =>
              send.then<void>((_) {}, onError: (Object _, StackTrace _) {}),
        ),
      );
    }
  }

  /// Removes the native listener and closes the Dart message stream.
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    Object? firstError;
    StackTrace? firstStackTrace;

    Future<void> preserveFirstError(FutureOr<void> Function() action) async {
      try {
        await action();
      } on Object catch (error, stackTrace) {
        firstError ??= error;
        firstStackTrace ??= stackTrace;
      }
    }

    final messageRegistration = _messageRegistration;
    _messageRegistration = null;
    await preserveFirstError(() => messageRegistration?.dispose());
    await preserveFirstError(drain);
    await preserveFirstError(_messages.close);
    if (firstError != null) {
      Error.throwWithStackTrace(firstError!, firstStackTrace!);
    }
  }
}

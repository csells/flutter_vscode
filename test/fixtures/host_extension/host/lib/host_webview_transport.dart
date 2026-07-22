import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_vscode_host_fixture/generated/view_protocol.g.dart';
import 'package:flutter_vscode_host_fixture/generated/vscode_facade.g.dart';

/// Fixture hook that observes one native message after protocol parsing.
typedef IncomingViewMessageObserver = void Function(Object? message);

/// Adapts one native VS Code webview to the shared protocol transport.
final class HostWebviewTransport
    implements ViewTransport, ViewTransportLifecycle {
  /// Starts listening to messages from the supplied VS Code webview.
  HostWebviewTransport(this._webview, [this._incomingMessageObserver]) {
    _messageRegistration = _webview.listenOnDidReceiveMessage(
      ((JSAny? message) {
        if (_closed || _receivingClosed) {
          return;
        }
        try {
          final incoming = message.dartify();
          _messages.add(incoming);
          _incomingMessageObserver?.call(incoming);
        } on Object {
          // Feed malformed external input through the protocol validator.
          _messages.add(null);
        }
      }).toJS,
    );
  }

  final Webview _webview;
  final IncomingViewMessageObserver? _incomingMessageObserver;
  final StreamController<Object?> _messages =
      StreamController<Object?>.broadcast(sync: true);
  final Completer<Never> _failure = Completer<Never>();
  final Set<Future<void>> _pendingSends = {};
  Disposable? _messageRegistration;
  var _receivingClosed = false;
  var _closed = false;
  var _closeCompleted = false;

  @override
  Stream<Object?> get messages => _messages.stream;

  /// Number of native message subscriptions still owned by this adapter.
  int get subscriptionCount => receivingSubscriptionCount;

  @override
  int get receivingSubscriptionCount => _messageRegistration == null ? 0 : 1;

  /// Number of native post-message promises that have not settled.
  int get pendingSendCount => _pendingSends.length;

  /// Completes with the first terminal native delivery failure.
  Future<Never> get failure => _failure.future;

  @override
  Future<void> send(Object? message) {
    if (_closed) {
      throw StateError('The Host webview transport is closed.');
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
      return Future.error(error, stackTrace);
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
    return delivery;
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
    if (_closeCompleted) {
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

    await preserveFirstError(closeReceiving);
    await preserveFirstError(drain);
    if (firstError != null) {
      Error.throwWithStackTrace(firstError!, firstStackTrace!);
    }
    _closeCompleted = true;
  }

  @override
  Future<void> closeReceiving() async {
    if (_receivingClosed) {
      return;
    }
    final messageRegistration = _messageRegistration;
    if (messageRegistration != null) {
      messageRegistration.disposeHostResource();
      _messageRegistration = null;
    }
    _receivingClosed = true;
    await _messages.close();
  }
}

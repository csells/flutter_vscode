import 'dart:async';
import 'dart:js_interop';

import 'package:coverage_treemap_host/generated/view_protocol.g.dart';
import 'package:coverage_treemap_host/generated/vscode_facade.g.dart';

/// Adapts one native VS Code webview to the shared protocol transport.
final class HostWebviewTransport
    implements ViewTransport, ViewTransportLifecycle {
  /// Starts listening to messages from the supplied VS Code webview.
  HostWebviewTransport(this._webview) {
    _messageRegistration = _webview.listenOnDidReceiveMessage(
      ((JSAny? message) {
        if (_closed || _receivingClosed) {
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
  final Set<Future<void>> _pendingSends = {};
  Disposable? _messageRegistration;
  var _receivingClosed = false;
  var _closed = false;

  @override
  Stream<Object?> get messages => _messages.stream;

  @override
  int get receivingSubscriptionCount => _messageRegistration == null ? 0 : 1;

  @override
  Future<void> send(Object? message) {
    if (_closed) {
      throw StateError('The Host webview transport is closed.');
    }
    final delivery = _webview.postMessageFuture(message.jsify()).then<void>((
      accepted,
    ) {
      if (!accepted) {
        throw StateError('VS Code rejected a Host-to-View message.');
      }
    });
    _pendingSends.add(delivery);
    unawaited(
      delivery.whenComplete(() => _pendingSends.remove(delivery)),
    );
    return delivery;
  }

  @override
  Future<void> closeReceiving() async {
    _receivingClosed = true;
    _messageRegistration?.dispose();
    _messageRegistration = null;
  }

  /// Stops the transport and releases the native message subscription.
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    await closeReceiving();
    await _messages.close();
  }
}

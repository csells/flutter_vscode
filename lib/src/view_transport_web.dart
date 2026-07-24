import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/widgets.dart';
import 'package:flutter_vscode/src/view_protocol.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:web/web.dart' as web;

/// Acquires and owns the transport for one VS Code-hosted Flutter View.
final class VSCodeViewBootstrap {
  VSCodeViewBootstrap._({
    required String sessionId,
    required String bootstrapNonce,
    required _VSCodeWebviewTransport transport,
  })  : _sessionId = sessionId,
        _bootstrapNonce = bootstrapNonce,
        _transport = transport;

  factory VSCodeViewBootstrap._create() {
    final sessionId = _requiredMetadata(sessionMetaName);
    final bootstrapNonce = _requiredMetadata(bootstrapNonceMetaName);
    late final _VSCodeApi api;
    try {
      api = _acquireVsCodeApi();
    } on Object catch (error) {
      throw StateError(
        'Could not acquire the private VS Code webview API. '
        'This Flutter View must run inside Host-generated VS Code HTML: $error',
      );
    }
    return VSCodeViewBootstrap._(
      sessionId: sessionId,
      bootstrapNonce: bootstrapNonce,
      transport: _VSCodeWebviewTransport(api),
    );
  }

  /// Acquires the private VS Code webview API exactly once.
  ///
  /// The Host-generated HTML must provide non-empty [sessionMetaName] and
  /// [bootstrapNonceMetaName] metadata before this constructor is called.
  factory VSCodeViewBootstrap.acquire() {
    return _instance ??= VSCodeViewBootstrap._create();
  }

  /// Metadata key containing the Host-created session identifier.
  static const sessionMetaName = 'flutter-vscode-session';

  /// Metadata key containing the Host-created bootstrap nonce.
  static const bootstrapNonceMetaName = 'flutter-vscode-bootstrap-nonce';

  static VSCodeViewBootstrap? _instance;

  final String _sessionId;
  final String _bootstrapNonce;
  final _VSCodeWebviewTransport _transport;
  Future<FlutterViewSession>? _connection;

  /// Native browser message listeners still owned by this bootstrap.
  int get receivingSubscriptionCount => _transport.receivingSubscriptionCount;

  /// Connects the Flutter View using Host-provided metadata.
  Future<FlutterViewSession> connect() {
    return _connection ??= FlutterViewSession.connect(
      transport: _transport,
      sessionId: _sessionId,
      bootstrapNonce: _bootstrapNonce,
    );
  }

  /// Removes the owned browser message listener.
  ///
  /// Await [FlutterViewSession.closed] before closing the transport during an
  /// orderly Host-requested shutdown.
  Future<void> close() => _transport.close();
}

final class _VSCodeWebviewTransport
    implements ViewTransport, ViewTransportLifecycle {
  _VSCodeWebviewTransport(this._api) {
    _messageListener = ((web.MessageEvent event) {
      if (_closed || _receivingClosed) {
        return;
      }
      try {
        final encoded = _jsonStringify(event.data);
        _messages.add(jsonDecode(encoded));
      } on Object {
        // Feed malformed external input to the protocol validator. It will
        // fail closed through the same typed invalid-message path.
        _messages.add(null);
      }
    }).toJS;
    web.window.addEventListener('message', _messageListener);
  }

  final _VSCodeApi _api;
  final StreamController<Object?> _messages =
      StreamController<Object?>.broadcast(sync: true);
  late final web.EventListener _messageListener;
  var _receivingClosed = false;
  var _closed = false;

  @override
  int get receivingSubscriptionCount => _receivingClosed ? 0 : 1;

  @override
  Stream<Object?> get messages => _messages.stream;

  @override
  Future<void> send(Object? message) {
    if (_closed) {
      throw StateError('The VS Code webview transport is closed.');
    }
    // acquireVsCodeApi().postMessage returns void. This confirms synchronous
    // handoff only; VS Code exposes no asynchronous acceptance result here.
    _api.postMessage(_jsonParse(jsonEncode(message)));
    return Future.value();
  }

  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    await closeReceiving();
  }

  @override
  Future<void> closeReceiving() async {
    if (_receivingClosed) {
      return;
    }
    _receivingClosed = true;
    web.window.removeEventListener('message', _messageListener);
    await _messages.close();
  }
}

@JS()
@staticInterop
class _VSCodeApi {}

extension on _VSCodeApi {
  external void postMessage(JSAny? message);
}

@JS('acquireVsCodeApi')
external _VSCodeApi _acquireVsCodeApi();

@JS('JSON.parse')
external JSAny? _jsonParse(String value);

@JS('JSON.stringify')
external String _jsonStringify(JSAny? value);

String _requiredMetadata(String name) {
  final element = web.document.querySelector('meta[name="$name"]');
  final value = (element as web.HTMLMetaElement?)?.content.trim();
  if (value == null || value.isEmpty) {
    throw StateError(
      'Host-generated VS Code HTML must provide non-empty '
      '<meta name="$name" content="…"> metadata.',
    );
  }
  return value;
}

/// Boots a Flutter View safely inside a VS Code webview.
///
/// Disables the web URL strategy before running [app]: a webview
/// document's real origin is `vscode-webview://`, so Flutter's default
/// strategy — exercised by `MaterialApp`'s navigation history
/// integration — throws a cross-origin `SecurityError` during engine
/// startup and the view never renders a frame.
void runFlutterView(Widget app) {
  setUrlStrategy(null);
  runApp(app);
}

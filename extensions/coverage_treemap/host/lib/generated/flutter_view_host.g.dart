// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: always_use_package_imports

import 'dart:async';
import 'dart:js_interop';
import 'dart:math';

import 'view_protocol.g.dart';
import 'vscode_facade.g.dart';

/// Observes each parsed native webview message after it is queued for
/// the protocol validator; harnesses use it to inspect traffic without
/// changing delivery.
typedef IncomingViewMessageObserver = void Function(Object? message);

/// Adapts one native VS Code webview to the shared protocol transport.
final class HostWebviewTransport
    implements ViewTransport, ViewTransportLifecycle {
  /// Starts listening to messages from the supplied VS Code webview.
  HostWebviewTransport(this._webview, [this._onIncomingMessage]) {
    _messageRegistration = _webview.listenOnDidReceiveMessage(
      ((JSAny? message) {
        if (_closed || _receivingClosed) {
          return;
        }
        try {
          final incoming = message.dartify();
          _messages.add(incoming);
          _onIncomingMessage?.call(incoming);
        } on Object {
          // Feed malformed external input through the protocol validator.
          _messages.add(null);
        }
      }).toJS,
    );
  }

  final Webview _webview;
  final IncomingViewMessageObserver? _onIncomingMessage;
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

/// One open Flutter View panel with a connected protocol session.
final class FlutterViewHost {
  /// Opens the built Flutter View named [viewName] (its folder under
  /// `views/`) in a webview panel and connects the protocol session.
  ///
  /// Owns panel creation, resource-root scoping, session identifiers,
  /// CSP-correct HTML, and disposal: when the user closes the panel,
  /// the session and transport close and [onClosed] fires.
  factory FlutterViewHost.open({
    required ExtensionContext context,
    required VSCode vscode,
    required String viewName,
    required String viewType,
    required String title,
    Iterable<ViewOperationBinding> operations = const [],
    void Function()? onClosed,
  }) {
    var viewRoot = context.extensionRootUri;
    for (final segment in ['out', 'views', viewName]) {
      viewRoot = joinHostUriPath(viewRoot, segment.toJS);
    }
    final panel = vscode.windowApi.createFlutterViewPanel(
      viewType: viewType,
      title: title,
      localResourceRoots: [viewRoot],
    );
    final transport = HostWebviewTransport(panel.webviewSurface);
    final sessionId = _secureToken();
    final bootstrapNonce = _secureToken();
    final session = HostViewSession.connect(
      transport: transport,
      sessionId: sessionId,
      bootstrapNonce: bootstrapNonce,
      operations: operations,
    );
    final host = FlutterViewHost._(panel, session, transport);
    panel.webviewSurface.htmlText = flutterViewHtml(
      webview: panel.webviewSurface,
      viewRoot: viewRoot,
      sessionId: sessionId,
      bootstrapNonce: bootstrapNonce,
      title: title,
    );
    panel.listenOnDidDispose(
      ((JSAny? _) {
        unawaited(host.close());
        onClosed?.call();
      }).toJS,
    );
    return host;
  }

  FlutterViewHost._(this.panel, this.session, this.transport);

  /// The native webview panel showing the view.
  final WebviewPanel panel;

  /// The connected versioned protocol session.
  final HostViewSession session;

  /// The transport backing [session].
  final HostWebviewTransport transport;

  var _closed = false;


  /// Closes the protocol session and transport.
  ///
  /// Safe to call more than once; panel disposal triggers it
  /// automatically.
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    await session.close();
    await transport.close();
  }
}

/// CSP-correct webview HTML that boots the built Flutter View under
/// [viewRoot] and carries the protocol bootstrap metadata.
String flutterViewHtml({
  required Webview webview,
  required Uri viewRoot,
  required String sessionId,
  required String bootstrapNonce,
  required String title,
}) {
  final base = webview.asFlutterViewUri(viewRoot).toDartString();
  final bootstrap = webview
      .asFlutterViewUri(joinHostUriPath(viewRoot, 'flutter_bootstrap.js'.toJS))
      .toDartString();
  final csp = webview.contentSecurityPolicySource;
  final safeTitle = title
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');
  return '''
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="Content-Security-Policy" content="default-src 'none'; img-src $csp data:; font-src $csp; style-src $csp 'unsafe-inline'; script-src $csp 'wasm-unsafe-eval'; connect-src $csp; worker-src $csp blob:">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="flutter-vscode-session" content="$sessionId">
  <meta name="flutter-vscode-bootstrap-nonce" content="$bootstrapNonce">
  <base href="$base/">
  <title>$safeTitle</title>
</head>
<body>
  <script src="$bootstrap"></script>
</body>
</html>
''';
}

String _secureToken() {
  final random = Random.secure();
  return List.generate(32, (_) => random.nextInt(16).toRadixString(16)).join();
}

import 'dart:async';
import 'dart:js_interop';
import 'dart:math';

import 'package:flutter_vscode_host_fixture/generated/view_protocol.g.dart';
import 'package:flutter_vscode_host_fixture/generated/vscode_facade.g.dart';
import 'package:flutter_vscode_host_fixture/host_webview_transport.dart';
import 'package:flutter_vscode_host_fixture_shared/fixture_view_contract.dart';

const _pingCommand = 'flutter-vscode.host-test.ping';
const _eventCountCommand = 'flutter-vscode.host-test.openEventCount';
const _unsubscribeCommand = 'flutter-vscode.host-test.unsubscribeOpenEvent';
const _identityCommand = 'flutter-vscode.host-test.hoverDocumentMatchedEvent';
const _failAsyncCommand = 'flutter-vscode.host-test.failAsync';
const _failSyncCommand = 'flutter-vscode.host-test.failSync';
const _jsPromiseSourceCommand = 'flutter-vscode.host-test.jsPromiseSource';
const _jsPromiseRoundTripCommand =
    'flutter-vscode.host-test.jsPromiseRoundTrip';
const _hoverReceivedCancellationTokenCommand =
    'flutter-vscode.host-test.hoverReceivedCancellationToken';
const _openFlutterViewCommand = 'flutter-vscode.host-test.openFlutterView';

const _readHostValueOperation = ViewOperation<ReadHostValueRequest, String>(
  name: readHostValueOperationName,
  encodeArguments: encodeReadHostValueRequest,
  decodeArguments: decodeReadHostValueRequest,
  encodeResult: encodeReadHostValueResult,
  decodeResult: decodeReadHostValueResult,
);

@JSExport()
class _VSCodeHostExtension {
  var _openEventCount = 0;
  Disposable? _openEventSubscription;
  TextDocument? _lastOpenedDocument;
  var _hoverDocumentMatchedEvent = false;
  var _hoverReceivedCancellationToken = false;

  JSPromise<JSAny?> activate(
    JSObject rawContext,
    JSObject rawVscode,
    JSBoolean failActivation,
  ) {
    return toHostPromise(
      Future<JSAny?>(() {
        try {
          final context = ExtensionContext.fromJS(rawContext);
          final vscode = VSCode.fromJS(rawVscode);
          final ping = (() {
            return Future<JSString>.value('pong from Dart'.toJS).toJS;
          }).toJS;

          final registration = vscode.commands.registerCommand(
            _pingCommand.toJS,
            ping,
          );
          context.subscriptions.toDart.add(registration);

          final jsPromiseRoundTrip = (() {
            final source = vscode.commands
                .executeCommand(_jsPromiseSourceCommand.toJS)
                .toDart;
            return toHostPromise(
              source.then<JSAny?>((value) {
                final text = (value! as JSString).toDart;
                return 'Dart received: $text'.toJS;
              }),
            );
          }).toJS;
          final jsPromiseRoundTripRegistration = vscode.commands
              .registerCommand(
                _jsPromiseRoundTripCommand.toJS,
                jsPromiseRoundTrip,
              );
          context.subscriptions.toDart.add(jsPromiseRoundTripRegistration);

          final failAsync = (() {
            return toHostPromise(
              Future<JSAny?>.error(
                StateError('Dart command failed intentionally'),
                StackTrace.current,
              ),
            );
          }).toJS;
          final failAsyncRegistration = vscode.commands.registerCommand(
            _failAsyncCommand.toJS,
            failAsync,
          );
          context.subscriptions.toDart.add(failAsyncRegistration);

          JSAny? failSyncCallback() {
            // A native JS Error must cross the synchronous host callback seam.
            // ignore: only_throw_errors
            throw JavaScriptError('Dart synchronous failure'.toJS);
          }

          final failSync = failSyncCallback.toJS;
          final failSyncRegistration = vscode.commands.registerCommand(
            _failSyncCommand.toJS,
            failSync,
          );
          context.subscriptions.toDart.add(failSyncRegistration);

          final provideHover =
              (
                    TextDocument document,
                    Position position,
                    CancellationToken token,
                  ) {
                    _hoverDocumentMatchedEvent = identical(
                      _lastOpenedDocument,
                      document,
                    );
                    _hoverReceivedCancellationToken =
                        !token.isCancellationRequested;
                    final contents = MarkdownString(
                      'Hover from Dart at ${position.line}:${position.character}'
                          .toJS,
                    );
                    final range = Range(0, 0, 0, 5);
                    return Hover(contents, range);
                  }
                  .toJS;
          final provider = HoverProvider(provideHover: provideHover);
          final providerRegistration = vscode.languages.registerHoverProvider(
            'plaintext'.toJS,
            provider,
          );
          context.subscriptions.toDart.add(providerRegistration);

          final onDidOpenDocument = ((TextDocument document) {
            _openEventCount += 1;
            _lastOpenedDocument = document;
          }).toJS;
          _openEventSubscription = vscode.workspace.onDidOpenTextDocument(
            onDidOpenDocument,
          );

          final eventCount = (() => _openEventCount.toJS).toJS;
          final eventCountRegistration = vscode.commands.registerCommand(
            _eventCountCommand.toJS,
            eventCount,
          );
          context.subscriptions.toDart.add(eventCountRegistration);

          final identityResult = (() => _hoverDocumentMatchedEvent.toJS).toJS;
          final identityRegistration = vscode.commands.registerCommand(
            _identityCommand.toJS,
            identityResult,
          );
          context.subscriptions.toDart.add(identityRegistration);

          final cancellationTokenResult =
              (() => _hoverReceivedCancellationToken.toJS).toJS;
          final cancellationTokenRegistration = vscode.commands.registerCommand(
            _hoverReceivedCancellationTokenCommand.toJS,
            cancellationTokenResult,
          );
          context.subscriptions.toDart.add(cancellationTokenRegistration);

          final unsubscribe = _disposeOpenEventSubscription.toJS;
          final unsubscribeRegistration = vscode.commands.registerCommand(
            _unsubscribeCommand.toJS,
            unsubscribe,
          );
          context.subscriptions.toDart.add(unsubscribeRegistration);

          final openFlutterView = (() => toHostPromise(
            _openView(context, vscode),
          )).toJS;
          final openFlutterViewRegistration = vscode.commands.registerCommand(
            _openFlutterViewCommand.toJS,
            openFlutterView,
          );
          context.subscriptions.toDart.add(openFlutterViewRegistration);
          if (failActivation.toDart) {
            throw StateError('Dart host activation failed intentionally');
          }
          return null;
        } catch (error) {
          _disposeOpenEventSubscription();
          Error.throwWithStackTrace(
            StateError('Host activation failed: $error'),
            StackTrace.current,
          );
        }
      }),
    );
  }

  JSPromise<JSAny?> deactivate() {
    return Future<JSAny?>(() {
      _disposeOpenEventSubscription();
      return null;
    }).toJS;
  }

  void _disposeOpenEventSubscription() {
    _openEventSubscription?.dispose();
    _openEventSubscription = null;
  }

  Future<JSAny?> _openView(ExtensionContext context, VSCode vscode) async {
    final sessionId = _secureToken();
    final bootstrapNonce = _secureToken();
    final viewRoot = _joinUri(context.extensionUri, const [
      'out',
      'views',
      'main',
    ]);
    final panel = vscode.window.createFlutterViewPanel(
      viewType: 'flutter-vscode.host-test.mainPanel',
      title: 'Flutter View Fixture',
      localResourceRoots: [viewRoot],
    );
    final resources = _ViewResources(panel);
    JSAny? result;
    Object? firstError;
    StackTrace? firstStackTrace;
    try {
      final transport = HostWebviewTransport(panel.webview);
      resources.transport = transport;
      final session = HostViewSession.connect(
        transport: transport,
        sessionId: sessionId,
        bootstrapNonce: bootstrapNonce,
        operations: [
          _readHostValueOperation.bind((request) {
            if (request.key != 'greeting') {
              throw ArgumentError.value(request.key, 'key');
            }
            return 'hello from Host Dart';
          }),
        ],
      );
      resources
        ..session = session
        ..panelDisposed = panel.listenOnDidDispose(
          (() {
            unawaited(
              resources
                  .cleanup(panelAlreadyDisposed: true)
                  .then<void>((_) {}, onError: (Object _, StackTrace _) {}),
            );
          }).toJS,
        );
      panel.webview.htmlText = _viewHtml(
        webview: panel.webview,
        viewRoot: viewRoot,
        sessionId: sessionId,
        bootstrapNonce: bootstrapNonce,
      );

      await _awaitViewMilestone(session.ready, transport);
      final rendered = await _awaitViewMilestone(session.rendered, transport);
      final viewCloseReport = await _awaitViewMilestone(
        session.shutdown(),
        transport,
      );
      await _awaitViewMilestone(session.closed, transport);
      if (viewCloseReport.pendingRequestCount != 0 ||
          viewCloseReport.subscriptionCount != 0) {
        throw StateError(
          'Flutter View reported live protocol work during shutdown.',
        );
      }
      await resources.cleanup();
      if (resources.pendingRequestCount != 0 ||
          resources.subscriptionCount != 0 ||
          resources.pendingSendCount != 0) {
        throw StateError('Host retained Flutter View resources after cleanup.');
      }
      result = <String, Object?>{
        'renderedValue': rendered,
        'closed': true,
        'viewPendingRequests': viewCloseReport.pendingRequestCount,
        'viewSubscriptions': viewCloseReport.subscriptionCount,
        'hostPendingRequests': resources.pendingRequestCount,
        'hostSubscriptions': resources.subscriptionCount,
        'hostPendingSends': resources.pendingSendCount,
      }.jsify();
    } on Object catch (error, stackTrace) {
      firstError = error;
      firstStackTrace = stackTrace;
    } finally {
      try {
        await resources.cleanup();
      } on Object catch (error, stackTrace) {
        firstError ??= error;
        firstStackTrace ??= stackTrace;
      }
    }
    if (firstError != null) {
      Error.throwWithStackTrace(firstError, firstStackTrace!);
    }
    return result;
  }
}

Future<T> _awaitViewMilestone<T>(
  Future<T> milestone,
  HostWebviewTransport transport,
) {
  return Future.any<T>([
    milestone,
    transport.failure,
  ]).timeout(const Duration(seconds: 30));
}

final class _ViewResources {
  _ViewResources(this.panel);

  final WebviewPanel panel;
  HostWebviewTransport? transport;
  HostViewSession? session;
  Disposable? panelDisposed;
  Future<void>? _cleanup;
  var _panelAlreadyDisposed = false;

  int get pendingRequestCount => session?.pendingRequestCount ?? 0;

  int get pendingSendCount => transport?.pendingSendCount ?? 0;

  int get subscriptionCount =>
      (session?.subscriptionCount ?? 0) +
      (transport?.subscriptionCount ?? 0) +
      (panelDisposed == null ? 0 : 1);

  Future<void> cleanup({bool panelAlreadyDisposed = false}) {
    _panelAlreadyDisposed |= panelAlreadyDisposed;
    return _cleanup ??= _cleanupOwned();
  }

  Future<void> _cleanupOwned() async {
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

    final currentSession = session;
    if (currentSession != null) {
      await preserveFirstError(currentSession.close);
      await preserveFirstError(() async {
        await currentSession.closed;
      });
    }
    final currentPanelDisposed = panelDisposed;
    panelDisposed = null;
    await preserveFirstError(() => currentPanelDisposed?.dispose());
    final currentTransport = transport;
    if (currentTransport != null) {
      await preserveFirstError(
        () => currentTransport.close().timeout(const Duration(seconds: 5)),
      );
    }
    if (!_panelAlreadyDisposed) {
      // Native JS interop extension-type member tear-offs are disallowed.
      // ignore: unnecessary_lambdas
      await preserveFirstError(() => panel.dispose());
    }
    if (firstError != null) {
      Error.throwWithStackTrace(firstError!, firstStackTrace!);
    }
  }
}

Uri _joinUri(Uri base, List<String> segments) {
  var result = base;
  for (final segment in segments) {
    result = Uri.joinPath(result, segment.toJS);
  }
  return result;
}

String _viewHtml({
  required Webview webview,
  required Uri viewRoot,
  required String sessionId,
  required String bootstrapNonce,
}) {
  final resourceRoot = webview.asWebviewUri(viewRoot).toDartString();
  final bootstrap = webview
      .asWebviewUri(Uri.joinPath(viewRoot, 'flutter_bootstrap.js'.toJS))
      .toDartString();
  final cspSource = webview.contentSecurityPolicySource;
  final cspNonce = _secureToken();
  return '''
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="Content-Security-Policy" content="default-src 'none'; img-src ${_html(cspSource)} data:; font-src ${_html(cspSource)}; style-src ${_html(cspSource)} 'unsafe-inline'; script-src ${_html(cspSource)} 'nonce-$cspNonce' 'wasm-unsafe-eval'; connect-src ${_html(cspSource)}; worker-src ${_html(cspSource)} blob:">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="flutter-vscode-session" content="${_html(sessionId)}">
  <meta name="flutter-vscode-bootstrap-nonce" content="${_html(bootstrapNonce)}">
  <base href="${_html(resourceRoot)}/">
  <title>Flutter View Fixture</title>
</head>
<body>
  <script nonce="$cspNonce" src="${_html(bootstrap)}"></script>
</body>
</html>
''';
}

String _secureToken() {
  final random = Random.secure();
  return List.generate(
    24,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}

String _html(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

void main() {
  registerHostExports(createJSInteropWrapper(_VSCodeHostExtension()));
}

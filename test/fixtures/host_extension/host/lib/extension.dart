import 'dart:js_interop';

import 'package:flutter_vscode_host_fixture/generated/vscode_facade.g.dart';

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
}

void main() {
  registerHostExports(createJSInteropWrapper(_VSCodeHostExtension()));
}

// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: always_use_package_imports

import 'dart:js_interop';

import 'vscode_parity.g.dart';

export 'host_exports.g.dart';
export 'vscode_parity.g.dart';
export 'vscode_runtime.g.dart';

/// Dart-friendly command helpers over the parity layer.
extension CommandsFacade on Commands {
  /// Registers a callback without an explicit JavaScript `this` value.
  Disposable registerCommandCallback(JSString command, JSFunction callback) =>
      registerCommand(command, callback);

  /// Executes [command] and converts its thenable to a Dart future.
  Future<JSAny?> executeCommandFuture(JSString command) =>
      executeCommand<JSAny?>(command).toDart;
}

/// Dart-friendly language feature helpers over the parity layer.
extension LanguagesFacade on Languages {
  /// Registers [provider] for a string document selector.
  Disposable registerHoverProviderForString(
    JSString selector,
    HoverProvider provider,
  ) => registerHoverProvider(selector, provider);
}

/// Dart-friendly workspace event helpers over the parity layer.
extension WorkspaceFacade on Workspace {
  /// Subscribes [listener] to opened text documents.
  Disposable listenOnDidOpenTextDocument(JSFunction listener) =>
      onDidOpenTextDocument(listener);
}

/// Dart-friendly Flutter View panel creation over the parity layer.
extension WindowFacade on Window {
  /// Creates a panel with scripts enabled and scoped local resource roots.
  WebviewPanel createFlutterViewPanel({
    required String viewType,
    required String title,
    required List<Uri> localResourceRoots,
    int viewColumn = ViewColumn.one,
  }) => createWebviewPanel(
    viewType.toJS,
    title.toJS,
    viewColumn,
    WebviewOptions(
      enableScripts: true,
      localResourceRoots: localResourceRoots.toJS,
    ),
  );
}

/// Dart-friendly URI helpers over VS Code's native URI values.
extension UriFacade on Uri {
  /// Serializes this URI to a Dart string.
  String toDartString({bool skipEncoding = false}) =>
      toUriString(skipEncoding).toDart;
}

/// Dart-friendly lifecycle helpers for a Flutter View panel.
extension WebviewPanelFacade on WebviewPanel {
  /// Subscribes [listener] to panel disposal.
  Disposable listenOnDidDispose(JSFunction listener) => onDidDispose(listener);
}

/// Dart-friendly messaging helpers for a Flutter View.
extension WebviewFacade on Webview {
  /// Current HTML as a Dart string.
  String get htmlText => html.toDart;

  /// Replaces the HTML from a Dart string.
  set htmlText(String value) => html = value.toJS;

  /// Content security policy source as a Dart string.
  String get contentSecurityPolicySource => cspSource.toDart;

  /// Posts [message] and reports whether it was accepted by the panel.
  Future<bool> postMessageFuture(JSAny? message) async =>
      (await postMessage(message).toDart).toDart;

  /// Subscribes [listener] to messages from the Flutter View.
  Disposable listenOnDidReceiveMessage(JSFunction listener) =>
      onDidReceiveMessage(listener);
}

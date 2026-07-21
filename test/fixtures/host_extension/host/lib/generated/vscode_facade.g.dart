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

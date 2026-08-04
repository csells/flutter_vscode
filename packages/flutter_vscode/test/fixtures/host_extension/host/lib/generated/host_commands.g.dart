// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: always_use_package_imports

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_vscode/vscode_dart.dart';

import 'vscode_runtime.g.dart';

/// An ordinary-Dart command handler.
///
/// [arguments] are the dartified invocation arguments, in order. VS
/// Code passes them variadically; up to eight are captured, and — a
/// compiled-JavaScript reality — absent, `null`, and `undefined`
/// trailing arguments are indistinguishable, so trailing nulls are
/// trimmed.
///
/// The returned value (or the value the returned Future completes
/// with) must be protocol-safe data: `null`, `bool`, `num`, `String`,
/// or a `List`/`Map` of protocol-safe data. Anything else fails the
/// command with an actionable error. A thrown error rejects the host
/// promise with mapped Dart stack frames.
typedef CommandHandler = FutureOr<Object?> Function(List<Object?> arguments);

/// Registers ordinary-Dart command handlers with VS Code.
///
/// One instance holds the two ambient values every registration needs
/// — the [ExtensionContext] whose subscriptions carry the
/// registration's lifetime and the generated API the native call rides
/// — so each call site declares only a command name and its behavior.
/// The module owns every interop seam: argument dartification, result
/// conversion, `toHostCallback`/`toHostPromise` stack mapping, and
/// `context.subscriptions` registration.
final class ExtensionCommands {
  /// Creates a registrar over the activation [context] and the
  /// generated [api].
  ExtensionCommands({required this.context, required this.api});

  /// The activation context whose subscriptions own registrations.
  final ExtensionContext context;

  /// The generated VS Code API the registrations ride.
  final VscodeApiDart api;

  /// Registers [handler] for the command [name].
  ///
  /// The registration is pushed onto [ExtensionContext.subscriptions],
  /// so it lives until the extension deactivates; the returned
  /// [Disposable] serves callers that dispose earlier.
  Disposable register(String name, CommandHandler handler) {
    final callback = toHostCallback(
      (([
        JSAny? a1,
        JSAny? a2,
        JSAny? a3,
        JSAny? a4,
        JSAny? a5,
        JSAny? a6,
        JSAny? a7,
        JSAny? a8,
      ]) {
        final raw = <JSAny?>[a1, a2, a3, a4, a5, a6, a7, a8];
        while (raw.isNotEmpty && raw.last.isUndefinedOrNull) {
          raw.removeLast();
        }
        final arguments = List<Object?>.unmodifiable(
          raw.map((argument) => argument.dartify()),
        );
        return toHostPromise(
          Future<JSAny?>(() async => _hostResult(name, await handler(arguments))),
        );
      }).toJS,
    );
    final registration = api.commands.registerCommand(name, callback);
    context.subscriptions.toDart.add(JSAnon_ffa2e03c40a2(registration));
    return registration;
  }

  static JSAny? _hostResult(String name, Object? result) {
    try {
      return result.jsify();
    } on Object catch (error) {
      throw StateError(
        'The "$name" command returned a ${result.runtimeType}, which cannot '
        'cross to the Extension Host. Return protocol-safe data: null, '
        'bool, num, String, or a List/Map of protocol-safe data. ($error)',
      );
    }
  }
}

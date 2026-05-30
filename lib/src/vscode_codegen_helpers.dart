/// Describes the return behavior of a VS Code command method.
enum VSCodeReturnKind {
  /// A synchronous void method.
  voidSync,

  /// A `Future<void>` method.
  futureVoid,

  /// A `Future<T>` method where `T` is not void.
  futureValue,
}

/// Builds the body of a generated Dart method that delegates to
// ignore: comment_references
/// [VSCodeControllerBase.sendCommand].
///
/// This helper is intentionally pure (string-in, string-out) so it can be
/// tested without `build_runner` or analyzer dependencies.
String buildDartSendCommandBody({
  required String? commandId,
  required String paramListExpression,
  required VSCodeReturnKind returnKind,
  String? futureValueType,
}) {
  switch (returnKind) {
    case VSCodeReturnKind.voidSync:
      return "  VSCodeControllerBase.sendCommand('$commandId', "
          '[$paramListExpression], expectsResponse: false,);';
    case VSCodeReturnKind.futureVoid:
      return "  return VSCodeControllerBase.sendCommand('$commandId', "
          '[$paramListExpression], expectsResponse: false,);';
    case VSCodeReturnKind.futureValue:
      final typeName = futureValueType ?? 'dynamic';
      // ignore: missing_whitespace_between_adjacent_strings this is a string concatenation
      return '  return VSCodeControllerBase.sendCommand<$typeName>'
          "('$commandId', [$paramListExpression], expectsResponse: true,);";
  }
}

/// Builds a single TypeScript command handler `case` block for use inside
/// the generated `handleCommand` switch.
///
// ignore: comment_references
/// This mirrors the behavior of [VSCodeTsGenerator] but is decoupled from
/// analyzer/build_runner so it can be unit tested in isolation.
String buildTsCommandHandler({
  required String? commandId,
  required bool isVoidLike,
  required int positionalParamCount,
}) {
  final params = List<String>.generate(
    positionalParamCount,
    (index) => 'params[$index]',
  ).join(', ');

  final buffer = StringBuffer()
    ..writeln("      case '$commandId': {")
    ..writeln(
      "        const fn = resolveVscodeFn('${_escapeTsString(commandId ?? '')}');",
    )
    ..writeln('        if (!fn) return;');

  if (isVoidLike) {
    buffer
      ..writeln('        void fn($params);')
      ..writeln('        return;');
  } else {
    buffer
      ..writeln('        const result = await fn($params);')
      ..writeln('        if (requestId) {')
      ..writeln('          void webview.postMessage({ requestId, result });')
      ..writeln('        }')
      ..writeln('        return;');
  }

  buffer.writeln('      }');
  return buffer.toString();
}

String _escapeTsString(String value) => value.replaceAll("'", r"\'");

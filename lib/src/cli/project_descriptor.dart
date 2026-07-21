import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// Reads the deliberately restricted Dart-owned extension descriptor.
///
/// The descriptor uses Dart literal syntax so Extension Authors stay in Dart,
/// but it is parsed as data. Project code is never loaded or executed.
Future<Map<String, Object?>> readProjectDescriptor(File descriptor) async {
  final result = parseString(
    content: await descriptor.readAsString(),
    path: descriptor.path,
    throwIfDiagnostics: false,
  );
  if (result.errors.isNotEmpty ||
      result.unit.directives.isNotEmpty ||
      result.unit.declarations.length != 1) {
    throw const FormatException(
      'extension.dart must contain only a const literal map named extension.',
    );
  }

  final declaration = result.unit.declarations.single;
  if (declaration is! TopLevelVariableDeclaration ||
      declaration.augmentKeyword != null ||
      declaration.externalKeyword != null ||
      declaration.metadata.isNotEmpty ||
      !declaration.variables.isConst ||
      declaration.variables.metadata.isNotEmpty ||
      declaration.variables.variables.length != 1) {
    throw const FormatException(
      'extension.dart must contain only a const literal map named extension.',
    );
  }
  final variable = declaration.variables.variables.single;
  if (variable.name.lexeme != 'extension' || variable.initializer == null) {
    throw const FormatException(
      'extension.dart must contain only a const literal map named extension.',
    );
  }

  final value = _readLiteral(variable.initializer!);
  if (value is! Map<String, Object?>) {
    throw const FormatException(
      'extension.dart must contain only a const literal map named extension.',
    );
  }
  return value;
}

Object? _readLiteral(Expression expression) {
  return switch (expression) {
    SimpleStringLiteral() => expression.value,
    BooleanLiteral() => expression.value,
    IntegerLiteral() when expression.value != null => expression.value,
    DoubleLiteral() => expression.value,
    NullLiteral() => null,
    ListLiteral() => _readList(expression),
    SetOrMapLiteral() => _readMap(expression),
    _ => throw const FormatException(
        'extension.dart must contain only a const literal map; function '
        'calls, references, interpolation, and collection control flow are '
        'not supported.',
      ),
  };
}

List<Object?> _readList(ListLiteral literal) {
  final values = <Object?>[];
  for (final element in literal.elements) {
    if (element is! Expression) {
      throw const FormatException(
        'extension.dart list values must be literal values.',
      );
    }
    values.add(_readLiteral(element));
  }
  return values;
}

Map<String, Object?> _readMap(SetOrMapLiteral literal) {
  final values = <String, Object?>{};
  for (final element in literal.elements) {
    if (element is! MapLiteralEntry ||
        element.keyQuestion != null ||
        element.valueQuestion != null ||
        element.key is! SimpleStringLiteral) {
      throw const FormatException(
        'extension.dart map entries must use unique literal string keys and '
        'literal values.',
      );
    }
    final key = (element.key as SimpleStringLiteral).value;
    if (values.containsKey(key)) {
      throw FormatException(
        'extension.dart contains the duplicate map key "$key".',
      );
    }
    values[key] = _readLiteral(element.value);
  }
  return values;
}

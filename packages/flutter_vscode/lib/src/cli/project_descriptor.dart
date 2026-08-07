import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// The one library an extension descriptor may import.
const _manifestLibrary = 'package:flutter_vscode/manifest.dart';

/// The actionable declaration every descriptor error points back to.
const _guidance =
    'Declare a single top-level '
    'const extension = ExtensionManifest(...) using the types from '
    "'$_manifestLibrary'; the CLI parses it as data and never executes "
    'project code.';

/// The literal-value rules shared by every argument position.
const _literalRules =
    'extension.dart manifest values must be constant '
    'literals; references, interpolation, function calls, and collection '
    'control flow are not supported.';

/// The constant shape of one manifest type the parser reads as data.
///
/// [defaults] mirrors the const default values `lib/manifest.dart` declares,
/// so an omitted optional argument parses to the same data the analyzer
/// sees; [fieldOrder] fixes the output map's key order.
final class _ConstShape {
  const _ConstShape({
    required this.typeName,
    required this.requiredFields,
    required this.defaults,
    required this.fieldOrder,
  });

  final String typeName;
  final Set<String> requiredFields;
  final Map<String, Object?> defaults;
  final List<String> fieldOrder;
}

const _manifestShape = _ConstShape(
  typeName: 'ExtensionManifest',
  requiredFields: {
    'name',
    'displayName',
    'description',
    'version',
    'publisher',
    'activationEvents',
  },
  defaults: {
    'schemaVersion': 1,
    'commands': <Object?>[],
    'viewsContainers': <String, Object?>{},
    'views': <String, Object?>{},
    'configuration': null,
  },
  fieldOrder: [
    'schemaVersion',
    'name',
    'displayName',
    'description',
    'version',
    'publisher',
    'activationEvents',
    'commands',
    'viewsContainers',
    'views',
    'configuration',
  ],
);

const _commandShape = _ConstShape(
  typeName: 'ExtensionCommand',
  requiredFields: {'command', 'title'},
  defaults: {},
  fieldOrder: ['command', 'title'],
);

const _viewContainerShape = _ConstShape(
  typeName: 'ExtensionViewContainer',
  requiredFields: {'id', 'title', 'icon'},
  defaults: {},
  fieldOrder: ['id', 'title', 'icon'],
);

const _viewShape = _ConstShape(
  typeName: 'ExtensionView',
  requiredFields: {'id', 'name', 'icon'},
  defaults: {
    'type': null,
    'when': null,
    'visibility': null,
    'contextualTitle': null,
    'initialSize': null,
  },
  fieldOrder: [
    'id',
    'name',
    'icon',
    'type',
    'when',
    'visibility',
    'contextualTitle',
    'initialSize',
  ],
);

const _configurationShape = _ConstShape(
  typeName: 'ExtensionConfiguration',
  requiredFields: {'properties'},
  defaults: {'title': null, 'order': null},
  fieldOrder: ['title', 'order', 'properties'],
);

/// Reads the deliberately restricted Dart-owned extension descriptor.
///
/// The descriptor declares `const extension = ExtensionManifest(...)` using
/// the types from `package:flutter_vscode/manifest.dart`, so Extension
/// Authors get analyzer completion and type-checking — but the CLI parses
/// the constant invocation as data. Project code is never loaded or
/// executed.
Future<Map<String, Object?>> readProjectDescriptor(File descriptor) async {
  final result = parseString(
    content: await descriptor.readAsString(),
    path: descriptor.path,
    throwIfDiagnostics: false,
  );
  if (result.errors.isNotEmpty) {
    throw const FormatException(
      'extension.dart contains a Dart syntax error. $_guidance',
    );
  }
  for (final directive in result.unit.directives) {
    if (directive is! ImportDirective ||
        directive.prefix != null ||
        directive.deferredKeyword != null ||
        directive.uri.stringValue != _manifestLibrary) {
      throw const FormatException(
        "extension.dart may import only '$_manifestLibrary'. $_guidance",
      );
    }
  }
  if (result.unit.declarations.length != 1) {
    throw const FormatException(
      'extension.dart must contain exactly one declaration. $_guidance',
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
      'extension.dart must declare one const value named extension. '
      '$_guidance',
    );
  }
  final variable = declaration.variables.variables.single;
  final initializer = variable.initializer;
  if (variable.name.lexeme != 'extension' || initializer == null) {
    throw const FormatException(
      'extension.dart must declare one const value named extension. '
      '$_guidance',
    );
  }
  if (initializer is SetOrMapLiteral) {
    throw const FormatException(
      'extension.dart declares the retired map-literal descriptor. '
      '$_guidance',
    );
  }
  final manifest = _asInvocationOf(initializer, _manifestShape.typeName);
  if (manifest == null) {
    throw FormatException(
      'extension.dart must initialize extension with '
      '${_manifestShape.typeName}(...). $_guidance',
    );
  }
  return _readInvocation(manifest, _manifestShape);
}

/// Returns [expression]'s argument list when it invokes [typeName] without
/// a target, prefix, type arguments, or named constructor.
ArgumentList? _asInvocationOf(Expression expression, String typeName) {
  return switch (expression) {
    MethodInvocation(
      target: null,
      typeArguments: null,
      :final methodName,
      :final argumentList,
    )
        when methodName.name == typeName =>
      argumentList,
    InstanceCreationExpression(:final constructorName, :final argumentList)
        when constructorName.type.importPrefix == null &&
            constructorName.type.name.lexeme == typeName &&
            constructorName.type.typeArguments == null &&
            constructorName.name == null =>
      argumentList,
    _ => null,
  };
}

/// Reads one const invocation of [shape] into its descriptor map.
Map<String, Object?> _readInvocation(
  ArgumentList arguments,
  _ConstShape shape,
) {
  final known = {...shape.requiredFields, ...shape.defaults.keys};
  final values = <String, Object?>{};
  for (final argument in arguments.arguments) {
    if (argument is! NamedExpression) {
      throw FormatException(
        '${shape.typeName} arguments must all be named, found the '
        'positional argument $argument.',
      );
    }
    final name = argument.name.label.name;
    if (!known.contains(name)) {
      final supported = known.toList()..sort();
      throw FormatException(
        '${shape.typeName} has no "$name" parameter. Supported parameters: '
        '${supported.join(', ')}.',
      );
    }
    if (values.containsKey(name)) {
      throw FormatException(
        '${shape.typeName} passes the duplicate argument "$name".',
      );
    }
    values[name] = _readValue(argument.expression);
  }
  final missing = shape.requiredFields.difference(values.keys.toSet()).toList()
    ..sort();
  if (missing.isNotEmpty) {
    throw FormatException(
      '${shape.typeName} is missing the required '
      '${missing.length == 1 ? 'argument' : 'arguments'} '
      '${missing.join(', ')}.',
    );
  }
  return {
    for (final field in shape.fieldOrder)
      if (values.containsKey(field))
        field: values[field]
      else if (shape.defaults.containsKey(field))
        field: shape.defaults[field],
  };
}

Object? _readValue(Expression expression) {
  for (final shape in const [
    _commandShape,
    _viewContainerShape,
    _viewShape,
    _configurationShape,
  ]) {
    final invocation = _asInvocationOf(expression, shape.typeName);
    if (invocation != null) {
      return _readInvocation(invocation, shape);
    }
  }
  return switch (expression) {
    SimpleStringLiteral() => expression.value,
    AdjacentStrings() => _readAdjacentStrings(expression),
    BooleanLiteral() => expression.value,
    IntegerLiteral() when expression.value != null => expression.value,
    DoubleLiteral() => expression.value,
    NullLiteral() => null,
    ListLiteral() => _readList(expression),
    SetOrMapLiteral() => _readMap(expression),
    _ => throw const FormatException(_literalRules),
  };
}

Map<String, Object?> _readMap(SetOrMapLiteral literal) {
  final values = <String, Object?>{};
  for (final element in literal.elements) {
    if (element is! MapLiteralEntry) {
      throw const FormatException(_literalRules);
    }
    final key = element.key;
    if (key is! SimpleStringLiteral) {
      throw const FormatException(
        'extension.dart map keys must be simple string literals. '
        '$_literalRules',
      );
    }
    if (values.containsKey(key.value)) {
      throw FormatException(
        'extension.dart declares the duplicate map key "${key.value}".',
      );
    }
    values[key.value] = _readValue(element.value);
  }
  return values;
}

String _readAdjacentStrings(AdjacentStrings literal) {
  final parts = StringBuffer();
  for (final part in literal.strings) {
    if (part is! SimpleStringLiteral) {
      throw const FormatException(_literalRules);
    }
    parts.write(part.value);
  }
  return parts.toString();
}

List<Object?> _readList(ListLiteral literal) {
  final values = <Object?>[];
  for (final element in literal.elements) {
    if (element is! Expression) {
      throw const FormatException(_literalRules);
    }
    values.add(_readValue(element));
  }
  return values;
}

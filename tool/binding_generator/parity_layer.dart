/// Emits the complete typed Parity Layer from the pinned canonical IR.
///
/// Every rule in this emitter is a Total Mapping Rule (ADR 0012): a
/// judgment-free, deterministic mapping from one class of TypeScript
/// construct to `dart:js_interop` code, applied to every occurrence. A
/// construct with no rule fails generation with an actionable error;
/// nothing is approximated. Strategy and per-construct precedent:
/// `specs/research/js-to-dart-mapping.md`.
///
/// The emitted layer is rooted in the module object an extension receives
/// at activation (`VscodeApi`); it introduces no globals. External members
/// use ordinary Dart primitives where blessed; generated helpers (tuple
/// accessors, constructors, rest-parameter calls, call signatures) use JS
/// types throughout so every value is boundary-safe by construction.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

/// A construct reached the emitter without a Total Mapping Rule.
final class ParityGenerationException implements Exception {
  /// Creates an actionable totality failure.
  ParityGenerationException(this.declarationId, this.message);

  /// The IR declaration that could not be mapped.
  final String declarationId;

  /// What rule is missing.
  final String message;

  @override
  String toString() => 'PARITY_TOTALITY_ERROR: $declarationId: $message';
}

/// The generated artifacts: the Dart library and the disposition ledger.
typedef ParityArtifacts = ({String library, String ledger});

/// The canonical Construct Classes: one per Total Mapping Rule. Live
/// coverage requires a tagged real-host probe per class unless the class
/// appears in [parityLiveExemptions] with a reason.
const parityConstructClasses = [
  'mixed-union',
  'string-literal-union',
  'overload-set',
  'reserved-name',
  'underscore-name',
  'numeric-enum',
  'tuple',
  'index-signature',
  'rest-parameter',
  'promise-thenable',
  'array',
  'declared-constructor',
  'default-constructor',
  'object-literal-factory',
  'type-literal',
  'intersection',
  'call-signature',
  'readonly-property',
  'optional-member',
  'stable-typedef',
  'narrowing',
  'external-setter',
  'function-type',
];

/// Construct Classes exempt from live probing, each with its reason.
const parityLiveExemptions = {
  'string-literal-union':
      'zero occurrences in the pinned baseline; rule proven on synthetic IR',
  'readonly-property':
      'the rule is the absence of a setter, provable only at compile time',
  'underscore-name':
      'the only baseline sites are deprecated internal fields with no '
          'stable behavior to observe',
};

const _reservedWords = {
  'assert', 'break', 'case', 'catch', 'class', 'const', 'continue',
  'default', 'do', 'else', 'enum', 'extends', 'false', 'final', 'finally',
  'for', 'if', 'in', 'is', 'new', 'null', 'rethrow', 'return', 'super',
  'switch', 'this', 'throw', 'true', 'try', 'var', 'void', 'while', 'with',
  // Object core members that extension types may not redeclare compatibly.
  'toString', 'hashCode', 'runtimeType', 'noSuchMethod',
};

/// Builds the Parity Layer library and its totality ledger from IR JSON.
ParityArtifacts emitParityLayer(Map<String, Object?> inventory) {
  return ParityEmitter(inventory).emit();
}

/// The Parity Layer emitter.
///
/// Public so that the dart-layer emitter (`dart_layer.dart`) can reuse the
/// exact same IR walk, registries, and Total Mapping Rules when it layers
/// Dart-first ergonomics over the parity surface; the parity output itself
/// is produced only through [emitParityLayer].
final class ParityEmitter {
  /// Indexes the IR declarations for emission.
  ParityEmitter(Map<String, Object?> inventory)
      : declarations = [
          for (final declaration in inventory['declarations']! as List<Object?>)
            (declaration! as Map<Object?, Object?>).cast<String, Object?>(),
        ] {
    for (final declaration in declarations) {
      byId[declaration['id']! as String] = declaration;
      childrenByParent
          .putIfAbsent(declaration['parentId']! as String, () => [])
          .add(declaration);
    }
    for (final declaration in declarations) {
      final parent = declaration['parentId']! as String;
      if (parent == 'module:vscode' || parent == 'global:global') {
        topLevelByName[declaration['name']! as String] = declaration;
      }
    }
  }

  /// The IR declarations in pinned order.
  final List<Map<String, Object?>> declarations;

  /// Declarations indexed by IR id.
  final byId = <String, Map<String, Object?>>{};

  /// Child declarations indexed by their parent id.
  final childrenByParent = <String, List<Map<String, Object?>>>{};

  /// Module- and global-rooted declarations indexed by name.
  final topLevelByName = <String, Map<String, Object?>>{};

  /// Generated tuple extension types by name.
  final tupleTypes = <String, String>{};

  /// Mapped element types of each generated tuple, by tuple name.
  final tupleElements = <String, List<String>>{};

  /// Generated string-literal wrapper types by name.
  final literalWrappers = <String, String>{};

  /// Generated anonymous-shape extension types by name.
  final anonTypes = <String, String>{};

  /// Whether scoped type-parameter references currently erase to `JSAny?`
  /// (active inside registered helper types, which hoist to the top level
  /// where no type parameters are in scope).
  bool eraseScopeReferences = false;

  /// Generated intersection extension types by name.
  final intersectionTypes = <String, String>{};

  /// The per-declaration disposition ledger.
  final dispositions = <String, String>{};

  static const _externalReferenceMap = {
    'Uint8Array': 'JSUint8Array',
    'Uint32Array': 'JSUint32Array',
    'Record': 'JSObject',
    'RegExp': 'JSObject',
    'Error': 'JSObject',
    'Iterable': 'JSObject',
    'AsyncIterable': 'JSObject',
    'IterableIterator': 'JSObject',
    'Date': 'JSObject',
  };

  /// Emits the parity library and ledger, populating every registry.
  ParityArtifacts emit() {
    _computeDispositions();

    final namespaces = StringBuffer();
    // Thenable itself is mapped to JSPromise (its ledger disposition);
    // the typedef ships so author code can keep the upstream name.
    if (topLevelByName.containsKey('Thenable')) {
      namespaces
        ..writeln('typedef Thenable<T extends JSAny?> = JSPromise<T>;')
        ..writeln();
    }
    final interfaces = StringBuffer();
    final classes = StringBuffer();
    final enums = StringBuffer();
    final typedefs = StringBuffer();
    final anonTypes = StringBuffer();
    final root = StringBuffer();

    for (final declaration in declarations) {
      if (dispositions[declaration['id']! as String] != 'emitted') {
        continue;
      }
      final parent = declaration['parentId']! as String;
      final topLevel = parent == 'module:vscode' || parent == 'global:global';
      switch (declaration['kind']) {
        case 'typeAlias' when topLevel:
          _emitAlias(declaration, typedefs);
        case 'enum' when topLevel:
          _emitEnum(declaration, typedefs, enums);
        case 'namespace' when topLevel:
          _emitNamespace(declaration, namespaces);
        case 'interface' when topLevel:
          _emitInterface(declaration, interfaces);
        case 'class' when topLevel:
          _emitClass(declaration, classes);
        case 'typeLiteral':
          _emitTypeLiteral(declaration, anonTypes);
        case 'variable' when parent == 'module:vscode':
        case 'interface' || 'class' || 'enum' || 'typeAlias' || 'namespace':
        case 'property' ||
              'method' ||
              'constructor' ||
              'function' ||
              'variable' ||
              'enumMember' ||
              'indexSignature' ||
              'callSignature':
          break; // Emitted as part of an owning surface.
        default:
          throw ParityGenerationException(
            declaration['id']! as String,
            'no Total Mapping Rule for declaration kind '
            "${declaration['kind']}",
          );
      }
    }

    final stableTypedefs = StringBuffer();
    final typedefCounters = <String, int>{};
    for (final declaration in declarations) {
      if (declaration['kind'] != 'typeLiteral' || !isEmitted(declaration)) {
        continue;
      }
      final base = _stableLiteralBase(declaration);
      final ordinal = typedefCounters.update(
        base,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      final target = hashName('JSAnon', declaration['shapeHash']);
      stableTypedefs.writeln('typedef $base\$$ordinal = $target;');
    }
    if (stableTypedefs.isNotEmpty) {
      stableTypedefs.writeln();
    }

    _emitRoot(root);

    final library = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
      ..writeln('//')
      ..writeln('// The complete typed VS Code Parity Layer (ADR 0012),')
      ..writeln('// produced only by Total Mapping Rules. Regenerate with:')
      ..writeln('//   dart tool/binding_generator/generate.dart '
          '--parity-layer .')
      ..writeln('//')
      ..writeln('// JS `undefined` and `null` both surface as Dart `null`')
      ..writeln('// (documented platform-wide conflation).')
      ..writeln('// ignore_for_file: type=lint')
      ..writeln("import 'dart:js_interop';")
      ..writeln("import 'dart:js_interop_unsafe';")
      ..writeln()
      ..write(typedefs)
      ..write(stableTypedefs)
      ..write(_sortedValues(tupleTypes))
      ..write(_sortedValues(literalWrappers))
      ..write(_sortedValues(intersectionTypes))
      ..write(anonTypes)
      ..write(enums)
      ..write(namespaces)
      ..write(interfaces)
      ..write(classes)
      ..write(root);

    final ledger = const JsonEncoder.withIndent('  ').convert({
      'schemaVersion': 1,
      'dispositions': dispositions,
    });
    return (library: library.toString(), ledger: '$ledger\n');
  }

  String _sortedValues(Map<String, String> registry) {
    final names = registry.keys.toList()..sort();
    return names.map((name) => registry[name]!).join();
  }

  // ---------------------------------------------------------------- ledger

  void _computeDispositions() {
    final thenable = topLevelByName['Thenable'];
    bool underThenable(Map<String, Object?> declaration) {
      var parent = declaration['parentId'] as String?;
      while (parent != null) {
        if (thenable != null && parent == thenable['id']) {
          return true;
        }
        parent = byId[parent]?['parentId'] as String?;
      }
      return false;
    }

    bool underSymbolKeyed(Map<String, Object?> declaration) {
      Map<String, Object?>? cursor = declaration;
      while (cursor != null) {
        final name = cursor['name'];
        if (name is String && name.startsWith('[')) {
          return true;
        }
        cursor = byId[cursor['parentId']];
      }
      return false;
    }

    for (final declaration in declarations) {
      final id = declaration['id']! as String;
      if (declaration['visibility'] != 'public') {
        dispositions[id] = 'non-public';
      } else if (thenable != null &&
          (id == thenable['id'] || underThenable(declaration))) {
        dispositions[id] = 'thenable-as-jspromise';
      } else if (underSymbolKeyed(declaration)) {
        dispositions[id] = 'symbol-keyed-member';
      } else {
        dispositions[id] = 'emitted';
      }
    }
  }

  /// Whether [declaration] carries the `emitted` parity disposition.
  bool isEmitted(Map<String, Object?> declaration) =>
      dispositions[declaration['id']! as String] == 'emitted';

  // ----------------------------------------------------------------- names

  /// Maps a JS name to its mangled Dart name (reserved words, underscores).
  String dartName(String jsName) {
    var name = jsName;
    if (name.startsWith('_')) {
      name = '\$$name';
    }
    if (_reservedWords.contains(name)) {
      name = '$name\$';
    }
    return name;
  }

  /// The Dart member name for [declaration], including overload suffixes.
  String memberName(Map<String, Object?> declaration) {
    final base = dartName(declaration['name']! as String);
    final ordinal = declaration['overloadOrdinal'];
    if (ordinal is int && ordinal > 0) {
      return '$base\$${ordinal + 1}';
    }
    return base;
  }

  String? _jsRename(Map<String, Object?> declaration, String dartName) {
    final jsName = declaration['name']! as String;
    return dartName == jsName ? null : jsName;
  }

  /// The generated extension-type name for a namespace.
  String namespaceTypeName(String name) =>
      '${name[0].toUpperCase()}${name.substring(1)}Ns';

  /// A readable, deterministic alias base from the literal's named
  /// ancestor chain (e.g. class Position, member `with` ->
  /// `PositionWith`); occurrence ordinals disambiguate siblings.
  String _stableLiteralBase(Map<String, Object?> declaration) {
    final segments = <String>[];
    var cursor = byId[declaration['parentId']];
    while (cursor != null) {
      final name = cursor['name'];
      if (name is String && cursor['kind'] != 'typeLiteral') {
        final clean = name.replaceAll(RegExp('[^A-Za-z0-9]'), '');
        if (clean.isNotEmpty) {
          segments.add(
            clean[0].toUpperCase() + clean.substring(1),
          );
        }
      }
      cursor = byId[cursor['parentId']];
    }
    final base = segments.reversed.join();
    if (base.isEmpty || RegExp('^[0-9]').hasMatch(base)) {
      return 'Anon$base';
    }
    return base;
  }

  /// A deterministic hash-derived type name for a canonical shape.
  String hashName(String prefix, Object? shape) {
    final digest = sha256.convert(utf8.encode(jsonEncode(shape))).toString();
    return '${prefix}_${digest.substring(0, 12)}';
  }

  /// The type-parameter scopes visible from [declaration].
  List<Set<String>> scopesFor(Map<String, Object?> declaration) {
    final scopes = <Set<String>>[];
    Map<String, Object?>? cursor = declaration;
    while (cursor != null) {
      final parameters = cursor['typeParameters'];
      if (parameters is List<Object?>) {
        scopes.add({
          for (final parameter in parameters)
            (parameter! as Map<Object?, Object?>)['name']! as String,
        });
      }
      cursor = byId[cursor['parentId']];
    }
    return scopes;
  }

  /// The Dart type-parameter clause for [declaration], or the empty string.
  String typeParameterClause(Map<String, Object?> declaration) {
    final parameters = declaration['typeParameters'];
    if (parameters is! List<Object?> || parameters.isEmpty) {
      return '';
    }
    final names = [
      for (final parameter in parameters)
        (parameter! as Map<Object?, Object?>)['name']! as String,
    ];
    return '<${names.map((name) => '$name extends JSAny?').join(', ')}>';
  }

  // ----------------------------------------------------------------- types

  /// Maps one IR type node to a Dart type.
  ///
  /// [generic] selects JS-typed form (valid inside generics and helpers)
  /// over the primitive-friendly external form.
  String mapType(
    Object? node, {
    required bool generic,
    required List<Set<String>> scopes,
    required String context,
  }) {
    if (node is! Map<Object?, Object?>) {
      throw ParityGenerationException(context, 'non-object type node');
    }
    final type = node.cast<String, Object?>();
    switch (type['kind']) {
      case 'primitive':
        return _mapPrimitive(type['name']! as String, generic, context);
      case 'literal':
        final value = type['value'];
        if (value is String) {
          return generic ? 'JSString' : 'String';
        }
        if (value is num) {
          return generic ? 'JSNumber' : 'num';
        }
        if (value is bool) {
          return generic ? 'JSBoolean' : 'bool';
        }
        return 'JSAny?';
      case 'reference':
        return _mapReference(
          type,
          generic: generic,
          scopes: scopes,
          context: context,
        );
      case 'array':
        final element = mapType(
          type['elementType'],
          generic: true,
          scopes: scopes,
          context: context,
        );
        return 'JSArray<${nullableForGeneric(element)}>';
      case 'union':
        return _mapUnion(
          type,
          generic: generic,
          scopes: scopes,
          context: context,
        );
      case 'intersection':
        return _registerIntersection(type, scopes: scopes, context: context);
      case 'tuple':
        return _registerTuple(type, scopes: scopes, context: context);
      case 'typeLiteral':
        final id = type['id'];
        if (id is String) {
          final declaration = byId[id];
          if (declaration == null) {
            throw ParityGenerationException(
              context,
              'reference to unregistered type literal $id',
            );
          }
          return hashName('JSAnon', declaration['shapeHash']);
        }
        return 'JSObject';
      case 'function':
        return 'JSFunction';
      case 'operator':
        if (type['operator'] == 'readonly') {
          return mapType(
            type['type'],
            generic: generic,
            scopes: scopes,
            context: context,
          );
        }
        throw ParityGenerationException(
          context,
          'no Total Mapping Rule for type operator ${type['operator']}',
        );
      default:
        throw ParityGenerationException(
          context,
          'no Total Mapping Rule for type kind ${type['kind']}',
        );
    }
  }

  String _mapPrimitive(String name, bool generic, String context) {
    switch (name) {
      case 'string':
        return generic ? 'JSString' : 'String';
      case 'number':
        return generic ? 'JSNumber' : 'num';
      case 'boolean':
        return generic ? 'JSBoolean' : 'bool';
      case 'void':
        return generic ? 'JSAny?' : 'void';
      case 'any' || 'unknown' || 'null' || 'undefined' || 'never':
        return 'JSAny?';
      case 'object':
        return 'JSObject';
      case 'symbol':
        return 'JSSymbol';
      case 'bigint':
        return 'JSBigInt';
      default:
        throw ParityGenerationException(
          context,
          'no Total Mapping Rule for primitive $name',
        );
    }
  }

  String _mapReference(
    Map<String, Object?> type, {
    required bool generic,
    required List<Set<String>> scopes,
    required String context,
  }) {
    final name = type['name']! as String;
    final arguments = (type['typeArguments'] as List<Object?>?) ?? const [];

    for (final scope in scopes) {
      if (scope.contains(name)) {
        return eraseScopeReferences ? 'JSAny?' : name;
      }
    }
    if (name.contains('.')) {
      final prefix = name.split('.').first;
      final target = topLevelByName[prefix];
      if (target != null && target['kind'] == 'enum') {
        return generic ? 'JSNumber' : 'int';
      }
      throw ParityGenerationException(
        context,
        'no Total Mapping Rule for dotted reference $name',
      );
    }
    if (name == 'Thenable' || name == 'PromiseLike' || name == 'Promise') {
      final argument = arguments.isEmpty
          ? 'JSAny?'
          : mapType(
              arguments.first,
              generic: true,
              scopes: scopes,
              context: context,
            );
      return 'JSPromise<${nullableForGeneric(argument)}>';
    }
    if (name == 'Array' || name == 'ReadonlyArray') {
      final argument = arguments.isEmpty
          ? 'JSAny?'
          : mapType(
              arguments.first,
              generic: true,
              scopes: scopes,
              context: context,
            );
      return 'JSArray<${nullableForGeneric(argument)}>';
    }
    if (name == 'Readonly' && arguments.isNotEmpty) {
      return mapType(
        arguments.first,
        generic: generic,
        scopes: scopes,
        context: context,
      );
    }
    final external = _externalReferenceMap[name];
    if (external != null) {
      return external;
    }

    final target = topLevelByName[name];
    if (target == null) {
      throw ParityGenerationException(
        context,
        'no Total Mapping Rule for reference $name',
      );
    }
    switch (target['kind']) {
      case 'enum':
        return generic ? 'JSNumber' : 'int';
      case 'typeAlias':
        return _mapAliasReference(
          target,
          arguments,
          generic: generic,
          scopes: scopes,
          context: context,
        );
      case 'interface' || 'class':
        final parameters =
            (target['typeParameters'] as List<Object?>?) ?? const [];
        if (parameters.isEmpty) {
          return name;
        }
        final mappedArguments = <String>[
          for (var index = 0; index < parameters.length; index += 1)
            index < arguments.length
                ? nullableForGeneric(
                    mapType(
                      arguments[index],
                      generic: true,
                      scopes: scopes,
                      context: context,
                    ),
                  )
                : 'JSAny?',
        ];
        return '$name<${mappedArguments.join(', ')}>';
      default:
        throw ParityGenerationException(
          context,
          'no Total Mapping Rule for reference to ${target['kind']} $name',
        );
    }
  }

  /// Alias references are expanded position-correctly by substitution; the
  /// emitted typedef exists for Extension Authors, not for internal use.
  ///
  /// The one exception is an alias whose body is a union consisting only
  /// of string literals: its zero-cost wrapper is named after the alias
  /// (parity-runtime ledger entry 6), so non-generic positions keep the
  /// upstream name instead of a shape-hash name.
  String _mapAliasReference(
    Map<String, Object?> alias,
    List<Object?> arguments, {
    required bool generic,
    required List<Set<String>> scopes,
    required String context,
  }) {
    final literalUnion = _stringLiteralUnion(alias['type']);
    if (literalUnion != null && !generic) {
      final name = _registerLiteralWrapper(
        literalUnion.members,
        name: alias['name']! as String,
      );
      return literalUnion.nullable ? '$name?' : name;
    }
    final parameters = (alias['typeParameters'] as List<Object?>?) ?? const [];
    var body = alias['type'];
    if (parameters.isNotEmpty) {
      final substitutions = <String, Object?>{
        for (var index = 0; index < parameters.length; index += 1)
          (parameters[index]! as Map<Object?, Object?>)['name']! as String:
              index < arguments.length
                  ? arguments[index]
                  : {'kind': 'primitive', 'name': 'any'},
      };
      body = substitute(body, substitutions);
    }
    return mapType(body, generic: generic, scopes: scopes, context: context);
  }

  /// Substitutes type-parameter references in an IR type node.
  Object? substitute(Object? node, Map<String, Object?> substitutions) {
    if (node is List<Object?>) {
      return [for (final item in node) substitute(item, substitutions)];
    }
    if (node is! Map<Object?, Object?>) {
      return node;
    }
    final map = node.cast<String, Object?>();
    if (map['kind'] == 'reference' &&
        substitutions.containsKey(map['name']) &&
        ((map['typeArguments'] as List<Object?>?) ?? const []).isEmpty) {
      return substitutions[map['name']];
    }
    return {
      for (final entry in map.entries)
        entry.key: substitute(entry.value, substitutions),
    };
  }

  String _mapUnion(
    Map<String, Object?> type, {
    required bool generic,
    required List<Set<String>> scopes,
    required String context,
  }) {
    final members = (type['types']! as List<Object?>)
        .map(
          (member) =>
              (member! as Map<Object?, Object?>).cast<String, Object?>(),
        )
        .toList();
    var nullable = false;
    final rest = <Map<String, Object?>>[];
    for (final member in members) {
      if (member['kind'] == 'primitive' &&
          (member['name'] == 'null' || member['name'] == 'undefined')) {
        nullable = true;
      } else {
        rest.add(member);
      }
    }
    if (rest.isEmpty) {
      return 'JSAny?';
    }
    final allStringLiterals = rest.length > 1 &&
        rest.every(
          (member) =>
              member['kind'] == 'literal' && member['value'] is String,
        );
    if (allStringLiterals && !generic) {
      final name = _registerLiteralWrapper(rest);
      return nullable ? '$name?' : name;
    }
    String base;
    if (rest.length == 1) {
      base = mapType(
        rest.single,
        generic: generic,
        scopes: scopes,
        context: context,
      );
    } else {
      final categories = {
        for (final member in rest)
          _lubCategory(member, scopes: scopes, context: context),
      };
      if (categories.length == 1) {
        base = switch (categories.single) {
          'S' => generic ? 'JSString' : 'String',
          'N' => generic ? 'JSNumber' : 'num',
          'B' => generic ? 'JSBoolean' : 'bool',
          'O' => 'JSObject',
          _ => 'JSAny?',
        };
      } else {
        base = 'JSAny';
      }
    }
    if (nullable && !base.endsWith('?') && base != 'void') {
      base = '$base?';
    }
    return base;
  }

  String _lubCategory(
    Map<String, Object?> member, {
    required List<Set<String>> scopes,
    required String context,
  }) {
    switch (member['kind']) {
      case 'primitive':
        return switch (member['name']) {
          'string' => 'S',
          'number' => 'N',
          'boolean' => 'B',
          'object' => 'O',
          _ => 'A',
        };
      case 'literal':
        final value = member['value'];
        if (value is String) return 'S';
        if (value is num) return 'N';
        if (value is bool) return 'B';
        return 'A';
      case 'reference':
        final name = member['name']! as String;
        for (final scope in scopes) {
          if (scope.contains(name)) {
            return 'A';
          }
        }
        if (name.contains('.')) {
          return 'N';
        }
        final target = topLevelByName[name];
        if (target != null && target['kind'] == 'enum') {
          return 'N';
        }
        if (target != null && target['kind'] == 'typeAlias') {
          final mapped = _mapAliasReference(
            target,
            (member['typeArguments'] as List<Object?>?) ?? const [],
            generic: true,
            scopes: scopes,
            context: context,
          );
          return _categoryOfMapped(mapped);
        }
        return 'O';
      case 'array' || 'tuple' || 'typeLiteral' || 'function' ||
            'intersection':
        return 'O';
      case 'union':
        final mapped = _mapUnion(
          member.cast<String, Object?>(),
          generic: true,
          scopes: scopes,
          context: context,
        );
        return _categoryOfMapped(mapped);
      case 'operator':
        return _lubCategory(
          (member['type']! as Map<Object?, Object?>).cast<String, Object?>(),
          scopes: scopes,
          context: context,
        );
      default:
        return 'A';
    }
  }

  String _categoryOfMapped(String mapped) {
    final bare = mapped.endsWith('?')
        ? mapped.substring(0, mapped.length - 1)
        : mapped;
    if (bare == 'JSString' || bare == 'String') return 'S';
    if (bare == 'JSNumber' || bare == 'num' || bare == 'int') return 'N';
    if (bare == 'JSBoolean' || bare == 'bool') return 'B';
    if (bare == 'JSAny') return 'A';
    return 'O';
  }

  /// Rewrites `void` to `JSAny?` so a type is valid in generic positions.
  String nullableForGeneric(String type) => type == 'void' ? 'JSAny?' : type;

  // ------------------------------------------------------------ registries

  /// Detects a union type consisting only of string literals (plus an
  /// optional `null`/`undefined` member), the construct behind zero-cost
  /// literal wrappers; returns `null` for every other type node.
  ({List<Map<String, Object?>> members, bool nullable})? _stringLiteralUnion(
    Object? node,
  ) {
    if (node is! Map<Object?, Object?>) {
      return null;
    }
    final type = node.cast<String, Object?>();
    if (type['kind'] != 'union') {
      return null;
    }
    var nullable = false;
    final rest = <Map<String, Object?>>[];
    for (final rawMember in type['types']! as List<Object?>) {
      final member =
          (rawMember! as Map<Object?, Object?>).cast<String, Object?>();
      if (member['kind'] == 'primitive' &&
          (member['name'] == 'null' || member['name'] == 'undefined')) {
        nullable = true;
      } else {
        rest.add(member);
      }
    }
    final allStringLiterals = rest.length > 1 &&
        rest.every(
          (member) => member['kind'] == 'literal' && member['value'] is String,
        );
    if (!allStringLiterals) {
      return null;
    }
    return (members: rest, nullable: nullable);
  }

  /// Zero-cost typed wrapper for a union of string literals: the value
  /// IS the string; one generated constant per literal. Anonymous unions
  /// take a shape-hash name; an all-string-literal alias passes its own
  /// [name] so the wrapper keeps the upstream name.
  String _registerLiteralWrapper(
    List<Map<String, Object?>> members, {
    String? name,
  }) {
    final values = [for (final member in members) member['value']! as String]
      ..sort();
    final wrapperName = name ?? hashName('JSLit', values);
    literalWrappers.putIfAbsent(wrapperName, () {
      final buffer = StringBuffer()
        ..writeln('extension type const $wrapperName(String value) {');
      for (var index = 0; index < values.length; index += 1) {
        final literal = values[index];
        final identifier =
            RegExp(r'^[A-Za-z_$][A-Za-z0-9_$]*$').hasMatch(literal) &&
                    dartName(literal) == literal
                ? literal
                : 'value\$${index + 1}';
        buffer.writeln(
          "  static const $identifier = $wrapperName('$literal');",
        );
      }
      buffer
        ..writeln('}')
        ..writeln();
      return buffer.toString();
    });
    return wrapperName;
  }

  String _registerTuple(
    Map<String, Object?> type, {
    required List<Set<String>> scopes,
    required String context,
  }) {
    final elements = type['elements']! as List<Object?>;
    final previousErase = eraseScopeReferences;
    eraseScopeReferences = true;
    final mapped = <String>[
      for (final element in elements)
        nullableForGeneric(
          mapType(
            element is Map<Object?, Object?> && element['type'] != null
                ? element['type']
                : element,
            generic: true,
            scopes: scopes,
            context: context,
          ),
        ),
    ];
    eraseScopeReferences = previousErase;
    final name = hashName('JSTuple', mapped);
    tupleElements.putIfAbsent(name, () => mapped);
    tupleTypes.putIfAbsent(name, () {
      final buffer = StringBuffer()
        ..writeln('extension type $name(JSArray<JSAny?> _self) '
            'implements JSObject {');
      for (var index = 0; index < mapped.length; index += 1) {
        final cast = mapped[index] == 'JSAny?' ? '' : ' as ${mapped[index]}';
        buffer.writeln(
          '  ${mapped[index]} get \$${index + 1} => _self[$index]$cast;',
        );
      }
      buffer
        ..writeln('}')
        ..writeln();
      return buffer.toString();
    });
    return name;
  }

  String _registerIntersection(
    Map<String, Object?> type, {
    required List<Set<String>> scopes,
    required String context,
  }) {
    final operands = type['types']! as List<Object?>;
    final previousErase = eraseScopeReferences;
    eraseScopeReferences = true;
    final mapped = <String>[
      for (final operand in operands)
        mapType(operand, generic: true, scopes: scopes, context: context),
    ];
    eraseScopeReferences = previousErase;
    final name = hashName('JSIntersection', mapped);
    intersectionTypes.putIfAbsent(
      name,
      () => _buildIntersection(name, mapped, context),
    );
    return name;
  }

  Map<String, Object?>? _operandDeclaration(String mappedName) {
    if (mappedName.startsWith('JSAnon_')) {
      for (final declaration in declarations) {
        if (declaration['kind'] == 'typeLiteral' &&
            hashName('JSAnon', declaration['shapeHash']) == mappedName) {
          return declaration;
        }
      }
      return null;
    }
    final target = topLevelByName[mappedName];
    if (target != null &&
        (target['kind'] == 'interface' || target['kind'] == 'class')) {
      return target;
    }
    return null;
  }

  /// Implements every operand; members two or more operands declare are
  /// redeclared from the first declaring operand to resolve the conflict
  /// deterministically.
  String _buildIntersection(String name, List<String> mapped, String context) {
    final bases = {...mapped.where((m) => !m.endsWith('?')), 'JSObject'};
    final memberOwners = <String, List<Map<String, Object?>>>{};
    for (final operand in mapped) {
      final declaration = _operandDeclaration(operand);
      if (declaration == null) {
        continue;
      }
      final children = childrenByParent[declaration['id']] ??
          const <Map<String, Object?>>[];
      for (final child in children) {
        final childName = child['name'];
        if (childName is String && isEmitted(child)) {
          memberOwners.putIfAbsent(childName, () => []).add(child);
        }
      }
    }
    final body = StringBuffer()
      ..writeln('extension type $name(JSObject _self) '
          'implements ${bases.join(', ')} {');
    final previousErase = eraseScopeReferences;
    eraseScopeReferences = true;
    for (final owners in memberOwners.values) {
      if (owners.length < 2) {
        continue;
      }
      _emitMembers([owners.first], body, receiver: '_self');
    }
    eraseScopeReferences = previousErase;
    body
      ..writeln('}')
      ..writeln();
    return body.toString();
  }

  // ---------------------------------------------------------------- shapes

  void _emitAlias(Map<String, Object?> declaration, StringBuffer out) {
    final name = declaration['name']! as String;
    final clause = typeParameterClause(declaration);
    if (name == 'Thenable') {
      out.writeln('typedef Thenable<T extends JSAny?> = JSPromise<T>;');
      return;
    }
    final literalUnion = _stringLiteralUnion(declaration['type']);
    if (literalUnion != null) {
      // The alias IS its wrapper (parity-runtime ledger entry 6): the
      // wrapper is registered under the alias name and hoists with the
      // other literal wrappers; no typedef is emitted.
      _registerLiteralWrapper(literalUnion.members, name: name);
      return;
    }
    final mapped = mapType(
      declaration['type'],
      generic: true,
      scopes: scopesFor(declaration),
      context: declaration['id']! as String,
    );
    out
      ..writeln('typedef $name$clause = ${nullableForGeneric(mapped)};')
      ..writeln();
  }

  void _emitEnum(
    Map<String, Object?> declaration,
    StringBuffer typedefs,
    StringBuffer out,
  ) {
    final name = declaration['name']! as String;
    typedefs.writeln('typedef $name = int;');
    final members = childrenByParent[declaration['id']] ?? const <Map<String, Object?>>[];
    out.writeln('extension type ${name}Values(JSObject _self) '
        'implements JSObject {');
    for (final member in members.where(isEmitted)) {
      final dartName = this.dartName(member['name']! as String);
      final rename = _jsRename(member, dartName);
      if (rename != null) {
        out.writeln("  @JS('$rename')");
      }
      out.writeln('  external int get $dartName;');
    }
    out
      ..writeln('}')
      ..writeln();
  }

  void _emitNamespace(Map<String, Object?> declaration, StringBuffer out) {
    final typeName = namespaceTypeName(declaration['name']! as String);
    out.writeln('extension type $typeName(JSObject _self) '
        'implements JSObject {');
    for (final child in childrenByParent[declaration['id']] ?? const <Map<String, Object?>>[]) {
      if (!isEmitted(child)) {
        continue;
      }
      switch (child['kind']) {
        case 'function':
          _emitCallable(child, out, receiver: '_self');
        case 'variable':
          _emitVariable(child, out);
        default:
          throw ParityGenerationException(
            child['id']! as String,
            'no Total Mapping Rule for namespace member kind '
            "${child['kind']}",
          );
      }
    }
    out
      ..writeln('}')
      ..writeln();
  }

  void _emitVariable(Map<String, Object?> declaration, StringBuffer out) {
    final dartName = this.dartName(declaration['name']! as String);
    final rename = _jsRename(declaration, dartName);
    final scopes = scopesFor(declaration);
    final id = declaration['id']! as String;
    final type = mapType(
      declaration['type'],
      generic: false,
      scopes: scopes,
      context: id,
    );
    final buffer = StringBuffer();
    if (rename != null) {
      buffer.writeln("  @JS('$rename')");
    }
    buffer.writeln('  external $type get $dartName;');
    if (declaration['declarationKind'] != null &&
        declaration['declarationKind'] != 'const') {
      if (rename != null) {
        buffer.writeln("  @JS('$rename')");
      }
      buffer.writeln('  external set $dartName($type value);');
    }
    out.write(buffer);
  }

  void _emitInterface(Map<String, Object?> declaration, StringBuffer out) {
    final name = declaration['name']! as String;
    final id = declaration['id']! as String;
    final clause = typeParameterClause(declaration);
    final scopes = scopesFor(declaration);
    final children = childrenByParent[id] ?? const [];
    final hasCallSignature =
        children.any((child) => child['kind'] == 'callSignature');
    final representation = hasCallSignature ? 'JSFunction' : 'JSObject';
    final bases = <String>{
      for (final base in (declaration['extends'] as List<Object?>?) ?? const [])
        mapType(base, generic: true, scopes: scopes, context: id),
      'JSObject',
    };
    out.writeln('extension type $name$clause($representation _self) '
        'implements ${bases.join(', ')} {');
    if (representation == 'JSObject') {
      _emitLiteralFactory(name, children, out);
    }
    _emitMembers(children, out, receiver: '_self');
    out
      ..writeln('}')
      ..writeln();
  }

  /// The blessed creation rule: an external constructor with only named
  /// parameters produces a JS object literal. Members whose JS name is not
  /// a plain Dart identifier are excluded (authors use setProperty);
  /// method members take JSFunction so interfaces are implementable.
  void _emitLiteralFactory(
    String name,
    List<Map<String, Object?>> children,
    StringBuffer out,
  ) {
    final parameters = <String>[];
    for (final child in children) {
      if (!isEmitted(child)) {
        continue;
      }
      final childName = child['name'];
      if (childName is! String || dartName(childName) != childName) {
        continue;
      }
      if (child['kind'] == 'property') {
        var type = nullableForGeneric(
          mapType(
            child['type'],
            generic: true,
            scopes: scopesFor(child),
            context: child['id']! as String,
          ),
        );
        if (!type.endsWith('?')) {
          type = '$type?';
        }
        parameters.add('$type $childName');
      } else if (child['kind'] == 'method' &&
          (child['overloadOrdinal'] ?? 0) == 0) {
        parameters.add('JSFunction? $childName');
      }
    }
    if (parameters.isEmpty) {
      return;
    }
    out.writeln(
      '  external factory $name.lit\$({${parameters.join(', ')}});',
    );
  }

  void _emitClass(Map<String, Object?> declaration, StringBuffer out) {
    final name = declaration['name']! as String;
    final id = declaration['id']! as String;
    final clause = typeParameterClause(declaration);
    final scopes = scopesFor(declaration);
    final children = childrenByParent[id] ?? const [];
    final bases = <String>{
      for (final base in [
        ...(declaration['extends'] as List<Object?>?) ?? const <Object?>[],
        ...(declaration['implements'] as List<Object?>?) ?? const <Object?>[],
      ])
        mapType(base, generic: true, scopes: scopes, context: id),
      'JSObject',
    };
    out.writeln('extension type $name$clause(JSObject _self) '
        'implements ${bases.join(', ')} {');
    _emitMembers(
      children.where((child) => child['static'] != true).toList(),
      out,
      receiver: '_self',
    );
    // The class object itself: constructors and statics, reached through
    // the module wrapper rather than any global.
    out
      ..writeln('}')
      ..writeln()
      ..writeln(
        'extension type ${name}Ctor(JSFunction _self) implements JSObject {',
      );
    final ownerClause = typeParameterClause(declaration);
    final ownerParameters =
        (declaration['typeParameters'] as List<Object?>?) ?? const [];
    final instantiated = ownerParameters.isEmpty
        ? name
        : '$name<${ownerParameters.map(
            (parameter) =>
                (parameter! as Map<Object?, Object?>)['name']! as String,
          ).join(', ')}>';
    out
      ..writeln('  bool isInstance(JSAny? value) {')
      ..writeln('    if (value == null) return false;')
      ..writeln("    final prototype = _self.getProperty('prototype'.toJS);")
      ..writeln('    if (prototype is! JSObject) return false;')
      ..writeln('    return (prototype.callMethod(')
      ..writeln("      'isPrototypeOf'.toJS,")
      ..writeln('      value,')
      ..writeln('    )! as JSBoolean).toDart;')
      ..writeln('  }')
      ..writeln('  $instantiated cast$ownerClause(JSAny? value) {')
      ..writeln('    if (!isInstance(value)) {')
      ..writeln(
        "      throw ArgumentError('value is not an instance of $name');",
      )
      ..writeln('    }')
      ..writeln('    return $instantiated(value! as JSObject);')
      ..writeln('  }');
    final hasConstructor = children.any(
      (child) => child['kind'] == 'constructor' && isEmitted(child),
    );
    if (!hasConstructor) {
      out
        ..writeln('  $instantiated new\$$ownerClause() =>')
        ..writeln('      _self.callAsConstructorVarArgs<JSObject>(const [])')
        ..writeln('          as $instantiated;');
    }
    for (final child in children.where(isEmitted)) {
      if (child['kind'] == 'constructor') {
        _emitConstructor(name, child, out);
      } else if (child['static'] == true) {
        _emitMembers([child], out, receiver: '_self');
      }
    }
    out
      ..writeln('}')
      ..writeln();
  }

  void _emitConstructor(
    String className,
    Map<String, Object?> declaration,
    StringBuffer out,
  ) {
    final ordinal = declaration['overloadOrdinal'];
    final suffix = ordinal is int && ordinal > 0 ? '\$${ordinal + 1}' : '';
    final scopes = scopesFor(declaration);
    final id = declaration['id']! as String;
    final parameters =
        (declaration['parameters'] as List<Object?>?) ?? const [];
    final owner = byId[declaration['parentId']]!;
    final ownerClause = typeParameterClause(owner);
    final ownerParameters =
        (owner['typeParameters'] as List<Object?>?) ?? const [];
    final instantiated = ownerParameters.isEmpty
        ? className
        : '$className<${ownerParameters.map(
            (parameter) =>
                (parameter! as Map<Object?, Object?>)['name']! as String,
          ).join(', ')}>';
    final signature = _helperParameters(parameters, scopes, id);
    final trimmed =
        '${signature.local}.sublist(0, ${signature.trimExpression})';
    out
      ..writeln(
        '  $instantiated new\$$suffix$ownerClause(${signature.clause}) {',
      )
      ..writeln('    final ${signature.local} = <JSAny?>[${signature.values}];')
      ..writeln(
        '    return _self.callAsConstructorVarArgs<JSObject>($trimmed)'
        ' as $instantiated;',
      )
      ..writeln('  }');
  }

  void _emitTypeLiteral(Map<String, Object?> declaration, StringBuffer out) {
    final name = hashName('JSAnon', declaration['shapeHash']);
    if (anonTypes.containsKey(name)) {
      return;
    }
    final children =
        childrenByParent[declaration['id']] ?? const <Map<String, Object?>>[];
    final hasCallSignature =
        children.any((child) => child['kind'] == 'callSignature');
    final representation = hasCallSignature ? 'JSFunction' : 'JSObject';
    final body = StringBuffer()
      ..writeln('extension type $name($representation _self) '
          'implements JSObject {');
    final previousErase = eraseScopeReferences;
    eraseScopeReferences = true;
    if (representation == 'JSObject') {
      _emitLiteralFactory(name, children, body);
    }
    _emitMembers(children, body, receiver: '_self');
    eraseScopeReferences = previousErase;
    body
      ..writeln('}')
      ..writeln();
    anonTypes[name] = body.toString();
    out.write(anonTypes[name]);
  }

  void _emitMembers(
    List<Map<String, Object?>> children,
    StringBuffer out, {
    required String receiver,
  }) {
    var indexSignatures = 0;
    for (final child in children) {
      if (!isEmitted(child)) {
        continue;
      }
      switch (child['kind']) {
        case 'property':
          _emitProperty(child, out);
        case 'method' || 'function':
          _emitCallable(child, out, receiver: receiver);
        case 'indexSignature':
          indexSignatures += 1;
          _emitIndexSignature(child, out, ordinal: indexSignatures);
        case 'callSignature':
          _emitCallSignature(child, out, receiver: receiver);
        case 'constructor':
          break; // Emitted on the Ctor type.
        case 'typeLiteral':
          break; // Registered literals emit as their own top-level types.
        default:
          throw ParityGenerationException(
            child['id']! as String,
            "no Total Mapping Rule for member kind ${child['kind']}",
          );
      }
    }
  }

  void _emitProperty(Map<String, Object?> declaration, StringBuffer out) {
    final dartName = this.dartName(declaration['name']! as String);
    final rename = _jsRename(declaration, dartName);
    final scopes = scopesFor(declaration);
    final id = declaration['id']! as String;
    var type = mapType(
      declaration['type'],
      generic: false,
      scopes: scopes,
      context: id,
    );
    if (declaration['optional'] == true &&
        !type.endsWith('?') &&
        type != 'void') {
      type = '$type?';
    }
    if (type == 'void') {
      type = 'JSAny?';
    }
    if (rename != null) {
      out.writeln("  @JS('$rename')");
    }
    out.writeln('  external $type get $dartName;');
    if (declaration['readonly'] != true) {
      if (rename != null) {
        out.writeln("  @JS('$rename')");
      }
      out.writeln('  external set $dartName($type value);');
    }
  }

  void _emitCallable(
    Map<String, Object?> declaration,
    StringBuffer out, {
    required String receiver,
  }) {
    final scopes = scopesFor(declaration);
    final id = declaration['id']! as String;
    final dartName = memberName(declaration);
    final jsName = declaration['name']! as String;
    final clause = typeParameterClause(declaration);
    final parameters =
        (declaration['parameters'] as List<Object?>?) ?? const [];
    final hasRest = parameters.any(
      (parameter) =>
          (parameter! as Map<Object?, Object?>)['rest'] == true,
    );
    final ownScopes = [
      ...scopes,
      if (declaration['typeParameters'] is List<Object?>)
        {
          for (final parameter
              in declaration['typeParameters']! as List<Object?>)
            (parameter! as Map<Object?, Object?>)['name']! as String,
        },
    ];

    if (hasRest) {
      final returnType = nullableForGeneric(
        mapType(
          declaration['returnType'],
          generic: true,
          scopes: ownScopes,
          context: id,
        ),
      );
      final signature = _helperParameters(parameters, ownScopes, id);
      final trimmed =
          '${signature.local}.sublist(0, ${signature.trimExpression})';
      final call =
          "$receiver.callMethodVarArgs<$returnType>('$jsName'.toJS, $trimmed)";
      out
        ..writeln('  $returnType $dartName$clause(${signature.clause}) {')
        ..writeln(
          '    final ${signature.local} = <JSAny?>[${signature.values}];',
        )
        ..writeln('    return $call;')
        ..writeln('  }');
      return;
    }

    final returnType = mapType(
      declaration['returnType'],
      generic: false,
      scopes: ownScopes,
      context: id,
    );
    final required = <String>[];
    final optional = <String>[];
    for (final rawParameter in parameters) {
      final parameter =
          (rawParameter! as Map<Object?, Object?>).cast<String, Object?>();
      var type = mapType(
        parameter['type'],
        generic: false,
        scopes: ownScopes,
        context: id,
      );
      if (type == 'void') {
        type = 'JSAny?';
      }
      final parameterName = this.dartName(parameter['name']! as String);
      if (parameter['optional'] == true) {
        if (!type.endsWith('?')) {
          type = '$type?';
        }
        optional.add('$type $parameterName');
      } else {
        required.add('$type $parameterName');
      }
    }
    final signature = [
      required.join(', '),
      if (optional.isNotEmpty) '[${optional.join(', ')}]',
    ].where((part) => part.isNotEmpty).join(', ');
    final rename = dartName == jsName ? null : jsName;
    if (rename != null) {
      out.writeln("  @JS('$rename')");
    }
    out.writeln('  external $returnType $dartName$clause($signature);');
  }

  void _emitIndexSignature(
    Map<String, Object?> declaration,
    StringBuffer out, {
    required int ordinal,
  }) {
    final scopes = scopesFor(declaration);
    final id = declaration['id']! as String;
    final parameters = declaration['parameters']! as List<Object?>;
    final keyType = mapType(
      (parameters.first! as Map<Object?, Object?>)['type'],
      generic: false,
      scopes: scopes,
      context: id,
    );
    var valueType = mapType(
      declaration['returnType'],
      generic: false,
      scopes: scopes,
      context: id,
    );
    if (valueType == 'void') {
      valueType = 'JSAny?';
    }
    if (!valueType.endsWith('?') && !_isPrimitiveDart(valueType)) {
      valueType = '$valueType?';
    }
    if (ordinal == 1) {
      out.writeln('  external $valueType operator []($keyType key);');
      if (declaration['readonly'] != true) {
        out.writeln(
          '  external void operator []=($keyType key, $valueType value);',
        );
      }
      return;
    }
    // Only one operator pair is expressible; later signatures become
    // deterministic named accessors.
    out.writeln('  $valueType indexGet\$$ordinal($keyType key) => '
        '_self.getProperty(key.toString().toJS);');
    if (declaration['readonly'] != true) {
      out.writeln(
        '  void indexSet\$$ordinal($keyType key, $valueType value) => '
        '_self.setProperty(key.toString().toJS, value as JSAny?);',
      );
    }
  }

  bool _isPrimitiveDart(String type) =>
      type == 'String' || type == 'num' || type == 'bool' || type == 'int';

  void _emitCallSignature(
    Map<String, Object?> declaration,
    StringBuffer out, {
    required String receiver,
  }) {
    final scopes = scopesFor(declaration);
    final id = declaration['id']! as String;
    final parameters =
        (declaration['parameters'] as List<Object?>?) ?? const [];
    final signature = _helperParameters(parameters, scopes, id);
    final returnType = nullableForGeneric(
      mapType(
        declaration['returnType'],
        generic: true,
        scopes: scopes,
        context: id,
      ),
    );

    final local = signature.local;
    final count = '${local}Count';
    final arguments = [
      for (var index = 0; index < parameters.length; index += 1)
        '$count > $index ? $local[$index] : null',
    ].join(', ');
    final argumentTail = arguments.isEmpty ? '' : ', $arguments';
    out
      ..writeln('  $returnType call(${signature.clause}) {')
      ..writeln('    final $local = <JSAny?>[${signature.values}];')
      ..writeln('    final $count = ${signature.trimExpression};')
      ..writeln(
        '    return $receiver.callAsFunction(null$argumentTail)'
        ' as $returnType;',
      )
      ..writeln('  }');
  }

  /// Builds a JS-typed helper parameter list with trailing-optional
  /// trimming: optionals are nullable and trailing nulls are not passed.
  ({String clause, String values, String trimExpression, String local})
      _helperParameters(
    List<Object?> parameters,
    List<Set<String>> scopes,
    String context,
  ) {
    var dollars = 1;
    bool collides(int count) => parameters.any(
          (parameter) =>
              (parameter! as Map<Object?, Object?>)['name'] ==
              'args${r'$' * count}',
        );
    while (collides(dollars)) {
      dollars += 1;
    }
    final local = 'args${r'$' * dollars}';
    final requiredParts = <String>[];
    final optionalParts = <String>[];
    final values = <String>[];
    var requiredCount = 0;
    var restValues = '';
    for (final rawParameter in parameters) {
      final parameter =
          (rawParameter! as Map<Object?, Object?>).cast<String, Object?>();
      final parameterName = dartName(parameter['name']! as String);
      if (parameter['rest'] == true) {
        optionalParts.add('List<JSAny?> $parameterName = const []');
        restValues = '...$parameterName';
        continue;
      }
      var type = nullableForGeneric(
        mapType(
          parameter['type'],
          generic: true,
          scopes: scopes,
          context: context,
        ),
      );
      if (parameter['optional'] == true) {
        if (!type.endsWith('?')) {
          type = '$type?';
        }
        optionalParts.add('$type $parameterName');
      } else {
        requiredCount += 1;
        requiredParts.add('$type $parameterName');
      }
      values.add(parameterName);
    }
    final clause = [
      requiredParts.join(', '),
      if (optionalParts.isNotEmpty) '[${optionalParts.join(', ')}]',
    ].where((part) => part.isNotEmpty).join(', ');
    final allValues =
        [values.join(', '), restValues].where((v) => v.isNotEmpty).join(', ');
    final trimExpression = restValues.isNotEmpty
        ? '$local.length'
        : '_trimTrailingNulls($local, $requiredCount)';
    return (
      clause: clause,
      values: allValues,
      trimExpression: trimExpression,
      local: local,
    );
  }

  void _emitRoot(StringBuffer out) {
    out
      ..writeln('/// The VS Code API module object, as passed to activation.')
      ..writeln('///')
      ..writeln('/// The module wrapper is the only root of this layer: no')
      ..writeln('/// generated code resolves names through JS scope.')
      ..writeln('extension type VscodeApi(JSObject _self) '
          'implements JSObject {');
    for (final declaration in declarations) {
      if (declaration['parentId'] != 'module:vscode' ||
          !isEmitted(declaration)) {
        continue;
      }
      final name = declaration['name']! as String;
      switch (declaration['kind']) {
        case 'namespace':
          out.writeln(
            '  external ${namespaceTypeName(name)} get $name;',
          );
        case 'class':
          out.writeln('  external ${name}Ctor get $name;');
        case 'enum':
          out.writeln('  external ${name}Values get $name;');
        case 'variable':
          _emitVariable(declaration, out);
        case 'interface' || 'typeAlias':
          break; // Types have no runtime object on the module.
        default:
          throw ParityGenerationException(
            declaration['id']! as String,
            'no Total Mapping Rule for module member kind '
            "${declaration['kind']}",
          );
      }
    }
    out
      ..writeln('}')
      ..writeln()
      ..writeln('int _trimTrailingNulls(List<JSAny?> args, int floor) {')
      ..writeln('  var length = args.length;')
      ..writeln('  while (length > floor && args[length - 1] == null) {')
      ..writeln('    length -= 1;')
      ..writeln('  }')
      ..writeln('  return length;')
      ..writeln('}');
  }
}

/// The IR validation and canonicalization projection: every
/// structural, identity, type, and canonical-signature rule the
/// generator enforces against the pinned v1 inventory before any
/// emission happens.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'generator.dart';
import 'validators.dart';

/// Validates the inventory module descriptor.
void validateIrModule(Object? value) {
  final module = objectMap(value, 'inventory.module');
  validateIrExactKeys(
    module,
    const {'id', 'name'},
    path: 'inventory.module',
  );
  if (module['id'] != 'module:vscode' || module['name'] != 'vscode') {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'inventory.module must identify module:vscode with name vscode.',
    );
  }
}

/// Validates and returns the normalized inventory source descriptor.
Map<String, Object?> validateIrSource(
  Object? value, {
  required Map<String, Object?> inventory,
}) {
  final source = objectMap(value, 'inventory.source');
  validateIrExactKeys(
    source,
    const {
      'product',
      'parser',
      'inputSha256',
      'manifestSchema',
      'inputs',
      'contributionSchemas',
    },
    path: 'inventory.source',
  );

  final product = objectMap(source['product'], 'inventory.source.product');
  validateIrExactKeys(
    product,
    const {'name', 'version', 'commit'},
    path: 'inventory.source.product',
  );
  nonEmptyString(product['name'], 'inventory.source.product.name');
  nonEmptyString(product['version'], 'inventory.source.product.version');
  _validateIrCommit(product['commit'], 'inventory.source.product.commit');

  final parser = objectMap(source['parser'], 'inventory.source.parser');
  validateIrExactKeys(
    parser,
    const {'name', 'version'},
    path: 'inventory.source.parser',
  );
  if (parser['name'] != 'typescript') {
    _invalidIrValue('inventory.source.parser.name', parser['name']);
  }
  nonEmptyString(parser['version'], 'inventory.source.parser.version');
  _validateIrSha256(
    source['inputSha256'],
    'inventory.source.inputSha256',
  );

  final manifestSchema = objectMap(
    source['manifestSchema'],
    'inventory.source.manifestSchema',
  );
  validateIrExactKeys(
    manifestSchema,
    const {'schemaUri', 'standalone', 'composition'},
    path: 'inventory.source.manifestSchema',
  );
  nonEmptyString(
    manifestSchema['schemaUri'],
    'inventory.source.manifestSchema.schemaUri',
  );
  _validateIrBoolean(
    manifestSchema['standalone'],
    'inventory.source.manifestSchema.standalone',
  );
  nonEmptyString(
    manifestSchema['composition'],
    'inventory.source.manifestSchema.composition',
  );

  final inputs = objectList(source['inputs'], 'inventory.source.inputs');
  if (inputs.isEmpty) {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'inventory.source.inputs must contain pinned source receipts.',
    );
  }
  final inputsByKind = <String, List<Map<String, Object?>>>{};
  for (var index = 0; index < inputs.length; index += 1) {
    final path = 'inventory.source.inputs[$index]';
    final input = objectMap(inputs[index], path);
    validateIrExactKeys(
      input,
      const {
        'name',
        'kind',
        'path',
        'version',
        'commit',
        'source',
        'sha256',
        'license',
      },
      optionalKeys: const {'licensePath'},
      path: path,
    );
    for (final key in const [
      'name',
      'path',
      'version',
      'source',
      'license',
    ]) {
      nonEmptyString(input[key], '$path.$key');
    }
    final kind = string(input['kind'], '$path.kind');
    if (!const {
      'apiDeclarations',
      'extensionManifestSchemaSource',
      'extensionManifestValidatorSource',
      'contributionSchemaSource',
      'contributionValidationHelperSource',
      'license',
    }.contains(kind)) {
      _invalidIrValue('$path.kind', kind);
    }
    _validateIrCommit(input['commit'], '$path.commit');
    _validateIrSha256(input['sha256'], '$path.sha256');
    if (input.containsKey('licensePath')) {
      nonEmptyString(input['licensePath'], '$path.licensePath');
    }
    inputsByKind.putIfAbsent(kind, () => []).add(input);
  }

  final contributionSchemas = objectList(
    source['contributionSchemas'],
    'inventory.source.contributionSchemas',
  );
  final schemaNames = <String>[
    for (var index = 0; index < contributionSchemas.length; index += 1)
      nonEmptyString(
        contributionSchemas[index],
        'inventory.source.contributionSchemas[$index]',
      ),
  ];
  if (schemaNames.length != 1 || schemaNames.single != 'commands') {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'inventory.source.contributionSchemas must contain exactly commands.',
    );
  }
  const officialSourcePathByKind = <String, String>{
    'apiDeclarations': 'src/vscode-dts/vscode.d.ts',
    'extensionManifestSchemaSource':
        'src/vs/workbench/services/extensions/common/extensionsRegistry.ts',
    'extensionManifestValidatorSource':
        'src/vs/platform/extensions/common/extensionValidator.ts',
    'contributionSchemaSource':
        'src/vs/workbench/services/actions/common/menusExtensionPoint.ts',
    'contributionValidationHelperSource': 'src/vs/base/common/strings.ts',
    'license': 'LICENSE.txt',
  };
  for (final entry in officialSourcePathByKind.entries) {
    final matches = inputsByKind[entry.key] ?? const [];
    if (matches.length != 1) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        'inventory.source.inputs must contain exactly one ${entry.key} '
            'receipt; found ${matches.length}.',
      );
    }
    final input = matches.single;
    final productVersion = string(
      product['version'],
      'inventory.source.product.version',
    );
    final productCommit = string(
      product['commit'],
      'inventory.source.product.commit',
    );
    if (input['version'] != productVersion ||
        input['commit'] != productCommit) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        'inventory.source.inputs ${entry.key} receipt must match product '
            '$productVersion@$productCommit.',
      );
    }
    final expectedSource = 'https://raw.githubusercontent.com/microsoft/vscode/'
        '$productCommit/${entry.value}';
    if (input['source'] != expectedSource) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        'inventory.source.inputs ${entry.key} source must be the canonical '
            'microsoft/vscode URL $expectedSource.',
      );
    }
  }

  String receiptSha(String kind) =>
      string(inputsByKind[kind]!.single['sha256'], 'inventory.source.inputs');
  void requireReceiptSha(String actual, String kind, String path) {
    _validateIrSha256(actual, path);
    final expected = receiptSha(kind);
    if (actual != expected) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path must match the inventory.source.inputs $kind receipt SHA-256 '
            '$expected.',
      );
    }
  }

  requireReceiptSha(
    string(source['inputSha256'], 'inventory.source.inputSha256'),
    'apiDeclarations',
    'inventory.source.inputSha256',
  );
  final projectedManifest = objectMap(
    inventory['manifestSchema'],
    'inventory.manifestSchema',
  );
  requireReceiptSha(
    string(
      projectedManifest['inputSha256'],
      'inventory.manifestSchema.inputSha256',
    ),
    'extensionManifestSchemaSource',
    'inventory.manifestSchema.inputSha256',
  );
  if (projectedManifest['schemaUri'] != manifestSchema['schemaUri'] ||
      projectedManifest['standalone'] != manifestSchema['standalone']) {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'inventory.source.manifestSchema must match the projected '
          'inventory.manifestSchema identity.',
    );
  }
  final projectedValidator = objectMap(
    inventory['manifestValidator'],
    'inventory.manifestValidator',
  );
  requireReceiptSha(
    string(
      projectedValidator['inputSha256'],
      'inventory.manifestValidator.inputSha256',
    ),
    'extensionManifestValidatorSource',
    'inventory.manifestValidator.inputSha256',
  );
  final projectedContributions = objectMap(
    inventory['contributionSchemas'],
    'inventory.contributionSchemas',
  );
  final projectedCommands = objectMap(
    projectedContributions['commands'],
    'inventory.contributionSchemas.commands',
  );
  requireReceiptSha(
    string(
      projectedCommands['inputSha256'],
      'inventory.contributionSchemas.commands.inputSha256',
    ),
    'contributionSchemaSource',
    'inventory.contributionSchemas.commands.inputSha256',
  );
  return source;
}

/// Validates the exact key set of one inventory declaration.
void validateIrDeclarationKeys(
  Map<String, Object?> declaration,
  String path,
) {
  const common = {
    'id',
    'kind',
    'name',
    'qualifiedName',
    'parentId',
    'deprecated',
    'visibility',
    'coverage',
  };
  const callable = {
    ...common,
    'overloadOrdinal',
    'canonicalSignature',
    'typeParameters',
    'parameters',
    'returnType',
  };
  final kind = string(declaration['kind'], '$path.kind');
  final requiredKeys = switch (kind) {
    'namespace' => common,
    'interface' => {...common, 'typeParameters', 'extends'},
    'class' => {
        ...common,
        'abstract',
        'typeParameters',
        'extends',
        'implements',
      },
    'enum' => {...common, 'constant'},
    'enumMember' => {...common, 'initializer'},
    'typeAlias' => {...common, 'typeParameters', 'type'},
    'variable' => {...common, 'constant', 'declarationKind', 'type'},
    'property' => {
        ...common,
        'optional',
        'readonly',
        'static',
        'abstract',
        'type',
      },
    'function' || 'constructor' || 'callSignature' => callable,
    'method' => {...callable, 'static', 'optional', 'abstract'},
    'indexSignature' => {...callable, 'readonly'},
    'typeLiteral' => {...common, 'shapeHash', 'shape'},
    _ => throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.kind has unsupported IR declaration kind $kind.',
      ),
  };
  validateIrExactKeys(
    declaration,
    requiredKeys,
    optionalKeys: const {'occurrenceCount'},
    path: path,
  );
  _validateIrDeclarationScalars(declaration, path);
  _validateIrCoverage(
    declaration['coverage'],
    '$path.coverage',
    visibility: string(declaration['visibility'], '$path.visibility'),
  );
}

void _validateIrDeclarationScalars(
  Map<String, Object?> declaration,
  String path,
) {
  nonEmptyString(declaration['id'], '$path.id');
  nonEmptyString(declaration['name'], '$path.name');
  nonEmptyString(declaration['qualifiedName'], '$path.qualifiedName');
  nonEmptyString(declaration['parentId'], '$path.parentId');
  _validateIrBoolean(declaration['deprecated'], '$path.deprecated');
  final visibility = string(declaration['visibility'], '$path.visibility');
  if (!const {'public', 'protected', 'private'}.contains(visibility)) {
    _invalidIrValue('$path.visibility', visibility);
  }
  if (declaration.containsKey('occurrenceCount')) {
    final occurrenceCount = _validateIrNonNegativeInteger(
      declaration['occurrenceCount'],
      '$path.occurrenceCount',
    );
    if (occurrenceCount < 2) {
      _invalidIrValue('$path.occurrenceCount', occurrenceCount);
    }
    final kind = declaration['kind'];
    final isNonMergeable =
        const {'class', 'typeAlias', 'enumMember'}.contains(kind) ||
            (kind == 'variable' && declaration['declarationKind'] != 'var');
    if (isNonMergeable) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.occurrenceCount is impossible for nonmergeable $kind '
            'declarations.',
      );
    }
  }

  final kind = declaration['kind'];
  switch (kind) {
    case 'class':
      _validateIrBoolean(declaration['abstract'], '$path.abstract');
    case 'enum':
      _validateIrBoolean(declaration['constant'], '$path.constant');
    case 'variable':
      _validateIrBoolean(declaration['constant'], '$path.constant');
      final declarationKind = string(
        declaration['declarationKind'],
        '$path.declarationKind',
      );
      if (!const {'const', 'let', 'var'}.contains(declarationKind)) {
        _invalidIrValue('$path.declarationKind', declarationKind);
      }
    case 'property':
      for (final key in const ['optional', 'readonly', 'static', 'abstract']) {
        _validateIrBoolean(declaration[key], '$path.$key');
      }
    case 'function' || 'constructor' || 'callSignature':
      _validateIrNonNegativeInteger(
        declaration['overloadOrdinal'],
        '$path.overloadOrdinal',
      );
    case 'method':
      _validateIrNonNegativeInteger(
        declaration['overloadOrdinal'],
        '$path.overloadOrdinal',
      );
      for (final key in const ['optional', 'static', 'abstract']) {
        _validateIrBoolean(declaration[key], '$path.$key');
      }
    case 'indexSignature':
      _validateIrNonNegativeInteger(
        declaration['overloadOrdinal'],
        '$path.overloadOrdinal',
      );
      _validateIrBoolean(declaration['readonly'], '$path.readonly');
    case 'typeLiteral':
      _validateIrSha256(declaration['shapeHash'], '$path.shapeHash');
  }
}

/// Validates the canonical ordering of the declaration list.
void validateIrDeclarationOrder(List<Object?> declarations) {
  for (var index = 1; index < declarations.length; index += 1) {
    final previous = objectMap(
      declarations[index - 1],
      'inventory.declarations[${index - 1}]',
    );
    final current = objectMap(
      declarations[index],
      'inventory.declarations[$index]',
    );
    if (_compareIrDeclarations(previous, current) > 0) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        'inventory.declarations must remain in producer sort order; '
            'entry $index precedes entry ${index - 1}.',
      );
    }
  }
}

int _compareIrDeclarations(
  Map<String, Object?> left,
  Map<String, Object?> right,
) {
  final qualified = string(
    left['qualifiedName'],
    'inventory declaration.qualifiedName',
  ).compareTo(
    string(
      right['qualifiedName'],
      'inventory declaration.qualifiedName',
    ),
  );
  if (qualified != 0) {
    return qualified;
  }
  final leftOrdinal = left['overloadOrdinal'];
  final rightOrdinal = right['overloadOrdinal'];
  if (leftOrdinal is int && rightOrdinal is int) {
    final ordinal = leftOrdinal.compareTo(rightOrdinal);
    if (ordinal != 0) {
      return ordinal;
    }
  }
  return string(left['id'], 'inventory declaration.id').compareTo(
    string(right['id'], 'inventory declaration.id'),
  );
}

/// Validates the identity fields of one inventory declaration.
void validateIrDeclarationIdentity(
  Map<String, Object?> declaration,
  String path,
  Map<String, Map<String, Object?>> declarationsById,
) {
  final id = string(declaration['id'], '$path.id');
  final kind = string(declaration['kind'], '$path.kind');
  final name = string(declaration['name'], '$path.name');
  final qualifiedName = string(
    declaration['qualifiedName'],
    '$path.qualifiedName',
  );
  final parentId = string(declaration['parentId'], '$path.parentId');
  final parent = declarationsById[parentId];
  final rootParent = parentId == 'module:vscode' || parentId == 'global:global';
  if (!rootParent && parent == null) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.parentId $parentId does not resolve to a producer declaration.',
    );
  }
  final parentKind = parent?['kind'] as String?;
  final allowedParentKinds = switch (kind) {
    'namespace' ||
    'interface' ||
    'class' ||
    'enum' ||
    'typeAlias' ||
    'variable' ||
    'function' =>
      const {'namespace'},
    'enumMember' => const {'enum'},
    'property' || 'method' => const {'class', 'interface', 'typeLiteral'},
    'constructor' => const {'class'},
    'callSignature' || 'indexSignature' => const {
        'class',
        'interface',
        'typeLiteral',
      },
    'typeLiteral' => const {
        'typeAlias',
        'variable',
        'property',
        'function',
        'constructor',
        'callSignature',
        'method',
        'indexSignature',
      },
    _ => const <String>{},
  };
  final acceptsRoot = const {
    'namespace',
    'interface',
    'class',
    'enum',
    'typeAlias',
    'variable',
    'function',
  }.contains(kind);
  if ((rootParent && !acceptsRoot) ||
      (!rootParent && !allowedParentKinds.contains(parentKind))) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.parentId $parentId is incompatible with $kind declarations.',
    );
  }

  final parentQualifiedName = switch (parentId) {
    'module:vscode' => 'vscode',
    'global:global' => 'global',
    _ => string(parent!['qualifiedName'], '$path.parentId.qualifiedName'),
  };
  final expectedQualifiedName = kind == 'typeLiteral'
      ? '$parentId.\$shape@${declaration['shapeHash']}'
      : '$parentQualifiedName.$name';
  if (qualifiedName != expectedQualifiedName) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.qualifiedName must be derived from name and parentId as '
          '$expectedQualifiedName.',
    );
  }

  if (kind == 'constructor' && name != 'constructor' ||
      kind == 'callSignature' && name != r'$call' ||
      kind == 'indexSignature' && name != r'$index' ||
      kind == 'typeLiteral' && name != r'$type') {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.name is not the producer name for $kind declarations.',
    );
  }

  final expectedId = switch (kind) {
    'namespace' ||
    'interface' ||
    'class' ||
    'enum' ||
    'typeAlias' ||
    'variable' =>
      '$kind:$qualifiedName',
    'enumMember' => 'enumMember:$parentId/${_encodeIrIdPart(name)}',
    'property' =>
      'property:$parentId/${declaration['static'] == true ? r'$static' : r'$instance'}/${_encodeIrIdPart(name)}',
    'function' ||
    'constructor' ||
    'callSignature' ||
    'method' ||
    'indexSignature' =>
      '$kind:$qualifiedName@${sha256.convert(utf8.encode(string(declaration['canonicalSignature'], '$path.canonicalSignature')))}',
    'typeLiteral' =>
      'typeLiteral:$parentId/\$shape@${declaration['shapeHash']}',
    _ => id,
  };
  if (id != expectedId) {
    final basis = const {
      'function',
      'constructor',
      'callSignature',
      'method',
      'indexSignature',
    }.contains(kind)
        ? 'canonicalSignature, qualifiedName, and kind'
        : kind == 'typeLiteral'
            ? 'parentId and shapeHash'
            : 'name, qualifiedName, parentId, kind, and flags';
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.id must be derived from $basis as $expectedId.',
    );
  }

  final visibility = string(declaration['visibility'], '$path.visibility');
  if (rootParent && visibility != 'public') {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.visibility must be public for top-level producer declarations.',
    );
  }
  if (parent != null) {
    final parentVisibility = string(
      parent['visibility'],
      '$path.parentId.visibility',
    );
    final inheritsVisibility = kind == 'typeLiteral' ||
        kind == 'enumMember' ||
        ((kind == 'property' || kind == 'method') && parentKind != 'class') ||
        kind == 'callSignature' ||
        kind == 'indexSignature';
    if (inheritsVisibility && visibility != parentVisibility) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.visibility must inherit $parentVisibility from $parentId.',
      );
    }
    if ((kind == 'property' || kind == 'method') && parentKind != 'class') {
      for (final flag in const ['static', 'abstract']) {
        if (declaration[flag] != false) {
          throw VSCodeBindingGenerationException(
            'INVALID_GENERATOR_INPUT',
            '$path.$flag must be false outside class declarations.',
          );
        }
      }
    }
  }
  if (kind == 'variable') {
    final declarationKind = declaration['declarationKind'];
    final expectedConstant = declarationKind == 'const';
    if (declaration['constant'] != expectedConstant) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.constant must equal (declarationKind == const).',
      );
    }
  }
}

String _encodeIrIdPart(String value) {
  return Uri.encodeComponent(value)
      .replaceAll('%21', '!')
      .replaceAll('%27', "'")
      .replaceAll('%28', '(')
      .replaceAll('%29', ')')
      .replaceAll('%2A', '*');
}

/// Returns the type-parameter scopes one declaration inherits.
List<List<String?>> irInheritedTypeParameterScopes(
  Map<String, Object?> declaration,
  Map<String, Map<String, Object?>> declarationsById,
  String path,
) {
  final ancestors = <Map<String, Object?>>[];
  var parentId = string(declaration['parentId'], '$path.parentId');
  final seen = <String>{};
  while (parentId != 'module:vscode' && parentId != 'global:global') {
    if (!seen.add(parentId)) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.parentId participates in a declaration cycle.',
      );
    }
    final parent = declarationsById[parentId];
    if (parent == null) {
      return const [];
    }
    ancestors.add(parent);
    parentId = string(parent['parentId'], '$path.parentId');
  }
  final scopes = <List<String?>>[];
  for (final ancestor in ancestors.reversed) {
    if (_irDeclarationContributesTypeParameterScope(ancestor)) {
      scopes.add(_irTypeParameterNames(ancestor['typeParameters']));
    }
  }
  return scopes;
}

bool _irDeclarationContributesTypeParameterScope(
  Map<String, Object?> declaration,
) {
  return const {
    'interface',
    'class',
    'typeAlias',
    'function',
    'constructor',
    'callSignature',
    'method',
    'indexSignature',
  }.contains(declaration['kind']);
}

List<String?> _irTypeParameterNames(Object? value) {
  return [
    for (final parameter in objectList(value, 'typeParameters'))
      string(
        objectMap(parameter, 'typeParameters entry')['name'],
        'typeParameters entry.name',
      ),
  ];
}

/// Validates overload ordinal assignments across the inventory.
void validateIrOverloadOrdinals(
  Map<String, Map<String, Object?>> declarationsById,
  Map<String, String> declarationPathsById,
) {
  final groups = <String, List<Map<String, Object?>>>{};
  for (final declaration in declarationsById.values) {
    if (!const {
      'function',
      'constructor',
      'callSignature',
      'method',
      'indexSignature',
    }.contains(declaration['kind'])) {
      continue;
    }
    final key = '${declaration['kind']}:${declaration['qualifiedName']}:'
        '${declaration['static'] == true}';
    groups.putIfAbsent(key, () => []).add(declaration);
  }
  for (final declarations in groups.values) {
    declarations.sort(
      (left, right) => (left['overloadOrdinal']! as int)
          .compareTo(right['overloadOrdinal']! as int),
    );
    var expected = 0;
    for (final declaration in declarations) {
      final actual = declaration['overloadOrdinal']! as int;
      if (actual != expected) {
        final path = declarationPathsById[declaration['id']]!;
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path.overloadOrdinal must be $expected for its producer overload '
              'group; found $actual.',
        );
      }
      expected += (declaration['occurrenceCount'] as int?) ?? 1;
    }
  }
}

/// Validates the registered type-literal graph across the inventory.
void validateIrTypeLiteralGraph(
  Map<String, Map<String, Object?>> declarationsById,
  Map<String, String> declarationPathsById,
) {
  final inbound = <String, int>{};

  void visit(Object? value, String ownerId, String path) {
    if (value is List<Object?>) {
      for (var index = 0; index < value.length; index += 1) {
        visit(value[index], ownerId, '$path[$index]');
      }
      return;
    }
    if (value is! Map<Object?, Object?>) {
      return;
    }
    final map = value.cast<String, Object?>();
    if (map['kind'] == 'typeLiteral' && map.containsKey('id')) {
      final id = string(map['id'], '$path.id');
      final declaration = declarationsById[id];
      if (declaration == null || declaration['kind'] != 'typeLiteral') {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path.id $id must resolve to a registered typeLiteral declaration.',
        );
      }
      if (declaration['shapeHash'] != map['shapeHash']) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path.shapeHash must match registered typeLiteral declaration $id.',
        );
      }
      if (declaration['parentId'] != ownerId) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path typeLiteral $id must remain bound to owner $ownerId.',
        );
      }
      inbound[id] = (inbound[id] ?? 0) + 1;
    }
    for (final entry in map.entries) {
      visit(entry.value, ownerId, '$path.${entry.key}');
    }
  }

  for (final entry in declarationsById.entries) {
    final path = declarationPathsById[entry.key]!;
    for (final field in entry.value.entries) {
      visit(field.value, entry.key, '$path.${field.key}');
    }
  }
  for (final declaration in declarationsById.values) {
    if (declaration['kind'] != 'typeLiteral') {
      continue;
    }
    final id = declaration['id']! as String;
    if ((inbound[id] ?? 0) == 0) {
      final path = declarationPathsById[id]!;
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path typeLiteral $id must have an inbound registered reference.',
      );
    }
  }
  _validateIrRegisteredTypeLiteralShapes(
    declarationsById,
    declarationPathsById,
  );
}

void _validateIrRegisteredTypeLiteralShapes(
  Map<String, Map<String, Object?>> declarationsById,
  Map<String, String> declarationPathsById,
) {
  final childrenByParent = <String, List<Map<String, Object?>>>{};
  for (final declaration in declarationsById.values) {
    childrenByParent
        .putIfAbsent(declaration['parentId']! as String, () => [])
        .add(declaration);
  }
  for (final declaration in declarationsById.values) {
    if (declaration['kind'] != 'typeLiteral') {
      continue;
    }
    final id = declaration['id']! as String;
    final path = declarationPathsById[id]!;
    final shape = _registeredTypeLiteralShape(declaration, path);
    final expected = sha256.convert(utf8.encode(jsonEncode(shape))).toString();
    if (declaration['shapeHash'] != expected) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.shapeHash must commit to its canonical shape as $expected.',
      );
    }
    _validateRegisteredShapeChildren(
      shape: shape,
      children: childrenByParent[id] ?? const [],
      declarationsById: declarationsById,
      declarationPathsById: declarationPathsById,
      path: path,
    );
  }
}

Map<String, Object?> _registeredTypeLiteralShape(
  Map<String, Object?> declaration,
  String path,
) {
  final shape = declaration['shape'];
  if (shape is! Map<Object?, Object?> ||
      shape.keys.length != 1 ||
      shape['members'] is! List<Object?>) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.shape must be an object with exactly a members list.',
    );
  }
  const memberKeysByKind = <String, Set<String>>{
    'property': {'kind', 'name', 'optional', 'readonly', 'type'},
    'method': {'kind', 'signature', 'name', 'optional', 'static', 'abstract'},
    'callSignature': {'kind', 'signature'},
    'indexSignature': {'kind', 'signature', 'readonly'},
  };
  final members = shape['members']! as List<Object?>;
  for (var index = 0; index < members.length; index += 1) {
    final member = members[index];
    if (member is! Map<Object?, Object?>) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.shape.members[$index] must be an object.',
      );
    }
    final expectedKeys = memberKeysByKind[member['kind']];
    final actualKeys = member.keys.whereType<String>().toSet();
    if (expectedKeys == null ||
        actualKeys.length != member.keys.length ||
        actualKeys.length != expectedKeys.length ||
        !actualKeys.containsAll(expectedKeys)) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.shape.members[$index] has an unsupported member schema.',
      );
    }
    final kind = member['kind']! as String;
    final name = member['name'];
    final namedMember = kind == 'property' || kind == 'method';
    final validValues = (!namedMember || (name is String && name.isNotEmpty)) &&
        (!actualKeys.contains('optional') || member['optional'] is bool) &&
        (!actualKeys.contains('readonly') || member['readonly'] is bool) &&
        (!actualKeys.contains('static') || member['static'] is bool) &&
        (!actualKeys.contains('abstract') || member['abstract'] is bool) &&
        (!actualKeys.contains('signature') ||
            member['signature'] is Map<Object?, Object?>) &&
        (!actualKeys.contains('type') ||
            member['type'] is Map<Object?, Object?> ||
            member['type'] is List<Object?>);
    if (!validValues) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.shape.members[$index] has an unsupported member schema.',
      );
    }
  }
  return shape.cast<String, Object?>();
}

void _validateRegisteredShapeChildren({
  required Map<String, Object?> shape,
  required List<Map<String, Object?>> children,
  required Map<String, Map<String, Object?>> declarationsById,
  required Map<String, String> declarationPathsById,
  required String path,
}) {
  VSCodeBindingGenerationException mismatch(String detail) =>
      VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.shape members must match the canonical children committed '
            'by shapeHash: $detail.',
      );

  final members = [
    for (final member in shape['members']! as List<Object?>)
      (member! as Map<Object?, Object?>).cast<String, Object?>(),
  ];
  if (members.length != children.length) {
    throw mismatch(
      'expected ${members.length} children, found ${children.length}',
    );
  }
  final used = <Map<String, Object?>>{};
  final signatureOrdinals = <String, int>{};
  for (final member in members) {
    final kind = member['kind']! as String;
    if (kind == 'property') {
      final name = member['name'];
      final matches = children
          .where(
            (child) => child['kind'] == 'property' && child['name'] == name,
          )
          .toList();
      if (matches.length != 1 || !used.add(matches.single)) {
        throw mismatch('property $name has no unique child declaration');
      }
      final child = matches.single;
      if (member['optional'] != child['optional'] ||
          member['readonly'] != child['readonly']) {
        throw mismatch('property $name flags diverge');
      }
      final scopes = irInheritedTypeParameterScopes(
        child,
        declarationsById,
        declarationPathsById[child['id']!]!,
      );
      final childType = scopes.any((scope) => scope.isNotEmpty)
          ? _canonicalizeIrType(child['type'], scopes)
          : child['type'];
      if (!_shapeTypeMatchesChildType(
        member['type'],
        childType,
        declarationsById,
      )) {
        throw mismatch('property $name type diverges');
      }
    } else if (kind == 'method' ||
        kind == 'callSignature' ||
        kind == 'indexSignature') {
      final name = member['name'];
      final ordinal = signatureOrdinals.update(
        '$kind@${name ?? ''}',
        (value) => value + 1,
        ifAbsent: () => 0,
      );
      final matches = children
          .where(
            (child) =>
                child['kind'] == kind &&
                child['overloadOrdinal'] == ordinal &&
                (name == null || child['name'] == name),
          )
          .toList();
      if (matches.length != 1 || !used.add(matches.single)) {
        throw mismatch('$kind ${name ?? ordinal} has no unique child');
      }
      final child = matches.single;
      final canonical = (jsonDecode(child['canonicalSignature']! as String)
              as Map<Object?, Object?>)
          .cast<String, Object?>();
      if (kind == 'method') {
        canonical
          ..remove('static')
          ..remove('optional');
        if (member['optional'] != child['optional'] ||
            member['static'] != child['static'] ||
            member['abstract'] != child['abstract']) {
          throw mismatch('method $name flags diverge');
        }
      }
      if (kind == 'indexSignature') {
        canonical.remove('readonly');
        if (member['readonly'] != child['readonly']) {
          throw mismatch('index signature flags diverge');
        }
      }
      if (_encodeCanonicalJson(member['signature']) !=
          _encodeCanonicalJson(canonical)) {
        throw mismatch('$kind ${name ?? ordinal} signature diverges');
      }
    } else {
      throw mismatch('unsupported member kind $kind');
    }
  }
}

bool _shapeTypeMatchesChildType(
  Object? shapeType,
  Object? childType,
  Map<String, Map<String, Object?>> declarationsById,
) {
  if (shapeType is List<Object?>) {
    if (childType is! List<Object?> || childType.length != shapeType.length) {
      return false;
    }
    for (var index = 0; index < shapeType.length; index += 1) {
      if (!_shapeTypeMatchesChildType(
        shapeType[index],
        childType[index],
        declarationsById,
      )) {
        return false;
      }
    }
    return true;
  }
  if (shapeType is! Map<Object?, Object?>) {
    return shapeType == childType;
  }
  if (childType is! Map<Object?, Object?>) {
    return false;
  }
  final shapeMap = shapeType.cast<String, Object?>();
  final childMap = childType.cast<String, Object?>();
  if (shapeMap['kind'] == 'typeLiteral' &&
      childMap['kind'] == 'typeLiteral' &&
      shapeMap.containsKey('shape') &&
      childMap.containsKey('id')) {
    if (shapeMap['shapeHash'] != childMap['shapeHash']) {
      return false;
    }
    final registered = declarationsById[childMap['id']];
    return registered != null &&
        _encodeCanonicalJson(shapeMap['shape']) ==
            _encodeCanonicalJson(registered['shape']);
  }
  final shapeKeys = shapeMap.keys.toSet();
  if (shapeKeys.length != childMap.keys.length ||
      !childMap.keys.every(shapeKeys.contains)) {
    return false;
  }
  for (final key in shapeKeys) {
    if (!_shapeTypeMatchesChildType(
      shapeMap[key],
      childMap[key],
      declarationsById,
    )) {
      return false;
    }
  }
  return true;
}

/// Validates every type reference in one inventory declaration.
void validateIrDeclarationTypes(
  Map<String, Object?> declaration,
  String path, {
  required List<List<String?>> inheritedScopes,
}) {
  final kind = declaration['kind'];
  if (kind == 'interface' || kind == 'class') {
    _validateIrTypeParameterTypes(
      declaration['typeParameters'],
      '$path.typeParameters',
      inheritedScopes: inheritedScopes,
    );
    _validateIrHeritageTypes(declaration['extends'], '$path.extends');
    if (kind == 'class') {
      _validateIrHeritageTypes(
        declaration['implements'],
        '$path.implements',
      );
    }
    return;
  }
  if (kind == 'typeAlias') {
    final ownScope = _validateIrTypeParameterTypes(
      declaration['typeParameters'],
      '$path.typeParameters',
      inheritedScopes: inheritedScopes,
    );
    _validateIrType(
      declaration['type'],
      '$path.type',
      typeParameterScopes: [...inheritedScopes, ownScope],
    );
    return;
  }
  if (kind == 'variable' || kind == 'property') {
    _validateIrType(
      declaration['type'],
      '$path.type',
      typeParameterScopes: inheritedScopes,
    );
    return;
  }
  if (kind == 'enumMember') {
    _validateIrExpression(declaration['initializer'], '$path.initializer');
    return;
  }
  if (const {
    'function',
    'constructor',
    'callSignature',
    'method',
    'indexSignature',
  }.contains(kind)) {
    final ownScope = _validateIrTypeParameterTypes(
      declaration['typeParameters'],
      '$path.typeParameters',
      inheritedScopes: inheritedScopes,
    );
    final activeScopes = [...inheritedScopes, ownScope];
    _validateIrParameterTypes(
      declaration['parameters'],
      '$path.parameters',
      typeParameterScopes: activeScopes,
    );
    _validateIrType(
      declaration['returnType'],
      '$path.returnType',
      typeParameterScopes: activeScopes,
    );
    _validateIrCanonicalSignature(
      declaration['canonicalSignature'],
      '$path.canonicalSignature',
      inheritedScopes: inheritedScopes,
      localTypeParameterNames: ownScope,
      extraKeys: switch (kind) {
        'method' => const {'static', 'optional'},
        'indexSignature' => const {'readonly'},
        _ => const {},
      },
    );
    _validateIrCallableCanonicalEquality(
      declaration,
      path,
      inheritedScopes: inheritedScopes,
    );
  }
}

void _validateIrHeritageTypes(Object? value, String path) {
  final types = objectList(value, path);
  for (var index = 0; index < types.length; index += 1) {
    final typePath = '$path[$index]';
    final type = objectMap(types[index], typePath);
    if (type['kind'] != 'reference') {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$typePath must be a producer reference heritage node.',
      );
    }
    _validateIrType(type, typePath);
  }
}

void _validateIrTypes(
  Object? value,
  String path, {
  List<List<String?>> typeParameterScopes = const [],
}) {
  final types = objectList(value, path);
  for (var index = 0; index < types.length; index += 1) {
    _validateIrType(
      types[index],
      '$path[$index]',
      typeParameterScopes: typeParameterScopes,
    );
  }
}

void _validateIrParameterTypes(
  Object? value,
  String path, {
  List<List<String?>> typeParameterScopes = const [],
}) {
  final parameters = objectList(value, path);
  for (var index = 0; index < parameters.length; index += 1) {
    final parameterPath = '$path[$index]';
    final parameter = objectMap(parameters[index], parameterPath);
    validateIrExactKeys(
      parameter,
      const {'name', 'optional', 'rest', 'type'},
      path: parameterPath,
    );
    nonEmptyString(parameter['name'], '$parameterPath.name');
    _validateIrBoolean(parameter['optional'], '$parameterPath.optional');
    _validateIrBoolean(parameter['rest'], '$parameterPath.rest');
    _validateIrType(
      parameter['type'],
      '$parameterPath.type',
      typeParameterScopes: typeParameterScopes,
    );
  }
}

List<String?> _validateIrTypeParameterTypes(
  Object? value,
  String path, {
  List<List<String?>> inheritedScopes = const [],
}) {
  final parameters = objectList(value, path);
  final names = <String?>[];
  for (var index = 0; index < parameters.length; index += 1) {
    final parameterPath = '$path[$index]';
    final parameter = objectMap(parameters[index], parameterPath);
    validateIrExactKeys(
      parameter,
      const {'name'},
      optionalKeys: const {'constraint', 'default'},
      path: parameterPath,
    );
    names.add(nonEmptyString(parameter['name'], '$parameterPath.name'));
  }
  final activeScopes = [...inheritedScopes, names];
  for (var index = 0; index < parameters.length; index += 1) {
    final parameterPath = '$path[$index]';
    final parameter = objectMap(parameters[index], parameterPath);
    if (parameter.containsKey('constraint')) {
      _validateIrType(
        parameter['constraint'],
        '$parameterPath.constraint',
        typeParameterScopes: activeScopes,
      );
    }
    if (parameter.containsKey('default')) {
      _validateIrType(
        parameter['default'],
        '$parameterPath.default',
        typeParameterScopes: activeScopes,
      );
    }
  }
  return names;
}

void _validateIrType(
  Object? value,
  String path, {
  List<List<String?>> typeParameterScopes = const [],
}) {
  final type = objectMap(value, path);
  final kind = string(type['kind'], '$path.kind');
  switch (kind) {
    case 'primitive':
      validateIrExactKeys(type, const {'kind', 'name'}, path: path);
      final name = string(type['name'], '$path.name');
      if (!const {
        'any',
        'boolean',
        'never',
        'number',
        'object',
        'string',
        'undefined',
        'unknown',
        'void',
      }.contains(name)) {
        _invalidIrValue('$path.name', name);
      }
    case 'reference':
      validateIrExactKeys(
        type,
        const {'kind', 'name', 'typeArguments'},
        path: path,
      );
      nonEmptyString(type['name'], '$path.name');
      _validateIrTypes(
        type['typeArguments'],
        '$path.typeArguments',
        typeParameterScopes: typeParameterScopes,
      );
    case 'array':
      validateIrExactKeys(type, const {'kind', 'elementType'}, path: path);
      _validateIrType(
        type['elementType'],
        '$path.elementType',
        typeParameterScopes: typeParameterScopes,
      );
    case 'union' || 'intersection':
      validateIrExactKeys(type, const {'kind', 'types'}, path: path);
      _validateIrTypes(
        type['types'],
        '$path.types',
        typeParameterScopes: typeParameterScopes,
      );
    case 'literal':
      validateIrExactKeys(type, const {'kind', 'value'}, path: path);
      final literal = type['value'];
      if (literal != null &&
          literal is! String &&
          literal is! bool &&
          literal is! int) {
        _invalidIrValue('$path.value', literal);
      }
      if (literal is int) {
        _validateIrSafeInteger(literal, '$path.value');
      }
    case 'tuple':
      validateIrExactKeys(type, const {'kind', 'elements'}, path: path);
      final elements = objectList(type['elements'], '$path.elements');
      for (var index = 0; index < elements.length; index += 1) {
        final elementPath = '$path.elements[$index]';
        final element = objectMap(elements[index], elementPath);
        validateIrExactKeys(
          element,
          const {'optional', 'rest', 'type'},
          optionalKeys: const {'name'},
          path: elementPath,
        );
        if (element.containsKey('name')) {
          nonEmptyString(element['name'], '$elementPath.name');
        }
        _validateIrBoolean(element['optional'], '$elementPath.optional');
        _validateIrBoolean(element['rest'], '$elementPath.rest');
        _validateIrType(
          element['type'],
          '$elementPath.type',
          typeParameterScopes: typeParameterScopes,
        );
      }
    case 'operator':
      validateIrExactKeys(
        type,
        const {'kind', 'operator', 'type'},
        path: path,
      );
      final operator = string(type['operator'], '$path.operator');
      if (!const {'keyof', 'readonly', 'unique'}.contains(operator)) {
        _invalidIrValue('$path.operator', operator);
      }
      _validateIrType(
        type['type'],
        '$path.type',
        typeParameterScopes: typeParameterScopes,
      );
    case 'function':
      validateIrExactKeys(
        type,
        const {
          'kind',
          'typeParameters',
          'parameters',
          'returnType',
          'canonicalSignature',
        },
        path: path,
      );
      final ownScope = _validateIrTypeParameterTypes(
        type['typeParameters'],
        '$path.typeParameters',
        inheritedScopes: typeParameterScopes,
      );
      final activeScopes = [...typeParameterScopes, ownScope];
      _validateIrParameterTypes(
        type['parameters'],
        '$path.parameters',
        typeParameterScopes: activeScopes,
      );
      _validateIrType(
        type['returnType'],
        '$path.returnType',
        typeParameterScopes: activeScopes,
      );
      _validateIrCanonicalSignature(
        type['canonicalSignature'],
        '$path.canonicalSignature',
        inheritedScopes: typeParameterScopes,
        localTypeParameterNames: ownScope,
      );
      _validateIrFunctionTypeCanonicalEquality(
        type,
        path,
        inheritedScopes: typeParameterScopes,
      );
    case 'typeLiteral':
      final hasId = type.containsKey('id');
      final hasShape = type.containsKey('shape');
      if (hasId == hasShape) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path must contain exactly one of id or shape.',
        );
      }
      if (hasId) {
        validateIrExactKeys(
          type,
          const {'kind', 'id', 'shapeHash'},
          path: path,
        );
        nonEmptyString(type['id'], '$path.id');
      } else {
        validateIrExactKeys(
          type,
          const {'kind', 'shape', 'shapeHash'},
          path: path,
        );
        _validateIrTypeLiteralShape(
          type['shape'],
          '$path.shape',
          typeParameterScopes: typeParameterScopes,
        );
      }
      _validateIrSha256(type['shapeHash'], '$path.shapeHash');
      if (hasShape) {
        final actualHash = string(type['shapeHash'], '$path.shapeHash');
        final expectedHash =
            sha256.convert(utf8.encode(jsonEncode(type['shape']))).toString();
        if (actualHash != expectedHash) {
          throw VSCodeBindingGenerationException(
            'INVALID_GENERATOR_INPUT',
            '$path.shapeHash must equal the SHA-256 of its canonical shape '
                '$expectedHash.',
          );
        }
      }
    default:
      _invalidIrValue('$path.kind', kind);
  }
}

void _validateIrExpression(Object? value, String path) {
  final expression = objectMap(value, path);
  final kind = string(expression['kind'], '$path.kind');
  switch (kind) {
    case 'literal':
      validateIrExactKeys(
        expression,
        const {'kind', 'value'},
        path: path,
      );
      final literal = expression['value'];
      if (literal is! String && literal is! bool && literal is! int) {
        _invalidIrValue('$path.value', literal);
      }
      if (literal is int) {
        _validateIrSafeInteger(literal, '$path.value');
      }
    case 'reference':
      validateIrExactKeys(
        expression,
        const {'kind', 'name'},
        path: path,
      );
      nonEmptyString(expression['name'], '$path.name');
    case 'unary':
      validateIrExactKeys(
        expression,
        const {'kind', 'operator', 'operand'},
        path: path,
      );
      final operator = string(expression['operator'], '$path.operator');
      if (!const {'++', '--', '+', '-', '~', '!'}.contains(operator)) {
        _invalidIrValue('$path.operator', operator);
      }
      _validateIrExpression(expression['operand'], '$path.operand');
    default:
      _invalidIrValue('$path.kind', kind);
  }
}

void _validateIrTypeLiteralShape(
  Object? value,
  String path, {
  required List<List<String?>> typeParameterScopes,
}) {
  final shape = objectMap(value, path);
  validateIrExactKeys(shape, const {'members'}, path: path);
  final members = objectList(shape['members'], '$path.members');
  for (var index = 0; index < members.length; index += 1) {
    final memberPath = '$path.members[$index]';
    final member = objectMap(members[index], memberPath);
    final kind = string(member['kind'], '$memberPath.kind');
    switch (kind) {
      case 'property':
        validateIrExactKeys(
          member,
          const {'kind', 'name', 'optional', 'readonly', 'type'},
          path: memberPath,
        );
        nonEmptyString(member['name'], '$memberPath.name');
        _validateIrBoolean(member['optional'], '$memberPath.optional');
        _validateIrBoolean(member['readonly'], '$memberPath.readonly');
        if (typeParameterScopes.any((scope) => scope.isNotEmpty)) {
          _validateIrCanonicalType(
            member['type'],
            '$memberPath.type',
            typeParameterScopes: typeParameterScopes,
          );
        } else {
          _validateIrType(
            member['type'],
            '$memberPath.type',
            typeParameterScopes: typeParameterScopes,
          );
        }
      case 'method':
        validateIrExactKeys(
          member,
          const {
            'kind',
            'name',
            'signature',
            'optional',
            'static',
            'abstract',
          },
          path: memberPath,
        );
        nonEmptyString(member['name'], '$memberPath.name');
        _validateIrBoolean(member['optional'], '$memberPath.optional');
        _validateIrBoolean(member['static'], '$memberPath.static');
        _validateIrBoolean(member['abstract'], '$memberPath.abstract');
        _validateIrCanonicalSignatureObject(
          member['signature'],
          '$memberPath.signature',
          inheritedScopes: typeParameterScopes,
        );
      case 'callSignature':
        validateIrExactKeys(
          member,
          const {'kind', 'signature'},
          path: memberPath,
        );
        _validateIrCanonicalSignatureObject(
          member['signature'],
          '$memberPath.signature',
          inheritedScopes: typeParameterScopes,
        );
      case 'indexSignature':
        validateIrExactKeys(
          member,
          const {'kind', 'signature', 'readonly'},
          path: memberPath,
        );
        _validateIrBoolean(member['readonly'], '$memberPath.readonly');
        _validateIrCanonicalSignatureObject(
          member['signature'],
          '$memberPath.signature',
          inheritedScopes: typeParameterScopes,
        );
      default:
        _invalidIrValue('$memberPath.kind', kind);
    }
  }
}

void _validateIrCanonicalSignature(
  Object? value,
  String path, {
  List<List<String?>> inheritedScopes = const [],
  List<String?>? localTypeParameterNames,
  Set<String> extraKeys = const {},
}) {
  final serialized = string(value, path);
  Object? decoded;
  try {
    decoded = jsonDecode(serialized);
  } on FormatException {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must contain canonical v1 IR JSON.',
    );
  }
  _validateIrCanonicalSignatureObject(
    decoded,
    path,
    inheritedScopes: inheritedScopes,
    localTypeParameterNames: localTypeParameterNames,
    extraKeys: extraKeys,
  );
  if (jsonEncode(decoded) != serialized) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must use canonical producer JSON bytes.',
    );
  }
}

void _validateIrCanonicalSignatureObject(
  Object? value,
  String path, {
  List<List<String?>> inheritedScopes = const [],
  List<String?>? localTypeParameterNames,
  Set<String> extraKeys = const {},
}) {
  final signature = objectMap(value, path);
  validateIrExactKeys(
    signature,
    {'typeParameters', 'parameters', 'returnType', ...extraKeys},
    path: path,
  );
  final typeParameters = objectList(
    signature['typeParameters'],
    '$path.typeParameters',
  );
  if (localTypeParameterNames != null &&
      localTypeParameterNames.length != typeParameters.length) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.typeParameters must match the raw type-parameter count.',
    );
  }
  final localScope = localTypeParameterNames ??
      List<String?>.filled(typeParameters.length, null);
  final activeScopes = [...inheritedScopes, localScope];
  for (var index = 0; index < typeParameters.length; index += 1) {
    final parameterPath = '$path.typeParameters[$index]';
    final parameter = objectMap(typeParameters[index], parameterPath);
    validateIrExactKeys(
      parameter,
      const {},
      optionalKeys: const {'constraint', 'default'},
      path: parameterPath,
    );
    if (parameter.containsKey('constraint')) {
      _validateIrCanonicalType(
        parameter['constraint'],
        '$parameterPath.constraint',
        typeParameterScopes: activeScopes,
      );
    }
    if (parameter.containsKey('default')) {
      _validateIrCanonicalType(
        parameter['default'],
        '$parameterPath.default',
        typeParameterScopes: activeScopes,
      );
    }
  }
  final parameters = objectList(signature['parameters'], '$path.parameters');
  for (var index = 0; index < parameters.length; index += 1) {
    final parameterPath = '$path.parameters[$index]';
    final parameter = objectMap(parameters[index], parameterPath);
    validateIrExactKeys(
      parameter,
      const {'optional', 'rest', 'type'},
      path: parameterPath,
    );
    _validateIrBoolean(parameter['optional'], '$parameterPath.optional');
    _validateIrBoolean(parameter['rest'], '$parameterPath.rest');
    _validateIrCanonicalType(
      parameter['type'],
      '$parameterPath.type',
      typeParameterScopes: activeScopes,
    );
  }
  _validateIrCanonicalType(
    signature['returnType'],
    '$path.returnType',
    typeParameterScopes: activeScopes,
  );
  for (final key in extraKeys) {
    _validateIrBoolean(signature[key], '$path.$key');
  }
}

void _validateIrCallableCanonicalEquality(
  Map<String, Object?> declaration,
  String path, {
  required List<List<String?>> inheritedScopes,
}) {
  final extraKeys = switch (declaration['kind']) {
    'method' => const ['static', 'optional'],
    'indexSignature' => const ['readonly'],
    _ => const <String>[],
  };
  _validateIrRawCanonicalEquality(
    declaration,
    path,
    inheritedScopes: inheritedScopes,
    extraKeys: extraKeys,
  );
}

void _validateIrFunctionTypeCanonicalEquality(
  Map<String, Object?> type,
  String path, {
  required List<List<String?>> inheritedScopes,
}) {
  _validateIrRawCanonicalEquality(
    type,
    path,
    inheritedScopes: inheritedScopes,
  );
}

void _validateIrRawCanonicalEquality(
  Map<String, Object?> raw,
  String path, {
  required List<List<String?>> inheritedScopes,
  List<String> extraKeys = const [],
}) {
  final rawTypeParameters = objectList(
    raw['typeParameters'],
    '$path.typeParameters',
  );
  final ownScope = <String?>[
    for (var index = 0; index < rawTypeParameters.length; index += 1)
      string(
        objectMap(
          rawTypeParameters[index],
          '$path.typeParameters[$index]',
        )['name'],
        '$path.typeParameters[$index].name',
      ),
  ];
  final activeScopes = [...inheritedScopes, ownScope];
  final expectedTypeParameters = <Object?>[
    for (var index = 0; index < rawTypeParameters.length; index += 1)
      _canonicalizeIrTypeParameter(
        objectMap(
          rawTypeParameters[index],
          '$path.typeParameters[$index]',
        ),
        activeScopes,
      ),
  ];
  final rawParameters = objectList(raw['parameters'], '$path.parameters');
  final expectedParameters = <Object?>[
    for (var index = 0; index < rawParameters.length; index += 1)
      _canonicalizeIrParameter(
        objectMap(rawParameters[index], '$path.parameters[$index]'),
        activeScopes,
      ),
  ];
  final expected = <String, Object?>{
    'typeParameters': expectedTypeParameters,
    'parameters': expectedParameters,
    'returnType': _canonicalizeIrType(raw['returnType'], activeScopes),
    for (final key in extraKeys) key: raw[key],
  };
  final actual = string(
    raw['canonicalSignature'],
    '$path.canonicalSignature',
  );
  final expectedJson = jsonEncode(expected);
  if (actual != expectedJson) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.canonicalSignature must equal the mechanically canonicalized raw '
          'signature $expectedJson.',
    );
  }
}

Map<String, Object?> _canonicalizeIrTypeParameter(
  Map<String, Object?> parameter,
  List<List<String?>> scopes,
) {
  return {
    if (parameter.containsKey('constraint'))
      'constraint': _canonicalizeIrType(parameter['constraint'], scopes),
    if (parameter.containsKey('default'))
      'default': _canonicalizeIrType(parameter['default'], scopes),
  };
}

Map<String, Object?> _canonicalizeIrParameter(
  Map<String, Object?> parameter,
  List<List<String?>> scopes,
) {
  return {
    'optional': parameter['optional'],
    'rest': parameter['rest'],
    'type': _canonicalizeIrType(parameter['type'], scopes),
  };
}

Object? _canonicalizeIrType(
  Object? value,
  List<List<String?>> scopes,
) {
  final type = objectMap(value, 'IR type');
  final kind = type['kind'];
  if (kind == 'reference') {
    final name = type['name'];
    for (var scopeIndex = scopes.length - 1; scopeIndex >= 0; scopeIndex -= 1) {
      final index = scopes[scopeIndex].indexOf(name as String?);
      if (index < 0) {
        continue;
      }
      final depth = scopes.length - 1 - scopeIndex;
      return depth == 0
          ? <String, Object?>{'kind': 'typeParameter', 'index': index}
          : <String, Object?>{
              'kind': 'outerTypeParameter',
              'depth': depth,
              'index': index,
            };
    }
  }
  return switch (kind) {
    'primitive' => <String, Object?>{
        'kind': kind,
        'name': type['name'],
      },
    'reference' => <String, Object?>{
        'kind': kind,
        'name': type['name'],
        'typeArguments': [
          for (final argument in objectList(
            type['typeArguments'],
            'IR type.typeArguments',
          ))
            _canonicalizeIrType(argument, scopes),
        ],
      },
    'array' => <String, Object?>{
        'kind': kind,
        'elementType': _canonicalizeIrType(type['elementType'], scopes),
      },
    'union' || 'intersection' => <String, Object?>{
        'kind': kind,
        'types': [
          for (final item in objectList(type['types'], 'IR type.types'))
            _canonicalizeIrType(item, scopes),
        ],
      },
    'literal' => <String, Object?>{
        'kind': kind,
        'value': type['value'],
      },
    'tuple' => <String, Object?>{
        'kind': kind,
        'elements': [
          for (final elementValue in objectList(
            type['elements'],
            'IR type.elements',
          ))
            _canonicalizeIrTupleElement(
              objectMap(elementValue, 'IR tuple element'),
              scopes,
            ),
        ],
      },
    'operator' => <String, Object?>{
        'kind': kind,
        'operator': type['operator'],
        'type': _canonicalizeIrType(type['type'], scopes),
      },
    'function' => <String, Object?>{
        'kind': kind,
        'canonicalSignature': type['canonicalSignature'],
      },
    'typeLiteral' => <String, Object?>{
        'kind': kind,
        'shapeHash': type['shapeHash'],
      },
    _ => value,
  };
}

Map<String, Object?> _canonicalizeIrTupleElement(
  Map<String, Object?> element,
  List<List<String?>> scopes,
) {
  return {
    'optional': element['optional'],
    'rest': element['rest'],
    'type': _canonicalizeIrType(element['type'], scopes),
  };
}

void _validateIrCanonicalType(
  Object? value,
  String path, {
  List<List<String?>> typeParameterScopes = const [],
}) {
  final type = objectMap(value, path);
  final kind = string(type['kind'], '$path.kind');
  switch (kind) {
    case 'primitive':
      validateIrExactKeys(type, const {'kind', 'name'}, path: path);
      final name = string(type['name'], '$path.name');
      if (!const {
        'any',
        'boolean',
        'never',
        'number',
        'object',
        'string',
        'undefined',
        'unknown',
        'void',
      }.contains(name)) {
        _invalidIrValue('$path.name', name);
      }
    case 'reference':
      validateIrExactKeys(
        type,
        const {'kind', 'name', 'typeArguments'},
        path: path,
      );
      nonEmptyString(type['name'], '$path.name');
      final referenceName = string(type['name'], '$path.name');
      if (typeParameterScopes.any((scope) => scope.contains(referenceName))) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path reference $referenceName must use its canonical '
              'typeParameter or outerTypeParameter node.',
        );
      }
      final arguments = objectList(
        type['typeArguments'],
        '$path.typeArguments',
      );
      for (var index = 0; index < arguments.length; index += 1) {
        _validateIrCanonicalType(
          arguments[index],
          '$path.typeArguments[$index]',
          typeParameterScopes: typeParameterScopes,
        );
      }
    case 'array':
      validateIrExactKeys(type, const {'kind', 'elementType'}, path: path);
      _validateIrCanonicalType(
        type['elementType'],
        '$path.elementType',
        typeParameterScopes: typeParameterScopes,
      );
    case 'union' || 'intersection':
      validateIrExactKeys(type, const {'kind', 'types'}, path: path);
      final types = objectList(type['types'], '$path.types');
      for (var index = 0; index < types.length; index += 1) {
        _validateIrCanonicalType(
          types[index],
          '$path.types[$index]',
          typeParameterScopes: typeParameterScopes,
        );
      }
    case 'literal':
      validateIrExactKeys(type, const {'kind', 'value'}, path: path);
      final literal = type['value'];
      if (literal != null &&
          literal is! String &&
          literal is! bool &&
          literal is! int) {
        _invalidIrValue('$path.value', literal);
      }
      if (literal is int) {
        _validateIrSafeInteger(literal, '$path.value');
      }
    case 'tuple':
      validateIrExactKeys(type, const {'kind', 'elements'}, path: path);
      final elements = objectList(type['elements'], '$path.elements');
      for (var index = 0; index < elements.length; index += 1) {
        final elementPath = '$path.elements[$index]';
        final element = objectMap(elements[index], elementPath);
        validateIrExactKeys(
          element,
          const {'optional', 'rest', 'type'},
          path: elementPath,
        );
        _validateIrBoolean(element['optional'], '$elementPath.optional');
        _validateIrBoolean(element['rest'], '$elementPath.rest');
        _validateIrCanonicalType(
          element['type'],
          '$elementPath.type',
          typeParameterScopes: typeParameterScopes,
        );
      }
    case 'operator':
      validateIrExactKeys(
        type,
        const {'kind', 'operator', 'type'},
        path: path,
      );
      final operator = string(type['operator'], '$path.operator');
      if (!const {'keyof', 'readonly', 'unique'}.contains(operator)) {
        _invalidIrValue('$path.operator', operator);
      }
      _validateIrCanonicalType(
        type['type'],
        '$path.type',
        typeParameterScopes: typeParameterScopes,
      );
    case 'function':
      validateIrExactKeys(
        type,
        const {'kind', 'canonicalSignature'},
        path: path,
      );
      _validateIrCanonicalSignature(
        type['canonicalSignature'],
        '$path.canonicalSignature',
        inheritedScopes: typeParameterScopes,
      );
    case 'typeLiteral':
      validateIrExactKeys(
        type,
        const {'kind', 'shapeHash'},
        path: path,
      );
      _validateIrSha256(type['shapeHash'], '$path.shapeHash');
    case 'typeParameter':
      validateIrExactKeys(type, const {'kind', 'index'}, path: path);
      final index = _validateIrNonNegativeInteger(
        type['index'],
        '$path.index',
      );
      if (typeParameterScopes.isEmpty ||
          index >= typeParameterScopes.last.length) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path typeParameter index $index is outside its current scope.',
        );
      }
    case 'outerTypeParameter':
      validateIrExactKeys(
        type,
        const {'kind', 'depth', 'index'},
        path: path,
      );
      final depth = _validateIrNonNegativeInteger(
        type['depth'],
        '$path.depth',
      );
      final index = _validateIrNonNegativeInteger(
        type['index'],
        '$path.index',
      );
      if (depth < 1 || depth >= typeParameterScopes.length) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path outerTypeParameter depth $depth is outside its outer scopes.',
        );
      }
      final scope = typeParameterScopes[typeParameterScopes.length - 1 - depth];
      if (index >= scope.length) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path outerTypeParameter index $index is outside depth $depth.',
        );
      }
    default:
      _invalidIrValue('$path.kind', kind);
  }
}

Never _invalidIrValue(String path, Object? value) {
  throw VSCodeBindingGenerationException(
    'INVALID_GENERATOR_INPUT',
    '$path contains unsupported v1 IR value ${jsonEncode(value)}.',
  );
}

bool _validateIrBoolean(Object? value, String path) {
  if (value is! bool) {
    _invalidIrValue(path, value);
  }
  return value;
}

int _validateIrNonNegativeInteger(Object? value, String path) {
  if (value is! int || value < 0) {
    _invalidIrValue(path, value);
  }
  return _validateIrSafeInteger(value, path);
}

int _validateIrSafeInteger(int value, String path) {
  const maxSafeInteger = 9007199254740991;
  if (value < -maxSafeInteger || value > maxSafeInteger) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a JavaScript safe integer.',
    );
  }
  return value;
}

String _validateIrCommit(Object? value, String path) {
  final commit = string(value, path);
  if (!RegExp(r'^[0-9a-f]{40}$').hasMatch(commit)) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a lowercase 40-character Git commit.',
    );
  }
  return commit;
}

void _validateIrSha256(Object? value, String path) {
  final digest = string(value, path);
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(digest)) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a lowercase SHA-256 digest.',
    );
  }
}

void _validateIrCoverage(
  Object? value,
  String path, {
  required String visibility,
}) {
  final coverage = objectMap(value, path);
  validateIrExactKeys(
    coverage,
    const {'discovery', 'semantics', 'binding', 'host'},
    path: path,
  );
  final discovery = string(coverage['discovery'], '$path.discovery');
  final semantics = string(coverage['semantics'], '$path.semantics');
  final binding = string(coverage['binding'], '$path.binding');
  final host = string(coverage['host'], '$path.host');
  final expectedSemantics = visibility == 'public' ? 'pending' : 'excluded';
  final expectedBinding = visibility == 'public' ? 'pending' : 'excluded';
  final expectedHost = visibility == 'public' ? 'pending' : 'notApplicable';
  if (discovery != 'discovered' ||
      semantics != expectedSemantics ||
      binding != expectedBinding ||
      host != expectedHost) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must contain the producer coverage state for $visibility '
          'declarations: discovered/$expectedSemantics/$expectedBinding/'
          '$expectedHost.',
    );
  }
}

/// Requires a JSON object to match the exact v1 IR key set.
void validateIrExactKeys(
  Map<String, Object?> value,
  Set<String> requiredKeys, {
  required String path,
  Set<String> optionalKeys = const {},
}) {
  final missing = requiredKeys.where((key) => !value.containsKey(key)).toList()
    ..sort();
  final allowedKeys = {...requiredKeys, ...optionalKeys};
  final unexpected =
      value.keys.where((key) => !allowedKeys.contains(key)).toList()..sort();
  if (missing.isEmpty && unexpected.isEmpty) {
    return;
  }
  throw VSCodeBindingGenerationException(
    'INVALID_GENERATOR_INPUT',
    '$path does not match the exact v1 IR schema; missing '
        '${missing.isEmpty ? 'none' : missing.join(', ')}; unexpected '
        '${unexpected.isEmpty ? 'none' : unexpected.join(', ')}.',
  );
}

/// Rejects any input document whose schemaVersion is not 1.
void validateInputSchemaVersion(
  Map<String, Object?> document,
  String name,
) {
  if (document['schemaVersion'] != 1) {
    throw VSCodeBindingGenerationException(
      'UNSUPPORTED_INPUT_SCHEMA_VERSION',
      '$name.schemaVersion must be 1, found ${document['schemaVersion']}.',
    );
  }
}

/// Returns a stable semantic fingerprint for one normalized IR declaration.
String computeDeclarationFingerprint(Map<String, Object?> declaration) {
  final semanticDeclaration = Map<String, Object?>.from(declaration)
    ..remove('coverage');
  return sha256
      .convert(utf8.encode(_encodeCanonicalJson(semanticDeclaration)))
      .toString();
}

String _encodeCanonicalJson(Object? value) {
  if (value is Map<Object?, Object?>) {
    final keys = <String>[];
    for (final key in value.keys) {
      if (key is! String) {
        throw const VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          'A declaration fingerprint contains a non-string JSON key.',
        );
      }
      keys.add(key);
    }
    keys.sort();
    return '{${[
      for (final key in keys)
        '${jsonEncode(key)}:${_encodeCanonicalJson(value[key])}',
    ].join(',')}}';
  }
  if (value is List<Object?>) {
    return '[${value.map(_encodeCanonicalJson).join(',')}]';
  }
  return jsonEncode(value);
}

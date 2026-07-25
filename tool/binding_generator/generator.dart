/// Deterministic Dart binding generation from a pinned VS Code API inventory.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'coverage_ledger.dart';
import 'ecmascript_whitespace.dart';
import 'ir_validator.dart';
import 'manifest_projection.dart';
import 'templates.dart';
import 'validators.dart';

export 'ir_validator.dart' show computeDeclarationFingerprint;

/// A deterministic generation failure with a stable machine-readable [code].
final class VSCodeBindingGenerationException implements Exception {
  /// Creates a generation failure.
  const VSCodeBindingGenerationException(this.code, this.message);

  /// Stable diagnostic code.
  final String code;

  /// Actionable diagnostic text.
  final String message;

  @override
  String toString() => '$code: $message';
}

/// Files produced by one binding generation pass.
final class VSCodeGeneratedBindings {
  /// Creates an immutable generated-file set.
  VSCodeGeneratedBindings(Map<String, String> files)
      : files = Map.unmodifiable(files);

  /// Relative output path to UTF-8 file contents.
  final Map<String, String> files;
}

final class _SelectedBindings {
  _SelectedBindings(this.declarationsById, this.strategiesById);

  final Map<String, Map<String, Object?>> declarationsById;
  final Map<String, String> strategiesById;

  List<Map<String, Object?>> withStrategy(String strategy) {
    final result = <Map<String, Object?>>[
      for (final entry in strategiesById.entries)
        if (entry.value == strategy) declarationsById[entry.key]!,
    ]..sort((left, right) => id(left).compareTo(id(right)));
    return result;
  }

  Map<String, Object?> single(String strategy) {
    final matches = withStrategy(strategy);
    if (matches.length != 1) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'The $strategy translation rule requires exactly one selected '
            'declaration, found ${matches.length}.',
      );
    }
    return matches.single;
  }

  Map<String, Object?> singleWhere(
    String strategy,
    bool Function(Map<String, Object?> declaration) predicate,
  ) {
    final matches = withStrategy(strategy).where(predicate).toList();
    if (matches.length != 1) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'The $strategy relation requires exactly one matching declaration, '
            'found ${matches.length}.',
      );
    }
    return matches.single;
  }

  Map<String, Object?> parentOf(Map<String, Object?> declaration) {
    final parentId = string(
      declaration['parentId'],
      'inventory declaration ${id(declaration)}.parentId',
    );
    final parent = declarationsById[parentId];
    if (parent == null) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'Selected declaration ${id(declaration)} has missing parent '
            '$parentId.',
      );
    }
    return parent;
  }

  List<Map<String, Object?>> childrenOf(
    Map<String, Object?> parent,
    String strategy,
  ) =>
      withStrategy(strategy)
          .where((candidate) => candidate['parentId'] == id(parent))
          .toList();

  Map<String, Object?> singleChildOf(
    Map<String, Object?> parent,
    String strategy,
  ) {
    final matches = childrenOf(parent, strategy);
    if (matches.length != 1) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'Selected ${string(parent['kind'], 'parent.kind')} ${id(parent)} '
            'requires exactly one $strategy child, found ${matches.length}.',
      );
    }
    return matches.single;
  }

  Map<String, Object?> parentWithChild(
    String parentStrategy,
    String childStrategy,
  ) =>
      singleWhere(
        parentStrategy,
        (parent) => childrenOf(parent, childStrategy).isNotEmpty,
      );

  Map<String, Object?> selectedReference(Object? value) {
    final type = objectMap(value, 'selected reference type');
    if (type['kind'] != 'reference') {
      throw const VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'A selected reference relation did not contain a reference type.',
      );
    }
    final referenceName = string(type['name'], 'selected reference type.name');
    final matches = <Map<String, Object?>>[
      for (final entry in strategiesById.entries)
        if (entry.value != 'reviewedExcluded' &&
            name(declarationsById[entry.key]!) == referenceName)
          declarationsById[entry.key]!,
    ];
    if (matches.length != 1) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'Reference $referenceName must resolve to exactly one selected '
            'declaration, found ${matches.length}.',
      );
    }
    return matches.single;
  }

  String id(Map<String, Object?> declaration) =>
      string(declaration['id'], 'inventory declaration.id');

  String name(Map<String, Object?> declaration) => _dartIdentifier(
        declaration['name'],
        'inventory declaration ${id(declaration)}.name',
      );

  String observationName(Map<String, Object?> declaration) =>
      '_binding${sha256.convert(utf8.encode(id(declaration)))}';
}

/// Generates the reviewed VS Code API slice selected by Semantic Overrides.
final class VSCodeBindingGenerator {
  static const _strategies = {
    'boolObjectField',
    'boolGetterProjection',
    'commandExecution',
    'commandRegistration',
    'disposableStructuralType',
    'disposeMethod',
    'eventSubscription',
    'eventType',
    'eventValue',
    'hoverProviderRegistration',
    'intEnumMember',
    'intGetterProjection',
    'jsObjectLiteral',
    'markdownHoverConstructor',
    'markdownStringConstructor',
    'namespaceObject',
    'nativeJsClass',
    'nativeJsEnum',
    'numericRangeConstructor',
    'objectGetterProjection',
    'opaqueHostObject',
    'opaqueJsObject',
    'providerCallback',
    'providerObject',
    'providerResultProjection',
    'reviewedExcluded',
    'stringSelectorProjection',
    'stringGetterProjection',
    'stringGetterSetterProjection',
    'subscriptionsArray',
    'thenableBoolMethod',
    'thenableFutureBridge',
    'unaryUriMethod',
    'uriArrayObjectField',
    'uriJoinPath',
    'uriToString',
    'voidEventValue',
    'webviewPanelCreation',
  };

  /// Validates [overrides] against [inventory] and emits deterministic files.
  VSCodeGeneratedBindings generate({
    required Map<String, Object?> inventory,
    required Map<String, Object?> overrides,
    required Map<String, Object?> project,
  }) {
    validateInputSchemaVersion(inventory, 'inventory');
    validateInputSchemaVersion(overrides, 'overrides');
    validateIrExactKeys(
      inventory,
      const {
        'schemaVersion',
        'source',
        'manifestSchema',
        'manifestValidator',
        'contributionSchemas',
        'module',
        'declarations',
      },
      path: 'inventory',
    );
    validateIrModule(inventory['module']);
    _rejectUnexpectedKeys(
      overrides,
      const {
        'schemaVersion',
        'vscodeVersion',
        'manifestSchemaSha256',
        'manifestValidatorSha256',
        'commandsContributionSchemaSha256',
        'hostContracts',
        'targets',
        'entries',
        'removals',
      },
      subject: 'Semantic Override top-level object',
    );
    validateProjectDescriptor(project);
    final source = validateIrSource(
      inventory['source'],
      inventory: inventory,
    );
    final product = objectMap(source['product'], 'inventory.source.product');
    final inventoryVersion = string(
      product['version'],
      'inventory.source.product.version',
    );
    final projectApiTargetValue = project['apiTarget'];
    if (projectApiTargetValue is! String || projectApiTargetValue.isEmpty) {
      throw const VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'project.apiTarget is required and must name an exact pinned VS Code '
            'version.',
      );
    }
    final projectApiTarget = projectApiTargetValue;
    if (projectApiTarget != inventoryVersion) {
      throw VSCodeBindingGenerationException(
        'PROJECT_API_TARGET_MISMATCH',
        'project.apiTarget $projectApiTarget differs from this build; the '
            'inventory targets $inventoryVersion. Select $inventoryVersion '
            'or provide the matching pinned inventory and Semantic Overrides.',
      );
    }
    final inputSha256 = sha256Digest(
      source['inputSha256'],
      'inventory.source.inputSha256',
    );
    final overrideVersion = string(
      overrides['vscodeVersion'],
      'overrides.vscodeVersion',
    );
    if (overrideVersion != inventoryVersion) {
      throw VSCodeBindingGenerationException(
        'OVERRIDE_VERSION_MISMATCH',
        'Semantic Overrides target VS Code $overrideVersion, but the '
            'inventory targets $inventoryVersion.',
      );
    }
    final manifestSchemaSha256 = validateManifestSchema(inventory);
    final overrideManifestSchemaSha256 = sha256Digest(
      overrides['manifestSchemaSha256'],
      'overrides.manifestSchemaSha256',
    );
    if (overrideManifestSchemaSha256 != manifestSchemaSha256) {
      throw VSCodeBindingGenerationException(
        'MANIFEST_SCHEMA_PIN_MISMATCH',
        'Semantic Overrides reviewed manifest schema '
            '$overrideManifestSchemaSha256, but the inventory uses '
            '$manifestSchemaSha256.',
      );
    }
    final manifestValidatorSha256 = validateManifestValidator(inventory);
    final overrideManifestValidatorSha256 = sha256Digest(
      overrides['manifestValidatorSha256'],
      'overrides.manifestValidatorSha256',
    );
    if (overrideManifestValidatorSha256 != manifestValidatorSha256) {
      throw VSCodeBindingGenerationException(
        'MANIFEST_VALIDATOR_PIN_MISMATCH',
        'Semantic Overrides reviewed manifest validator '
            '$overrideManifestValidatorSha256, but the inventory uses '
            '$manifestValidatorSha256.',
      );
    }
    final commandsContributionSchemaSha256 =
        validateCommandsContributionSchema(inventory);
    final overrideCommandsContributionSchemaSha256 = sha256Digest(
      overrides['commandsContributionSchemaSha256'],
      'overrides.commandsContributionSchemaSha256',
    );
    if (overrideCommandsContributionSchemaSha256 !=
        commandsContributionSchemaSha256) {
      throw VSCodeBindingGenerationException(
        'CONTRIBUTION_SCHEMA_PIN_MISMATCH',
        'Semantic Overrides reviewed commands contribution schema '
            '$overrideCommandsContributionSchemaSha256, but the inventory '
            'uses $commandsContributionSchemaSha256.',
      );
    }
    final projectName = extensionIdentifierComponent(
      project['name'],
      'project.name',
    );
    final displayName = nonEmptyString(
      project['displayName'],
      'project.displayName',
    );
    final description = nonEmptyString(
      project['description'],
      'project.description',
    );
    final projectVersion = string(project['version'], 'project.version');
    if (!isStrictSemanticVersion(projectVersion)) {
      throw const VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'project.version must be a valid semantic version.',
      );
    }
    final publisher = extensionIdentifierComponent(
      project['publisher'],
      'project.publisher',
    );
    final extensionId = '$publisher.$projectName';
    final extensionKey = 'e_${sha256.convert(utf8.encode(extensionId))}';
    final activationEvents = [
      for (final event in objectList(
        project['activationEvents'],
        'project.activationEvents',
      ))
        string(event, 'project.activationEvents entry'),
    ];
    final commands = projectCommands(project['commands']);
    final declarations = objectList(
      inventory['declarations'],
      'inventory.declarations',
    );
    final declarationsById = <String, Map<String, Object?>>{};
    final declarationPathsById = <String, String>{};
    for (var index = 0; index < declarations.length; index += 1) {
      final declarationValue = declarations[index];
      final path = 'inventory.declarations[$index]';
      final declaration = objectMap(
        declarationValue,
        path,
      );
      validateIrDeclarationKeys(declaration, path);
      final id = string(declaration['id'], 'inventory declaration.id');
      if (declarationsById.containsKey(id)) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          'Inventory contains duplicate entry $id.',
        );
      }
      declarationsById[id] = declaration;
      declarationPathsById[id] = path;
    }
    validateIrDeclarationOrder(declarations);
    for (final entry in declarationsById.entries) {
      final path = declarationPathsById[entry.key]!;
      validateIrDeclarationIdentity(
        entry.value,
        path,
        declarationsById,
      );
      final inheritedScopes = irInheritedTypeParameterScopes(
        entry.value,
        declarationsById,
        path,
      );
      validateIrDeclarationTypes(
        entry.value,
        path,
        inheritedScopes: inheritedScopes,
      );
    }
    validateIrOverloadOrdinals(declarationsById, declarationPathsById);
    validateIrTypeLiteralGraph(declarationsById, declarationPathsById);
    final knownIds = declarationsById.keys.toSet();
    final publicIds = declarationsById.entries
        .where((entry) => entry.value['visibility'] == 'public')
        .map((entry) => entry.key)
        .toSet();
    if (overrides.containsKey('removals')) {
      _validateReviewedRemovals(overrides['removals'], publicIds);
    }
    final hostContracts = _validateHostContracts(overrides['hostContracts']);
    final entries = objectMap(overrides['entries'], 'overrides.entries');
    final targetList = <String>[
      for (final target in objectList(
        overrides['targets'],
        'overrides.targets',
      ))
        string(target, 'overrides.targets entry'),
    ];
    final targetIds = <String>{};
    for (final id in targetList) {
      if (!targetIds.add(id)) {
        throw VSCodeBindingGenerationException(
          'DUPLICATE_TARGET_ID',
          'Selected binding target $id appears more than once.',
        );
      }
    }
    final strategiesById = <String, String>{};
    final hostContractsById = <String, String>{};
    for (final id in entries.keys) {
      if (!knownIds.contains(id)) {
        throw VSCodeBindingGenerationException(
          'UNKNOWN_OVERRIDE_ID',
          'Semantic Override $id does not match any inventory entry.',
        );
      }
      if (!targetIds.contains(id)) {
        throw VSCodeBindingGenerationException(
          'UNUSED_OVERRIDE',
          'Semantic Override $id is outside the selected binding closure.',
        );
      }
      final entry = objectMap(entries[id], 'overrides.entries.$id');
      final strategy = string(
        entry['strategy'],
        'overrides.entries.$id.strategy',
      );
      if (!_strategies.contains(strategy)) {
        throw VSCodeBindingGenerationException(
          'UNKNOWN_OVERRIDE_STRATEGY',
          'Semantic Override $id uses unknown strategy $strategy.',
        );
      }
      final expectedDeclarationSha256 = string(
        entry['declarationSha256'],
        'overrides.entries.$id.declarationSha256',
      );
      final actualDeclarationSha256 = computeDeclarationFingerprint(
        declarationsById[id]!,
      );
      if (expectedDeclarationSha256 != actualDeclarationSha256) {
        throw VSCodeBindingGenerationException(
          'STALE_SEMANTIC_OVERRIDE',
          'Semantic Override $id reviewed declaration '
              '$expectedDeclarationSha256, but the pinned inventory now has '
              '$actualDeclarationSha256.',
        );
      }
      if (strategy == 'reviewedExcluded') {
        if (entry.containsKey('hostContract')) {
          throw VSCodeBindingGenerationException(
            'INVALID_OVERRIDE',
            'Reviewed exclusion $id cannot cite a Host Contract.',
          );
        }
        final reason = entry['reason'];
        if (reason is! String || isEcmaScriptFalsyOrWhitespace(reason)) {
          throw VSCodeBindingGenerationException(
            'INVALID_OVERRIDE',
            'Reviewed exclusion $id requires a non-empty reason.',
          );
        }
      } else {
        final hostContractValue = entry['hostContract'];
        if (hostContractValue is! String || hostContractValue.isEmpty) {
          throw VSCodeBindingGenerationException(
            'INVALID_OVERRIDE',
            'Emitted binding $id must cite an executable Host Contract.',
          );
        }
        final hostContract = hostContractValue;
        if (!hostContracts.containsKey(hostContract)) {
          throw VSCodeBindingGenerationException(
            'INVALID_OVERRIDE',
            'Emitted binding $id cites unknown Host Contract $hostContract.',
          );
        }
        hostContractsById[id] = hostContract;
      }
      _rejectUnexpectedKeys(
        entry,
        strategy == 'reviewedExcluded'
            ? const {'strategy', 'declarationSha256', 'reason'}
            : const {'strategy', 'declarationSha256', 'hostContract'},
        subject: 'Semantic Override entry $id',
      );
      strategiesById[id] = strategy;
    }
    for (final id in targetIds) {
      if (!publicIds.contains(id)) {
        throw VSCodeBindingGenerationException(
          'UNKNOWN_TARGET_ID',
          'Selected binding target $id does not match any public inventory '
              'entry.',
        );
      }
      if (!entries.containsKey(id)) {
        throw VSCodeBindingGenerationException(
          'MISSING_OVERRIDE',
          'Selected binding target $id has no Semantic Override.',
        );
      }
    }

    final observedHostContracts = hostContractsById.values.toSet();
    final unusedHostContracts = hostContracts.keys
        .where((contract) => !observedHostContracts.contains(contract))
        .toList()
      ..sort();
    if (unusedHostContracts.isNotEmpty) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Semantic Overrides contain unused Host Contracts: '
            '${unusedHostContracts.map((contract) => '$contract is not cited').join(', ')}.',
      );
    }

    final opaqueTypes = <String>[];
    for (final id in targetIds.toList()..sort()) {
      final entry = objectMap(entries[id], 'overrides.entries.$id');
      if (entry['strategy'] == 'opaqueJsObject') {
        final declaration = declarationsById[id]!;
        opaqueTypes.add(
          string(declaration['name'], 'inventory declaration $id.name'),
        );
      }
    }
    opaqueTypes.sort();

    final walkingSlice = strategiesById.values.any(
      (strategy) => strategy != 'opaqueJsObject',
    );
    final parity = walkingSlice
        ? _emitWalkingSliceParity(
            inventoryVersion: inventoryVersion,
            extensionKey: extensionKey,
            declarationsById: declarationsById,
            strategiesById: strategiesById,
          )
        : _emitOpaqueTypes(inventoryVersion, opaqueTypes);
    final facade = walkingSlice
        ? _emitWalkingSliceFacade(declarationsById, strategiesById)
        : null;
    final runtime =
        walkingSlice ? walkingSliceRuntimeTemplate(extensionKey) : null;
    final coverage = emitCoverageLedger(
      inventoryVersion: inventoryVersion,
      inputSha256: inputSha256,
      manifestSchemaSha256: manifestSchemaSha256,
      manifestValidatorSha256: manifestValidatorSha256,
      commandsContributionSchemaSha256: commandsContributionSchemaSha256,
      declarationsById: declarationsById,
      entries: entries,
      strategiesById: strategiesById,
      hostContracts: hostContracts,
      hostContractsById: hostContractsById,
    );

    const encoder = JsonEncoder.withIndent('  ');
    final manifest = <String, Object?>{
      'name': projectName,
      'displayName': displayName,
      'description': description,
      'version': projectVersion,
      'publisher': publisher,
      'engines': <String, Object?>{'vscode': inventoryVersion},
      'main': './out/bootstrap.cjs',
      'activationEvents': activationEvents,
      if (commands.isNotEmpty)
        'contributes': <String, Object?>{'commands': commands},
    };
    final dartExtensionId = jsonEncode(extensionId);
    final javaScriptExtensionKey = jsonEncode(extensionKey);
    if (walkingSlice && observedHostContracts.length != 1) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'The first walking slice must use one Host Contract, found '
            '${observedHostContracts.toList()..sort()}.',
      );
    }
    final javaScriptHostContractId = jsonEncode(
      walkingSlice ? observedHostContracts.single : '',
    );
    final hostExports = hostExportsTemplate(
      dartExtensionId: dartExtensionId,
      extensionKey: extensionKey,
    );
    final bootstrap = bootstrapTemplate(
      javaScriptExtensionKey: javaScriptExtensionKey,
      javaScriptHostContractId: javaScriptHostContractId,
    );

    return VSCodeGeneratedBindings({
      'host/lib/generated/vscode_parity.g.dart': parity,
      if (facade != null) 'host/lib/generated/vscode_facade.g.dart': facade,
      if (runtime != null) 'host/lib/generated/vscode_runtime.g.dart': runtime,
      'host/lib/generated/host_exports.g.dart': hostExports,
      'host/bootstrap.cjs': bootstrap,
      'package.json': '${encoder.convert(manifest)}\n',
      'coverage.json': coverage,
    });
  }
}

String _emitOpaqueTypes(String inventoryVersion, List<String> names) {
  final output = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// VS Code $inventoryVersion API parity slice.')
    ..writeln()
    ..writeln("import 'dart:js_interop';")
    ..writeln();
  for (final name in names) {
    output
      ..writeln('/// Native VS Code `$name` host object.')
      ..writeln(
        'extension type $name.fromJS(JSObject _) implements JSObject {}',
      );
  }
  return output.toString();
}

String _emitWalkingSliceParity({
  required String inventoryVersion,
  required String extensionKey,
  required Map<String, Map<String, Object?>> declarationsById,
  required Map<String, String> strategiesById,
}) {
  _validateWalkingSliceStrategies(declarationsById, strategiesById);
  final bindings = _SelectedBindings(declarationsById, strategiesById);
  final commandExecution = bindings.single('commandExecution');
  final commandRegistration = bindings.single('commandRegistration');
  final commandNamespace = bindings.parentOf(commandExecution);
  final commandNamespaceName = bindings.name(commandNamespace);
  final commandNamespaceType = _upperCamel(commandNamespaceName);
  final commandExecutionName = bindings.name(commandExecution);
  final commandRegistrationName = bindings.name(commandRegistration);
  final commandExecutionParameters = _declarationParameters(commandExecution);
  final commandExecutionIdParameter = _dartIdentifier(
    commandExecutionParameters.first['name'],
    'commandExecution.parameters[0].name',
  );
  final commandRegistrationParameters = _declarationParameters(
    commandRegistration,
  );
  final commandRegistrationIdParameter = _dartIdentifier(
    commandRegistrationParameters[0]['name'],
    'commandRegistration.parameters[0].name',
  );
  final commandRegistrationCallbackParameter = _dartIdentifier(
    commandRegistrationParameters[1]['name'],
    'commandRegistration.parameters[1].name',
  );
  final commandRegistrationThisParameter = _dartIdentifier(
    commandRegistrationParameters[2]['name'],
    'commandRegistration.parameters[2].name',
  );
  final positionMembers = bindings.withStrategy('intGetterProjection');
  if (positionMembers.isEmpty) {
    throw const VSCodeBindingGenerationException(
      'WALKING_SLICE_PROFILE_MISMATCH',
      'The intGetterProjection rule requires at least one selected property.',
    );
  }
  final position = bindings.parentOf(positionMembers.first);
  if (positionMembers.any(
    (member) => member['parentId'] != bindings.id(position),
  )) {
    throw const VSCodeBindingGenerationException(
      'WALKING_SLICE_PROFILE_MISMATCH',
      'Selected intGetterProjection properties must share one host object.',
    );
  }
  final positionType = bindings.name(position);
  final positionFields = StringBuffer();
  for (final member in positionMembers) {
    positionFields
      ..writeln('  /// Projected numeric host property.')
      ..writeln('  external int get ${bindings.name(member)};')
      ..writeln();
  }
  final webviewHtml = bindings.single('stringGetterSetterProjection');
  final webviewHtmlName = bindings.name(webviewHtml);
  final webviewCspName = bindings.name(
    bindings.single('stringGetterProjection'),
  );
  final webviewReceiveName = bindings.name(
    bindings.singleWhere(
      'eventValue',
      (declaration) => declaration['kind'] == 'property',
    ),
  );
  final webviewPostMessageName = bindings.name(
    bindings.single('thenableBoolMethod'),
  );
  final webviewAsUriName = bindings.name(bindings.single('unaryUriMethod'));
  final webviewAsUriParameter = _dartIdentifier(
    _declarationParameters(bindings.single('unaryUriMethod')).first['name'],
    'unaryUriMethod.parameters[0].name',
  );
  final panelCreation = bindings.single('webviewPanelCreation');
  final windowNamespace = bindings.parentOf(panelCreation);
  final windowNamespaceName = bindings.name(windowNamespace);
  final windowNamespaceType = _upperCamel(windowNamespaceName);
  final panelCreationName = bindings.name(panelCreation);
  final optionsScriptsName = bindings.name(
    bindings.single('boolObjectField'),
  );
  final optionsRootsName = bindings.name(
    bindings.single('uriArrayObjectField'),
  );
  final panelDisposeEventName = bindings.name(
    bindings.single('voidEventValue'),
  );
  final uriJoinPathName = bindings.name(bindings.single('uriJoinPath'));
  final uriType = bindings.name(
    bindings.parentOf(bindings.single('uriJoinPath')),
  );
  final upstreamUriToStringName = bindings.name(bindings.single('uriToString'));
  final dartUriToStringName = upstreamUriToStringName == 'toString'
      ? 'toUriString'
      : upstreamUriToStringName;
  final enumMember = bindings.single('intEnumMember');
  final enumMemberName = _lowerCamel(bindings.name(enumMember));
  final enumInitializer = objectMap(
    enumMember['initializer'],
    'intEnumMember.initializer',
  );
  final enumValue = integer(
    enumInitializer['value'],
    'intEnumMember.initializer.value',
  );
  final disposable = bindings.parentWithChild(
    'nativeJsClass',
    'disposeMethod',
  );
  final disposableType = bindings.name(disposable);
  final disposeName = bindings.name(
    bindings.singleChildOf(disposable, 'disposeMethod'),
  );
  final thenableType = bindings.name(bindings.single('thenableFutureBridge'));
  final eventType = bindings.name(bindings.single('eventType'));
  final contextSubscriptions = bindings.single('subscriptionsArray');
  final extensionContext = bindings.parentOf(contextSubscriptions);
  final extensionContextType = bindings.name(extensionContext);
  final extensionUriName = bindings.name(
    bindings.singleChildOf(extensionContext, 'objectGetterProjection'),
  );
  final contextSubscriptionsName = bindings.name(contextSubscriptions);
  final hoverRegistration = bindings.single('hoverProviderRegistration');
  final languageNamespace = bindings.parentOf(hoverRegistration);
  final languageNamespaceName = bindings.name(languageNamespace);
  final languageNamespaceType = _upperCamel(languageNamespaceName);
  final hoverRegistrationName = bindings.name(hoverRegistration);
  final hoverProvider = bindings.single('providerObject');
  final hoverProviderType = bindings.name(hoverProvider);
  final providerCallback = bindings.single('providerCallback');
  final providerCallbackName = bindings.name(providerCallback);
  final providerParameters = _declarationParameters(providerCallback);
  final textDocumentType = bindings.name(
    bindings.selectedReference(providerParameters[0]['type']),
  );
  final cancellationTokenType = bindings.name(
    bindings.selectedReference(providerParameters[2]['type']),
  );
  final cancellationRequestedName = bindings.name(
    bindings.single('boolGetterProjection'),
  );
  final workspaceEvent = bindings.singleWhere(
    'eventValue',
    (declaration) => declaration['kind'] == 'variable',
  );
  final workspaceNamespace = bindings.parentOf(workspaceEvent);
  final workspaceNamespaceName = bindings.name(workspaceNamespace);
  final workspaceNamespaceType = _upperCamel(workspaceNamespaceName);
  final workspaceEventName = bindings.name(workspaceEvent);
  final enumType = bindings.name(bindings.parentOf(enumMember));
  final optionsType = bindings.name(bindings.single('jsObjectLiteral'));
  final webviewPanel = bindings.parentOf(
    bindings.single('voidEventValue'),
  );
  final webviewPanelType = bindings.name(webviewPanel);
  final panelWebview = bindings.singleChildOf(
    webviewPanel,
    'objectGetterProjection',
  );
  final panelWebviewName = bindings.name(panelWebview);
  final webviewType = bindings.name(
    bindings.selectedReference(panelWebview['type']),
  );
  final panelDisposeName = bindings.name(
    bindings.singleChildOf(webviewPanel, 'disposeMethod'),
  );
  final markdownConstructor = bindings.single('markdownStringConstructor');
  final markdownType = bindings.name(bindings.parentOf(markdownConstructor));
  final rangeConstructor = bindings.single('numericRangeConstructor');
  final rangeType = bindings.name(bindings.parentOf(rangeConstructor));
  final hoverConstructor = bindings.single('markdownHoverConstructor');
  final hoverType = bindings.name(bindings.parentOf(hoverConstructor));
  return walkingSliceParityTemplate(
    inventoryVersion: inventoryVersion,
    commandNamespaceType: commandNamespaceType,
    commandNamespaceName: commandNamespaceName,
    languageNamespaceType: languageNamespaceType,
    languageNamespaceName: languageNamespaceName,
    windowNamespaceType: windowNamespaceType,
    windowNamespaceName: windowNamespaceName,
    workspaceNamespaceType: workspaceNamespaceType,
    workspaceNamespaceName: workspaceNamespaceName,
    disposableType: disposableType,
    commandRegistrationName: commandRegistrationName,
    commandRegistrationIdParameter: commandRegistrationIdParameter,
    commandRegistrationCallbackParameter: commandRegistrationCallbackParameter,
    commandRegistrationThisParameter: commandRegistrationThisParameter,
    thenableType: thenableType,
    commandExecutionName: commandExecutionName,
    commandExecutionIdParameter: commandExecutionIdParameter,
    disposeName: disposeName,
    extensionContextType: extensionContextType,
    uriType: uriType,
    extensionUriName: extensionUriName,
    contextSubscriptionsName: contextSubscriptionsName,
    hoverRegistrationName: hoverRegistrationName,
    hoverProviderType: hoverProviderType,
    providerCallbackName: providerCallbackName,
    textDocumentType: textDocumentType,
    cancellationTokenType: cancellationTokenType,
    cancellationRequestedName: cancellationRequestedName,
    eventType: eventType,
    workspaceEventName: workspaceEventName,
    webviewPanelType: webviewPanelType,
    panelCreationName: panelCreationName,
    optionsType: optionsType,
    enumType: enumType,
    enumMemberName: enumMemberName,
    enumValue: enumValue,
    optionsScriptsName: optionsScriptsName,
    optionsRootsName: optionsRootsName,
    positionType: positionType,
    positionFields: positionFields.toString(),
    extensionKey: extensionKey,
    uriJoinPathName: uriJoinPathName,
    upstreamUriToStringName: upstreamUriToStringName,
    dartUriToStringName: dartUriToStringName,
    webviewType: webviewType,
    panelWebviewName: panelWebviewName,
    panelDisposeEventName: panelDisposeEventName,
    panelDisposeName: panelDisposeName,
    webviewHtmlName: webviewHtmlName,
    webviewCspName: webviewCspName,
    webviewAsUriName: webviewAsUriName,
    webviewAsUriParameter: webviewAsUriParameter,
    webviewPostMessageName: webviewPostMessageName,
    webviewReceiveName: webviewReceiveName,
    markdownType: markdownType,
    rangeType: rangeType,
    hoverType: hoverType,
  );
}

String _emitWalkingSliceFacade(
  Map<String, Map<String, Object?>> declarationsById,
  Map<String, String> strategiesById,
) {
  final bindings = _SelectedBindings(declarationsById, strategiesById);
  final commandExecution = bindings.single('commandExecution');
  final commandRegistration = bindings.single('commandRegistration');
  final commandNamespace = bindings.parentOf(commandExecution);
  final commandNamespaceName = bindings.name(commandNamespace);
  final commandNamespaceType = _upperCamel(commandNamespaceName);
  final commandExecutionName = bindings.name(commandExecution);
  final commandRegistrationName = bindings.name(commandRegistration);
  final webviewHtmlName = bindings.name(
    bindings.single('stringGetterSetterProjection'),
  );
  final webviewCspName = bindings.name(
    bindings.single('stringGetterProjection'),
  );
  final webviewReceiveName = bindings.name(
    bindings.singleWhere(
      'eventValue',
      (declaration) => declaration['kind'] == 'property',
    ),
  );
  final webviewPostMessageName = bindings.name(
    bindings.single('thenableBoolMethod'),
  );
  final webviewAsUriName = bindings.name(bindings.single('unaryUriMethod'));
  final panelCreation = bindings.single('webviewPanelCreation');
  final windowNamespace = bindings.parentOf(panelCreation);
  final windowNamespaceName = bindings.name(windowNamespace);
  final windowNamespaceType = _upperCamel(windowNamespaceName);
  final panelCreationName = bindings.name(panelCreation);
  final optionsScriptsName = bindings.name(
    bindings.single('boolObjectField'),
  );
  final optionsRootsName = bindings.name(
    bindings.single('uriArrayObjectField'),
  );
  final panelDisposeEventName = bindings.name(
    bindings.single('voidEventValue'),
  );
  final uriJoinPathName = bindings.name(bindings.single('uriJoinPath'));
  final upstreamUriToStringName = bindings.name(bindings.single('uriToString'));
  final dartUriToStringName = upstreamUriToStringName == 'toString'
      ? 'toUriString'
      : upstreamUriToStringName;
  final enumMemberName = _lowerCamel(
    bindings.name(bindings.single('intEnumMember')),
  );
  final uriType = bindings.name(
    bindings.parentOf(bindings.single('uriJoinPath')),
  );
  final disposable = bindings.parentWithChild(
    'nativeJsClass',
    'disposeMethod',
  );
  final disposableType = bindings.name(disposable);
  final disposeName = bindings.name(
    bindings.singleChildOf(disposable, 'disposeMethod'),
  );
  final contextSubscriptions = bindings.single('subscriptionsArray');
  final extensionContext = bindings.parentOf(contextSubscriptions);
  final extensionContextType = bindings.name(extensionContext);
  final extensionUriName = bindings.name(
    bindings.singleChildOf(extensionContext, 'objectGetterProjection'),
  );
  final contextSubscriptionsName = bindings.name(contextSubscriptions);
  final hoverRegistration = bindings.single('hoverProviderRegistration');
  final languageNamespace = bindings.parentOf(hoverRegistration);
  final languageNamespaceName = bindings.name(languageNamespace);
  final languageNamespaceType = _upperCamel(languageNamespaceName);
  final hoverRegistrationName = bindings.name(hoverRegistration);
  final hoverProvider = bindings.single('providerObject');
  final hoverProviderType = bindings.name(hoverProvider);
  final providerCallback = bindings.single('providerCallback');
  final providerCallbackName = bindings.name(providerCallback);
  final providerParameters = _declarationParameters(providerCallback);
  final cancellationTokenType = bindings.name(
    bindings.selectedReference(providerParameters[2]['type']),
  );
  final cancellationRequestedName = bindings.name(
    bindings.single('boolGetterProjection'),
  );
  final workspaceEvent = bindings.singleWhere(
    'eventValue',
    (declaration) => declaration['kind'] == 'variable',
  );
  final workspaceNamespace = bindings.parentOf(workspaceEvent);
  final workspaceNamespaceName = bindings.name(workspaceNamespace);
  final workspaceNamespaceType = _upperCamel(workspaceNamespaceName);
  final workspaceEventName = bindings.name(workspaceEvent);
  final enumType = bindings.name(
    bindings.parentOf(bindings.single('intEnumMember')),
  );
  final optionsType = bindings.name(bindings.single('jsObjectLiteral'));
  final webviewPanel = bindings.parentOf(bindings.single('voidEventValue'));
  final webviewPanelType = bindings.name(webviewPanel);
  final panelWebview = bindings.singleChildOf(
    webviewPanel,
    'objectGetterProjection',
  );
  final panelWebviewName = bindings.name(panelWebview);
  final webviewType = bindings.name(
    bindings.selectedReference(panelWebview['type']),
  );
  final panelDisposeName = bindings.name(
    bindings.singleChildOf(webviewPanel, 'disposeMethod'),
  );
  final markdownType = bindings.name(
    bindings.parentOf(bindings.single('markdownStringConstructor')),
  );
  final rangeType = bindings.name(
    bindings.parentOf(bindings.single('numericRangeConstructor')),
  );
  final hoverType = bindings.name(
    bindings.parentOf(bindings.single('markdownHoverConstructor')),
  );
  final observationIds = _walkingSliceObservationIds(
    declarationsById,
    strategiesById,
  );
  final observationConstants = StringBuffer();
  final observationNames = observationIds.keys.toList()..sort();
  for (final name in observationNames) {
    observationConstants.writeln(
      'const _binding${_upperCamel(name)} = '
      '${_dartStringLiteral(observationIds[name]!)};',
    );
  }
  final positionMembers = bindings.withStrategy('intGetterProjection');
  final position = bindings.parentOf(positionMembers.first);
  final positionFacade = StringBuffer()
    ..writeln('/// Observed numeric projections supplied by VS Code callbacks.')
    ..writeln(
      'extension ${bindings.name(position)}Facade on '
      '${bindings.name(position)} {',
    );
  for (var index = 0; index < positionMembers.length; index += 1) {
    final memberName = bindings.name(positionMembers[index]);
    final facadeName = switch (memberName) {
      'line' => 'lineNumber',
      'character' => 'characterOffset',
      _ => '${memberName}Value',
    };
    positionFacade
      ..writeln('  /// Reads the observed `$memberName` host property.')
      ..writeln('  int get $facadeName {')
      ..writeln('    final value = $memberName;')
      ..writeln('    observeHostBindings(const [')
      ..writeln('      _bindingPositionClass,')
      ..writeln('      _bindingPositionProjection$index,')
      ..writeln('    ]);')
      ..writeln('    return value;')
      ..writeln('  }')
      ..writeln();
  }
  positionFacade.writeln('}');
  return walkingSliceFacadeTemplate(
    observationConstants: observationConstants.toString(),
    commandNamespaceType: commandNamespaceType,
    commandNamespaceName: commandNamespaceName,
    languageNamespaceType: languageNamespaceType,
    languageNamespaceName: languageNamespaceName,
    windowNamespaceType: windowNamespaceType,
    windowNamespaceName: windowNamespaceName,
    workspaceNamespaceType: workspaceNamespaceType,
    workspaceNamespaceName: workspaceNamespaceName,
    disposableType: disposableType,
    commandRegistrationName: commandRegistrationName,
    commandExecutionName: commandExecutionName,
    extensionContextType: extensionContextType,
    uriType: uriType,
    extensionUriName: extensionUriName,
    contextSubscriptionsName: contextSubscriptionsName,
    disposeName: disposeName,
    hoverProviderType: hoverProviderType,
    hoverRegistrationName: hoverRegistrationName,
    providerCallbackName: providerCallbackName,
    positionFacade: positionFacade.toString(),
    cancellationTokenType: cancellationTokenType,
    cancellationRequestedName: cancellationRequestedName,
    markdownType: markdownType,
    rangeType: rangeType,
    hoverType: hoverType,
    workspaceEventName: workspaceEventName,
    webviewPanelType: webviewPanelType,
    enumType: enumType,
    enumMemberName: enumMemberName,
    panelCreationName: panelCreationName,
    optionsType: optionsType,
    optionsScriptsName: optionsScriptsName,
    optionsRootsName: optionsRootsName,
    dartUriToStringName: dartUriToStringName,
    uriJoinPathName: uriJoinPathName,
    webviewType: webviewType,
    panelWebviewName: panelWebviewName,
    panelDisposeEventName: panelDisposeEventName,
    panelDisposeName: panelDisposeName,
    webviewHtmlName: webviewHtmlName,
    webviewCspName: webviewCspName,
    webviewAsUriName: webviewAsUriName,
    webviewPostMessageName: webviewPostMessageName,
    webviewReceiveName: webviewReceiveName,
  );
}

Map<String, String> _walkingSliceObservationIds(
  Map<String, Map<String, Object?>> declarationsById,
  Map<String, String> strategiesById,
) {
  final bindings = _SelectedBindings(declarationsById, strategiesById);
  final commandExecution = bindings.single('commandExecution');
  final commandRegistration = bindings.single('commandRegistration');
  final hoverRegistration = bindings.single('hoverProviderRegistration');
  final panelCreation = bindings.single('webviewPanelCreation');
  final workspaceEvent = bindings.singleWhere(
    'eventValue',
    (declaration) => declaration['kind'] == 'variable',
  );
  final commandNamespace = bindings.parentOf(commandExecution);
  final languageNamespace = bindings.parentOf(hoverRegistration);
  final windowNamespace = bindings.parentOf(panelCreation);
  final workspaceNamespace = bindings.parentOf(workspaceEvent);

  final disposableClass =
      bindings.parentWithChild('nativeJsClass', 'disposeMethod');
  final hoverConstructor = bindings.single('markdownHoverConstructor');
  final markdownConstructor = bindings.single('markdownStringConstructor');
  final rangeConstructor = bindings.single('numericRangeConstructor');
  final uriJoinPath = bindings.single('uriJoinPath');
  final hoverClass = bindings.parentOf(hoverConstructor);
  final markdownClass = bindings.parentOf(markdownConstructor);
  final rangeClass = bindings.parentOf(rangeConstructor);
  final uriClass = bindings.parentOf(uriJoinPath);

  final positionMembers = bindings.withStrategy('intGetterProjection');
  if (positionMembers.isEmpty) {
    throw const VSCodeBindingGenerationException(
      'WALKING_SLICE_PROFILE_MISMATCH',
      'The intGetterProjection rule requires at least one selected property.',
    );
  }
  final positionClass = bindings.parentOf(positionMembers.first);
  final cancellationRequested = bindings.single('boolGetterProjection');
  final cancellationToken = bindings.parentOf(cancellationRequested);
  final contextSubscriptions = bindings.single('subscriptionsArray');
  final extensionContext = bindings.parentOf(contextSubscriptions);
  final webviewPostMessage = bindings.single('thenableBoolMethod');
  final webview = bindings.parentOf(webviewPostMessage);
  final panelDisposeEvent = bindings.single('voidEventValue');
  final webviewPanel = bindings.parentOf(panelDisposeEvent);
  final webviewOptions = bindings.single('jsObjectLiteral');
  final providerCallback = bindings.single('providerCallback');
  final providerParameters = _declarationParameters(providerCallback);
  final textDocument = bindings.selectedReference(
    providerParameters.first['type'],
  );
  final structuralDisposable = bindings.single('disposableStructuralType');
  final webviewReceive = bindings.singleWhere(
    'eventValue',
    (declaration) => declaration['parentId'] == bindings.id(webview),
  );

  String id(Map<String, Object?> declaration) => bindings.id(declaration);
  return <String, String>{
    'eventCall': id(bindings.single('eventSubscription')),
    'disposableClass': id(disposableClass),
    'hoverClass': id(hoverClass),
    'markdownStringClass': id(markdownClass),
    'positionClass': id(positionClass),
    'rangeClass': id(rangeClass),
    'uriClass': id(uriClass),
    'hoverConstructor': id(hoverConstructor),
    'markdownStringConstructor': id(markdownConstructor),
    'rangeConstructor': id(rangeConstructor),
    'viewColumnEnum': id(bindings.single('nativeJsEnum')),
    'viewColumnOne': id(bindings.single('intEnumMember')),
    'executeCommand': id(commandExecution),
    'registerCommand': id(commandRegistration),
    'registerHoverProvider': id(hoverRegistration),
    'createWebviewPanel': id(panelCreation),
    'thenableInterface': id(bindings.single('thenableFutureBridge')),
    'cancellationTokenInterface': id(cancellationToken),
    'eventInterface': id(bindings.single('eventType')),
    'extensionContextInterface': id(extensionContext),
    'hoverProviderInterface': id(bindings.single('providerObject')),
    'textDocumentInterface': id(textDocument),
    'webviewInterface': id(webview),
    'webviewOptionsInterface': id(webviewOptions),
    'webviewPanelInterface': id(webviewPanel),
    'disposableDispose': id(
      bindings.singleChildOf(disposableClass, 'disposeMethod'),
    ),
    'contextSubscriptionDispose': id(
      bindings.singleChildOf(structuralDisposable, 'disposeMethod'),
    ),
    'hoverProviderCallback': id(providerCallback),
    'uriJoinPath': id(uriJoinPath),
    'uriToString': id(bindings.single('uriToString')),
    'webviewAsUri': id(bindings.single('unaryUriMethod')),
    'webviewPostMessage': id(webviewPostMessage),
    'webviewPanelDispose': id(
      bindings.singleChildOf(webviewPanel, 'disposeMethod'),
    ),
    'commandsNamespace': id(commandNamespace),
    'languagesNamespace': id(languageNamespace),
    'windowNamespace': id(windowNamespace),
    'workspaceNamespace': id(workspaceNamespace),
    for (var index = 0; index < positionMembers.length; index += 1)
      'positionProjection$index': id(positionMembers[index]),
    'cancellationRequested': id(cancellationRequested),
    'extensionUri': id(
      bindings.singleChildOf(extensionContext, 'objectGetterProjection'),
    ),
    'contextSubscriptions': id(contextSubscriptions),
    'webviewCsp': id(bindings.single('stringGetterProjection')),
    'webviewHtml': id(bindings.single('stringGetterSetterProjection')),
    'webviewReceive': id(webviewReceive),
    'optionsScripts': id(bindings.single('boolObjectField')),
    'optionsRoots': id(bindings.single('uriArrayObjectField')),
    'panelDisposeEvent': id(panelDisposeEvent),
    'panelWebview': id(
      bindings.singleChildOf(webviewPanel, 'objectGetterProjection'),
    ),
    'documentSelector': id(bindings.single('stringSelectorProjection')),
    'providerResult': id(bindings.single('providerResultProjection')),
    'contextSubscriptionType': id(structuralDisposable),
    'workspaceOpenEvent': id(workspaceEvent),
  };
}

String _upperCamel(String value) =>
    '${value.substring(0, 1).toUpperCase()}${value.substring(1)}';

String _lowerCamel(String value) =>
    '${value.substring(0, 1).toLowerCase()}${value.substring(1)}';

String _dartStringLiteral(String value) {
  if (value.contains("'") || value.contains('\n') || value.contains('\r')) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Host observation ID cannot be emitted as a raw Dart string: $value.',
    );
  }
  return value.contains(r'$') ? "r'$value'" : "'$value'";
}

void _validateWalkingSliceStrategies(
  Map<String, Map<String, Object?>> declarationsById,
  Map<String, String> strategiesById,
) {
  final bindings = _SelectedBindings(declarationsById, strategiesById);
  for (final entry in strategiesById.entries) {
    final declaration = declarationsById[entry.key]!;
    if (!_strategyAcceptsDeclaration(entry.value, declaration)) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'Semantic strategy ${entry.value} does not support the pinned shape '
            'of ${entry.key}. Update the general translation rule or choose '
            'a strategy that matches this declaration.',
      );
    }
  }

  const {
    'commandExecution',
    'commandRegistration',
    'eventSubscription',
    'eventType',
    'hoverProviderRegistration',
    'intEnumMember',
    'jsObjectLiteral',
    'markdownHoverConstructor',
    'markdownStringConstructor',
    'nativeJsEnum',
    'numericRangeConstructor',
    'providerCallback',
    'providerObject',
    'providerResultProjection',
    'stringSelectorProjection',
    'subscriptionsArray',
    'thenableBoolMethod',
    'thenableFutureBridge',
    'unaryUriMethod',
    'uriArrayObjectField',
    'uriJoinPath',
    'uriToString',
    'voidEventValue',
    'webviewPanelCreation',
  }.forEach(bindings.single);

  _validateWalkingSliceRelations(bindings);
}

void _validateWalkingSliceRelations(_SelectedBindings bindings) {
  // This local assertion reads most clearly as `(declaration, condition,
  // relationship)` at each call site.
  void expectRelation(
    Map<String, Object?> declaration,
    // The condition reads as the subject of this local assertion.
    // ignore: avoid_positional_boolean_parameters
    bool matches,
    String relationship,
  ) {
    if (!matches) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'Selected declaration ${bindings.id(declaration)} does not satisfy '
            'the $relationship relation required by its generated Dart '
            'binding.',
      );
    }
  }

  bool references(
    Object? value,
    Map<String, Object?> target, {
    int? typeArgumentCount,
  }) {
    if (!_isType(value, kind: 'reference', name: bindings.name(target))) {
      return false;
    }
    if (typeArgumentCount == null) {
      return true;
    }
    final arguments = (value! as Map<Object?, Object?>)['typeArguments'];
    return arguments is List<Object?> && arguments.length == typeArgumentCount;
  }

  bool containsReference(
    Object? value,
    Map<String, Object?> target,
  ) {
    if (references(value, target)) {
      return true;
    }
    if (value is! Map<Object?, Object?>) {
      return false;
    }
    final types = value['types'];
    return types is List<Object?> &&
        types.any((candidate) => references(candidate, target));
  }

  Object? referenceArgument(Object? value, int index) {
    if (!_isType(value, kind: 'reference')) {
      return null;
    }
    final arguments = (value! as Map<Object?, Object?>)['typeArguments'];
    if (arguments is! List<Object?> || index >= arguments.length) {
      return null;
    }
    return arguments[index];
  }

  Object? arrayElement(Object? value) {
    if (!_isType(value, kind: 'array')) {
      return null;
    }
    return (value! as Map<Object?, Object?>)['elementType'];
  }

  Object? readonlyArrayElement(Object? value) {
    if (!_isType(value, kind: 'operator')) {
      return null;
    }
    final operator = value! as Map<Object?, Object?>;
    if (operator['operator'] != 'readonly') {
      return null;
    }
    return arrayElement(operator['type']);
  }

  final thenable = bindings.single('thenableFutureBridge');
  final event = bindings.single('eventType');
  final disposable = bindings.parentWithChild(
    'nativeJsClass',
    'disposeMethod',
  );
  final uriJoinPath = bindings.single('uriJoinPath');
  final uri = bindings.parentOf(uriJoinPath);
  final positionMembers = bindings.withStrategy('intGetterProjection');
  final position = bindings.parentOf(positionMembers.first);
  final cancellationProperty = bindings.single('boolGetterProjection');
  final cancellationToken = bindings.parentOf(cancellationProperty);
  final markdownConstructor = bindings.single('markdownStringConstructor');
  final markdown = bindings.parentOf(markdownConstructor);
  final rangeConstructor = bindings.single('numericRangeConstructor');
  final range = bindings.parentOf(rangeConstructor);
  final hoverConstructor = bindings.single('markdownHoverConstructor');
  final hover = bindings.parentOf(hoverConstructor);
  final viewColumnMember = bindings.single('intEnumMember');
  final viewColumn = bindings.parentOf(viewColumnMember);
  final webviewPostMessage = bindings.single('thenableBoolMethod');
  final webview = bindings.parentOf(webviewPostMessage);
  final panelDisposeEvent = bindings.single('voidEventValue');
  final webviewPanel = bindings.parentOf(panelDisposeEvent);
  final webviewOptions = bindings.single('jsObjectLiteral');
  final provider = bindings.single('providerObject');
  final providerResult = bindings.single('providerResultProjection');
  final documentSelector = bindings.single('stringSelectorProjection');

  for (final constructor in [
    markdownConstructor,
    rangeConstructor,
    hoverConstructor,
  ]) {
    final parent = bindings.parentOf(constructor);
    expectRelation(
      parent,
      parent['kind'] == 'class' && parent['abstract'] == false,
      'non-abstract native class behind an emitted constructor',
    );
  }

  final commandExecution = bindings.single('commandExecution');
  final commandRegistration = bindings.single('commandRegistration');
  expectRelation(
    commandRegistration,
    commandRegistration['parentId'] == commandExecution['parentId'],
    'shared commands namespace',
  );
  expectRelation(
    commandExecution,
    references(commandExecution['returnType'], thenable, typeArgumentCount: 1),
    'selected Thenable return type',
  );
  expectRelation(
    commandRegistration,
    references(commandRegistration['returnType'], disposable),
    'selected Disposable return type',
  );

  final eventSubscription = bindings.single('eventSubscription');
  final eventSubscriptionParameters = _declarationParameters(
    eventSubscription,
  );
  expectRelation(
    eventSubscription,
    eventSubscription['parentId'] == bindings.id(event) &&
        _functionConsumesSingleTypeParameter(
          eventSubscriptionParameters.first['type'],
          event,
        ),
    'selected Event call signature parent and listener generic',
  );
  expectRelation(
    eventSubscription,
    references(eventSubscription['returnType'], disposable) &&
        references(
          arrayElement(eventSubscriptionParameters[2]['type']),
          disposable,
        ),
    'selected Disposable event subscription types',
  );
  for (final eventValue in bindings.withStrategy('eventValue')) {
    expectRelation(
      eventValue,
      references(eventValue['type'], event, typeArgumentCount: 1),
      'selected Event value type',
    );
  }
  expectRelation(
    panelDisposeEvent,
    references(panelDisposeEvent['type'], event, typeArgumentCount: 1),
    'selected Event<void> value type',
  );

  expectRelation(
    webviewPostMessage,
    references(
      webviewPostMessage['returnType'],
      thenable,
      typeArgumentCount: 1,
    ),
    'selected Thenable<boolean> return type',
  );
  final webviewUri = bindings.single('unaryUriMethod');
  final webviewUriParameters = _declarationParameters(webviewUri);
  expectRelation(
    webviewUri,
    webviewUri['parentId'] == bindings.id(webview) &&
        references(webviewUriParameters.single['type'], uri) &&
        references(webviewUri['returnType'], uri),
    'selected Webview and Uri types',
  );
  for (final strategy in const [
    'stringGetterProjection',
    'stringGetterSetterProjection',
  ]) {
    final property = bindings.single(strategy);
    expectRelation(
      property,
      property['parentId'] == bindings.id(webview),
      'selected Webview parent',
    );
  }
  final webviewReceive = bindings.singleWhere(
    'eventValue',
    (declaration) => declaration['kind'] == 'property',
  );
  expectRelation(
    webviewReceive,
    webviewReceive['parentId'] == bindings.id(webview) &&
        _isReferenceWithSingleArgument(
          webviewReceive['type'],
          bindings.name(event),
          'primitive',
          'any',
        ),
    'selected Webview parent and message value type',
  );

  final uriToString = bindings.single('uriToString');
  expectRelation(
    uriToString,
    uriToString['parentId'] == bindings.id(uri),
    'selected Uri parent',
  );
  final optionsRoots = bindings.single('uriArrayObjectField');
  expectRelation(
    optionsRoots,
    optionsRoots['parentId'] == bindings.id(webviewOptions) &&
        references(readonlyArrayElement(optionsRoots['type']), uri),
    'selected WebviewOptions and Uri element types',
  );
  final optionsScripts = bindings.single('boolObjectField');
  expectRelation(
    optionsScripts,
    optionsScripts['parentId'] == bindings.id(webviewOptions),
    'selected WebviewOptions parent',
  );

  final contextSubscriptions = bindings.single('subscriptionsArray');
  final extensionContext = bindings.parentOf(contextSubscriptions);
  final contextDisposable = bindings.single('disposableStructuralType');
  final subscriptionElement = arrayElement(contextSubscriptions['type']);
  expectRelation(
    contextSubscriptions,
    subscriptionElement is Map<Object?, Object?> &&
        subscriptionElement['kind'] == 'typeLiteral' &&
        subscriptionElement['id'] == bindings.id(contextDisposable),
    'selected structural subscription element type',
  );
  final extensionUri = bindings.singleChildOf(
    extensionContext,
    'objectGetterProjection',
  );
  expectRelation(
    extensionUri,
    references(extensionUri['type'], uri),
    'selected Uri property type',
  );

  final disposalMethods = [
    bindings.singleChildOf(disposable, 'disposeMethod'),
    bindings.singleChildOf(contextDisposable, 'disposeMethod'),
    bindings.singleChildOf(webviewPanel, 'disposeMethod'),
  ];
  final disposalNameCounts = <String, int>{};
  for (final disposalMethod in disposalMethods) {
    final name = bindings.name(disposalMethod);
    disposalNameCounts[name] = (disposalNameCounts[name] ?? 0) + 1;
  }
  final disposalNamesByFrequency = disposalNameCounts.entries.toList()
    ..sort((left, right) {
      final countOrder = right.value.compareTo(left.value);
      return countOrder != 0 ? countOrder : left.key.compareTo(right.key);
    });
  final disposalName = disposalNamesByFrequency.first.key;
  for (final disposalMethod in disposalMethods) {
    expectRelation(
      disposalMethod,
      bindings.name(disposalMethod) == disposalName,
      'shared structural, native, and panel disposal member name',
    );
  }

  final panelWebview = bindings.singleChildOf(
    webviewPanel,
    'objectGetterProjection',
  );
  expectRelation(
    panelWebview,
    references(panelWebview['type'], webview),
    'selected Webview property type',
  );
  final panelCreation = bindings.single('webviewPanelCreation');
  final panelCreationParameters = _declarationParameters(panelCreation);
  expectRelation(
    panelCreation,
    references(panelCreation['returnType'], webviewPanel) &&
        containsReference(panelCreationParameters[2]['type'], viewColumn) &&
        containsReference(panelCreationParameters[3]['type'], webviewOptions),
    'selected ViewColumn, WebviewOptions, and WebviewPanel types',
  );

  final hoverRegistration = bindings.single('hoverProviderRegistration');
  final hoverRegistrationParameters = _declarationParameters(
    hoverRegistration,
  );
  expectRelation(
    hoverRegistration,
    references(hoverRegistrationParameters[0]['type'], documentSelector) &&
        references(hoverRegistrationParameters[1]['type'], provider) &&
        references(hoverRegistration['returnType'], disposable),
    'selected selector, provider, and Disposable types',
  );
  final providerCallback = bindings.single('providerCallback');
  final providerParameters = _declarationParameters(providerCallback);
  final callbackDocument = bindings.selectedReference(
    providerParameters[0]['type'],
  );
  expectRelation(
    providerCallback,
    providerCallback['parentId'] == bindings.id(provider) &&
        references(providerParameters[1]['type'], position) &&
        references(providerParameters[2]['type'], cancellationToken) &&
        references(providerCallback['returnType'], providerResult) &&
        references(referenceArgument(providerCallback['returnType'], 0), hover),
    'selected provider callback types',
  );
  expectRelation(
    providerResult,
    _isProviderResultProjection(
      providerResult,
      bindings.name(thenable),
    ),
    'selected ProviderResult generic and Thenable union shape',
  );
  final workspaceEvent = bindings.singleWhere(
    'eventValue',
    (declaration) => declaration['kind'] == 'variable',
  );
  expectRelation(
    workspaceEvent,
    references(referenceArgument(workspaceEvent['type'], 0), callbackDocument),
    'provider document event argument type',
  );

  final hoverParameters = _declarationParameters(hoverConstructor);
  expectRelation(
    hoverConstructor,
    containsReference(hoverParameters[0]['type'], markdown) &&
        references(hoverParameters[1]['type'], range),
    'selected MarkdownString and Range constructor types',
  );
}

bool _strategyAcceptsDeclaration(
  String strategy,
  Map<String, Object?> declaration,
) {
  const nonGenericCallableStrategies = <String>{
    'commandRegistration',
    'disposeMethod',
    'eventSubscription',
    'hoverProviderRegistration',
    'markdownHoverConstructor',
    'markdownStringConstructor',
    'numericRangeConstructor',
    'providerCallback',
    'thenableBoolMethod',
    'unaryUriMethod',
    'uriJoinPath',
    'uriToString',
    'webviewPanelCreation',
  };
  if (nonGenericCallableStrategies.contains(strategy) &&
      !_hasTypeParameterCount(declaration, 0)) {
    return false;
  }
  final kind = declaration['kind'];
  final parameters = _declarationParameters(declaration);
  final type = declaration['type'];
  final returnType = declaration['returnType'];
  switch (strategy) {
    case 'namespaceObject':
      return kind == 'namespace';
    case 'nativeJsClass':
      return kind == 'class' && _hasTypeParameterCount(declaration, 0);
    case 'opaqueHostObject':
      return (kind == 'class' || kind == 'interface') &&
          _hasTypeParameterCount(declaration, 0);
    case 'opaqueJsObject':
      return kind == 'class' || kind == 'interface';
    case 'nativeJsEnum':
      return kind == 'enum';
    case 'intEnumMember':
      final initializer = declaration['initializer'];
      return kind == 'enumMember' &&
          initializer is Map<Object?, Object?> &&
          initializer['kind'] == 'literal' &&
          initializer['value'] is int;
    case 'eventType':
      return kind == 'interface' &&
          _hasUnboundedSingleTypeParameter(declaration);
    case 'thenableFutureBridge':
      return kind == 'interface' &&
          _hasUnboundedSingleTypeParameter(declaration) &&
          _extendsSingleTypeParameter(declaration, 'PromiseLike');
    case 'providerObject':
    case 'jsObjectLiteral':
      return kind == 'interface' &&
          _hasTypeParameterCount(declaration, 0) &&
          _hasNoHeritage(declaration);
    case 'disposableStructuralType':
      return kind == 'typeLiteral';
    case 'reviewedExcluded':
      return true;
    case 'boolGetterProjection':
      return _isProperty(
            declaration,
            readonly: null,
            optional: false,
          ) &&
          _isType(type, kind: 'primitive', name: 'boolean');
    case 'boolObjectField':
      return _isProperty(
            declaration,
            readonly: true,
            optional: true,
          ) &&
          _isType(type, kind: 'primitive', name: 'boolean');
    case 'intGetterProjection':
      return _isProperty(
            declaration,
            readonly: true,
            optional: false,
          ) &&
          _isType(type, kind: 'primitive', name: 'number');
    case 'stringGetterProjection':
      return _isProperty(
            declaration,
            readonly: true,
            optional: false,
          ) &&
          _isType(type, kind: 'primitive', name: 'string');
    case 'stringGetterSetterProjection':
      return _isProperty(
            declaration,
            readonly: false,
            optional: false,
          ) &&
          _isType(type, kind: 'primitive', name: 'string');
    case 'objectGetterProjection':
      return _isProperty(
            declaration,
            readonly: true,
            optional: false,
          ) &&
          _isType(type, kind: 'reference');
    case 'eventValue':
      return (kind == 'variable' ||
              _isProperty(
                declaration,
                readonly: true,
                optional: false,
              )) &&
          _isReferenceWithTypeArgumentCount(type, 1);
    case 'voidEventValue':
      return _isProperty(
            declaration,
            readonly: true,
            optional: false,
          ) &&
          _isReferenceWithSingleArgument(type, null, 'primitive', 'void');
    case 'subscriptionsArray':
      return _isProperty(
            declaration,
            readonly: true,
            optional: false,
          ) &&
          _isType(type, kind: 'array');
    case 'uriArrayObjectField':
      return _isProperty(
            declaration,
            readonly: true,
            optional: true,
          ) &&
          _isReadonlyArrayOfReference(type);
    case 'disposeMethod':
      return _isMethod(declaration, isStatic: false) &&
          parameters.isEmpty &&
          _isType(returnType, kind: 'primitive', name: 'any');
    case 'eventSubscription':
      return kind == 'callSignature' &&
          parameters.length == 3 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: true, rest: false),
            (optional: true, rest: false),
          ]) &&
          _isType(parameters.first['type'], kind: 'function') &&
          _isType(parameters[1]['type'], kind: 'primitive', name: 'any') &&
          _isType(returnType, kind: 'reference');
    case 'commandExecution':
      return kind == 'function' &&
          _hasUnknownDefaultSingleTypeParameter(declaration) &&
          parameters.length == 2 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: false, rest: true),
          ]) &&
          _isType(parameters[0]['type'], kind: 'primitive', name: 'string') &&
          _referencesSingleTypeParameter(returnType, declaration);
    case 'commandRegistration':
      return kind == 'function' &&
          parameters.length == 3 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: false, rest: false),
            (optional: true, rest: false),
          ]) &&
          _isType(parameters[0]['type'], kind: 'primitive', name: 'string') &&
          _isType(parameters[1]['type'], kind: 'function') &&
          _isType(parameters[2]['type'], kind: 'primitive', name: 'any') &&
          _isType(returnType, kind: 'reference');
    case 'hoverProviderRegistration':
      return kind == 'function' &&
          parameters.length == 2 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: false, rest: false),
          ]) &&
          parameters.every(
            (parameter) => _isType(parameter['type'], kind: 'reference'),
          ) &&
          _isType(returnType, kind: 'reference');
    case 'webviewPanelCreation':
      return kind == 'function' &&
          parameters.length == 4 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: false, rest: false),
            (optional: false, rest: false),
            (optional: true, rest: false),
          ]) &&
          _isType(parameters[0]['type'], kind: 'primitive', name: 'string') &&
          _isType(parameters[1]['type'], kind: 'primitive', name: 'string') &&
          _isType(returnType, kind: 'reference');
    case 'providerCallback':
      return _isMethod(declaration, isStatic: false) &&
          parameters.length == 3 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: false, rest: false),
            (optional: false, rest: false),
          ]) &&
          parameters.every(
            (parameter) => _isType(parameter['type'], kind: 'reference'),
          ) &&
          _isType(returnType, kind: 'reference');
    case 'markdownStringConstructor':
      return kind == 'constructor' &&
          parameters.length == 2 &&
          _hasParameterFlags(parameters, const [
            (optional: true, rest: false),
            (optional: true, rest: false),
          ]) &&
          _isType(parameters[0]['type'], kind: 'primitive', name: 'string') &&
          _isType(parameters[1]['type'], kind: 'primitive', name: 'boolean');
    case 'markdownHoverConstructor':
      return kind == 'constructor' &&
          parameters.length == 2 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: true, rest: false),
          ]) &&
          _isType(parameters[1]['type'], kind: 'reference');
    case 'numericRangeConstructor':
      return kind == 'constructor' &&
          parameters.length == 4 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: false, rest: false),
            (optional: false, rest: false),
            (optional: false, rest: false),
          ]) &&
          parameters.every(
            (parameter) =>
                _isType(parameter['type'], kind: 'primitive', name: 'number'),
          );
    case 'thenableBoolMethod':
      return _isMethod(declaration, isStatic: false) &&
          parameters.length == 1 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
          ]) &&
          _isType(
            parameters.single['type'],
            kind: 'primitive',
            name: 'any',
          ) &&
          _isReferenceWithSingleArgument(
            returnType,
            null,
            'primitive',
            'boolean',
          );
    case 'unaryUriMethod':
      return _isMethod(declaration, isStatic: false) &&
          parameters.length == 1 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
          ]) &&
          _isType(parameters.first['type'], kind: 'reference') &&
          _sameReference(parameters.first['type'], returnType);
    case 'uriJoinPath':
      return _isMethod(declaration, isStatic: true) &&
          parameters.length == 2 &&
          _hasParameterFlags(parameters, const [
            (optional: false, rest: false),
            (optional: false, rest: true),
          ]) &&
          _isType(parameters[0]['type'], kind: 'reference') &&
          _isArrayOfPrimitive(parameters[1]['type'], 'string') &&
          _sameReference(parameters[0]['type'], returnType);
    case 'uriToString':
      return _isMethod(declaration, isStatic: false) &&
          parameters.length == 1 &&
          _hasParameterFlags(parameters, const [
            (optional: true, rest: false),
          ]) &&
          _isType(
            parameters.first['type'],
            kind: 'primitive',
            name: 'boolean',
          ) &&
          _isType(returnType, kind: 'primitive', name: 'string');
    case 'stringSelectorProjection':
      return kind == 'typeAlias' && _unionContainsString(type);
    case 'providerResultProjection':
      return kind == 'typeAlias' &&
          _hasUnboundedSingleTypeParameter(declaration) &&
          _isType(type, kind: 'union');
  }
  return false;
}

List<Map<String, Object?>> _declarationParameters(
  Map<String, Object?> declaration,
) =>
    objectList(
      declaration['parameters'] ?? const <Object?>[],
      'declaration.parameters',
    ).map((value) => objectMap(value, 'declaration parameter')).toList();

bool _isProperty(
  Map<String, Object?> declaration, {
  required bool? readonly,
  required bool optional,
}) =>
    declaration['kind'] == 'property' &&
    (readonly == null || declaration['readonly'] == readonly) &&
    declaration['optional'] == optional &&
    declaration['static'] == false;

bool _isMethod(
  Map<String, Object?> declaration, {
  required bool isStatic,
}) =>
    declaration['kind'] == 'method' &&
    declaration['static'] == isStatic &&
    declaration['optional'] == false;

bool _hasParameterFlags(
  List<Map<String, Object?>> parameters,
  List<({bool optional, bool rest})> expected,
) =>
    parameters.length == expected.length &&
    Iterable<int>.generate(parameters.length).every(
      (index) =>
          parameters[index]['optional'] == expected[index].optional &&
          parameters[index]['rest'] == expected[index].rest,
    );

bool _hasTypeParameterCount(
  Map<String, Object?> declaration,
  int expected,
) =>
    declaration['typeParameters'] is List<Object?> &&
    (declaration['typeParameters']! as List<Object?>).length == expected;

bool _hasUnboundedSingleTypeParameter(Map<String, Object?> declaration) {
  final parameters = declaration['typeParameters'];
  if (parameters is! List<Object?> || parameters.length != 1) {
    return false;
  }
  final parameter = parameters.single;
  return parameter is Map<Object?, Object?> &&
      parameter.keys.toSet().length == 1 &&
      parameter.keys.single == 'name' &&
      parameter['name'] is String;
}

bool _hasUnknownDefaultSingleTypeParameter(
  Map<String, Object?> declaration,
) {
  final parameters = declaration['typeParameters'];
  if (parameters is! List<Object?> || parameters.length != 1) {
    return false;
  }
  final parameter = parameters.single;
  return parameter is Map<Object?, Object?> &&
      parameter.keys.toSet().length == 2 &&
      parameter.containsKey('name') &&
      parameter.containsKey('default') &&
      parameter['name'] is String &&
      _isType(parameter['default'], kind: 'primitive', name: 'unknown');
}

bool _hasNoHeritage(Map<String, Object?> declaration) {
  final heritage = declaration['extends'];
  return heritage is List<Object?> && heritage.isEmpty;
}

bool _isArrayOfPrimitive(Object? value, String primitiveName) {
  if (!_isType(value, kind: 'array')) {
    return false;
  }
  return _isType(
    (value! as Map<Object?, Object?>)['elementType'],
    kind: 'primitive',
    name: primitiveName,
  );
}

bool _referencesSingleTypeParameter(
  Object? value,
  Map<String, Object?> declaration,
) {
  final typeParameters = declaration['typeParameters'];
  if (typeParameters is! List<Object?> || typeParameters.length != 1) {
    return false;
  }
  final parameter = typeParameters.single;
  if (parameter is! Map<Object?, Object?> || parameter['name'] is! String) {
    return false;
  }
  return _isReferenceWithSingleArgument(
    value,
    null,
    'reference',
    parameter['name']! as String,
  );
}

bool _functionConsumesSingleTypeParameter(
  Object? value,
  Map<String, Object?> declaration,
) {
  if (!_isType(value, kind: 'function')) {
    return false;
  }
  final function = value! as Map<Object?, Object?>;
  final parameters = function['parameters'];
  if (parameters is! List<Object?> || parameters.length != 1) {
    return false;
  }
  final parameter = parameters.single;
  if (parameter is! Map<Object?, Object?> ||
      parameter['optional'] != false ||
      parameter['rest'] != false) {
    return false;
  }
  return _isSingleTypeParameterReference(parameter['type'], declaration);
}

bool _isSingleTypeParameterReference(
  Object? value,
  Map<String, Object?> declaration,
) {
  final typeParameters = declaration['typeParameters'];
  if (typeParameters is! List<Object?> || typeParameters.length != 1) {
    return false;
  }
  final parameter = typeParameters.single;
  if (parameter is! Map<Object?, Object?> || parameter['name'] is! String) {
    return false;
  }
  if (!_isType(value, kind: 'reference', name: parameter['name']! as String)) {
    return false;
  }
  final typeArguments = (value! as Map<Object?, Object?>)['typeArguments'];
  return typeArguments is List<Object?> && typeArguments.isEmpty;
}

bool _extendsSingleTypeParameter(
  Map<String, Object?> declaration,
  String parentName,
) {
  final heritage = declaration['extends'];
  if (heritage is! List<Object?> || heritage.length != 1) {
    return false;
  }
  final parent = heritage.single;
  return _isType(parent, kind: 'reference', name: parentName) &&
      _referencesSingleTypeParameter(parent, declaration);
}

bool _isProviderResultProjection(
  Map<String, Object?> declaration,
  String thenableName,
) {
  final type = declaration['type'];
  if (!_isType(type, kind: 'union')) {
    return false;
  }
  final types = (type! as Map<Object?, Object?>)['types'];
  if (types is! List<Object?> || types.length != 4) {
    return false;
  }
  bool isThenableMember(Object? candidate) {
    if (!_isType(candidate, kind: 'reference', name: thenableName)) {
      return false;
    }
    final arguments = (candidate! as Map<Object?, Object?>)['typeArguments'];
    return arguments is List<Object?> &&
        arguments.length == 1 &&
        _isNullableTypeParameterUnion(arguments.single, declaration);
  }

  return types
              .where(
                (candidate) =>
                    _isSingleTypeParameterReference(candidate, declaration),
              )
              .length ==
          1 &&
      types.where(_isUndefinedType).length == 1 &&
      types.where(_isNullLiteralType).length == 1 &&
      types.where(isThenableMember).length == 1;
}

bool _isNullableTypeParameterUnion(
  Object? value,
  Map<String, Object?> declaration,
) {
  if (!_isType(value, kind: 'union')) {
    return false;
  }
  final types = (value! as Map<Object?, Object?>)['types'];
  return types is List<Object?> &&
      types.length == 3 &&
      types
              .where(
                (candidate) =>
                    _isSingleTypeParameterReference(candidate, declaration),
              )
              .length ==
          1 &&
      types.where(_isUndefinedType).length == 1 &&
      types.where(_isNullLiteralType).length == 1;
}

bool _isUndefinedType(Object? value) =>
    _isType(value, kind: 'primitive', name: 'undefined');

bool _isNullLiteralType(Object? value) {
  if (!_isType(value, kind: 'literal')) {
    return false;
  }
  final literal = value! as Map<Object?, Object?>;
  return literal.containsKey('value') && literal['value'] == null;
}

bool _unionContainsString(Object? value) {
  if (!_isType(value, kind: 'union')) {
    return false;
  }
  final types = (value! as Map<Object?, Object?>)['types'];
  return types is List<Object?> &&
      types.any(
        (candidate) => _isType(candidate, kind: 'primitive', name: 'string'),
      );
}

bool _isType(Object? value, {required String kind, String? name}) {
  if (value is! Map<Object?, Object?> || value['kind'] != kind) {
    return false;
  }
  return name == null || value['name'] == name;
}

bool _isReferenceWithSingleArgument(
  Object? value,
  String? referenceName,
  String argumentKind,
  String argumentName,
) {
  if (!_isType(value, kind: 'reference', name: referenceName)) {
    return false;
  }
  final reference = value! as Map<Object?, Object?>;
  final arguments = reference['typeArguments'];
  return arguments is List<Object?> &&
      arguments.length == 1 &&
      _isType(arguments.single, kind: argumentKind, name: argumentName);
}

bool _isReferenceWithTypeArgumentCount(Object? value, int count) {
  if (!_isType(value, kind: 'reference')) {
    return false;
  }
  final arguments = (value! as Map<Object?, Object?>)['typeArguments'];
  return arguments is List<Object?> && arguments.length == count;
}

bool _isReadonlyArrayOfReference(Object? value) {
  if (!_isType(value, kind: 'operator')) {
    return false;
  }
  final operator = value! as Map<Object?, Object?>;
  final array = operator['type'];
  return operator['operator'] == 'readonly' &&
      _isType(array, kind: 'array') &&
      _isType(
        (array! as Map<Object?, Object?>)['elementType'],
        kind: 'reference',
      );
}

bool _sameReference(Object? left, Object? right) =>
    _isType(left, kind: 'reference') &&
    _isType(right, kind: 'reference') &&
    (left! as Map<Object?, Object?>)['name'] ==
        (right! as Map<Object?, Object?>)['name'];

String _dartIdentifier(Object? value, String path) {
  final identifier = string(value, path);
  if (!RegExp(r'^[A-Za-z_$][A-Za-z0-9_$]*$').hasMatch(identifier)) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path $identifier is not a Dart identifier.',
    );
  }
  return identifier;
}

void _rejectUnexpectedKeys(
  Map<String, Object?> value,
  Set<String> allowedKeys, {
  required String subject,
}) {
  final unexpected =
      value.keys.where((key) => !allowedKeys.contains(key)).toList()..sort();
  if (unexpected.isEmpty) {
    return;
  }
  final expected = allowedKeys.toList()..sort();
  throw VSCodeBindingGenerationException(
    'INVALID_OVERRIDE',
    '$subject must contain exactly ${expected.join(', ')}; unexpected '
        '${unexpected.join(', ')}.',
  );
}

void _validateReviewedRemovals(Object? value, Set<String> currentPublicIds) {
  if (value is! Map<Object?, Object?> ||
      value.keys.any((key) => key is! String)) {
    throw const VSCodeBindingGenerationException(
      'INVALID_OVERRIDE',
      'Semantic Override removals must be an object when present.',
    );
  }
  final removals = value.cast<String, Object?>();
  for (final id in removals.keys.toList()..sort()) {
    if (currentPublicIds.contains(id)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Semantic Override removal $id is stale because the declaration is '
            'still public in the pinned inventory.',
      );
    }
    final value = removals[id];
    if (value is! Map<Object?, Object?> ||
        value.keys.any((key) => key is! String)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Semantic Override removal $id must be an object.',
      );
    }
    final removal = value.cast<String, Object?>();
    _rejectUnexpectedKeys(
      removal,
      const {'strategy', 'declarationSha256', 'reason'},
      subject: 'Semantic Override removal $id',
    );
    if (removal['strategy'] != 'reviewedRemoval') {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Semantic Override removal $id strategy must be reviewedRemoval.',
      );
    }
    final declarationSha256 = removal['declarationSha256'];
    if (declarationSha256 is! String ||
        !RegExp(r'^[0-9a-f]{64}$').hasMatch(declarationSha256)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Semantic Override removal $id declarationSha256 must be a '
            'lowercase SHA-256.',
      );
    }
    final reason = removal['reason'];
    if (reason is! String || isEcmaScriptFalsyOrWhitespace(reason)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Semantic Override removal $id requires a non-empty reason.',
      );
    }
  }
}

Map<String, Map<String, Object?>> _validateHostContracts(Object? value) {
  final rawContracts = objectMap(value, 'overrides.hostContracts');
  if (rawContracts.isEmpty) {
    throw const VSCodeBindingGenerationException(
      'INVALID_OVERRIDE',
      'Semantic Overrides must declare at least one executable Host Contract.',
    );
  }
  final result = <String, Map<String, Object?>>{};
  final ids = rawContracts.keys.toList()..sort();
  for (final id in ids) {
    if (!RegExp(r'^[a-z][A-Za-z0-9]*$').hasMatch(id)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Host Contract ID $id must be lower camel case.',
      );
    }
    final contract = objectMap(
      rawContracts[id],
      'overrides.hostContracts.$id',
    );
    const expectedKeys = {'artifact', 'artifactSha256', 'boundary'};
    if (contract.length != expectedKeys.length ||
        !contract.keys.toSet().containsAll(expectedKeys)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Host Contract $id must contain exactly artifact, artifactSha256, '
            'and boundary.',
      );
    }
    final boundary = string(
      contract['boundary'],
      'overrides.hostContracts.$id.boundary',
    );
    if (boundary != 'vscodeExtensionHost') {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Host Contract $id has unsupported boundary $boundary.',
      );
    }
    final artifact = string(
      contract['artifact'],
      'overrides.hostContracts.$id.artifact',
    );
    if (!RegExp(
      r'^tool/bindings/contracts/[a-z0-9](?:[a-z0-9._-]*[a-z0-9])?\.json$',
    ).hasMatch(artifact)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Host Contract $id artifact must be a canonical JSON file directly '
            'under tool/bindings/contracts/.',
      );
    }
    final artifactSha256 = string(
      contract['artifactSha256'],
      'overrides.hostContracts.$id.artifactSha256',
    );
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(artifactSha256)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Host Contract $id artifactSha256 must be a lowercase SHA-256.',
      );
    }
    final normalized = <String, Object?>{
      'boundary': boundary,
      'artifact': artifact,
      'artifactSha256': artifactSha256,
    };
    result[id] = normalized;
  }
  return result;
}

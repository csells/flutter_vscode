/// Deterministic Dart binding generation from a pinned VS Code API inventory.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'ecmascript_whitespace.dart';

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
    final parentId = _string(
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
        'Selected ${_string(parent['kind'], 'parent.kind')} ${id(parent)} '
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
    final type = _objectMap(value, 'selected reference type');
    if (type['kind'] != 'reference') {
      throw const VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'A selected reference relation did not contain a reference type.',
      );
    }
    final referenceName = _string(type['name'], 'selected reference type.name');
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
      _string(declaration['id'], 'inventory declaration.id');

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
    _validateInputSchemaVersion(inventory, 'inventory');
    _validateInputSchemaVersion(overrides, 'overrides');
    _validateIrExactKeys(
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
    _validateIrModule(inventory['module']);
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
    _validateProjectDescriptor(project);
    final source = _validateIrSource(
      inventory['source'],
      inventory: inventory,
    );
    final product = _objectMap(source['product'], 'inventory.source.product');
    final inventoryVersion = _string(
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
    final inputSha256 = _sha256Digest(
      source['inputSha256'],
      'inventory.source.inputSha256',
    );
    final overrideVersion = _string(
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
    final manifestSchemaSha256 = _validateManifestSchema(inventory);
    final overrideManifestSchemaSha256 = _sha256Digest(
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
    final manifestValidatorSha256 = _validateManifestValidator(inventory);
    final overrideManifestValidatorSha256 = _sha256Digest(
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
        _validateCommandsContributionSchema(inventory);
    final overrideCommandsContributionSchemaSha256 = _sha256Digest(
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
    final projectName = _extensionIdentifierComponent(
      project['name'],
      'project.name',
    );
    final displayName = _nonEmptyString(
      project['displayName'],
      'project.displayName',
    );
    final description = _nonEmptyString(
      project['description'],
      'project.description',
    );
    final projectVersion = _string(project['version'], 'project.version');
    if (!_isStrictSemanticVersion(projectVersion)) {
      throw const VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'project.version must be a valid semantic version.',
      );
    }
    final publisher = _extensionIdentifierComponent(
      project['publisher'],
      'project.publisher',
    );
    final extensionId = '$publisher.$projectName';
    final extensionKey = 'e_${sha256.convert(utf8.encode(extensionId))}';
    final activationEvents = [
      for (final event in _objectList(
        project['activationEvents'],
        'project.activationEvents',
      ))
        _string(event, 'project.activationEvents entry'),
    ];
    final commands = _projectCommands(project['commands']);
    final declarations = _objectList(
      inventory['declarations'],
      'inventory.declarations',
    );
    final declarationsById = <String, Map<String, Object?>>{};
    final declarationPathsById = <String, String>{};
    for (var index = 0; index < declarations.length; index += 1) {
      final declarationValue = declarations[index];
      final path = 'inventory.declarations[$index]';
      final declaration = _objectMap(
        declarationValue,
        path,
      );
      _validateIrDeclarationKeys(declaration, path);
      final id = _string(declaration['id'], 'inventory declaration.id');
      if (declarationsById.containsKey(id)) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          'Inventory contains duplicate entry $id.',
        );
      }
      declarationsById[id] = declaration;
      declarationPathsById[id] = path;
    }
    _validateIrDeclarationOrder(declarations);
    for (final entry in declarationsById.entries) {
      final path = declarationPathsById[entry.key]!;
      _validateIrDeclarationIdentity(
        entry.value,
        path,
        declarationsById,
      );
      final inheritedScopes = _irInheritedTypeParameterScopes(
        entry.value,
        declarationsById,
        path,
      );
      _validateIrDeclarationTypes(
        entry.value,
        path,
        inheritedScopes: inheritedScopes,
      );
    }
    _validateIrOverloadOrdinals(declarationsById, declarationPathsById);
    _validateIrTypeLiteralGraph(declarationsById, declarationPathsById);
    final knownIds = declarationsById.keys.toSet();
    final publicIds = declarationsById.entries
        .where((entry) => entry.value['visibility'] == 'public')
        .map((entry) => entry.key)
        .toSet();
    if (overrides.containsKey('removals')) {
      _validateReviewedRemovals(overrides['removals'], publicIds);
    }
    final hostContracts = _validateHostContracts(overrides['hostContracts']);
    final entries = _objectMap(overrides['entries'], 'overrides.entries');
    final targetList = <String>[
      for (final target in _objectList(
        overrides['targets'],
        'overrides.targets',
      ))
        _string(target, 'overrides.targets entry'),
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
      final entry = _objectMap(entries[id], 'overrides.entries.$id');
      final strategy = _string(
        entry['strategy'],
        'overrides.entries.$id.strategy',
      );
      if (!_strategies.contains(strategy)) {
        throw VSCodeBindingGenerationException(
          'UNKNOWN_OVERRIDE_STRATEGY',
          'Semantic Override $id uses unknown strategy $strategy.',
        );
      }
      final expectedDeclarationSha256 = _string(
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
      final entry = _objectMap(entries[id], 'overrides.entries.$id');
      if (entry['strategy'] == 'opaqueJsObject') {
        final declaration = declarationsById[id]!;
        opaqueTypes.add(
          _string(declaration['name'], 'inventory declaration $id.name'),
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
        walkingSlice ? _emitWalkingSliceRuntime(extensionKey) : null;
    final coverage = _emitCoverageLedger(
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
    final hostExports = '''
// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:js_interop';

/// Fully qualified extension identifier used by the generated host.
// The JSON encoder deliberately emits a double-quoted, escaped Dart literal.
// ignore: prefer_single_quotes
const generatedExtensionId = $dartExtensionId;

/// Collision-resistant key used for this extension's JavaScript globals.
const generatedExtensionKey =
    '$extensionKey';

@JS(
  '__flutterVscode.hosts.$extensionKey',
)
external set _hostExports(JSObject value);

/// Publishes the Dart lifecycle object for the CommonJS bootstrap.
void registerHostExports(JSObject value) {
  _hostExports = value;
}
''';
    final bootstrap = '''
'use strict';

const crypto = require('node:crypto');
const fs = require('node:fs');
const manifest = require('../package.json');
const moduleApi = require('node:module');
const path = require('node:path');
const vscode = require('vscode');

process.setSourceMapsEnabled?.(true);
globalThis.self ??= globalThis;
const namespace = (globalThis.__flutterVscode ??= Object.create(null));
namespace.hosts ??= Object.create(null);
namespace.apis ??= Object.create(null);
namespace.bindingCallbackWrappers ??= Object.create(null);
namespace.bindingObservers ??= Object.create(null);
namespace.callbackWrappers ??= Object.create(null);
namespace.stackMappers ??= Object.create(null);
const extensionId = `\${manifest.publisher}.\${manifest.name}`;
const extensionKey = `e_\${crypto
  .createHash('sha256')
  .update(extensionId)
  .digest('hex')}`;
const emittedExtensionKey = $javaScriptExtensionKey;
if (extensionKey !== emittedExtensionKey) {
  throw new Error('Generated Dart and manifest extension identities differ.');
}
namespace.apis[extensionKey] = vscode;

const observedBindingIds = new Set();
namespace.bindingObservers[extensionKey] = (bindingId) => {
  if (typeof bindingId !== 'string' || bindingId.length === 0) {
    throw new TypeError('Generated Host Contract binding ID must be a string.');
  }
  observedBindingIds.add(bindingId);
};
namespace.bindingCallbackWrappers[extensionKey] = (
  callback,
  bindingIds,
) => function (...args) {
  const callbackResult = Reflect.apply(callback, this, args);
  for (const bindingId of bindingIds) {
    namespace.bindingObservers[extensionKey](bindingId);
  }
  return callbackResult;
};
const evidencePath = process.env.FLUTTER_VSCODE_HOST_EVIDENCE_PATH;
if (evidencePath) {
  process.once('exit', () => {
    fs.writeFileSync(
      evidencePath,
      `\${JSON.stringify({
        schemaVersion: 1,
        contract: $javaScriptHostContractId,
        boundary: 'vscodeExtensionHost',
        observedBindingIds: [...observedBindingIds].sort(),
      }, null, 2)}\n`,
    );
  });
}

const hostBundlePath = path.resolve(__dirname, '../out/extension.dart.js');
const hostSourceMap = new moduleApi.SourceMap(
  JSON.parse(fs.readFileSync(`\${hostBundlePath}.map`, 'utf8')),
);
const mapHostStack = (stack) => stack.replace(
  /[^\\s()]*extension\\.dart\\.js:(\\d+):(\\d+)/g,
  (location, line, column) => {
    const entry = hostSourceMap.findEntry(
      Number(line) - 1,
      Number(column) - 1,
    );
    if (entry.originalSource === undefined) {
      return location;
    }
    const source = entry.originalSource.replace(/^(\\.\\.\\/)+/, '');
    return `\${source}:\${entry.originalLine + 1}:\${entry.originalColumn + 1}`;
  },
);
namespace.stackMappers[extensionKey] = mapHostStack;
namespace.callbackWrappers[extensionKey] = (callback) => function (...args) {
  try {
    return Reflect.apply(callback, this, args);
  } catch (error) {
    if (error && typeof error.stack === 'string') {
      error.stack = mapHostStack(error.stack);
    }
    throw error;
  }
};

require('../out/extension.dart.js');

const host = namespace.hosts[extensionKey];
if (!host) {
  throw new Error('Dart host did not register its lifecycle exports.');
}

exports.activate = async (context) => {
  const firstActivationSubscription = context.subscriptions.length;
  try {
    return await host.activate(context, vscode);
  } catch (error) {
    const registrations = context.subscriptions.splice(
      firstActivationSubscription,
    );
    for (const registration of registrations.reverse()) {
      try {
        await registration.dispose();
      } catch {
        // Preserve the activation failure after attempting every rollback.
      }
    }
    throw error;
  }
};
exports.deactivate = () => host.deactivate();
''';

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

void _validateIrModule(Object? value) {
  final module = _objectMap(value, 'inventory.module');
  _validateIrExactKeys(
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

Map<String, Object?> _validateIrSource(
  Object? value, {
  required Map<String, Object?> inventory,
}) {
  final source = _objectMap(value, 'inventory.source');
  _validateIrExactKeys(
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

  final product = _objectMap(source['product'], 'inventory.source.product');
  _validateIrExactKeys(
    product,
    const {'name', 'version', 'commit'},
    path: 'inventory.source.product',
  );
  _nonEmptyString(product['name'], 'inventory.source.product.name');
  _nonEmptyString(product['version'], 'inventory.source.product.version');
  _validateIrCommit(product['commit'], 'inventory.source.product.commit');

  final parser = _objectMap(source['parser'], 'inventory.source.parser');
  _validateIrExactKeys(
    parser,
    const {'name', 'version'},
    path: 'inventory.source.parser',
  );
  if (parser['name'] != 'typescript') {
    _invalidIrValue('inventory.source.parser.name', parser['name']);
  }
  _nonEmptyString(parser['version'], 'inventory.source.parser.version');
  _validateIrSha256(
    source['inputSha256'],
    'inventory.source.inputSha256',
  );

  final manifestSchema = _objectMap(
    source['manifestSchema'],
    'inventory.source.manifestSchema',
  );
  _validateIrExactKeys(
    manifestSchema,
    const {'schemaUri', 'standalone', 'composition'},
    path: 'inventory.source.manifestSchema',
  );
  _nonEmptyString(
    manifestSchema['schemaUri'],
    'inventory.source.manifestSchema.schemaUri',
  );
  _validateIrBoolean(
    manifestSchema['standalone'],
    'inventory.source.manifestSchema.standalone',
  );
  _nonEmptyString(
    manifestSchema['composition'],
    'inventory.source.manifestSchema.composition',
  );

  final inputs = _objectList(source['inputs'], 'inventory.source.inputs');
  if (inputs.isEmpty) {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'inventory.source.inputs must contain pinned source receipts.',
    );
  }
  final inputsByKind = <String, List<Map<String, Object?>>>{};
  for (var index = 0; index < inputs.length; index += 1) {
    final path = 'inventory.source.inputs[$index]';
    final input = _objectMap(inputs[index], path);
    _validateIrExactKeys(
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
      _nonEmptyString(input[key], '$path.$key');
    }
    final kind = _string(input['kind'], '$path.kind');
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
      _nonEmptyString(input['licensePath'], '$path.licensePath');
    }
    inputsByKind.putIfAbsent(kind, () => []).add(input);
  }

  final contributionSchemas = _objectList(
    source['contributionSchemas'],
    'inventory.source.contributionSchemas',
  );
  final schemaNames = <String>[
    for (var index = 0; index < contributionSchemas.length; index += 1)
      _nonEmptyString(
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
    final productVersion = _string(
      product['version'],
      'inventory.source.product.version',
    );
    final productCommit = _string(
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
      _string(inputsByKind[kind]!.single['sha256'], 'inventory.source.inputs');
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
    _string(source['inputSha256'], 'inventory.source.inputSha256'),
    'apiDeclarations',
    'inventory.source.inputSha256',
  );
  final projectedManifest = _objectMap(
    inventory['manifestSchema'],
    'inventory.manifestSchema',
  );
  requireReceiptSha(
    _string(
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
  final projectedValidator = _objectMap(
    inventory['manifestValidator'],
    'inventory.manifestValidator',
  );
  requireReceiptSha(
    _string(
      projectedValidator['inputSha256'],
      'inventory.manifestValidator.inputSha256',
    ),
    'extensionManifestValidatorSource',
    'inventory.manifestValidator.inputSha256',
  );
  final projectedContributions = _objectMap(
    inventory['contributionSchemas'],
    'inventory.contributionSchemas',
  );
  final projectedCommands = _objectMap(
    projectedContributions['commands'],
    'inventory.contributionSchemas.commands',
  );
  requireReceiptSha(
    _string(
      projectedCommands['inputSha256'],
      'inventory.contributionSchemas.commands.inputSha256',
    ),
    'contributionSchemaSource',
    'inventory.contributionSchemas.commands.inputSha256',
  );
  return source;
}

void _validateIrDeclarationKeys(
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
  final kind = _string(declaration['kind'], '$path.kind');
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
    'typeLiteral' => {...common, 'shapeHash'},
    _ => throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.kind has unsupported IR declaration kind $kind.',
      ),
  };
  _validateIrExactKeys(
    declaration,
    requiredKeys,
    optionalKeys: const {'occurrenceCount'},
    path: path,
  );
  _validateIrDeclarationScalars(declaration, path);
  _validateIrCoverage(
    declaration['coverage'],
    '$path.coverage',
    visibility: _string(declaration['visibility'], '$path.visibility'),
  );
}

void _validateIrDeclarationScalars(
  Map<String, Object?> declaration,
  String path,
) {
  _nonEmptyString(declaration['id'], '$path.id');
  _nonEmptyString(declaration['name'], '$path.name');
  _nonEmptyString(declaration['qualifiedName'], '$path.qualifiedName');
  _nonEmptyString(declaration['parentId'], '$path.parentId');
  _validateIrBoolean(declaration['deprecated'], '$path.deprecated');
  final visibility = _string(declaration['visibility'], '$path.visibility');
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
      final declarationKind = _string(
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

void _validateIrDeclarationOrder(List<Object?> declarations) {
  for (var index = 1; index < declarations.length; index += 1) {
    final previous = _objectMap(
      declarations[index - 1],
      'inventory.declarations[${index - 1}]',
    );
    final current = _objectMap(
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
  final qualified = _string(
    left['qualifiedName'],
    'inventory declaration.qualifiedName',
  ).compareTo(
    _string(
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
  return _string(left['id'], 'inventory declaration.id').compareTo(
    _string(right['id'], 'inventory declaration.id'),
  );
}

void _validateIrDeclarationIdentity(
  Map<String, Object?> declaration,
  String path,
  Map<String, Map<String, Object?>> declarationsById,
) {
  final id = _string(declaration['id'], '$path.id');
  final kind = _string(declaration['kind'], '$path.kind');
  final name = _string(declaration['name'], '$path.name');
  final qualifiedName = _string(
    declaration['qualifiedName'],
    '$path.qualifiedName',
  );
  final parentId = _string(declaration['parentId'], '$path.parentId');
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
    _ => _string(parent!['qualifiedName'], '$path.parentId.qualifiedName'),
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
      '$kind:$qualifiedName@${sha256.convert(utf8.encode(_string(declaration['canonicalSignature'], '$path.canonicalSignature')))}',
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

  final visibility = _string(declaration['visibility'], '$path.visibility');
  if (rootParent && visibility != 'public') {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path.visibility must be public for top-level producer declarations.',
    );
  }
  if (parent != null) {
    final parentVisibility = _string(
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

List<List<String?>> _irInheritedTypeParameterScopes(
  Map<String, Object?> declaration,
  Map<String, Map<String, Object?>> declarationsById,
  String path,
) {
  final ancestors = <Map<String, Object?>>[];
  var parentId = _string(declaration['parentId'], '$path.parentId');
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
    parentId = _string(parent['parentId'], '$path.parentId');
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
    for (final parameter in _objectList(value, 'typeParameters'))
      _string(
        _objectMap(parameter, 'typeParameters entry')['name'],
        'typeParameters entry.name',
      ),
  ];
}

void _validateIrOverloadOrdinals(
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

void _validateIrTypeLiteralGraph(
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
      final id = _string(map['id'], '$path.id');
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
  _validateIrSingleChildTypeLiteralShapeHashes(
    declarationsById,
    declarationPathsById,
  );
}

void _validateIrSingleChildTypeLiteralShapeHashes(
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
    final children = childrenByParent[id] ?? const [];
    if (children.length != 1 || children.single['kind'] != 'property') {
      continue;
    }
    final child = children.single;
    final rawType = child['type'];
    final scopes = _irInheritedTypeParameterScopes(
      child,
      declarationsById,
      declarationPathsById[child['id']]!,
    );
    final hasGenericScope = scopes.any((scope) => scope.isNotEmpty);
    if (!hasGenericScope && _containsRegisteredIrTypeLiteral(rawType)) {
      continue;
    }
    final memberType =
        hasGenericScope ? _canonicalizeIrType(rawType, scopes) : rawType;
    final shape = <String, Object?>{
      'members': <Object?>[
        <String, Object?>{
          'kind': 'property',
          'name': child['name'],
          'optional': child['optional'],
          'readonly': child['readonly'],
          'type': memberType,
        },
      ],
    };
    final expected = sha256.convert(utf8.encode(jsonEncode(shape))).toString();
    if (declaration['shapeHash'] != expected) {
      final path = declarationPathsById[id]!;
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path.shapeHash must commit to its canonical children as $expected.',
      );
    }
  }
}

bool _containsRegisteredIrTypeLiteral(Object? value) {
  if (value is List<Object?>) {
    return value.any(_containsRegisteredIrTypeLiteral);
  }
  if (value is! Map<Object?, Object?>) {
    return false;
  }
  if (value['kind'] == 'typeLiteral' && value.containsKey('id')) {
    return true;
  }
  return value.values.any(_containsRegisteredIrTypeLiteral);
}

void _validateIrDeclarationTypes(
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
  final types = _objectList(value, path);
  for (var index = 0; index < types.length; index += 1) {
    final typePath = '$path[$index]';
    final type = _objectMap(types[index], typePath);
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
  final types = _objectList(value, path);
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
  final parameters = _objectList(value, path);
  for (var index = 0; index < parameters.length; index += 1) {
    final parameterPath = '$path[$index]';
    final parameter = _objectMap(parameters[index], parameterPath);
    _validateIrExactKeys(
      parameter,
      const {'name', 'optional', 'rest', 'type'},
      path: parameterPath,
    );
    _nonEmptyString(parameter['name'], '$parameterPath.name');
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
  final parameters = _objectList(value, path);
  final names = <String?>[];
  for (var index = 0; index < parameters.length; index += 1) {
    final parameterPath = '$path[$index]';
    final parameter = _objectMap(parameters[index], parameterPath);
    _validateIrExactKeys(
      parameter,
      const {'name'},
      optionalKeys: const {'constraint', 'default'},
      path: parameterPath,
    );
    names.add(_nonEmptyString(parameter['name'], '$parameterPath.name'));
  }
  final activeScopes = [...inheritedScopes, names];
  for (var index = 0; index < parameters.length; index += 1) {
    final parameterPath = '$path[$index]';
    final parameter = _objectMap(parameters[index], parameterPath);
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
  final type = _objectMap(value, path);
  final kind = _string(type['kind'], '$path.kind');
  switch (kind) {
    case 'primitive':
      _validateIrExactKeys(type, const {'kind', 'name'}, path: path);
      final name = _string(type['name'], '$path.name');
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
      _validateIrExactKeys(
        type,
        const {'kind', 'name', 'typeArguments'},
        path: path,
      );
      _nonEmptyString(type['name'], '$path.name');
      _validateIrTypes(
        type['typeArguments'],
        '$path.typeArguments',
        typeParameterScopes: typeParameterScopes,
      );
    case 'array':
      _validateIrExactKeys(type, const {'kind', 'elementType'}, path: path);
      _validateIrType(
        type['elementType'],
        '$path.elementType',
        typeParameterScopes: typeParameterScopes,
      );
    case 'union' || 'intersection':
      _validateIrExactKeys(type, const {'kind', 'types'}, path: path);
      _validateIrTypes(
        type['types'],
        '$path.types',
        typeParameterScopes: typeParameterScopes,
      );
    case 'literal':
      _validateIrExactKeys(type, const {'kind', 'value'}, path: path);
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
      _validateIrExactKeys(type, const {'kind', 'elements'}, path: path);
      final elements = _objectList(type['elements'], '$path.elements');
      for (var index = 0; index < elements.length; index += 1) {
        final elementPath = '$path.elements[$index]';
        final element = _objectMap(elements[index], elementPath);
        _validateIrExactKeys(
          element,
          const {'optional', 'rest', 'type'},
          optionalKeys: const {'name'},
          path: elementPath,
        );
        if (element.containsKey('name')) {
          _nonEmptyString(element['name'], '$elementPath.name');
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
      _validateIrExactKeys(
        type,
        const {'kind', 'operator', 'type'},
        path: path,
      );
      final operator = _string(type['operator'], '$path.operator');
      if (!const {'keyof', 'readonly', 'unique'}.contains(operator)) {
        _invalidIrValue('$path.operator', operator);
      }
      _validateIrType(
        type['type'],
        '$path.type',
        typeParameterScopes: typeParameterScopes,
      );
    case 'function':
      _validateIrExactKeys(
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
        _validateIrExactKeys(
          type,
          const {'kind', 'id', 'shapeHash'},
          path: path,
        );
        _nonEmptyString(type['id'], '$path.id');
      } else {
        _validateIrExactKeys(
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
        final actualHash = _string(type['shapeHash'], '$path.shapeHash');
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
  final expression = _objectMap(value, path);
  final kind = _string(expression['kind'], '$path.kind');
  switch (kind) {
    case 'literal':
      _validateIrExactKeys(
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
      _validateIrExactKeys(
        expression,
        const {'kind', 'name'},
        path: path,
      );
      _nonEmptyString(expression['name'], '$path.name');
    case 'unary':
      _validateIrExactKeys(
        expression,
        const {'kind', 'operator', 'operand'},
        path: path,
      );
      final operator = _string(expression['operator'], '$path.operator');
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
  final shape = _objectMap(value, path);
  _validateIrExactKeys(shape, const {'members'}, path: path);
  final members = _objectList(shape['members'], '$path.members');
  for (var index = 0; index < members.length; index += 1) {
    final memberPath = '$path.members[$index]';
    final member = _objectMap(members[index], memberPath);
    final kind = _string(member['kind'], '$memberPath.kind');
    switch (kind) {
      case 'property':
        _validateIrExactKeys(
          member,
          const {'kind', 'name', 'optional', 'readonly', 'type'},
          path: memberPath,
        );
        _nonEmptyString(member['name'], '$memberPath.name');
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
        _validateIrExactKeys(
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
        _nonEmptyString(member['name'], '$memberPath.name');
        _validateIrBoolean(member['optional'], '$memberPath.optional');
        _validateIrBoolean(member['static'], '$memberPath.static');
        _validateIrBoolean(member['abstract'], '$memberPath.abstract');
        _validateIrCanonicalSignatureObject(
          member['signature'],
          '$memberPath.signature',
          inheritedScopes: typeParameterScopes,
        );
      case 'callSignature':
        _validateIrExactKeys(
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
        _validateIrExactKeys(
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
  final serialized = _string(value, path);
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
  final signature = _objectMap(value, path);
  _validateIrExactKeys(
    signature,
    {'typeParameters', 'parameters', 'returnType', ...extraKeys},
    path: path,
  );
  final typeParameters = _objectList(
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
    final parameter = _objectMap(typeParameters[index], parameterPath);
    _validateIrExactKeys(
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
  final parameters = _objectList(signature['parameters'], '$path.parameters');
  for (var index = 0; index < parameters.length; index += 1) {
    final parameterPath = '$path.parameters[$index]';
    final parameter = _objectMap(parameters[index], parameterPath);
    _validateIrExactKeys(
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
  final rawTypeParameters = _objectList(
    raw['typeParameters'],
    '$path.typeParameters',
  );
  final ownScope = <String?>[
    for (var index = 0; index < rawTypeParameters.length; index += 1)
      _string(
        _objectMap(
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
        _objectMap(
          rawTypeParameters[index],
          '$path.typeParameters[$index]',
        ),
        activeScopes,
      ),
  ];
  final rawParameters = _objectList(raw['parameters'], '$path.parameters');
  final expectedParameters = <Object?>[
    for (var index = 0; index < rawParameters.length; index += 1)
      _canonicalizeIrParameter(
        _objectMap(rawParameters[index], '$path.parameters[$index]'),
        activeScopes,
      ),
  ];
  final expected = <String, Object?>{
    'typeParameters': expectedTypeParameters,
    'parameters': expectedParameters,
    'returnType': _canonicalizeIrType(raw['returnType'], activeScopes),
    for (final key in extraKeys) key: raw[key],
  };
  final actual = _string(
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
  final type = _objectMap(value, 'IR type');
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
          for (final argument in _objectList(
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
          for (final item in _objectList(type['types'], 'IR type.types'))
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
          for (final elementValue in _objectList(
            type['elements'],
            'IR type.elements',
          ))
            _canonicalizeIrTupleElement(
              _objectMap(elementValue, 'IR tuple element'),
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
  final type = _objectMap(value, path);
  final kind = _string(type['kind'], '$path.kind');
  switch (kind) {
    case 'primitive':
      _validateIrExactKeys(type, const {'kind', 'name'}, path: path);
      final name = _string(type['name'], '$path.name');
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
      _validateIrExactKeys(
        type,
        const {'kind', 'name', 'typeArguments'},
        path: path,
      );
      _nonEmptyString(type['name'], '$path.name');
      final referenceName = _string(type['name'], '$path.name');
      if (typeParameterScopes.any((scope) => scope.contains(referenceName))) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          '$path reference $referenceName must use its canonical '
              'typeParameter or outerTypeParameter node.',
        );
      }
      final arguments = _objectList(
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
      _validateIrExactKeys(type, const {'kind', 'elementType'}, path: path);
      _validateIrCanonicalType(
        type['elementType'],
        '$path.elementType',
        typeParameterScopes: typeParameterScopes,
      );
    case 'union' || 'intersection':
      _validateIrExactKeys(type, const {'kind', 'types'}, path: path);
      final types = _objectList(type['types'], '$path.types');
      for (var index = 0; index < types.length; index += 1) {
        _validateIrCanonicalType(
          types[index],
          '$path.types[$index]',
          typeParameterScopes: typeParameterScopes,
        );
      }
    case 'literal':
      _validateIrExactKeys(type, const {'kind', 'value'}, path: path);
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
      _validateIrExactKeys(type, const {'kind', 'elements'}, path: path);
      final elements = _objectList(type['elements'], '$path.elements');
      for (var index = 0; index < elements.length; index += 1) {
        final elementPath = '$path.elements[$index]';
        final element = _objectMap(elements[index], elementPath);
        _validateIrExactKeys(
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
      _validateIrExactKeys(
        type,
        const {'kind', 'operator', 'type'},
        path: path,
      );
      final operator = _string(type['operator'], '$path.operator');
      if (!const {'keyof', 'readonly', 'unique'}.contains(operator)) {
        _invalidIrValue('$path.operator', operator);
      }
      _validateIrCanonicalType(
        type['type'],
        '$path.type',
        typeParameterScopes: typeParameterScopes,
      );
    case 'function':
      _validateIrExactKeys(
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
      _validateIrExactKeys(
        type,
        const {'kind', 'shapeHash'},
        path: path,
      );
      _validateIrSha256(type['shapeHash'], '$path.shapeHash');
    case 'typeParameter':
      _validateIrExactKeys(type, const {'kind', 'index'}, path: path);
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
      _validateIrExactKeys(
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
  final commit = _string(value, path);
  if (!RegExp(r'^[0-9a-f]{40}$').hasMatch(commit)) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a lowercase 40-character Git commit.',
    );
  }
  return commit;
}

void _validateIrSha256(Object? value, String path) {
  final digest = _string(value, path);
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
  final coverage = _objectMap(value, path);
  _validateIrExactKeys(
    coverage,
    const {'discovery', 'semantics', 'binding', 'host'},
    path: path,
  );
  final discovery = _string(coverage['discovery'], '$path.discovery');
  final semantics = _string(coverage['semantics'], '$path.semantics');
  final binding = _string(coverage['binding'], '$path.binding');
  final host = _string(coverage['host'], '$path.host');
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

void _validateIrExactKeys(
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

void _validateInputSchemaVersion(
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

void _validateProjectDescriptor(Map<String, Object?> project) {
  const expectedKeys = {
    'activationEvents',
    'apiTarget',
    'commands',
    'description',
    'displayName',
    'name',
    'publisher',
    'schemaVersion',
    'version',
  };
  final unexpected =
      project.keys.where((key) => !expectedKeys.contains(key)).toList()..sort();
  if (unexpected.isNotEmpty) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_DESCRIPTOR',
      'Unknown project descriptor fields: ${unexpected.join(', ')}.',
    );
  }
  if (project['schemaVersion'] != 1) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_DESCRIPTOR',
      'project.schemaVersion must be 1, found ${project['schemaVersion']}.',
    );
  }
}

bool _isStrictSemanticVersion(String value) {
  final match = RegExp(
    r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)'
    r'(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
    r'(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$',
  ).firstMatch(value);
  if (match == null) {
    return false;
  }
  final preRelease = match.group(4);
  if (preRelease == null) {
    return true;
  }
  return preRelease.split('.').every(
        (part) =>
            !RegExp(r'^\d+$').hasMatch(part) ||
            part == '0' ||
            !part.startsWith('0'),
      );
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
  final enumInitializer = _objectMap(
    enumMember['initializer'],
    'intEnumMember.initializer',
  );
  final enumValue = _integer(
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
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.
// VS Code $inventoryVersion mechanically reviewed API slice.

import 'dart:js_interop';

/// Selected root namespaces from the native VS Code API object.
extension type VSCode.fromJS(JSObject _) implements JSObject {
  /// Command registration and execution APIs.
  external $commandNamespaceType get $commandNamespaceName;

  /// Language feature registration APIs.
  external $languageNamespaceType get $languageNamespaceName;

  /// Window and Flutter View panel APIs.
  external $windowNamespaceType get $windowNamespaceName;

  /// Workspace state and event APIs.
  external $workspaceNamespaceType get $workspaceNamespaceName;
}

/// Selected `vscode.commands` operations.
extension type $commandNamespaceType.fromJS(JSObject _) implements JSObject {
  /// Registers [callback] for [command].
  external $disposableType $commandRegistrationName(
    JSString $commandRegistrationIdParameter,
    JSFunction $commandRegistrationCallbackParameter, [
    JSAny? $commandRegistrationThisParameter,
  ]);

  /// Executes [command] and returns its host thenable.
  external $thenableType<T> $commandExecutionName<T extends JSAny?>(
    JSString $commandExecutionIdParameter,
  );
}

/// A host thenable represented by a native JavaScript promise contract.
extension type $thenableType<T extends JSAny?>.fromJS(JSPromise<T> _)
    implements JSPromise<T> {}

/// Structural host object that can release its resource.
extension type DisposableLike.fromJS(JSObject _) implements JSObject {
  /// Releases the resource.
  external JSAny? $disposeName();
}

/// Native VS Code disposable registration.
extension type $disposableType.fromJS(JSObject _)
    implements JSObject, DisposableLike {
  /// Releases the registration.
  external JSAny? $disposeName();
}

/// Native VS Code extension activation context.
extension type $extensionContextType.fromJS(JSObject _) implements JSObject {
  /// Root URI of the installed extension.
  external $uriType get $extensionUriName;

  /// Registrations VS Code disposes with the extension.
  external JSArray<DisposableLike> get $contextSubscriptionsName;
}

/// Selected `vscode.languages` operations.
extension type $languageNamespaceType.fromJS(JSObject _) implements JSObject {
  /// Registers [provider] for the selected documents.
  external $disposableType $hoverRegistrationName(
    JSAny selector,
    $hoverProviderType provider,
  );
}

/// Native hover provider callback object.
@JS()
extension type $hoverProviderType._(JSObject _) implements JSObject {
  /// Creates a provider backed by [provideHover].
  external factory $hoverProviderType({JSFunction $providerCallbackName});
}

/// Native VS Code text document whose identity is preserved.
extension type $textDocumentType.fromJS(JSObject _) implements JSObject {}

/// Native cancellation token supplied to provider callbacks.
extension type $cancellationTokenType.fromJS(JSObject _) implements JSObject {
  /// Whether the host requested cancellation.
  external bool get $cancellationRequestedName;
}

/// Selected `vscode.workspace` events.
extension type $workspaceNamespaceType.fromJS(JSObject _) implements JSObject {
  /// Fires when a text document opens.
  external $eventType<$textDocumentType> get $workspaceEventName;
}

/// Selected `vscode.window` operations.
extension type $windowNamespaceType.fromJS(JSObject _) implements JSObject {
  /// Creates a native VS Code panel that hosts one Flutter View.
  external $webviewPanelType $panelCreationName(
    JSString viewType,
    JSString title,
    int showOptions, [
    $optionsType options,
  ]);
}

/// Reviewed numeric values from VS Code's `ViewColumn` enum.
abstract final class $enumType {
  /// The first editor column.
  static const int $enumMemberName = $enumValue;
}

/// Native options passed when a Flutter View panel is created.
@JS()
extension type $optionsType._(JSObject _) implements JSObject {
  /// Creates the reviewed options shape used by Flutter Views.
  external factory $optionsType({
    bool $optionsScriptsName,
    JSArray<$uriType> $optionsRootsName,
  });
}

/// Callable native VS Code event.
extension type $eventType<T extends JSAny?>.fromJS(JSFunction _)
    implements JSFunction {
  /// Subscribes [listener] and returns its native disposable.
  $disposableType call(
    JSFunction listener, [
    JSAny? thisArgs,
    JSArray<$disposableType>? disposables,
  ]) {
    final JSAny? result;
    if (disposables != null) {
      result = _.callAsFunction(null, listener, thisArgs, disposables);
    } else if (thisArgs != null) {
      result = _.callAsFunction(null, listener, thisArgs);
    } else {
      result = _.callAsFunction(null, listener);
    }
    return $disposableType.fromJS(result! as JSObject);
  }
}

/// Callable native VS Code event that carries no value.
extension type VoidEvent.fromJS(JSFunction _) implements JSFunction {
  /// Subscribes [listener] and returns its native disposable.
  $disposableType call(
    JSFunction listener, [
    JSAny? thisArgs,
    JSArray<$disposableType>? disposables,
  ]) {
    final JSAny? result;
    if (disposables != null) {
      result = _.callAsFunction(null, listener, thisArgs, disposables);
    } else if (thisArgs != null) {
      result = _.callAsFunction(null, listener, thisArgs);
    } else {
      result = _.callAsFunction(null, listener);
    }
    return $disposableType.fromJS(result! as JSObject);
  }
}

/// Native VS Code zero-based document position.
extension type $positionType.fromJS(JSObject _) implements JSObject {
$positionFields
}

/// Native VS Code URI with the reviewed Flutter View operations.
@JS(
  '__flutterVscode.apis.$extensionKey.$uriType',
)
extension type $uriType._(JSObject _) implements JSObject {
  /// Joins one path segment onto [base].
  @JS('$uriJoinPathName')
  external static $uriType $uriJoinPathName(
    $uriType base,
    JSString pathSegment,
  );

  /// Serializes this URI using VS Code's URI implementation.
  @JS('$upstreamUriToStringName')
  // VS Code defines this as a positional boolean parameter.
  // ignore: avoid_positional_boolean_parameters
  external JSString $dartUriToStringName([bool skipEncoding]);
}

/// Native VS Code panel that hosts one Flutter View.
extension type $webviewPanelType.fromJS(JSObject _)
    implements JSObject, DisposableLike {
  /// The panel's web content surface.
  external $webviewType get $panelWebviewName;

  /// Fires once when the panel is disposed.
  external VoidEvent get $panelDisposeEventName;

  /// Closes the panel and releases its resources.
  external JSAny? $panelDisposeName();
}

/// Native VS Code web content surface for a Flutter View.
extension type $webviewType.fromJS(JSObject _) implements JSObject {
  /// Current HTML document source.
  external JSString get $webviewHtmlName;

  /// Replaces the HTML document source.
  external set $webviewHtmlName(JSString value);

  /// Source allowed by VS Code's content security policy.
  external JSString get $webviewCspName;

  /// Converts an extension resource URI into a panel-safe URI.
  external $uriType $webviewAsUriName($uriType $webviewAsUriParameter);

  /// Posts [message] to the Flutter View runtime.
  external $thenableType<JSBoolean> $webviewPostMessageName(JSAny? message);

  /// Fires when the Flutter View posts a message to Host Dart.
  external $eventType<JSAny?> get $webviewReceiveName;
}

/// Native VS Code markdown content.
@JS(
  '__flutterVscode.apis.$extensionKey.$markdownType',
)
extension type $markdownType._(JSObject _) implements JSObject {
  /// Creates markdown initialized with [value].
  external factory $markdownType([JSString value]);
}

/// Native VS Code range between two numeric coordinates.
@JS(
  '__flutterVscode.apis.$extensionKey.$rangeType',
)
extension type $rangeType._(JSObject _) implements JSObject {
  /// Creates a range from zero-based start and end coordinates.
  external factory $rangeType(
    int startLine,
    int startCharacter,
    int endLine,
    int endCharacter,
  );
}

/// Native VS Code hover result.
@JS(
  '__flutterVscode.apis.$extensionKey.$hoverType',
)
extension type $hoverType._(JSObject _) implements JSObject {
  /// Creates a hover with [contents] and an optional [range].
  external factory $hoverType($markdownType contents, [$rangeType range]);
}
''';
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
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: always_use_package_imports

import 'dart:js_interop';

import 'vscode_parity.g.dart';
import 'vscode_runtime.g.dart';

export 'host_exports.g.dart';
export 'vscode_parity.g.dart';
export 'vscode_runtime.g.dart';

$observationConstants
/// Observed access to the selected root VS Code namespaces.
extension VSCodeFacade on VSCode {
  /// Command registration and execution APIs.
  $commandNamespaceType get commandApi {
    final api = $commandNamespaceName;
    observeHostBindings(const [_bindingCommandsNamespace]);
    return api;
  }

  /// Language feature registration APIs.
  $languageNamespaceType get languageApi {
    final api = $languageNamespaceName;
    observeHostBindings(const [_bindingLanguagesNamespace]);
    return api;
  }

  /// Window and Flutter View panel APIs.
  $windowNamespaceType get windowApi {
    final api = $windowNamespaceName;
    observeHostBindings(const [_bindingWindowNamespace]);
    return api;
  }

  /// Workspace state and event APIs.
  $workspaceNamespaceType get workspaceApi {
    final api = $workspaceNamespaceName;
    observeHostBindings(const [_bindingWorkspaceNamespace]);
    return api;
  }
}

/// Dart-friendly command helpers over the parity layer.
extension ${commandNamespaceType}Facade on $commandNamespaceType {
  /// Registers a callback and preserves mapped Dart frames for sync failures.
  $disposableType registerCommandCallback(
    JSString command,
    JSFunction callback,
  ) {
    final registration = $commandRegistrationName(
      command,
      toHostCallback(callback),
    );
    observeHostBindings(const [
      _bindingRegisterCommand,
      _bindingDisposableClass,
    ]);
    return registration;
  }

  /// Executes [command] and converts its thenable to a Dart future.
  Future<JSAny?> executeCommandFuture(JSString command) async {
    final result = await $commandExecutionName<JSAny?>(command).toDart;
    observeHostBindings(const [
      _bindingExecuteCommand,
      _bindingThenableInterface,
    ]);
    return result;
  }
}

/// Dart-friendly activation-context helpers.
extension ${extensionContextType}Facade on $extensionContextType {
  /// Root URI of the installed extension.
  $uriType get extensionRootUri {
    final uri = $extensionUriName;
    observeHostBindings(const [
      _bindingExtensionContextInterface,
      _bindingExtensionUri,
    ]);
    return uri;
  }

  /// Adds [registration] to the native extension subscription collection.
  void addSubscription(DisposableLike registration) {
    $contextSubscriptionsName.toDart.add(registration);
    observeHostBindings(const [
      _bindingExtensionContextInterface,
      _bindingContextSubscriptions,
      _bindingContextSubscriptionType,
      _bindingContextSubscriptionDispose,
    ]);
  }
}

/// Dart-friendly disposal for native command, event, and provider resources.
extension ${disposableType}Facade on $disposableType {
  /// Releases this registration through the generated binding.
  void disposeHostResource() {
    $disposeName();
    observeHostBindings(const [
      _bindingDisposableClass,
      _bindingDisposableDispose,
    ]);
  }
}

/// Dart-friendly language feature helpers over the parity layer.
extension ${languageNamespaceType}Facade on $languageNamespaceType {
  /// Registers [provider] for a string document selector.
  $disposableType registerHoverProviderForString(
    JSString selector,
    $hoverProviderType provider,
  ) {
    final registration = $hoverRegistrationName(selector, provider);
    observeHostBindings(const [
      _bindingRegisterHoverProvider,
      _bindingDocumentSelector,
    ]);
    return registration;
  }
}

/// Creates a provider whose actual callback invocation is host-observed.
$hoverProviderType createHostHoverProvider(JSFunction provideHover) {
  final provider = $hoverProviderType(
    $providerCallbackName: observeHostCallback(
      toHostCallback(provideHover),
      const [
        _bindingHoverProviderCallback,
        _bindingTextDocumentInterface,
        _bindingCancellationTokenInterface,
        _bindingProviderResult,
      ],
    ),
  );
  observeHostBindings(const [_bindingHoverProviderInterface]);
  return provider;
}

$positionFacade

/// Observed cancellation state supplied by VS Code provider callbacks.
extension ${cancellationTokenType}Facade on $cancellationTokenType {
  /// Whether the host requested cancellation.
  bool get cancellationRequested {
    final requested = $cancellationRequestedName;
    observeHostBindings(const [_bindingCancellationRequested]);
    return requested;
  }
}

/// Creates observed native markdown content.
$markdownType createHostMarkdownString(JSString value) {
  final markdown = $markdownType(value);
  observeHostBindings(const [
    _bindingMarkdownStringClass,
    _bindingMarkdownStringConstructor,
  ]);
  return markdown;
}

/// Creates an observed native numeric range.
$rangeType createHostRange(
  int startLine,
  int startCharacter,
  int endLine,
  int endCharacter,
) {
  final range = $rangeType(
    startLine,
    startCharacter,
    endLine,
    endCharacter,
  );
  observeHostBindings(const [
    _bindingRangeClass,
    _bindingRangeConstructor,
  ]);
  return range;
}

/// Creates an observed native hover result.
$hoverType createHostHover($markdownType contents, [$rangeType? range]) {
  final hover = range == null
      ? $hoverType(contents)
      : $hoverType(contents, range);
  observeHostBindings(const [
    _bindingHoverClass,
    _bindingHoverConstructor,
  ]);
  return hover;
}

/// Dart-friendly workspace event helpers over the parity layer.
extension ${workspaceNamespaceType}Facade on $workspaceNamespaceType {
  /// Subscribes [listener] to opened text documents.
  $disposableType listenOnDidOpenTextDocument(JSFunction listener) {
    final registration = $workspaceEventName(listener);
    observeHostBindings(const [
      _bindingWorkspaceOpenEvent,
      _bindingEventInterface,
      _bindingEventCall,
    ]);
    return registration;
  }
}

/// Dart-friendly Flutter View panel creation over the parity layer.
extension ${windowNamespaceType}Facade on $windowNamespaceType {
  /// Creates a panel with scripts enabled and scoped local resource roots.
  $webviewPanelType createFlutterViewPanel({
    required String viewType,
    required String title,
    required List<$uriType> localResourceRoots,
    int viewColumn = $enumType.$enumMemberName,
  }) {
    final panel = $panelCreationName(
      viewType.toJS,
      title.toJS,
      viewColumn,
      $optionsType(
        $optionsScriptsName: true,
        $optionsRootsName: localResourceRoots.toJS,
      ),
    );
    observeHostBindings(const [
      _bindingCreateWebviewPanel,
      _bindingWebviewOptionsInterface,
      _bindingOptionsScripts,
      _bindingOptionsRoots,
      _bindingWebviewPanelInterface,
    ]);
    if (viewColumn == $enumType.$enumMemberName) {
      observeHostBindings(const [
        _bindingViewColumnEnum,
        _bindingViewColumnOne,
      ]);
    }
    return panel;
  }
}

/// Dart-friendly URI helpers over VS Code's native URI values.
extension ${uriType}Facade on $uriType {
  /// Serializes this URI to a Dart string.
  String toDartString({bool skipEncoding = false}) {
    final result = $dartUriToStringName(skipEncoding).toDart;
    observeHostBindings(const [
      _bindingUriClass,
      _bindingUriToString,
    ]);
    return result;
  }
}

/// Joins one observed path segment onto [base].
$uriType joinHostUriPath($uriType base, JSString pathSegment) {
  final uri = $uriType.$uriJoinPathName(base, pathSegment);
  observeHostBindings(const [
    _bindingUriClass,
    _bindingUriJoinPath,
  ]);
  return uri;
}

/// Dart-friendly lifecycle helpers for a Flutter View panel.
extension ${webviewPanelType}Facade on $webviewPanelType {
  /// The panel's observed web content surface.
  $webviewType get webviewSurface {
    final surface = $panelWebviewName;
    observeHostBindings(const [
      _bindingWebviewPanelInterface,
      _bindingPanelWebview,
      _bindingWebviewInterface,
    ]);
    return surface;
  }

  /// Subscribes [listener] to panel disposal.
  $disposableType listenOnDidDispose(JSFunction listener) {
    final registration = $panelDisposeEventName(listener);
    observeHostBindings(const [_bindingPanelDisposeEvent]);
    return registration;
  }

  /// Closes the panel through the observed native binding.
  void disposeHostPanel() {
    $panelDisposeName();
    observeHostBindings(const [
      _bindingWebviewPanelInterface,
      _bindingWebviewPanelDispose,
    ]);
  }
}

/// Dart-friendly messaging helpers for a Flutter View.
extension ${webviewType}Facade on $webviewType {
  /// Current HTML as a Dart string.
  String get htmlText {
    final value = $webviewHtmlName.toDart;
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewHtml,
    ]);
    return value;
  }

  /// Replaces the HTML from a Dart string.
  set htmlText(String value) {
    $webviewHtmlName = value.toJS;
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewHtml,
    ]);
  }

  /// Content security policy source as a Dart string.
  String get contentSecurityPolicySource {
    final value = $webviewCspName.toDart;
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewCsp,
    ]);
    return value;
  }

  /// Converts an extension resource URI into a panel-safe URI.
  $uriType asFlutterViewUri($uriType localResource) {
    final uri = $webviewAsUriName(localResource);
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewAsUri,
    ]);
    return uri;
  }

  /// Posts [message] and reports whether it was accepted by the panel.
  Future<bool> postMessageFuture(JSAny? message) async {
    final result = await $webviewPostMessageName(message).toDart;
    final accepted = result.toDart;
    if (accepted) {
      observeHostBindings(const [
        _bindingWebviewInterface,
        _bindingWebviewPostMessage,
        _bindingThenableInterface,
      ]);
    }
    return accepted;
  }

  /// Subscribes [listener] to messages from the Flutter View.
  $disposableType listenOnDidReceiveMessage(JSFunction listener) {
    final registration = $webviewReceiveName(listener);
    observeHostBindings(const [
      _bindingWebviewInterface,
      _bindingWebviewReceive,
      _bindingEventInterface,
      _bindingEventCall,
    ]);
    return registration;
  }
}
''';
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

String _emitWalkingSliceRuntime(String extensionKey) {
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:async';
import 'dart:js_interop';

@JS('__flutterVscode.stackMappers.$extensionKey')
external JSString _mapHostStack(JSString stack);

@JS('__flutterVscode.callbackWrappers.$extensionKey')
external JSFunction _wrapHostCallback(JSFunction callback);

@JS('__flutterVscode.bindingObservers.$extensionKey')
external void _observeHostBinding(JSString bindingId);

@JS('__flutterVscode.bindingCallbackWrappers.$extensionKey')
external JSFunction _wrapObservedHostCallback(
  JSFunction callback,
  JSArray<JSString> bindingIds,
);
'''
      r'''

/// Native JavaScript error used to preserve Dart failure details.
@JS('Error')
extension type JavaScriptError._(JSObject _) implements JSObject {
  /// Creates an error with [message].
  external factory JavaScriptError(JSString message);

  /// Host-visible stack trace.
  external JSString get stack;

  /// Replaces the host-visible stack trace.
  external set stack(JSString value);
}

/// Creates a native host error whose stack retains mapped Dart source frames.
JavaScriptError toHostError(Object error, StackTrace stackTrace) {
  final hostError = JavaScriptError(error.toString().toJS);
  final stack = '${hostError.stack.toDart}\n$stackTrace';
  hostError.stack = _mapHostStack(stack.toJS);
  return hostError;
}

/// Wraps [callback] so synchronous throws retain mapped Dart source frames.
JSFunction toHostCallback(JSFunction callback) => _wrapHostCallback(callback);

/// Records binding IDs reached through an actual generated host operation.
void observeHostBindings(Iterable<String> bindingIds) {
  for (final bindingId in bindingIds) {
    _observeHostBinding(bindingId.toJS);
  }
}

/// Records [bindingIds] only when the native host invokes [callback].
JSFunction observeHostCallback(
  JSFunction callback,
  List<String> bindingIds,
) =>
    _wrapObservedHostCallback(
      callback,
      bindingIds.map((bindingId) => bindingId.toJS).toList().toJS,
    );

/// Converts [future] to a host promise while retaining Dart stack frames.
JSPromise<T> toHostPromise<T extends JSAny?>(Future<T> future) {
  return JSPromise<T>(
    (JSFunction resolve, JSFunction reject) {
      unawaited(
        future.then<void>(
          (value) {
            resolve.callAsFunction(resolve, value);
          },
          onError: (Object error, StackTrace stackTrace) {
            reject.callAsFunction(
              reject,
              toHostError(error, stackTrace),
            );
          },
        ),
      );
    }.toJS,
  );
}
''';
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
    _objectList(
      declaration['parameters'] ?? const <Object?>[],
      'declaration.parameters',
    ).map((value) => _objectMap(value, 'declaration parameter')).toList();

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
  final identifier = _string(value, path);
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
  final rawContracts = _objectMap(value, 'overrides.hostContracts');
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
    final contract = _objectMap(
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
    final boundary = _string(
      contract['boundary'],
      'overrides.hostContracts.$id.boundary',
    );
    if (boundary != 'vscodeExtensionHost') {
      throw VSCodeBindingGenerationException(
        'INVALID_OVERRIDE',
        'Host Contract $id has unsupported boundary $boundary.',
      );
    }
    final artifact = _string(
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
    final artifactSha256 = _string(
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

String _emitCoverageLedger({
  required String inventoryVersion,
  required String inputSha256,
  required String manifestSchemaSha256,
  required String manifestValidatorSha256,
  required String commandsContributionSchemaSha256,
  required Map<String, Map<String, Object?>> declarationsById,
  required Map<String, Object?> entries,
  required Map<String, String> strategiesById,
  required Map<String, Map<String, Object?>> hostContracts,
  required Map<String, String> hostContractsById,
}) {
  var semanticsReviewed = 0;
  var semanticsExcluded = 0;
  var bindingsEmitted = 0;
  var bindingsExcluded = 0;
  var hostVerified = 0;
  var hostNotApplicable = 0;
  var sourceOccurrences = 0;
  var publicLogicalEntries = 0;
  var reviewedExcludedTargets = 0;
  final ledgerEntries = <Map<String, Object?>>[];
  final ids = declarationsById.keys.toList()..sort();

  for (final id in ids) {
    final declaration = declarationsById[id]!;
    final occurrenceCount = _integerOrDefault(
      declaration['occurrenceCount'],
      defaultValue: 1,
      path: 'inventory declaration $id.occurrenceCount',
    );
    sourceOccurrences += occurrenceCount;
    final strategy = strategiesById[id];
    final visibility = _string(
      declaration['visibility'] ?? 'public',
      'inventory declaration $id.visibility',
    );
    final excludedByVisibility = visibility != 'public';
    final excludedByOverride = strategy == 'reviewedExcluded';
    if (!excludedByVisibility) {
      publicLogicalEntries += 1;
    }
    if (excludedByOverride) {
      reviewedExcludedTargets += 1;
    }

    final semantics = excludedByVisibility || excludedByOverride
        ? 'excluded'
        : strategy == null
            ? 'pending'
            : 'reviewed';
    final binding = excludedByVisibility || excludedByOverride
        ? 'excluded'
        : strategy == null
            ? 'pending'
            : 'emitted';
    final host = excludedByVisibility || excludedByOverride
        ? 'notApplicable'
        : strategy == null
            ? 'pending'
            : 'verified';

    if (semantics == 'reviewed') {
      semanticsReviewed += 1;
    } else if (semantics == 'excluded') {
      semanticsExcluded += 1;
    }
    if (binding == 'emitted') {
      bindingsEmitted += 1;
    } else if (binding == 'excluded') {
      bindingsExcluded += 1;
    }
    if (host == 'verified') {
      hostVerified += 1;
    } else if (host == 'notApplicable') {
      hostNotApplicable += 1;
    }

    final exclusionReason = excludedByOverride
        ? _string(
            _objectMap(entries[id], 'overrides.entries.$id')['reason'],
            'overrides.entries.$id.reason',
          )
        : null;
    ledgerEntries.add({
      'id': id,
      'kind': _string(declaration['kind'], 'inventory declaration $id.kind'),
      'visibility': visibility,
      'occurrenceCount': occurrenceCount,
      'selected': strategy != null,
      'discovery': <String, Object?>{'status': 'discovered'},
      'semantics': <String, Object?>{
        'status': semantics,
        if (excludedByVisibility) 'basis': 'visibility',
        if (strategy != null && !excludedByVisibility)
          'basis': 'semanticOverride',
        if (strategy != null && !excludedByVisibility) 'strategy': strategy,
        if (exclusionReason != null) 'reason': exclusionReason,
      },
      'binding': <String, Object?>{
        'status': binding,
        if (binding == 'emitted')
          'artifacts': <String>[
            'host/lib/generated/vscode_parity.g.dart',
          ],
      },
      'host': <String, Object?>{
        'status': host,
        if (host == 'verified') 'contract': hostContractsById[id],
      },
    });
  }

  final discovered = declarationsById.length;
  final semanticsPending = discovered - semanticsReviewed - semanticsExcluded;
  final bindingsPending = discovered - bindingsEmitted - bindingsExcluded;
  final hostPending = discovered - hostVerified - hostNotApplicable;
  final implementedTargets = semanticsReviewed;
  final ledger = <String, Object?>{
    'schemaVersion': 1,
    'source': <String, Object?>{
      'vscodeVersion': inventoryVersion,
      'inputSha256': inputSha256,
      'manifestSchemaSha256': manifestSchemaSha256,
      'manifestValidatorSha256': manifestValidatorSha256,
      'commandsContributionSchemaSha256': commandsContributionSchemaSha256,
    },
    'hostContracts': hostContracts,
    'hostEvidence': <String, Object?>{
      'kind': 'mechanicalAttribution',
      'meaning': '$hostVerified generated binding IDs were exercised by one '
          'real Extension Host Contract after its surrounding native '
          'behavior passed.',
      'independentBehavioralContracts': false,
    },
    'scope': <String, Object?>{
      'name': 'checkpoint4FlutterViewSlice',
      'fullApiParity':
          semanticsPending == 0 && bindingsPending == 0 && hostPending == 0,
      'selectedTargets': strategiesById.length,
      'implementedTargets': implementedTargets,
      'reviewedExcludedTargets': reviewedExcludedTargets,
    },
    'inventory': <String, Object?>{
      'logicalEntries': discovered,
      'sourceOccurrences': sourceOccurrences,
      'publicLogicalEntries': publicLogicalEntries,
      'nonPublicLogicalEntries': discovered - publicLogicalEntries,
    },
    'exclusions': <String, Object?>{
      'reviewedSemanticOverrides': reviewedExcludedTargets,
      'nonPublicVisibility': discovered - publicLogicalEntries,
    },
    'summary': <String, Object?>{
      'discovered': discovered,
      'semanticsReviewed': semanticsReviewed,
      'semanticsExcluded': semanticsExcluded,
      'semanticsPending': semanticsPending,
      'bindingsEmitted': bindingsEmitted,
      'bindingsExcluded': bindingsExcluded,
      'bindingsPending': bindingsPending,
      'hostVerified': hostVerified,
      'hostNotApplicable': hostNotApplicable,
      'hostPending': hostPending,
    },
    'entries': ledgerEntries,
  };
  const encoder = JsonEncoder.withIndent('  ');
  return '${encoder.convert(ledger)}\n';
}

String _validateManifestSchema(Map<String, Object?> inventory) {
  final schema = _objectMap(
    inventory['manifestSchema'],
    'inventory.manifestSchema',
  );
  final inputSha256 = _sha256Digest(
    schema['inputSha256'],
    'inventory.manifestSchema.inputSha256',
  );
  const expectedProjection = <String, Object?>{
    'schemaUri': 'vscode://schemas/vscode-extensions',
    'standalone': false,
    'properties': <String, Object?>{
      'activationEvents': <String, Object?>{
        'type': 'array',
        'items': <String, Object?>{'type': 'string'},
      },
      'contributes': <String, Object?>{'type': 'object'},
      'displayName': <String, Object?>{'type': 'string'},
      'engines': <String, Object?>{
        'type': 'object',
        'properties': <String, Object?>{
          'vscode': <String, Object?>{'type': 'string'},
        },
      },
      'publisher': <String, Object?>{'type': 'string'},
    },
  };
  final projection = Map<String, Object?>.of(schema)..remove('inputSha256');
  if (jsonEncode(projection) != jsonEncode(expectedProjection)) {
    final differingPath = _firstJsonDifferencePath(
      expectedProjection,
      projection,
      'inventory.manifestSchema',
    );
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Pinned manifest schema contains an unprojected change. First '
          'differing path: $differingPath. Regenerate the IR from the pinned '
          'input; if upstream changed, review and update the generator '
          'projection before retrying.',
    );
  }
  return inputSha256;
}

String _validateManifestValidator(Map<String, Object?> inventory) {
  final validator = _objectMap(
    inventory['manifestValidator'],
    'inventory.manifestValidator',
  );
  final inputSha256 = _sha256Digest(
    validator['inputSha256'],
    'inventory.manifestValidator.inputSha256',
  );
  const expectedProjection = <String, Object?>{
    'generatedManifestRules': <Object?>[
      <String, Object?>{
        'path': 'publisher',
        'presence': 'optional',
        'type': 'string',
      },
      <String, Object?>{
        'path': 'name',
        'presence': 'required',
        'type': 'string',
      },
      <String, Object?>{
        'path': 'version',
        'presence': 'required',
        'type': 'string',
      },
      <String, Object?>{
        'path': 'engines',
        'presence': 'required',
        'type': 'object',
      },
      <String, Object?>{
        'path': 'engines.vscode',
        'presence': 'required',
        'type': 'string',
      },
      <String, Object?>{
        'path': 'activationEvents',
        'presence': 'optional',
        'type': 'string[]',
        'requiresAny': <Object?>['main', 'browser'],
      },
      <String, Object?>{
        'path': 'main',
        'presence': 'optional',
        'type': 'string',
      },
    ],
    'versionPredicate': 'semver.valid',
    'engineVersionSyntax': <String, Object?>{
      'source': r'^(\^|>=)?((\d+)|x)\.((\d+)|x)\.((\d+)|x)(\-.*)?$',
      'flags': '',
    },
    'validatorBodySha256':
        'a7df6554afff3fa5c5e021f793fc8a4662fc641ade451565a8ff59929cf5a171',
    'projectionLimits': <String, Object?>{
      'remainingValidatorBranches': 'integrityPinnedByValidatorBodySha256',
      'semverValidImplementation': 'unprojectedExternal',
    },
  };
  final projection = Map<String, Object?>.of(validator)..remove('inputSha256');
  if (jsonEncode(projection) != jsonEncode(expectedProjection)) {
    final differingPath = _firstJsonDifferencePath(
      expectedProjection,
      projection,
      'inventory.manifestValidator',
    );
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Pinned manifest validator contains an unprojected change. '
          'First differing path: $differingPath. Regenerate the IR from the '
          'pinned input; if upstream changed, review and update the generator '
          'projection before retrying.',
    );
  }
  return inputSha256;
}

String _validateCommandsContributionSchema(
  Map<String, Object?> inventory,
) {
  final schemas = _objectMap(
    inventory['contributionSchemas'],
    'inventory.contributionSchemas',
  );
  if (schemas.keys.length != 1 || !schemas.containsKey('commands')) {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Inventory must contain exactly the commands contribution schema.',
    );
  }
  final commands = _objectMap(
    schemas['commands'],
    'inventory.contributionSchemas.commands',
  );
  final inputSha256 = _sha256Digest(
    commands['inputSha256'],
    'inventory.contributionSchemas.commands.inputSha256',
  );
  const expectedProjection = <String, Object?>{
    'extensionPoint': 'commands',
    'accepts': <Object?>['object', 'array'],
    'itemSchema': <String, Object?>{
      'type': 'object',
      'required': <Object?>['command', 'title'],
      'properties': <String, Object?>{
        'category': <String, Object?>{'type': 'string'},
        'command': <String, Object?>{'type': 'string'},
        'enablement': <String, Object?>{'type': 'string'},
        'icon': <String, Object?>{
          'anyOf': <Object?>[
            <String, Object?>{'type': 'string'},
            <String, Object?>{
              'type': 'object',
              'properties': <String, Object?>{
                'dark': <String, Object?>{'type': 'string'},
                'light': <String, Object?>{'type': 'string'},
              },
            },
          ],
        },
        'shortTitle': <String, Object?>{'type': 'string'},
        'title': <String, Object?>{'type': 'string'},
      },
    },
    'validation': <String, Object?>{
      'whitespacePredicate': 'ecmascript-trim-empty',
      'nonWhitespaceStringProperties': <Object?>['command', 'title'],
      'icon': <String, Object?>{
        'objectRequiredStringProperties': <Object?>['dark', 'light'],
      },
    },
  };
  final projection = Map<String, Object?>.of(commands)..remove('inputSha256');
  if (jsonEncode(projection) != jsonEncode(expectedProjection)) {
    final differingPath = _firstJsonDifferencePath(
      expectedProjection,
      projection,
      'inventory.contributionSchemas.commands',
    );
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Commands contribution schema contains an unprojected change. '
          'First differing path: $differingPath. Regenerate the IR from the '
          'pinned inputs; if upstream changed, review and update the generator '
          'projection before retrying.',
    );
  }
  return inputSha256;
}

String _firstJsonDifferencePath(
  Object? expected,
  Object? actual,
  String path,
) {
  if (expected is Map<Object?, Object?> && actual is Map<Object?, Object?>) {
    final expectedKeys = expected.keys.whereType<String>().toSet();
    final actualKeys = actual.keys.whereType<String>().toSet();
    if (expectedKeys.length != expected.length ||
        actualKeys.length != actual.length) {
      return path;
    }
    final keys = {...expectedKeys, ...actualKeys}.toList()..sort();
    for (final key in keys) {
      final childPath = '$path.$key';
      if (!expected.containsKey(key) || !actual.containsKey(key)) {
        return childPath;
      }
      if (jsonEncode(expected[key]) != jsonEncode(actual[key])) {
        return _firstJsonDifferencePath(
          expected[key],
          actual[key],
          childPath,
        );
      }
    }
    return path;
  }
  if (expected is List<Object?> && actual is List<Object?>) {
    final sharedLength =
        expected.length < actual.length ? expected.length : actual.length;
    for (var index = 0; index < sharedLength; index++) {
      if (jsonEncode(expected[index]) != jsonEncode(actual[index])) {
        return _firstJsonDifferencePath(
          expected[index],
          actual[index],
          '$path[$index]',
        );
      }
    }
    return '$path[$sharedLength]';
  }
  return path;
}

List<Map<String, Object?>> _projectCommands(Object? value) {
  if (value == null) {
    return const [];
  }
  final result = <Map<String, Object?>>[];
  final identifiers = <String>{};
  const supportedKeys = {
    'category',
    'command',
    'enablement',
    'icon',
    'shortTitle',
    'title',
  };
  for (final rawCommand in _objectList(value, 'project.commands')) {
    final command = _objectMap(rawCommand, 'project.commands entry');
    final unknown = command.keys
        .where((key) => !supportedKeys.contains(key))
        .toList()
      ..sort();
    if (unknown.isNotEmpty) {
      throw VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'Unknown command contribution fields: ${unknown.join(', ')}.',
      );
    }
    final identifier = _nonWhitespaceString(
      command['command'],
      'project.commands entry.command',
    );
    if (!identifiers.add(identifier)) {
      throw VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'Duplicate command contribution $identifier.',
      );
    }
    final title = _nonWhitespaceString(
      command['title'],
      'project.commands entry.title',
    );
    result.add(<String, Object?>{
      'command': identifier,
      'title': title,
      for (final key in ['shortTitle', 'category', 'enablement'])
        if (command[key] != null)
          key: _string(command[key], 'project.commands entry.$key'),
      if (command['icon'] != null) 'icon': _projectCommandIcon(command['icon']),
    });
  }
  return result;
}

Object _projectCommandIcon(Object? value) {
  if (value is String) {
    return value;
  }
  final icon = _objectMap(value, 'project.commands entry.icon');
  final unknown = icon.keys
      .where((key) => key != 'dark' && key != 'light')
      .toList()
    ..sort();
  if (unknown.isNotEmpty ||
      !icon.containsKey('dark') ||
      !icon.containsKey('light')) {
    throw const VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      'Command icon must be a string or an object containing both dark and '
          'light string paths and no other fields.',
    );
  }
  return <String, Object?>{
    'dark': _string(icon['dark'], 'project.commands entry.icon.dark'),
    'light': _string(
      icon['light'],
      'project.commands entry.icon.light',
    ),
  };
}

List<Object?> _objectList(Object? value, String path) {
  if (value is! List<Object?>) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a JSON array.',
    );
  }
  return value;
}

Map<String, Object?> _objectMap(Object? value, String path) {
  if (value is! Map<Object?, Object?>) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a JSON object.',
    );
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path contains a non-string key.',
      );
    }
    result[entry.key! as String] = entry.value;
  }
  return result;
}

String _string(Object? value, String path) {
  if (value is! String) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a string.',
    );
  }
  return value;
}

String _sha256Digest(Object? value, String path) {
  final result = _string(value, path);
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(result)) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a lowercase SHA-256 digest.',
    );
  }
  return result;
}

String _nonEmptyString(Object? value, String path) {
  final result = _string(value, path);
  if (result.isEmpty) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      '$path must not be empty.',
    );
  }
  return result;
}

String _extensionIdentifierComponent(Object? value, String path) {
  final result = _nonEmptyString(value, path);
  if (!RegExp(r'^[a-z0-9][a-z0-9-]*$').hasMatch(result)) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      '$path "$result" is unsafe for a packaged extension identifier. '
          'flutter_vscode requires lower-kebab components: start with a '
          'lowercase ASCII letter or digit, then use only lowercase ASCII '
          'letters, digits, or hyphens.',
    );
  }
  return result;
}

String _nonWhitespaceString(Object? value, String path) {
  final result = _string(value, path);
  if (isEcmaScriptFalsyOrWhitespace(result)) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      '$path must contain a non-whitespace character.',
    );
  }
  return result;
}

int _integerOrDefault(
  Object? value, {
  required int defaultValue,
  required String path,
}) {
  if (value == null) {
    return defaultValue;
  }
  if (value is! int) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be an integer.',
    );
  }
  return value;
}

int _integer(Object? value, String path) {
  if (value is! int) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be an integer.',
    );
  }
  return value;
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

/// Deterministic Dart binding generation from a pinned VS Code API inventory.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'ecmascript_whitespace.dart';

const _walkingSliceStrategiesById = <String, String>{
  r'callSignature:vscode.Event.$call@00d877bcd478273b6bafb74ceed20260eab023f2569cccd28d6f939bd4b030fd':
      'eventSubscription',
  'class:vscode.Disposable': 'nativeJsClass',
  'class:vscode.Hover': 'nativeJsClass',
  'class:vscode.MarkdownString': 'nativeJsClass',
  'class:vscode.Position': 'opaqueHostObject',
  'class:vscode.Range': 'nativeJsClass',
  'class:vscode.RelativePattern': 'reviewedExcluded',
  'class:vscode.Uri': 'nativeJsClass',
  'constructor:vscode.Hover.constructor@ba542e9f5fc2931b2263cfd40cedcb0b3f62795cc6c64e9d945f68fe93e1a733':
      'markdownHoverConstructor',
  'constructor:vscode.MarkdownString.constructor@778db11e42722b5fdfd54cb5c08b7cbae6f446502675c24b6e1baafb768f8763':
      'markdownStringConstructor',
  'constructor:vscode.Range.constructor@96fdd2143cf2ad164603faafc0bc158b86ecec84199402dcbea3c53247046e73':
      'reviewedExcluded',
  'constructor:vscode.Range.constructor@feb11e87d50082b0a3dce50eb837c5fb2141e1972675614c832daac107a42aa2':
      'numericRangeConstructor',
  'enum:vscode.ViewColumn': 'nativeJsEnum',
  'enumMember:enum:vscode.ViewColumn/One': 'intEnumMember',
  'function:vscode.commands.executeCommand@b17465f671e67bfe53e6a6035f410a9da4014065660ba0353f0c1819e01e51c4':
      'commandExecution',
  'function:vscode.commands.registerCommand@34f73a03df1575981702703e8a718cb4adc33e54b09dd607cb695dbc0a6fe811':
      'commandRegistration',
  'function:vscode.languages.registerHoverProvider@359bc682e80de72a8b404f4910825931a7d3218571ce6fbc7c24e51b6fdda82c':
      'hoverProviderRegistration',
  'function:vscode.window.createWebviewPanel@4af3ed891d6653b0e15049855163b86a1bb88077e84074494d213b532780dd71':
      'webviewPanelCreation',
  'interface:global.Thenable': 'thenableFutureBridge',
  'interface:vscode.CancellationToken': 'opaqueHostObject',
  'interface:vscode.DocumentFilter': 'reviewedExcluded',
  'interface:vscode.Event': 'eventType',
  'interface:vscode.ExtensionContext': 'opaqueHostObject',
  'interface:vscode.HoverProvider': 'providerObject',
  'interface:vscode.TextDocument': 'opaqueHostObject',
  'interface:vscode.Webview': 'opaqueHostObject',
  'interface:vscode.WebviewOptions': 'jsObjectLiteral',
  'interface:vscode.WebviewPanel': 'opaqueHostObject',
  'interface:vscode.WebviewPanelOptions': 'reviewedExcluded',
  'method:vscode.Disposable.dispose@0d951b53cb391f95a153c09ca504c6a20544ab772eee3ddde2cb90e82f2af650':
      'disposeMethod',
  r'method:vscode.ExtensionContext.subscriptions.$element.$type.dispose@0d951b53cb391f95a153c09ca504c6a20544ab772eee3ddde2cb90e82f2af650':
      'disposeMethod',
  'method:vscode.HoverProvider.provideHover@a969cbd1bc9d722b55f274c6a1498f88b5a0f8111d844c87acb34af847215f47':
      'providerCallback',
  'method:vscode.Uri.joinPath@def462330bbbdd12dba18cecdb919bfb417658caeb2e1f58c491cbffb8630c60':
      'uriJoinPath',
  'method:vscode.Uri.toString@f34ea61ca7bffcee2909bb6d6e58a9ac5b97c70f77ba6a2e899890a9aadbfd06':
      'uriToString',
  'method:vscode.Webview.asWebviewUri@d651d976be2224c53dd59a45880372a0ad40e686c697b38c14bcd4a900d02675':
      'unaryUriMethod',
  'method:vscode.Webview.postMessage@a2972cc260d088838e09de8dc683393276ed8c03d172023d9a807a9d585d71a1':
      'thenableBoolMethod',
  'method:vscode.WebviewPanel.dispose@0d951b53cb391f95a153c09ca504c6a20544ab772eee3ddde2cb90e82f2af650':
      'disposeMethod',
  'namespace:vscode.commands': 'namespaceObject',
  'namespace:vscode.languages': 'namespaceObject',
  'namespace:vscode.window': 'namespaceObject',
  'namespace:vscode.workspace': 'namespaceObject',
  r'property:class:vscode.Position/$instance/character': 'intGetterProjection',
  r'property:class:vscode.Position/$instance/line': 'intGetterProjection',
  r'property:interface:vscode.CancellationToken/$instance/isCancellationRequested':
      'boolGetterProjection',
  r'property:interface:vscode.ExtensionContext/$instance/extensionUri':
      'objectGetterProjection',
  r'property:interface:vscode.ExtensionContext/$instance/subscriptions':
      'subscriptionsArray',
  r'property:interface:vscode.Webview/$instance/cspSource':
      'stringGetterProjection',
  r'property:interface:vscode.Webview/$instance/html':
      'stringGetterSetterProjection',
  r'property:interface:vscode.Webview/$instance/onDidReceiveMessage':
      'eventValue',
  r'property:interface:vscode.WebviewOptions/$instance/enableScripts':
      'boolObjectField',
  r'property:interface:vscode.WebviewOptions/$instance/localResourceRoots':
      'uriArrayObjectField',
  r'property:interface:vscode.WebviewPanel/$instance/onDidDispose':
      'voidEventValue',
  r'property:interface:vscode.WebviewPanel/$instance/webview':
      'objectGetterProjection',
  'typeAlias:vscode.DocumentSelector': 'stringSelectorProjection',
  'typeAlias:vscode.GlobPattern': 'reviewedExcluded',
  'typeAlias:vscode.MarkedString': 'reviewedExcluded',
  'typeAlias:vscode.ProviderResult': 'providerResultProjection',
  r'typeLiteral:vscode.ExtensionContext.subscriptions.$element.$type@f5716cc35f40e12ce43adfbf37b72dc3bb90a514875ac7efb9346af4aa710ba9':
      'disposableStructuralType',
  r'typeLiteral:vscode.window.createWebviewPanel.$signature@4af3ed891d6653b0e15049855163b86a1bb88077e84074494d213b532780dd71.$parameter2.$item1.$type@d5b6776560804b01b07459130bbbedf0f397f2e563430e59e2fd6209012306ac':
      'reviewedExcluded',
  'variable:vscode.workspace.onDidOpenTextDocument': 'eventValue',
};

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
    _validateProjectDescriptor(project);
    final source = _objectMap(inventory['source'], 'inventory.source');
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
    final inputSha256 = _string(
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
    final overrideManifestSchemaSha256 = _string(
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
    final manifestValidator = _objectMap(
      inventory['manifestValidator'],
      'inventory.manifestValidator',
    );
    final manifestValidatorSha256 = _string(
      manifestValidator['inputSha256'],
      'inventory.manifestValidator.inputSha256',
    );
    final overrideManifestValidatorSha256 = _string(
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
    final overrideCommandsContributionSchemaSha256 = _string(
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
    for (final declarationValue in declarations) {
      final declaration = _objectMap(
        declarationValue,
        'inventory declaration',
      );
      final id = _string(declaration['id'], 'inventory declaration.id');
      if (declarationsById.containsKey(id)) {
        throw VSCodeBindingGenerationException(
          'INVALID_GENERATOR_INPUT',
          'Inventory contains duplicate entry $id.',
        );
      }
      declarationsById[id] = declaration;
    }
    final knownIds = declarationsById.keys.toSet();
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
      final hostVerified = _boolean(
        entry['hostVerified'],
        'overrides.entries.$id.hostVerified',
      );
      if (strategy == 'reviewedExcluded') {
        if (hostVerified) {
          throw VSCodeBindingGenerationException(
            'INVALID_OVERRIDE',
            'Reviewed exclusion $id cannot be host-verified.',
          );
        }
        _nonEmptyString(entry['reason'], 'overrides.entries.$id.reason');
      } else if (!hostVerified) {
        throw VSCodeBindingGenerationException(
          'INVALID_OVERRIDE',
          'Emitted binding $id must be host-verified before it enters the '
              'reviewed slice.',
        );
      }
      strategiesById[id] = strategy;
    }
    for (final id in targetIds) {
      if (!knownIds.contains(id)) {
        throw VSCodeBindingGenerationException(
          'UNKNOWN_TARGET_ID',
          'Selected binding target $id does not match any inventory entry.',
        );
      }
      if (!entries.containsKey(id)) {
        throw VSCodeBindingGenerationException(
          'MISSING_OVERRIDE',
          'Selected binding target $id has no Semantic Override.',
        );
      }
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
    final facade = walkingSlice ? _emitWalkingSliceFacade() : null;
    final runtime = walkingSlice ? _emitWalkingSliceRuntime() : null;
    final coverage = _emitCoverageLedger(
      inventoryVersion: inventoryVersion,
      inputSha256: inputSha256,
      manifestSchemaSha256: manifestSchemaSha256,
      manifestValidatorSha256: manifestValidatorSha256,
      commandsContributionSchemaSha256: commandsContributionSchemaSha256,
      declarationsById: declarationsById,
      entries: entries,
      strategiesById: strategiesById,
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
const manifest = require('../package.json');
const vscode = require('vscode');

process.setSourceMapsEnabled?.(true);
globalThis.self ??= globalThis;
const namespace = (globalThis.__flutterVscode ??= Object.create(null));
namespace.hosts ??= Object.create(null);
namespace.apis ??= Object.create(null);
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

require('../out/extension.dart.js');

const host = namespace.hosts[extensionKey];
if (!host) {
  throw new Error('Dart host did not register its lifecycle exports.');
}

const failActivation =
  process.env.FLUTTER_VSCODE_HOST_TEST_FAIL_ACTIVATION === '1';

exports.activate = (context) =>
  host.activate(context, vscode, failActivation);
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
  _validateWalkingSliceProfile(declarationsById, strategiesById);
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.
// VS Code $inventoryVersion mechanically reviewed API slice.

import 'dart:js_interop';

/// Selected root namespaces from the native VS Code API object.
extension type VSCode.fromJS(JSObject _) implements JSObject {
  /// Command registration and execution APIs.
  external Commands get commands;

  /// Language feature registration APIs.
  external Languages get languages;

  /// Window and Flutter View panel APIs.
  external Window get window;

  /// Workspace state and event APIs.
  external Workspace get workspace;
}

/// Selected `vscode.commands` operations.
extension type Commands.fromJS(JSObject _) implements JSObject {
  /// Registers [callback] for [command].
  external Disposable registerCommand(
    JSString command,
    JSFunction callback, [
    JSAny? thisArg,
  ]);

  /// Executes [command] and returns its host thenable.
  external Thenable<T> executeCommand<T extends JSAny?>(JSString command);
}

/// A host thenable represented by a native JavaScript promise contract.
extension type Thenable<T extends JSAny?>.fromJS(JSPromise<T> _)
    implements JSPromise<T> {}

/// Structural host object that can release its resource.
extension type DisposableLike.fromJS(JSObject _) implements JSObject {
  /// Releases the resource.
  external JSAny? dispose();
}

/// Native VS Code disposable registration.
extension type Disposable.fromJS(JSObject _)
    implements JSObject, DisposableLike {
  /// Releases the registration.
  external JSAny? dispose();
}

/// Native VS Code extension activation context.
extension type ExtensionContext.fromJS(JSObject _) implements JSObject {
  /// Root URI of the installed extension.
  external Uri get extensionUri;

  /// Registrations VS Code disposes with the extension.
  external JSArray<DisposableLike> get subscriptions;
}

/// Selected `vscode.languages` operations.
extension type Languages.fromJS(JSObject _) implements JSObject {
  /// Registers [provider] for the selected documents.
  external Disposable registerHoverProvider(
    JSAny selector,
    HoverProvider provider,
  );
}

/// Native hover provider callback object.
@JS()
extension type HoverProvider._(JSObject _) implements JSObject {
  /// Creates a provider backed by [provideHover].
  external factory HoverProvider({JSFunction provideHover});
}

/// Native VS Code text document whose identity is preserved.
extension type TextDocument.fromJS(JSObject _) implements JSObject {}

/// Native cancellation token supplied to provider callbacks.
extension type CancellationToken.fromJS(JSObject _) implements JSObject {
  /// Whether the host requested cancellation.
  external bool get isCancellationRequested;
}

/// Selected `vscode.workspace` events.
extension type Workspace.fromJS(JSObject _) implements JSObject {
  /// Fires when a text document opens.
  external Event<TextDocument> get onDidOpenTextDocument;
}

/// Selected `vscode.window` operations.
extension type Window.fromJS(JSObject _) implements JSObject {
  /// Creates a native VS Code panel that hosts one Flutter View.
  external WebviewPanel createWebviewPanel(
    JSString viewType,
    JSString title,
    int showOptions, [
    WebviewOptions options,
  ]);
}

/// Reviewed numeric values from VS Code's `ViewColumn` enum.
abstract final class ViewColumn {
  /// The first editor column.
  static const int one = 1;
}

/// Native options passed when a Flutter View panel is created.
@JS()
extension type WebviewOptions._(JSObject _) implements JSObject {
  /// Creates the reviewed options shape used by Flutter Views.
  external factory WebviewOptions({
    bool enableScripts,
    JSArray<Uri> localResourceRoots,
  });
}

/// Callable native VS Code event.
extension type Event<T extends JSAny?>.fromJS(JSFunction _)
    implements JSFunction {
  /// Subscribes [listener] and returns its native disposable.
  Disposable call(
    JSFunction listener, [
    JSAny? thisArgs,
    JSArray<Disposable>? disposables,
  ]) {
    final JSAny? result;
    if (disposables != null) {
      result = _.callAsFunction(null, listener, thisArgs, disposables);
    } else if (thisArgs != null) {
      result = _.callAsFunction(null, listener, thisArgs);
    } else {
      result = _.callAsFunction(null, listener);
    }
    return Disposable.fromJS(result! as JSObject);
  }
}

/// Callable native VS Code event that carries no value.
extension type VoidEvent.fromJS(JSFunction _) implements JSFunction {
  /// Subscribes [listener] and returns its native disposable.
  Disposable call(
    JSFunction listener, [
    JSAny? thisArgs,
    JSArray<Disposable>? disposables,
  ]) {
    final JSAny? result;
    if (disposables != null) {
      result = _.callAsFunction(null, listener, thisArgs, disposables);
    } else if (thisArgs != null) {
      result = _.callAsFunction(null, listener, thisArgs);
    } else {
      result = _.callAsFunction(null, listener);
    }
    return Disposable.fromJS(result! as JSObject);
  }
}

/// Native VS Code zero-based document position.
extension type Position.fromJS(JSObject _) implements JSObject {
  /// Zero-based line number.
  external int get line;

  /// Zero-based character offset.
  external int get character;
}

/// Native VS Code URI with the reviewed Flutter View operations.
@JS(
  '__flutterVscode.apis.$extensionKey.Uri',
)
extension type Uri._(JSObject _) implements JSObject {
  /// Joins one path segment onto [base].
  @JS('joinPath')
  external static Uri joinPath(Uri base, JSString pathSegment);

  /// Serializes this URI using VS Code's URI implementation.
  @JS('toString')
  // VS Code defines this as a positional boolean parameter.
  // ignore: avoid_positional_boolean_parameters
  external JSString toUriString([bool skipEncoding]);
}

/// Native VS Code panel that hosts one Flutter View.
extension type WebviewPanel.fromJS(JSObject _)
    implements JSObject, DisposableLike {
  /// The panel's web content surface.
  external Webview get webview;

  /// Fires once when the panel is disposed.
  external VoidEvent get onDidDispose;

  /// Closes the panel and releases its resources.
  external JSAny? dispose();
}

/// Native VS Code web content surface for a Flutter View.
extension type Webview.fromJS(JSObject _) implements JSObject {
  /// Current HTML document source.
  external JSString get html;

  /// Replaces the HTML document source.
  external set html(JSString value);

  /// Source allowed by VS Code's content security policy.
  external JSString get cspSource;

  /// Converts an extension resource URI into a panel-safe URI.
  external Uri asWebviewUri(Uri localResource);

  /// Posts [message] to the Flutter View runtime.
  external Thenable<JSBoolean> postMessage(JSAny? message);

  /// Fires when the Flutter View posts a message to Host Dart.
  external Event<JSAny?> get onDidReceiveMessage;
}

/// Native VS Code markdown content.
@JS(
  '__flutterVscode.apis.$extensionKey.MarkdownString',
)
extension type MarkdownString._(JSObject _) implements JSObject {
  /// Creates markdown initialized with [value].
  external factory MarkdownString([JSString value]);
}

/// Native VS Code range between two numeric coordinates.
@JS(
  '__flutterVscode.apis.$extensionKey.Range',
)
extension type Range._(JSObject _) implements JSObject {
  /// Creates a range from zero-based start and end coordinates.
  external factory Range(
    int startLine,
    int startCharacter,
    int endLine,
    int endCharacter,
  );
}

/// Native VS Code hover result.
@JS(
  '__flutterVscode.apis.$extensionKey.Hover',
)
extension type Hover._(JSObject _) implements JSObject {
  /// Creates a hover with [contents] and an optional [range].
  external factory Hover(MarkdownString contents, [Range range]);
}
''';
}

String _emitWalkingSliceFacade() {
  return '''
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
''';
}

String _emitWalkingSliceRuntime() {
  return r'''
// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:async';
import 'dart:js_interop';

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
            final hostError = JavaScriptError(error.toString().toJS);
            hostError.stack = '${hostError.stack.toDart}\n$stackTrace'.toJS;
            reject.callAsFunction(reject, hostError);
          },
        ),
      );
    }.toJS,
  );
}
''';
}

void _validateWalkingSliceProfile(
  Map<String, Map<String, Object?>> declarationsById,
  Map<String, String> strategiesById,
) {
  for (final expected in _walkingSliceStrategiesById.entries) {
    final actual = strategiesById[expected.key];
    if (actual != expected.value) {
      throw VSCodeBindingGenerationException(
        'WALKING_SLICE_PROFILE_MISMATCH',
        'Walking-slice entry ${expected.key} must use ${expected.value}, '
            'but found ${actual ?? 'no strategy'}.',
      );
    }
  }
  final unexpectedIds = strategiesById.keys
      .where((id) => !_walkingSliceStrategiesById.containsKey(id))
      .toList()
    ..sort();
  if (unexpectedIds.isNotEmpty) {
    throw VSCodeBindingGenerationException(
      'WALKING_SLICE_PROFILE_MISMATCH',
      'The walking slice contains unexpected entries: '
          '${unexpectedIds.join(', ')}.',
    );
  }

  const expectedCounts = <String, int>{
    'boolObjectField': 1,
    'boolGetterProjection': 1,
    'commandExecution': 1,
    'commandRegistration': 1,
    'disposableStructuralType': 1,
    'disposeMethod': 3,
    'eventSubscription': 1,
    'eventType': 1,
    'eventValue': 2,
    'hoverProviderRegistration': 1,
    'intEnumMember': 1,
    'intGetterProjection': 2,
    'jsObjectLiteral': 1,
    'markdownHoverConstructor': 1,
    'markdownStringConstructor': 1,
    'namespaceObject': 4,
    'nativeJsClass': 5,
    'nativeJsEnum': 1,
    'numericRangeConstructor': 1,
    'objectGetterProjection': 2,
    'opaqueHostObject': 6,
    'providerCallback': 1,
    'providerObject': 1,
    'providerResultProjection': 1,
    'reviewedExcluded': 7,
    'stringGetterProjection': 1,
    'stringGetterSetterProjection': 1,
    'stringSelectorProjection': 1,
    'subscriptionsArray': 1,
    'thenableBoolMethod': 1,
    'thenableFutureBridge': 1,
    'unaryUriMethod': 1,
    'uriArrayObjectField': 1,
    'uriJoinPath': 1,
    'uriToString': 1,
    'voidEventValue': 1,
    'webviewPanelCreation': 1,
  };
  final actualCounts = <String, int>{};
  for (final strategy in strategiesById.values) {
    actualCounts[strategy] = (actualCounts[strategy] ?? 0) + 1;
  }
  if (!_mapsEqual(actualCounts, expectedCounts)) {
    throw VSCodeBindingGenerationException(
      'WALKING_SLICE_PROFILE_MISMATCH',
      'The reviewed walking-slice strategy profile changed. Expected '
          '$expectedCounts, found $actualCounts.',
    );
  }

  _expectStrategyNames(
    declarationsById,
    strategiesById,
    'namespaceObject',
    {'commands', 'languages', 'window', 'workspace'},
  );
  _expectStrategyNames(
    declarationsById,
    strategiesById,
    'nativeJsClass',
    {'Disposable', 'Hover', 'MarkdownString', 'Range', 'Uri'},
  );
  _expectStrategyNames(
    declarationsById,
    strategiesById,
    'opaqueHostObject',
    {
      'CancellationToken',
      'ExtensionContext',
      'Position',
      'TextDocument',
      'Webview',
      'WebviewPanel',
    },
  );
  _expectStrategyNames(
    declarationsById,
    strategiesById,
    'jsObjectLiteral',
    {'WebviewOptions'},
  );
  _expectStrategyNames(
    declarationsById,
    strategiesById,
    'nativeJsEnum',
    {'ViewColumn'},
  );
}

void _expectStrategyNames(
  Map<String, Map<String, Object?>> declarationsById,
  Map<String, String> strategiesById,
  String strategy,
  Set<String> expected,
) {
  final actual = <String>{
    for (final entry in strategiesById.entries)
      if (entry.value == strategy)
        _string(
          declarationsById[entry.key]!['name'],
          'inventory declaration ${entry.key}.name',
        ),
  };
  if (!_setsEqual(actual, expected)) {
    throw VSCodeBindingGenerationException(
      'WALKING_SLICE_PROFILE_MISMATCH',
      'Strategy $strategy expected names $expected, found $actual.',
    );
  }
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
        if (host == 'verified') 'contract': 'checkpoint4ExtensionHost',
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

bool _mapsEqual(Map<String, int> left, Map<String, int> right) {
  if (left.length != right.length) {
    return false;
  }
  return left.entries.every((entry) => right[entry.key] == entry.value);
}

bool _setsEqual(Set<String> left, Set<String> right) {
  return left.length == right.length && left.containsAll(right);
}

String _validateManifestSchema(Map<String, Object?> inventory) {
  final schema = _objectMap(
    inventory['manifestSchema'],
    'inventory.manifestSchema',
  );
  final inputSha256 = _string(
    schema['inputSha256'],
    'inventory.manifestSchema.inputSha256',
  );
  if (schema['schemaUri'] != 'vscode://schemas/vscode-extensions' ||
      schema['standalone'] != false) {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Inventory manifest schema identity is unsupported.',
    );
  }
  final properties = _objectMap(
    schema['properties'],
    'inventory.manifestSchema.properties',
  );
  _expectSchemaType(properties, 'publisher', 'string');
  _expectSchemaType(properties, 'displayName', 'string');
  _expectSchemaType(properties, 'engines', 'object');
  _expectSchemaType(properties, 'activationEvents', 'array');
  _expectSchemaType(properties, 'contributes', 'object');
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
  final inputSha256 = _string(
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

void _expectSchemaType(
  Map<String, Object?> properties,
  String name,
  String expected,
) {
  final property = _objectMap(
    properties[name],
    'inventory.manifestSchema.properties.$name',
  );
  if (property['type'] != expected) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Manifest schema property $name must have type $expected.',
    );
  }
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

bool _boolean(Object? value, String path) {
  if (value is! bool) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a boolean.',
    );
  }
  return value;
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

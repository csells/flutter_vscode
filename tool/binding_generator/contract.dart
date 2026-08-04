import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Repository-relative receipt paths attested by the checkpoint-4 contract.
///
/// The same canonical map is duplicated on purpose in
/// `tool/extension_host_test/host_contract.cjs` and
/// `test/binding_evidence_test.dart`; each copy cross-checks the others
/// through the byte-identical artifact they all validate.
const canonicalHostContractSourcePaths = <String, String>{
  'activationFailureTest':
      'test/fixtures/host_extension/test/activation_failure.cjs',
  'bindingCoverageLedger': 'tool/binding_generator/coverage_ledger.dart',
  'bindingGenerator': 'tool/binding_generator/generator.dart',
  'bindingIrTypeMapper': 'tool/binding_generator/ir_type_mapper.dart',
  'bindingIrValidator': 'tool/binding_generator/ir_validator.dart',
  'bindingManifestProjection':
      'tool/binding_generator/manifest_projection.dart',
  'bindingTemplates': 'tool/binding_generator/templates.dart',
  'bindingValidators': 'tool/binding_generator/validators.dart',
  'bindingWriter': 'tool/binding_generator/writer.dart',
  'bootstrapLifecycleTest':
      'tool/extension_host_test/bootstrap_lifecycle.test.cjs',
  'buildReceipt': 'lib/src/cli/build_receipt.dart',
  'builder': 'scripts/build_host_fixture.sh',
  'canonicalInventory': 'tool/bindings/ir/vscode-1.129.1.json',
  'canonicalViewProtocol': 'lib/src/view_protocol.dart',
  'cli': 'bin/flutter_vscode.dart',
  'container': 'tool/extension_host_test/Dockerfile',
  'contractWriter': 'tool/binding_generator/contract.dart',
  'ecmascriptWhitespace': 'tool/binding_generator/ecmascript_whitespace.dart',
  'evidenceIntegrityTest': 'test/binding_evidence_test.dart',
  'fixtureHost': 'test/fixtures/host_extension/host/lib/extension.dart',
  'fixtureHostPackage': 'test/fixtures/host_extension/host/pubspec.yaml',
  'fixtureManifest': 'test/fixtures/host_extension/package.json',
  'fixtureProject': 'test/fixtures/host_extension/extension.json',
  'fixtureSharedContract':
      'test/fixtures/host_extension/shared/lib/fixture_view_contract.dart',
  'fixtureSharedPackage': 'test/fixtures/host_extension/shared/pubspec.yaml',
  'fixtureTransport':
      'test/fixtures/host_extension/host/lib/generated/flutter_view_host.g.dart',
  'fixtureView': 'test/fixtures/host_extension/views/main/lib/main.dart',
  'fixtureViewIndex': 'test/fixtures/host_extension/views/main/web/index.html',
  'fixtureViewPackage': 'test/fixtures/host_extension/views/main/pubspec.yaml',
  'flutterViewHostTemplate': 'lib/src/cli/flutter_view_host_source.dart',
  'frameworkPackage': 'pubspec.yaml',
  // The fixture packages are members of the repository's pub workspace, so
  // this single root lockfile is the pinned resolution for the framework and
  // every fixture package alike.
  'frameworkPackageLock': 'pubspec.lock',
  'generatedBootstrap': 'test/fixtures/host_extension/host/bootstrap.cjs',
  'generatedDartLayer':
      'test/fixtures/host_extension/host/lib/generated/vscode_dart_layer.g.dart',
  'generatedHostCommands':
      'test/fixtures/host_extension/host/lib/generated/host_commands.g.dart',
  'generatedHostExports':
      'test/fixtures/host_extension/host/lib/generated/host_exports.g.dart',
  'generatedRuntime':
      'test/fixtures/host_extension/host/lib/generated/vscode_runtime.g.dart',
  'generatedSharedViewProtocol':
      'test/fixtures/host_extension/shared/lib/generated/view_protocol.g.dart',
  'generatedViewProtocol':
      'test/fixtures/host_extension/host/lib/generated/view_protocol.g.dart',
  'harnessPackage': 'tool/extension_host_test/package.json',
  'harnessPackageLock': 'tool/extension_host_test/package-lock.json',
  'hostCommandsTemplate': 'lib/src/cli/host_commands_source.dart',
  'hostImportChecker': 'tool/check_host_imports.dart',
  'launcher': 'tool/extension_host_test/run.cjs',
  'projectDescriptor': 'lib/src/cli/project_descriptor.dart',
  'runner': 'scripts/test_host_extension.sh',
  'test': 'test/fixtures/host_extension/test/run.cjs',
  'verifier': 'tool/extension_host_test/host_contract.cjs',
  'verifierTest': 'tool/extension_host_test/host_contract.test.cjs',
  'viewLibrary': 'lib/view.dart',
  'viewTransport': 'lib/src/view_transport_web.dart',
};

/// Builds the canonical checkpoint-4 Host Contract artifact from tree state.
///
/// Every field is derived mechanically: source receipts hash the receipted
/// repository files, the attributed bindings are the non-excluded Semantic
/// Override entries, and the API/runtime targets come from the pinned
/// inventory, the fixture manifest, the harness package, and the container
/// definition. Hand-editing the artifact is not a supported workflow.
String buildHostContractArtifact(Directory repositoryRoot) {
  final root = repositoryRoot.path;

  Map<String, Object?> readJson(String relativePath) =>
      (jsonDecode(File('$root/$relativePath').readAsStringSync())
              as Map<Object?, Object?>)
          .cast<String, Object?>();

  final inventory = readJson('tool/bindings/ir/vscode-1.129.1.json');
  final product = ((inventory['source']! as Map<Object?, Object?>)['product']!
          as Map<Object?, Object?>)
      .cast<String, Object?>();

  final fixtureManifest = readJson('test/fixtures/host_extension/package.json');
  final fixtureEngines = (fixtureManifest['engines']! as Map<Object?, Object?>)
      .cast<String, Object?>();

  final harnessPackage = readJson('tool/extension_host_test/package.json');
  final harnessDependencies =
      (harnessPackage['devDependencies']! as Map<Object?, Object?>)
          .cast<String, Object?>();

  final container =
      File('$root/tool/extension_host_test/Dockerfile').readAsStringSync();
  final nodeImage =
      RegExp(r'^FROM (\S+)$', multiLine: true).firstMatch(container)!.group(1)!;

  final sourceIds = canonicalHostContractSourcePaths.keys.toList()..sort();
  final sources = <String, Object?>{
    for (final sourceId in sourceIds)
      sourceId: <String, Object?>{
        'path': canonicalHostContractSourcePaths[sourceId],
        'sha256': sha256
            .convert(
              File('$root/${canonicalHostContractSourcePaths[sourceId]}')
                  .readAsBytesSync(),
            )
            .toString(),
      },
  };

  final overrides = readJson('tool/bindings/overrides/vscode-1.129.1.json');
  final entries =
      (overrides['entries']! as Map<Object?, Object?>).cast<String, Object?>();
  final attributedBindings = <String>[
    for (final entry in entries.entries)
      if ((entry.value! as Map<Object?, Object?>)['strategy'] !=
          'reviewedExcluded')
        entry.key,
  ]..sort();

  final artifact = <String, Object?>{
    'schemaVersion': 1,
    'id': 'checkpoint4ExtensionHost',
    'boundary': 'vscodeExtensionHost',
    'sourceRepository': 'https://github.com/SlowGen/flutter_vscode',
    'apiTarget': <String, Object?>{
      'version': product['version'],
      'commit': product['commit'],
    },
    'runtimeTarget': <String, Object?>{
      'vscodeVersion': fixtureEngines['vscode'],
      'testElectronVersion': harnessDependencies['@vscode/test-electron'],
      'nodeImage': nodeImage,
      'cachePolicy': 'freshInvocationScoped',
    },
    'trustBoundary': <String, Object?>{
      'dartToolchain':
          'The locally installed Flutter/Dart SDK and packages resolved '
              'from the enforced lockfile are trusted; this contract does '
              'not attest their bytes.',
      'vscodeRuntime':
          'Each gate resolves the exact official VS Code version into a '
              'new invocation-scoped cache; this contract does not attest '
              'a predeclared runtime binary digest.',
    },
    'sources': sources,
    'evidence': <String, Object?>{
      'kind': 'mechanicalAttribution',
      'meaning':
          'Every listed binding ID is attributed to this one real Extension '
              'Host Contract by its reviewed Semantic Override; the gate '
              'passes only after the receipted repository sources and the '
              'surrounding native behavior pass, without per-member '
              'observation.',
      'independentBehavioralContracts': false,
    },
    'attributedBindings': attributedBindings,
  };
  return '${const JsonEncoder.withIndent('  ').convert(artifact)}\n';
}

/// Writes the artifact and repins its hash inside the Semantic Overrides.
///
/// Every checked-in baseline cites the same checkpoint-4 contract, so each
/// `tool/bindings/overrides/vscode-*.json` is edited surgically: reviewed
/// content and formatting stay byte-identical outside the single
/// artifactSha256 value per file.
void writeHostContractArtifact(Directory repositoryRoot) {
  final root = repositoryRoot.path;
  final artifact = buildHostContractArtifact(repositoryRoot);
  File('$root/tool/bindings/contracts/checkpoint4-extension-host.json')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(artifact);

  final digest = sha256.convert(utf8.encode(artifact)).toString();
  final overridesFiles = Directory('$root/tool/bindings/overrides')
      .listSync()
      .whereType<File>()
      .where(
        (file) => RegExp(r'vscode-\d+\.\d+\.\d+\.json$')
            .hasMatch(file.uri.pathSegments.last),
      )
      .toList()
    ..sort((left, right) => left.path.compareTo(right.path));
  if (overridesFiles.isEmpty) {
    throw StateError('Expected at least one Semantic Override file to repin.');
  }
  for (final overridesFile in overridesFiles) {
    final overridesText = overridesFile.readAsStringSync();
    final pinPattern = RegExp('"artifactSha256": "[0-9a-f]{64}"');
    if (pinPattern.allMatches(overridesText).length != 1) {
      throw StateError(
        'Expected exactly one artifactSha256 pin in the Semantic Overrides '
        '(${overridesFile.path}).',
      );
    }
    overridesFile.writeAsStringSync(
      overridesText.replaceFirst(pinPattern, '"artifactSha256": "$digest"'),
    );
  }
}

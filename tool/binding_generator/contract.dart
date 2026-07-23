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
  'bindingGenerator': 'tool/binding_generator/generator.dart',
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
  'fixtureHostPackageLock': 'test/fixtures/host_extension/host/pubspec.lock',
  'fixtureManifest': 'test/fixtures/host_extension/package.json',
  'fixtureProject': 'test/fixtures/host_extension/extension.json',
  'fixtureSharedContract':
      'test/fixtures/host_extension/shared/lib/fixture_view_contract.dart',
  'fixtureSharedPackage': 'test/fixtures/host_extension/shared/pubspec.yaml',
  'fixtureTransport':
      'test/fixtures/host_extension/host/lib/host_webview_transport.dart',
  'fixtureView': 'test/fixtures/host_extension/views/main/lib/main.dart',
  'fixtureViewIndex': 'test/fixtures/host_extension/views/main/web/index.html',
  'fixtureViewPackage': 'test/fixtures/host_extension/views/main/pubspec.yaml',
  'fixtureViewPackageLock':
      'test/fixtures/host_extension/views/main/pubspec.lock',
  'frameworkPackage': 'pubspec.yaml',
  'frameworkPackageLock': 'pubspec.lock',
  'generatedBootstrap': 'test/fixtures/host_extension/host/bootstrap.cjs',
  'generatedFacade':
      'test/fixtures/host_extension/host/lib/generated/vscode_facade.g.dart',
  'generatedHostExports':
      'test/fixtures/host_extension/host/lib/generated/host_exports.g.dart',
  'generatedParity':
      'test/fixtures/host_extension/host/lib/generated/vscode_parity.g.dart',
  'generatedRuntime':
      'test/fixtures/host_extension/host/lib/generated/vscode_runtime.g.dart',
  'generatedViewProtocol':
      'test/fixtures/host_extension/host/lib/generated/view_protocol.g.dart',
  'harnessPackage': 'tool/extension_host_test/package.json',
  'harnessPackageLock': 'tool/extension_host_test/package-lock.json',
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
  final nodeImage = RegExp(r'^FROM (\S+)$', multiLine: true)
      .firstMatch(container)!
      .group(1)!;

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
  final entries = (overrides['entries']! as Map<Object?, Object?>)
      .cast<String, Object?>();
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
          'Every listed generated binding ID was exercised by this one '
              'real Extension Host Contract after its receipted repository '
              'sources and surrounding native behavior passed.',
      'independentBehavioralContracts': false,
    },
    'attributedBindings': attributedBindings,
  };
  return '${const JsonEncoder.withIndent('  ').convert(artifact)}\n';
}

/// Writes the artifact and repins its hash inside the Semantic Overrides.
///
/// The overrides file is edited surgically so reviewed content and
/// formatting stay byte-identical outside the single artifactSha256 value.
void writeHostContractArtifact(Directory repositoryRoot) {
  final root = repositoryRoot.path;
  final artifact = buildHostContractArtifact(repositoryRoot);
  File('$root/tool/bindings/contracts/checkpoint4-extension-host.json')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(artifact);

  final overridesFile = File('$root/tool/bindings/overrides/vscode-1.129.1.json');
  final overridesText = overridesFile.readAsStringSync();
  final digest = sha256.convert(utf8.encode(artifact)).toString();
  final pinPattern = RegExp('"artifactSha256": "[0-9a-f]{64}"');
  if (pinPattern.allMatches(overridesText).length != 1) {
    throw StateError(
      'Expected exactly one artifactSha256 pin in the Semantic Overrides.',
    );
  }
  overridesFile.writeAsStringSync(
    overridesText.replaceFirst(pinPattern, '"artifactSha256": "$digest"'),
  );
}

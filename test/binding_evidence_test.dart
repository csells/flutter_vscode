import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';

import '../tool/binding_generator/contract.dart' as contract_writer;

const canonicalHostContractSourcePaths = <String, String>{
  'activationFailureTest':
      'test/fixtures/host_extension/test/activation_failure.cjs',
  'bindingCoverageLedger': 'tool/binding_generator/coverage_ledger.dart',
  'bindingGenerator': 'tool/binding_generator/generator.dart',
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
  'fixtureHostPackageLock': 'test/fixtures/host_extension/host/pubspec.lock',
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
  'fixtureViewPackageLock':
      'test/fixtures/host_extension/views/main/pubspec.lock',
  'flutterViewHostTemplate': 'lib/src/cli/flutter_view_host_source.dart',
  'frameworkPackage': 'pubspec.yaml',
  'frameworkPackageLock': 'pubspec.lock',
  'generatedBootstrap': 'test/fixtures/host_extension/host/bootstrap.cjs',
  'generatedFacade':
      'test/fixtures/host_extension/host/lib/generated/vscode_facade.g.dart',
  'generatedHostExports':
      'test/fixtures/host_extension/host/lib/generated/host_exports.g.dart',
  'generatedParity':
      'test/fixtures/host_extension/host/lib/generated/vscode_parity.g.dart',
  'generatedParityLayer':
      'test/fixtures/host_extension/host/lib/generated/vscode_parity_layer.g.dart',
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

void main() {
  test('the durable Host Contract artifact matches mechanical regeneration',
      () {
    final regenerated =
        contract_writer.buildHostContractArtifact(Directory.current);
    expect(
      File(
        'tool/bindings/contracts/checkpoint4-extension-host.json',
      ).readAsStringSync(),
      regenerated,
      reason: 'The artifact is written only by the mechanical regenerator. '
          'Refresh it with: '
          'dart tool/binding_generator/generate.dart --contract .',
    );
    expect(
      contract_writer.canonicalHostContractSourcePaths,
      canonicalHostContractSourcePaths,
      reason: 'The writer and the evidence suite must attest the same '
          'receipt closure.',
    );
    final overrides = _readJson('tool/bindings/overrides/vscode-1.129.1.json');
    final contract = (overrides['hostContracts']!
            as Map<Object?, Object?>)['checkpoint4ExtensionHost']!
        as Map<Object?, Object?>;
    expect(
      sha256.convert(utf8.encode(regenerated)).toString(),
      contract['artifactSha256'],
      reason: 'The overrides pin must match the regenerated artifact bytes.',
    );
  });

  test('the contract writer regenerates a copied tree byte-identically', () {
    final temporary = Directory.systemTemp.createTempSync(
      'flutter_vscode_contract_writer_',
    );
    addTearDown(() => temporary.deleteSync(recursive: true));
    const overridesPath = 'tool/bindings/overrides/vscode-1.129.1.json';
    const artifactPath = 'tool/bindings/contracts/checkpoint4-extension-host.json';
    for (final relative in [
      ...contract_writer.canonicalHostContractSourcePaths.values,
      overridesPath,
    ]) {
      final destination = File('${temporary.path}/$relative');
      destination.parent.createSync(recursive: true);
      File(relative).copySync(destination.path);
    }

    contract_writer.writeHostContractArtifact(temporary);

    final written = File('${temporary.path}/$artifactPath');
    expect(written.existsSync(), isTrue);
    expect(
      written.readAsStringSync(),
      contract_writer.buildHostContractArtifact(temporary),
      reason: 'the written artifact must equal mechanical regeneration',
    );
    final writtenOverrides =
        File('${temporary.path}/$overridesPath').readAsStringSync();
    expect(
      writtenOverrides,
      contains(sha256.convert(written.readAsBytesSync()).toString()),
      reason: 'the overrides pin must carry the written artifact digest',
    );
    expect(
      writtenOverrides.replaceFirst(
        RegExp('"artifactSha256": "[0-9a-f]{64}"'),
        '"artifactSha256": "PIN"',
      ),
      File(overridesPath).readAsStringSync().replaceFirst(
            RegExp('"artifactSha256": "[0-9a-f]{64}"'),
            '"artifactSha256": "PIN"',
          ),
      reason: 'the surgical pin update must change nothing else',
    );

    final artifactBytes = written.readAsBytesSync();
    contract_writer.writeHostContractArtifact(temporary);
    expect(
      written.readAsBytesSync(),
      artifactBytes,
      reason: 'a second write on a converged copy must be byte-identical',
    );
    expect(
      File('${temporary.path}/$overridesPath').readAsStringSync(),
      writtenOverrides,
      reason: 'a second write must not move the overrides pin',
    );
  });

  test('the contract writer refuses ambiguous overrides pins', () {
    final temporary = Directory.systemTemp.createTempSync(
      'flutter_vscode_contract_writer_pins_',
    );
    addTearDown(() => temporary.deleteSync(recursive: true));
    const overridesPath = 'tool/bindings/overrides/vscode-1.129.1.json';
    for (final relative in [
      ...contract_writer.canonicalHostContractSourcePaths.values,
      overridesPath,
    ]) {
      final destination = File('${temporary.path}/$relative');
      destination.parent.createSync(recursive: true);
      File(relative).copySync(destination.path);
    }
    final overridesFile = File('${temporary.path}/$overridesPath');
    final original = overridesFile.readAsStringSync();
    final decoded =
        (jsonDecode(original) as Map<Object?, Object?>).cast<String, Object?>();
    final contracts = (decoded['hostContracts']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    contracts['secondExtensionHost'] =
        jsonDecode(jsonEncode(contracts['checkpoint4ExtensionHost']));
    overridesFile.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(decoded)}\n',
    );
    expect(
      () => contract_writer.writeHostContractArtifact(temporary),
      throwsStateError,
      reason: 'more than one pin-shaped value must refuse the surgical edit',
    );

    overridesFile.writeAsStringSync(
      original.replaceFirst(
        RegExp('"artifactSha256": "[0-9a-f]{64}"'),
        '"artifactSha256": "not-a-digest"',
      ),
    );
    expect(
      () => contract_writer.writeHostContractArtifact(temporary),
      throwsStateError,
      reason: 'zero pin-shaped values must refuse the surgical edit',
    );
  });

  test('every emitted binding cites an executable real-host contract', () {
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final contracts = (overrides['hostContracts']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();

    expect(contracts, isNotEmpty);
    for (final contractEntry in contracts.entries) {
      final contract = (contractEntry.value! as Map<Object?, Object?>)
          .cast<String, Object?>();
      expect(contract['boundary'], 'vscodeExtensionHost');
      expect(
        contract.keys.toSet(),
        {'artifact', 'artifactSha256', 'boundary'},
        reason: contractEntry.key,
      );

      final artifact = File(contract['artifact']! as String);
      expect(artifact.existsSync(), isTrue, reason: contractEntry.key);
      expect(
        sha256.convert(artifact.readAsBytesSync()).toString(),
        contract['artifactSha256'],
        reason: contractEntry.key,
      );
      final artifactJson = _readJson(artifact.path);
      expect(artifactJson['schemaVersion'], 1);
      expect(artifactJson['id'], contractEntry.key);
      expect(artifactJson['boundary'], 'vscodeExtensionHost');
      expect(
        artifactJson['sourceRepository'],
        'https://github.com/SlowGen/flutter_vscode',
      );
      final inventory = _readJson(
        'tool/bindings/ir/vscode-1.129.1.json',
      );
      final inventoryProduct = ((inventory['source']!
              as Map<Object?, Object?>)['product']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      expect(artifactJson['apiTarget'], {
        'version': inventoryProduct['version'],
        'commit': inventoryProduct['commit'],
      });
      final fixtureManifest = _readJson(
        'test/fixtures/host_extension/package.json',
      );
      final fixtureEngines =
          (fixtureManifest['engines']! as Map<Object?, Object?>)
              .cast<String, Object?>();
      final harnessPackage = _readJson(
        'tool/extension_host_test/package.json',
      );
      final harnessDependencies =
          (harnessPackage['devDependencies']! as Map<Object?, Object?>)
              .cast<String, Object?>();
      final container = File(
        'tool/extension_host_test/Dockerfile',
      ).readAsStringSync();
      final nodeImage = RegExp(r'^FROM (\S+)$', multiLine: true)
          .firstMatch(container)!
          .group(1)!;
      expect(artifactJson['runtimeTarget'], {
        'vscodeVersion': fixtureEngines['vscode'],
        'testElectronVersion': harnessDependencies['@vscode/test-electron'],
        'nodeImage': nodeImage,
        'cachePolicy': 'freshInvocationScoped',
      });
      expect(artifactJson['trustBoundary'], {
        'dartToolchain':
            'The locally installed Flutter/Dart SDK and packages resolved '
                'from the enforced lockfile are trusted; this contract does '
                'not attest their bytes.',
        'vscodeRuntime':
            'Each gate resolves the exact official VS Code version into a '
                'new invocation-scoped cache; this contract does not attest '
                'a predeclared runtime binary digest.',
      });
      expect(fixtureEngines['vscode'], overrides['vscodeVersion']);
      final sources = (artifactJson['sources']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      expect(
        sources.keys.toSet(),
        canonicalHostContractSourcePaths.keys.toSet(),
      );
      for (final sourceEntry in sources.entries) {
        final source = (sourceEntry.value! as Map<Object?, Object?>)
            .cast<String, Object?>();
        expect(
          source['path'],
          canonicalHostContractSourcePaths[sourceEntry.key],
          reason: sourceEntry.key,
        );
        final sourceFile = File(source['path']! as String);
        expect(sourceFile.existsSync(), isTrue, reason: sourceEntry.key);
        expect(
          sha256.convert(sourceFile.readAsBytesSync()).toString(),
          source['sha256'],
          reason: sourceEntry.key,
        );
      }

      expect(artifactJson['evidence'], {
        'kind': 'mechanicalAttribution',
        'meaning':
            'Every listed generated binding ID was exercised by this one '
                'real Extension Host Contract after its receipted repository '
                'sources and surrounding native behavior passed.',
        'independentBehavioralContracts': false,
      });
      expect(artifactJson, isNot(contains('verifiedBindings')));
      final attributedBindings =
          (artifactJson['attributedBindings']! as List).cast<String>();
      final expectedBindings = <String>[
        for (final entry in entries.entries)
          if ((entry.value! as Map<Object?, Object?>)['strategy'] !=
              'reviewedExcluded')
            entry.key,
      ]..sort();
      expect(attributedBindings, orderedEquals(expectedBindings));
    }

    for (final entry in entries.entries) {
      final override =
          (entry.value! as Map<Object?, Object?>).cast<String, Object?>();
      expect(override, isNot(contains('hostVerified')), reason: entry.key);
      if (override['strategy'] == 'reviewedExcluded') {
        expect(override, isNot(contains('hostContract')), reason: entry.key);
      } else {
        final contract = override['hostContract'];
        expect(contract, isA<String>(), reason: entry.key);
        expect(contracts, contains(contract), reason: entry.key);
      }
    }
  });

  test('generated operations own binding observations, not the host test', () {
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final expectedIds = <String>{
      for (final entry in entries.entries)
        if ((entry.value! as Map<Object?, Object?>)['strategy'] !=
            'reviewedExcluded')
          entry.key,
    };

    final hostTest = File(
      'test/fixtures/host_extension/test/run.cjs',
    ).readAsStringSync();
    expect(hostTest, isNot(contains('observeBindings')));
    expect(hostTest, isNot(contains('observedBindingIds')));
    expect(hostTest, isNot(contains('FLUTTER_VSCODE_HOST_EVIDENCE_PATH')));
    expect(
      hostTest,
      isNot(matches(RegExp('(class|interface|method):vscode'))),
    );
    final authorHostFiles = Directory(
      'test/fixtures/host_extension/host/lib',
    ).listSync(recursive: true).whereType<File>().where(
          (file) =>
              file.path.endsWith('.dart') &&
              !file.path.contains('${Platform.pathSeparator}generated'),
        );
    for (final file in authorHostFiles) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('observeHostBinding')), reason: file.path);
      expect(
        source,
        isNot(matches(RegExp('(class|interface|method):vscode'))),
        reason: file.path,
      );
    }

    final facade = File(
      'test/fixtures/host_extension/host/lib/generated/vscode_facade.g.dart',
    ).readAsStringSync();
    final declarations = RegExp(
      r"const (_binding\w+) = (?:r)?'([^']+)';",
    ).allMatches(facade).toList();
    expect(
      declarations.map((match) => match.group(2)).toSet(),
      expectedIds,
    );
    expect(declarations, hasLength(expectedIds.length));
    for (final declaration in declarations) {
      final name = declaration.group(1)!;
      expect(
        RegExp('\\b${RegExp.escape(name)}\\b').allMatches(facade),
        hasLength(greaterThan(1)),
        reason: '$name must be reached by a generated operation',
      );
    }

    final runtime = File(
      'test/fixtures/host_extension/host/lib/generated/vscode_runtime.g.dart',
    ).readAsStringSync();
    expect(runtime, contains('void observeHostBindings'));
    expect(runtime, contains('JSFunction observeHostCallback'));

    final bootstrap = File(
      'test/fixtures/host_extension/host/bootstrap.cjs',
    ).readAsStringSync();
    expect(bootstrap, contains('namespace.bindingObservers[extensionKey]'));
    expect(bootstrap, contains("process.once('exit'"));
    expect(bootstrap, contains('observedBindingIds:'));
  });
}

Map<String, Object?> _readJson(String path) =>
    (jsonDecode(File(path).readAsStringSync()) as Map<Object?, Object?>)
        .cast<String, Object?>();

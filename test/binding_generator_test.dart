import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../tool/binding_generator/generator.dart';

void main() {
  test('rejects an unsupported inventory schema version', () {
    final inventory = _inventory(['interface:vscode.Known'])
      ..['schemaVersion'] = 999;

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: _overrides({
          'interface:vscode.Known': 'opaqueJsObject',
        }),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'UNSUPPORTED_INPUT_SCHEMA_VERSION',
            )
            .having(
              (error) => error.message,
              'message',
              contains('inventory.schemaVersion'),
            ),
      ),
    );
  });

  test('rejects an unsupported Semantic Override schema version', () {
    final overrides = _overrides({
      'interface:vscode.Known': 'opaqueJsObject',
    })
      ..['schemaVersion'] = 999;

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'UNSUPPORTED_INPUT_SCHEMA_VERSION',
            )
            .having(
              (error) => error.message,
              'message',
              contains('overrides.schemaVersion'),
            ),
      ),
    );
  });

  test('rejects a Semantic Override for an unknown IR entry', () {
    final generator = VSCodeBindingGenerator();

    expect(
      () => generator.generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides({
          'interface:vscode.Missing': 'opaqueJsObject',
        }),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'UNKNOWN_OVERRIDE_ID',
            )
            .having(
              (error) => error.message,
              'message',
              contains('interface:vscode.Missing'),
            ),
      ),
    );
  });

  test('rejects an unrecognized Semantic Override strategy', () {
    final generator = VSCodeBindingGenerator();

    expect(
      () => generator.generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides({
          'interface:vscode.Known': 'handwrittenDartSnippet',
        }),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'UNKNOWN_OVERRIDE_STRATEGY',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('interface:vscode.Known'),
                contains('handwrittenDartSnippet'),
              ),
            ),
      ),
    );
  });

  test('rejects Semantic Overrides for a different VS Code pin', () {
    final generator = VSCodeBindingGenerator();

    expect(
      () => generator.generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides(
          {'interface:vscode.Known': 'opaqueJsObject'},
          vscodeVersion: '1.128.0',
        ),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'OVERRIDE_VERSION_MISMATCH',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(contains('1.128.0'), contains('1.129.1')),
            ),
      ),
    );
  });

  test('rejects Semantic Overrides for a different manifest schema pin', () {
    final generator = VSCodeBindingGenerator();

    expect(
      () => generator.generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides(
          {'interface:vscode.Known': 'opaqueJsObject'},
          manifestSchemaSha256: 'changed-manifest-schema',
        ),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'MANIFEST_SCHEMA_PIN_MISMATCH',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('changed-manifest-schema'),
                contains(
                  'feddc98984b755a95644674910aa8c671e3259f137698c581ec7e2837cb058aa',
                ),
              ),
            ),
      ),
    );
  });

  test('rejects Semantic Overrides for a different manifest validator pin', () {
    final generator = VSCodeBindingGenerator();

    expect(
      () => generator.generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides(
          {'interface:vscode.Known': 'opaqueJsObject'},
          manifestValidatorSha256: 'changed-manifest-validator',
        ),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'MANIFEST_VALIDATOR_PIN_MISMATCH',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('changed-manifest-validator'),
                contains(
                  'e8ae92aa491ab138b6f625acbbcbd7c53ff187098066ff13aebb64615202dde1',
                ),
              ),
            ),
      ),
    );
  });

  test('rejects unknown project descriptor fields', () {
    final project = _project()..['contributes'] = <String, Object?>{};

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides({
          'interface:vscode.Known': 'opaqueJsObject',
        }),
        project: project,
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'INVALID_PROJECT_DESCRIPTOR',
            )
            .having(
              (error) => error.message,
              'message',
              contains('contributes'),
            ),
      ),
    );
  });

  test('rejects an unsupported project descriptor schema version', () {
    final project = _project()..['schemaVersion'] = 999;

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides({
          'interface:vscode.Known': 'opaqueJsObject',
        }),
        project: project,
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'INVALID_PROJECT_DESCRIPTOR',
            )
            .having(
              (error) => error.message,
              'message',
              contains('schemaVersion'),
            ),
      ),
    );
  });

  test('rejects a manifest version that is not strict SemVer', () {
    final project = _project()..['version'] = '01.02.03';

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides({
          'interface:vscode.Known': 'opaqueJsObject',
        }),
        project: project,
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'INVALID_PROJECT_MANIFEST',
            )
            .having(
              (error) => error.message,
              'message',
              contains('project.version'),
            ),
      ),
    );
  });

  test('rejects a Semantic Override that is outside the selected closure', () {
    final generator = VSCodeBindingGenerator();

    expect(
      () => generator.generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides(
          {'interface:vscode.Known': 'opaqueJsObject'},
          targets: const [],
        ),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'UNUSED_OVERRIDE',
            )
            .having(
              (error) => error.message,
              'message',
              contains('interface:vscode.Known'),
            ),
      ),
    );
  });

  test('rejects an unclassified entry inside the selected closure', () {
    final generator = VSCodeBindingGenerator();

    expect(
      () => generator.generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides(
          const {},
          targets: const ['interface:vscode.Known'],
        ),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'MISSING_OVERRIDE',
            )
            .having(
              (error) => error.message,
              'message',
              contains('interface:vscode.Known'),
            ),
      ),
    );
  });

  test('rejects duplicate targets instead of silently collapsing them', () {
    final generator = VSCodeBindingGenerator();

    expect(
      () => generator.generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides(
          {'interface:vscode.Known': 'opaqueJsObject'},
          targets: const [
            'interface:vscode.Known',
            'interface:vscode.Known',
          ],
        ),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'DUPLICATE_TARGET_ID',
            )
            .having(
              (error) => error.message,
              'message',
              contains('interface:vscode.Known'),
            ),
      ),
    );
  });

  test('emits a deterministic native JS type from an opaque entry', () {
    final generator = VSCodeBindingGenerator();
    final generated = generator.generate(
      inventory: _inventory(['interface:vscode.Known']),
      overrides: _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      }),
      project: _project(),
    );

    expect(
      generated.files['host/lib/generated/vscode_parity.g.dart'],
      '''
// GENERATED CODE - DO NOT MODIFY BY HAND.
// VS Code 1.129.1 API parity slice.

import 'dart:js_interop';

/// Native VS Code `Known` host object.
extension type Known.fromJS(JSObject _) implements JSObject {}
''',
    );
  });

  test('emits a complete manifest from project data and the pinned engine', () {
    final generated = VSCodeBindingGenerator().generate(
      inventory: _inventory(['interface:vscode.Known']),
      overrides: _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      }),
      project: _project(),
    );

    expect(
      generated.files['package.json'],
      '''
{
  "name": "fixture",
  "displayName": "Fixture",
  "description": "Fixture.",
  "version": "0.0.0",
  "publisher": "test",
  "engines": {
    "vscode": "1.129.1"
  },
  "main": "./out/bootstrap.cjs",
  "activationEvents": []
}
''',
    );
  });

  test('uses one extension identity hash in Dart exports and bootstrap', () {
    final generated = VSCodeBindingGenerator().generate(
      inventory: _inventory(['interface:vscode.Known']),
      overrides: _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      }),
      project: _project(),
    );
    const key =
        'e_f4529a9f7129de4b2f063d5b0c34ffb960319d0e59975008828117c7271de9c4';

    expect(
      generated.files['host/lib/generated/host_exports.g.dart'],
      allOf(contains('__flutterVscode.hosts.$key'), contains(key)),
    );
    expect(
      generated.files['host/bootstrap.cjs'],
      allOf(
        contains("const emittedExtensionKey = '$key';"),
        contains(".createHash('sha256')"),
        contains('extensionKey !== emittedExtensionKey'),
      ),
    );
  });

  test('emits the reviewed walking slice and an honest coverage ledger', () {
    final inventory = _readJson(
      'tool/bindings/ir/vscode-1.129.1.json',
    );
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final project = _readJson(
      'test/fixtures/host_extension/extension.json',
    );
    final generator = VSCodeBindingGenerator();

    final first = generator.generate(
      inventory: inventory,
      overrides: overrides,
      project: project,
    );
    final second = generator.generate(
      inventory: inventory,
      overrides: overrides,
      project: project,
    );

    expect(first.files, second.files);
    expect(
      first.files.keys,
      containsAll({
        'host/lib/generated/host_exports.g.dart',
        'host/lib/generated/vscode_facade.g.dart',
        'host/lib/generated/vscode_parity.g.dart',
        'host/lib/generated/vscode_runtime.g.dart',
        'host/bootstrap.cjs',
        'package.json',
        'coverage.json',
      }),
    );
    final parity = first.files['host/lib/generated/vscode_parity.g.dart']!;
    expect(parity, contains('extension type TextDocument'));
    expect(parity, contains('extension type Position'));
    expect(parity, contains('extension type CancellationToken'));
    expect(parity, contains('extension type Thenable'));
    expect(parity, contains('extension type Event'));
    final facade = first.files['host/lib/generated/vscode_facade.g.dart']!;
    expect(facade, contains('registerCommand'));
    expect(facade, contains('executeCommand'));
    expect(facade, contains('registerHoverProvider'));
    expect(facade, contains('onDidOpenTextDocument'));
    final runtime = first.files['host/lib/generated/vscode_runtime.g.dart']!;
    expect(runtime, contains('toHostPromise'));
    expect(runtime, contains('JavaScriptError'));

    for (final entry in first.files.entries.where(
      (entry) => entry.key.endsWith('.dart'),
    )) {
      expect(entry.value, isNot(contains('dynamic')), reason: entry.key);
      expect(entry.value, isNot(contains('dart:js_util')), reason: entry.key);
      expect(
        entry.value,
        isNot(contains('dart:js_interop_unsafe')),
        reason: entry.key,
      );
    }

    final coverage =
        (jsonDecode(first.files['coverage.json']!) as Map<Object?, Object?>)
            .cast<String, Object?>();
    expect(coverage['source'], {
      'vscodeVersion': '1.129.1',
      'inputSha256':
          'ee11e767c8ab76f6c0de8dc88222796147a6f0bc82f3a1ec644e41b39b52f2cd',
      'manifestSchemaSha256':
          'feddc98984b755a95644674910aa8c671e3259f137698c581ec7e2837cb058aa',
      'manifestValidatorSha256':
          'e8ae92aa491ab138b6f625acbbcbd7c53ff187098066ff13aebb64615202dde1',
    });
    expect(coverage['scope'], {
      'name': 'checkpoint2WalkingSlice',
      'fullApiParity': false,
      'selectedTargets': 37,
      'implementedTargets': 32,
      'reviewedExcludedTargets': 5,
    });
    expect(coverage['inventory'], {
      'logicalEntries': 2979,
      'sourceOccurrences': 2982,
      'publicLogicalEntries': 2969,
      'nonPublicLogicalEntries': 10,
    });
    expect(coverage['summary'], {
      'discovered': 2979,
      'semanticsReviewed': 32,
      'semanticsExcluded': 15,
      'semanticsPending': 2932,
      'bindingsEmitted': 32,
      'bindingsExcluded': 15,
      'bindingsPending': 2932,
      'hostVerified': 32,
      'hostNotApplicable': 15,
      'hostPending': 2932,
    });
    final ledgerEntries =
        (coverage['entries']! as List<Object?>).cast<Map<Object?, Object?>>();
    expect(ledgerEntries, hasLength(2979));
    expect(
      ledgerEntries.map((entry) => entry['id']).toList(),
      orderedEquals(
        ledgerEntries.map((entry) => entry['id']).toList()..sort(),
      ),
    );
    expect(
      ledgerEntries.singleWhere(
        (entry) => entry['id'] == 'class:vscode.Hover',
      ),
      containsPair('selected', true),
    );
    expect(
      ledgerEntries.singleWhere(
        (entry) => entry['id'] == 'class:vscode.Hover',
      )['host'],
      {'status': 'verified', 'contract': 'checkpoint1ExtensionHost'},
    );
  });

  test('rejects a walking-slice strategy assigned to the wrong IR entry', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final commandExecutionId = _entryIdForStrategy(
      entries,
      'commandExecution',
    );
    final commandRegistrationId = _entryIdForStrategy(
      entries,
      'commandRegistration',
    );
    final commandExecution =
        (entries[commandExecutionId]! as Map<Object?, Object?>)
            .cast<String, Object?>();
    final commandRegistration =
        (entries[commandRegistrationId]! as Map<Object?, Object?>)
            .cast<String, Object?>();
    commandExecution['strategy'] = 'commandRegistration';
    commandRegistration['strategy'] = 'commandExecution';

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _readJson('test/fixtures/host_extension/extension.json'),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'WALKING_SLICE_PROFILE_MISMATCH',
            )
            .having(
              (error) => error.message,
              'message',
              contains(commandExecutionId),
            ),
      ),
    );
  });

  test('rejects a selected declaration whose reviewed shape changed', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final lineProperty = declarations.singleWhere(
      (entry) =>
          entry['id'] == r'property:class:vscode.Position/$instance/line',
    );
    final type = (lineProperty['type']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    type['name'] = 'string';

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: _readJson(
          'tool/bindings/overrides/vscode-1.129.1.json',
        ),
        project: _readJson('test/fixtures/host_extension/extension.json'),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'STALE_SEMANTIC_OVERRIDE',
            )
            .having(
              (error) => error.message,
              'message',
              contains(r'property:class:vscode.Position/$instance/line'),
            ),
      ),
    );
  });
}

String _entryIdForStrategy(Map<String, Object?> entries, String strategy) {
  return entries.entries.singleWhere((entry) {
    final value =
        (entry.value! as Map<Object?, Object?>).cast<String, Object?>();
    return value['strategy'] == strategy;
  }).key;
}

Map<String, Object?> _inventory(List<String> ids) {
  return {
    'schemaVersion': 1,
    'source': {
      'product': {'version': '1.129.1'},
      'inputSha256':
          'ee11e767c8ab76f6c0de8dc88222796147a6f0bc82f3a1ec644e41b39b52f2cd',
    },
    'manifestSchema': {
      'inputSha256':
          'feddc98984b755a95644674910aa8c671e3259f137698c581ec7e2837cb058aa',
      'schemaUri': 'vscode://schemas/vscode-extensions',
      'standalone': false,
      'properties': {
        'activationEvents': {
          'type': 'array',
          'items': {'type': 'string'},
        },
        'contributes': {'type': 'object'},
        'displayName': {'type': 'string'},
        'engines': {
          'type': 'object',
          'properties': {
            'vscode': {'type': 'string'},
          },
        },
        'publisher': {'type': 'string'},
      },
    },
    'manifestValidator': {
      'inputSha256':
          'e8ae92aa491ab138b6f625acbbcbd7c53ff187098066ff13aebb64615202dde1',
    },
    'declarations': [for (final id in ids) _testDeclaration(id)],
  };
}

Map<String, Object?> _overrides(
  Map<String, String> strategies, {
  String vscodeVersion = '1.129.1',
  String manifestSchemaSha256 =
      'feddc98984b755a95644674910aa8c671e3259f137698c581ec7e2837cb058aa',
  String manifestValidatorSha256 =
      'e8ae92aa491ab138b6f625acbbcbd7c53ff187098066ff13aebb64615202dde1',
  List<String>? targets,
}) {
  return {
    'schemaVersion': 1,
    'vscodeVersion': vscodeVersion,
    'manifestSchemaSha256': manifestSchemaSha256,
    'manifestValidatorSha256': manifestValidatorSha256,
    'targets': targets ?? strategies.keys.toList(),
    'entries': {
      for (final entry in strategies.entries)
        entry.key: {
          'strategy': entry.value,
          'declarationSha256': computeDeclarationFingerprint(
            _testDeclaration(entry.key),
          ),
          'hostVerified': entry.value != 'reviewedExcluded',
        },
    },
  };
}

Map<String, Object?> _testDeclaration(String id) {
  return {
    'id': id,
    'kind': 'interface',
    'name': id.substring(id.lastIndexOf('.') + 1),
  };
}

Map<String, Object?> _project() {
  return {
    'schemaVersion': 1,
    'name': 'fixture',
    'displayName': 'Fixture',
    'description': 'Fixture.',
    'version': '0.0.0',
    'publisher': 'test',
    'activationEvents': <Object?>[],
  };
}

Map<String, Object?> _readJson(String path) {
  return (jsonDecode(File(path).readAsStringSync()) as Map<Object?, Object?>)
      .cast<String, Object?>();
}

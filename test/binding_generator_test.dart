import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
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

  test('rejects unknown top-level Semantic Override fields', () {
    final overrides = _overrides({
      'interface:vscode.Known': 'opaqueJsObject',
    })
      ..['unknownPolicy'] = <Object?>[];

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('top-level'), contains('unknownPolicy')),
            ),
      ),
    );
  });

  test('rejects unknown top-level inventory fields', () {
    final inventory = _inventory(['interface:vscode.Known'])
      ..['futureSemantic'] = true;

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(contains('inventory'), contains('futureSemantic')),
            ),
      ),
    );
  });

  test('rejects unknown source identity fields', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final source =
        (inventory['source']! as Map<Object?, Object?>).cast<String, Object?>();
    source['futureSemantic'] = true;

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(contains('inventory.source'), contains('futureSemantic')),
            ),
      ),
    );
  });

  test('accepts optional reviewed removal metadata', () {
    final overrides = _overrides({
      'interface:vscode.Known': 'opaqueJsObject',
    })
      ..['removals'] = {
        'interface:vscode.Removed': {
          'strategy': 'reviewedRemoval',
          'declarationSha256': '0' * 64,
          'reason': 'The upstream stable API removed this declaration.',
        },
      };

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: overrides,
        project: _project(),
      ),
      returnsNormally,
    );
  });

  test('accepts a reviewed removal when the candidate is private', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<String, Object?>>();
    final privateId = declarations.firstWhere(
      (declaration) => declaration['visibility'] == 'private',
    )['id']! as String;
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    )..['removals'] = {
        privateId: {
          'strategy': 'reviewedRemoval',
          'declarationSha256': '0' * 64,
          'reason': 'The declaration is not part of the public inventory.',
        },
      };

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _readJson('test/fixtures/host_extension/extension.json'),
      ),
      returnsNormally,
    );
  });

  test('rejects malformed or stale reviewed removal metadata', () {
    final malformedRemovals = <String, Object?>{
      'non-object removals': <Object?>[],
      'extra entry field': {
        'interface:vscode.Removed': {
          'strategy': 'reviewedRemoval',
          'declarationSha256': '0' * 64,
          'reason': 'Removed upstream.',
          'reviewer': 'not pinned',
        },
      },
      'wrong strategy': {
        'interface:vscode.Removed': {
          'strategy': 'reviewedExcluded',
          'declarationSha256': '0' * 64,
          'reason': 'Removed upstream.',
        },
      },
      'malformed fingerprint': {
        'interface:vscode.Removed': {
          'strategy': 'reviewedRemoval',
          'declarationSha256': 'not-a-sha',
          'reason': 'Removed upstream.',
        },
      },
      'empty reason': {
        'interface:vscode.Removed': {
          'strategy': 'reviewedRemoval',
          'declarationSha256': '0' * 64,
          'reason': '   ',
        },
      },
      'declaration still present': {
        'interface:vscode.Known': {
          'strategy': 'reviewedRemoval',
          'declarationSha256': computeDeclarationFingerprint(
            _testDeclaration('interface:vscode.Known'),
          ),
          'reason': 'Not actually removed.',
        },
      },
    };

    for (final malformed in malformedRemovals.entries) {
      final overrides = _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      })
        ..['removals'] = malformed.value;

      expect(
        () => VSCodeBindingGenerator().generate(
          inventory: _inventory(['interface:vscode.Known']),
          overrides: overrides,
          project: _project(),
        ),
        throwsA(
          isA<VSCodeBindingGenerationException>()
              .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
              .having(
                (error) => error.message,
                'message',
                contains('removal'),
              ),
        ),
        reason: malformed.key,
      );
    }
  });

  test('uses ECMAScript trim semantics for reviewed removal reasons', () {
    Map<String, Object?> removalOverrides(String reason) {
      return _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      })
        ..['removals'] = {
          'interface:vscode.Removed': {
            'strategy': 'reviewedRemoval',
            'declarationSha256': '0' * 64,
            'reason': reason,
          },
        };
    }

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: removalOverrides('\u0085'),
        project: _project(),
      ),
      returnsNormally,
      reason: 'ECMAScript trim preserves U+0085.',
    );
    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: removalOverrides('\uFEFF'),
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
            .having(
              (error) => error.message,
              'message',
              contains('non-empty reason'),
            ),
      ),
      reason: 'ECMAScript trim removes U+FEFF.',
    );
  });

  test('rejects a private declaration as a binding target', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final privateDeclaration = declarations.firstWhere(
      (declaration) => declaration['visibility'] == 'private',
    );
    final privateId = privateDeclaration['id']! as String;
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    (overrides['targets']! as List<Object?>).add(privateId);
    (overrides['entries']! as Map<Object?, Object?>)[privateId] = {
      'strategy': 'reviewedExcluded',
      'declarationSha256': computeDeclarationFingerprint(
        privateDeclaration.cast<String, Object?>(),
      ),
      'reason': 'A private declaration cannot be selected.',
    };

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _readJson('test/fixtures/host_extension/extension.json'),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'UNKNOWN_TARGET_ID')
            .having(
              (error) => error.message,
              'message',
              contains('public'),
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

  test('rejects an emitted binding without an executable Host Contract', () {
    final overrides = _overrides({
      'interface:vscode.Known': 'opaqueJsObject',
    });
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    (entries['interface:vscode.Known']! as Map<Object?, Object?>)
        .cast<String, Object?>()
        .remove('hostContract');

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('interface:vscode.Known'),
                contains('Host Contract'),
              ),
            ),
      ),
    );
  });

  test('rejects extra fields on emitted and excluded override entries', () {
    final malformedEntries = <String, Map<String, Object?>>{
      'emitted': {
        'strategy': 'opaqueJsObject',
        'declarationSha256': computeDeclarationFingerprint(
          _testDeclaration('interface:vscode.Known'),
        ),
        'hostContract': 'testExtensionHost',
        'reason': 'must not coexist with an emitted binding',
      },
      'excluded': {
        'strategy': 'reviewedExcluded',
        'declarationSha256': computeDeclarationFingerprint(
          _testDeclaration('interface:vscode.Known'),
        ),
        'reason': 'outside the supported projection',
        'reviewer': 'extra metadata is not pinned',
      },
    };

    for (final malformed in malformedEntries.entries) {
      final overrides = _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      });
      final entries = (overrides['entries']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      (entries['interface:vscode.Known']! as Map<Object?, Object?>)
          .cast<String, Object?>()
        ..clear()
        ..addAll(malformed.value);

      expect(
        () => VSCodeBindingGenerator().generate(
          inventory: _inventory(['interface:vscode.Known']),
          overrides: overrides,
          project: _project(),
        ),
        throwsA(
          isA<VSCodeBindingGenerationException>()
              .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
              .having(
                (error) => error.message,
                'message',
                allOf(
                  contains('interface:vscode.Known'),
                  contains('exactly'),
                ),
              ),
        ),
        reason: malformed.key,
      );
    }
  });

  test('rejects a whitespace-only reviewed exclusion reason', () {
    final overrides = _overrides({
      'interface:vscode.Known': 'reviewedExcluded',
    });
    final entry = ((overrides['entries']!
                as Map<Object?, Object?>)['interface:vscode.Known']!
            as Map<Object?, Object?>)
        .cast<String, Object?>();
    entry['reason'] = '   ';

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
            .having(
              (error) => error.message,
              'message',
              contains('non-empty reason'),
            ),
      ),
    );
  });

  test('accepts the exact durable Host Contract schema', () {
    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides({
          'interface:vscode.Known': 'opaqueJsObject',
        }),
        project: _project(),
      ),
      returnsNormally,
    );
  });

  test('rejects a well-formed Host Contract that no binding cites', () {
    final overrides = _overrides({
      'interface:vscode.Known': 'opaqueJsObject',
    });
    final contracts = (overrides['hostContracts']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    contracts['unusedContract'] = {
      'boundary': 'vscodeExtensionHost',
      'artifact': 'tool/bindings/contracts/unused-contract.json',
      'artifactSha256': '0' * 64,
    };

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('unusedContract'), contains('not cited')),
            ),
      ),
    );
  });

  test('rejects Host Contract IDs that are not lower camel case', () {
    final overrides = _readJson('tool/bindings/overrides/vscode-1.129.1.json');
    final contracts = (overrides['hostContracts']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    contracts['Checkpoint4ExtensionHost'] =
        contracts.remove('checkpoint4ExtensionHost');
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    for (final entry in entries.values) {
      final override =
          (entry! as Map<Object?, Object?>).cast<String, Object?>();
      if (override['hostContract'] == 'checkpoint4ExtensionHost') {
        override['hostContract'] = 'Checkpoint4ExtensionHost';
      }
    }

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _readJson('tool/bindings/ir/vscode-1.129.1.json'),
        overrides: overrides,
        project: _readJson('test/fixtures/host_extension/extension.json'),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
            .having(
              (error) => error.message,
              'message',
              contains('must be lower camel case'),
            ),
      ),
    );
  });

  test('rejects Semantic Overrides with an emptied Host Contract map', () {
    final overrides = _readJson('tool/bindings/overrides/vscode-1.129.1.json');
    (overrides['hostContracts']! as Map<Object?, Object?>).clear();

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _readJson('tool/bindings/ir/vscode-1.129.1.json'),
        overrides: overrides,
        project: _readJson('test/fixtures/host_extension/extension.json'),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
            .having(
              (error) => error.message,
              'message',
              contains('at least one executable Host Contract'),
            ),
      ),
    );
  });

  test('rejects Host Contracts outside the durable artifact schema', () {
    final malformedContracts = <String, Map<String, Object?>>{
      'artifact outside tool/bindings/contracts': {
        'boundary': 'vscodeExtensionHost',
        'artifact': 'docs/test-extension-host.json',
        'artifactSha256': '0' * 64,
      },
      'non-canonical artifact filename': {
        'boundary': 'vscodeExtensionHost',
        'artifact': 'tool/bindings/contracts/test extension host.json',
        'artifactSha256': '0' * 64,
      },
      'malformed artifact checksum': {
        'boundary': 'vscodeExtensionHost',
        'artifact': 'tool/bindings/contracts/test-extension-host.json',
        'artifactSha256': 'A' * 64,
      },
      'extra unpinned field': {
        'boundary': 'vscodeExtensionHost',
        'artifact': 'tool/bindings/contracts/test-extension-host.json',
        'artifactSha256': '0' * 64,
        'runner': 'scripts/test_host_extension.sh',
      },
    };

    for (final malformed in malformedContracts.entries) {
      final overrides = _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      });
      final contracts = (overrides['hostContracts']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      (contracts['testExtensionHost']! as Map<Object?, Object?>)
          .cast<String, Object?>()
        ..clear()
        ..addAll(malformed.value);

      expect(
        () => VSCodeBindingGenerator().generate(
          inventory: _inventory(['interface:vscode.Known']),
          overrides: overrides,
          project: _project(),
        ),
        throwsA(
          isA<VSCodeBindingGenerationException>()
              .having((error) => error.code, 'code', 'INVALID_OVERRIDE')
              .having(
                (error) => error.message,
                'message',
                contains('Host Contract'),
              ),
        ),
        reason: malformed.key,
      );
    }
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
          manifestSchemaSha256: '0' * 64,
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
                contains('0' * 64),
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
          manifestValidatorSha256: '0' * 64,
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
                contains('0' * 64),
                contains(
                  'e8ae92aa491ab138b6f625acbbcbd7c53ff187098066ff13aebb64615202dde1',
                ),
              ),
            ),
      ),
    );
  });

  test('rejects malformed matching root evidence digests', () {
    const cases = [
      (
        overrideField: 'manifestSchemaSha256',
        inventoryPath: 'inventory.manifestSchema.inputSha256',
      ),
      (
        overrideField: 'manifestValidatorSha256',
        inventoryPath: 'inventory.manifestValidator.inputSha256',
      ),
      (
        overrideField: 'commandsContributionSchemaSha256',
        inventoryPath: 'inventory.contributionSchemas.commands.inputSha256',
      ),
    ];

    for (final testCase in cases) {
      final inventory = _inventory(['interface:vscode.Known']);
      switch (testCase.overrideField) {
        case 'manifestSchemaSha256':
          (inventory['manifestSchema']!
              as Map<Object?, Object?>)['inputSha256'] = 'x';
        case 'manifestValidatorSha256':
          (inventory['manifestValidator']!
              as Map<Object?, Object?>)['inputSha256'] = 'x';
        case 'commandsContributionSchemaSha256':
          final contributionSchemas =
              inventory['contributionSchemas']! as Map<Object?, Object?>;
          (contributionSchemas['commands']!
              as Map<Object?, Object?>)['inputSha256'] = 'x';
      }
      final overrides = _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      })
        ..[testCase.overrideField] = 'x';

      expect(
        () => VSCodeBindingGenerator().generate(
          inventory: inventory,
          overrides: overrides,
          project: _project(),
        ),
        throwsA(
          isA<VSCodeBindingGenerationException>()
              .having(
                (error) => error.code,
                'code',
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                allOf(
                  contains(testCase.inventoryPath),
                  contains('lowercase SHA-256'),
                ),
              ),
        ),
        reason: testCase.overrideField,
      );
    }
  });

  test('rejects malformed override and primary input digests', () {
    final malformedOverride = _overrides({
      'interface:vscode.Known': 'opaqueJsObject',
    })
      ..['manifestSchemaSha256'] = 'x';
    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: malformedOverride,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('overrides.manifestSchemaSha256'),
                contains('lowercase SHA-256'),
              ),
            ),
      ),
    );

    final malformedInventory = _inventory(['interface:vscode.Known']);
    final source = (malformedInventory['source']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    source['inputSha256'] = 'x';
    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: malformedInventory,
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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('inventory.source.inputSha256'),
                contains('lowercase SHA-256'),
              ),
            ),
      ),
    );
  });

  test('rejects missing command validator semantics in the inventory', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final schemas = (inventory['contributionSchemas']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    (schemas['commands']! as Map<Object?, Object?>)
        .cast<String, Object?>()
        .remove('validation');

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(contains('Commands'), contains('unprojected change')),
            ),
      ),
    );
  });

  test('reports the first command schema drift path and remediation', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final schemas = (inventory['contributionSchemas']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final commands =
        (schemas['commands']! as Map<Object?, Object?>).cast<String, Object?>();
    final validation = (commands['validation']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final icon =
        (validation['icon']! as Map<Object?, Object?>).cast<String, Object?>();
    (icon['objectRequiredStringProperties']! as List<Object?>).removeLast();

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains(
                  'First differing path: '
                  'inventory.contributionSchemas.commands.validation.icon.'
                  'objectRequiredStringProperties[1]',
                ),
                contains('Regenerate the IR'),
                contains('update the generator projection'),
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

  test('rejects a Project API Target that differs from the inventory', () {
    final project = _project()..['apiTarget'] = '1.130.0';

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
              'PROJECT_API_TARGET_MISMATCH',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('project.apiTarget 1.130.0'),
                contains('inventory targets 1.129.1'),
                contains('matching pinned inventory'),
              ),
            ),
      ),
    );
  });

  test('requires an explicit Project API Target', () {
    final project = _project()..remove('apiTarget');

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
              allOf(
                contains('project.apiTarget is required'),
                contains('exact pinned VS Code version'),
              ),
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

  test('emits command contributions from Dart-owned project data', () {
    final project = _readJson(
      'test/fixtures/host_extension/extension.json',
    )..['commands'] = <Object?>[
        <String, Object?>{
          'command': 'flutter-vscode.host-test.ping',
          'title': 'Ping Dart Host',
        },
      ];

    final generated = VSCodeBindingGenerator().generate(
      inventory: _readJson('tool/bindings/ir/vscode-1.129.1.json'),
      overrides: _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      ),
      project: project,
    );

    final manifest =
        (jsonDecode(generated.files['package.json']!) as Map<Object?, Object?>)
            .cast<String, Object?>();
    expect(manifest['contributes'], {
      'commands': [
        {
          'command': 'flutter-vscode.host-test.ping',
          'title': 'Ping Dart Host',
        },
      ],
    });
  });

  test('rejects whitespace-only required command contribution strings', () {
    for (final field in ['command', 'title']) {
      final project = _project()
        ..['commands'] = <Object?>[
          <String, Object?>{
            'command': 'test.fixture.ping',
            'title': 'Ping Dart Host',
            field: ' \t\n',
          },
        ];

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
                allOf(contains(field), contains('whitespace')),
              ),
        ),
        reason: field,
      );
    }
  });

  test('uses the projected ECMAScript trim predicate for required strings', () {
    final accepted = _project()
      ..['commands'] = <Object?>[
        <String, Object?>{
          'command': 'test.fixture.ping',
          'title': '\u0085',
        },
      ];

    final generated = VSCodeBindingGenerator().generate(
      inventory: _inventory(['interface:vscode.Known']),
      overrides: _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      }),
      project: accepted,
    );
    final manifest =
        (jsonDecode(generated.files['package.json']!) as Map<Object?, Object?>)
            .cast<String, Object?>();
    final contributes = (manifest['contributes']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final commands = contributes['commands']! as List<Object?>;
    expect(
      (commands.single! as Map<Object?, Object?>)['title'],
      '\u0085',
    );

    final rejected = _project()
      ..['commands'] = <Object?>[
        <String, Object?>{
          'command': 'test.fixture.ping',
          'title': '\uFEFF',
        },
      ];
    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: _inventory(['interface:vscode.Known']),
        overrides: _overrides({
          'interface:vscode.Known': 'opaqueJsObject',
        }),
        project: rejected,
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>().having(
          (error) => error.code,
          'code',
          'INVALID_PROJECT_MANIFEST',
        ),
      ),
    );
  });

  test('accepts empty optional command strings allowed by the pinned validator',
      () {
    final project = _project()
      ..['commands'] = <Object?>[
        <String, Object?>{
          'command': 'test.fixture.first',
          'title': 'First',
          'shortTitle': '',
          'category': '',
          'enablement': '',
          'icon': '',
        },
        <String, Object?>{
          'command': 'test.fixture.second',
          'title': 'Second',
          'icon': <String, Object?>{'dark': '', 'light': ''},
        },
      ];

    final generated = VSCodeBindingGenerator().generate(
      inventory: _inventory(['interface:vscode.Known']),
      overrides: _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      }),
      project: project,
    );
    final manifest =
        (jsonDecode(generated.files['package.json']!) as Map<Object?, Object?>)
            .cast<String, Object?>();
    final contributes = (manifest['contributes']! as Map<Object?, Object?>)
        .cast<String, Object?>();

    expect(contributes['commands'], project['commands']);
  });

  test('rejects command icon objects without both theme paths', () {
    for (final lonePath in ['dark', 'light']) {
      final project = _project()
        ..['commands'] = <Object?>[
          <String, Object?>{
            'command': 'test.fixture.ping',
            'title': 'Ping Dart Host',
            'icon': <String, Object?>{lonePath: 'icons/ping.svg'},
          },
        ];

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
                allOf(contains('icon'), contains('dark'), contains('light')),
              ),
        ),
        reason: lonePath,
      );
    }
  });

  test('emits the reviewed Flutter View host binding slice', () {
    final generated = VSCodeBindingGenerator().generate(
      inventory: _readJson('tool/bindings/ir/vscode-1.129.1.json'),
      overrides: _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      ),
      project: _readJson('test/fixtures/host_extension/extension.json'),
    );

    final parity = generated.files['host/lib/generated/vscode_parity.g.dart']!;
    expect(
      parity,
      allOf([
        contains('external Window get window;'),
        contains('extension type Window.fromJS(JSObject _)'),
        contains('WebviewPanel createWebviewPanel('),
        contains('static const int one = 1;'),
        contains('external factory WebviewOptions({'),
        contains('bool enableScripts,'),
        contains('JSArray<Uri> localResourceRoots,'),
        contains('external Uri get extensionUri;'),
        contains('external static Uri joinPath('),
        contains('external JSString toUriString([bool skipEncoding]);'),
        contains('extension type WebviewPanel.fromJS(JSObject _)'),
        contains('external Webview get webview;'),
        contains('external VoidEvent get onDidDispose;'),
        contains('extension type Webview.fromJS(JSObject _)'),
        contains('external JSString get html;'),
        contains('external set html(JSString value);'),
        contains('external JSString get cspSource;'),
        contains('external Uri asWebviewUri(Uri localResource);'),
        contains('external Thenable<JSBoolean> postMessage(JSAny? message);'),
        contains('external Event<JSAny?> get onDidReceiveMessage;'),
      ]),
    );

    final facade = generated.files['host/lib/generated/vscode_facade.g.dart']!;
    expect(
      facade,
      allOf(
        contains('WebviewPanel createFlutterViewPanel({'),
        contains('required List<Uri> localResourceRoots,'),
        contains('Future<bool> postMessageFuture(JSAny? message)'),
        contains('Disposable listenOnDidReceiveMessage(JSFunction listener)'),
        contains('Disposable listenOnDidDispose(JSFunction listener)'),
      ),
    );
  });

  test('derives namespace and operation names from the canonical IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();

    final executionId = _entryIdForStrategy(entries, 'commandExecution');
    final registrationId = _entryIdForStrategy(entries, 'commandRegistration');
    final commandNamespaceId = declarations.singleWhere(
      (candidate) => candidate['id'] == executionId,
    )['parentId']! as String;
    _renameProducerDeclaration(
      inventory,
      overrides,
      executionId,
      'runAction',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      registrationId,
      'installAction',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      commandNamespaceId,
      'actions',
    );

    final generated = VSCodeBindingGenerator().generate(
      inventory: inventory,
      overrides: overrides,
      project: _readJson('test/fixtures/host_extension/extension.json'),
    );
    final parity = generated.files['host/lib/generated/vscode_parity.g.dart']!;

    expect(parity, contains('external Actions get actions;'));
    expect(parity, contains('extension type Actions.fromJS(JSObject _)'));
    expect(parity, contains('Thenable<T> runAction<T extends JSAny?>'));
    expect(parity, contains('Disposable installAction('));
    expect(parity, isNot(contains('external Commands get commands;')));
    expect(parity, isNot(contains('executeCommand<T extends JSAny?>')));
  });

  test('derives projected member names from the canonical IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final projectedIds = entries.entries
        .where(
          (entry) =>
              (entry.value! as Map<Object?, Object?>)['strategy'] ==
              'intGetterProjection',
        )
        .map((entry) => entry.key)
        .toList()
      ..sort();
    final replacementNames = ['column', 'row'];
    for (var index = 0; index < projectedIds.length; index += 1) {
      final id = projectedIds[index];
      _renameProducerDeclaration(
        inventory,
        overrides,
        id,
        replacementNames[index],
      );
    }

    final parity = VSCodeBindingGenerator()
        .generate(
          inventory: inventory,
          overrides: overrides,
          project: _readJson('test/fixtures/host_extension/extension.json'),
        )
        .files['host/lib/generated/vscode_parity.g.dart']!;

    expect(parity, contains('external int get row;'));
    expect(parity, contains('external int get column;'));
    expect(parity, isNot(contains('external int get line;')));
    expect(parity, isNot(contains('external int get character;')));
  });

  test('derives observation IDs and writable string members from IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final targets = overrides['targets']! as List<Object?>;
    final oldId = _entryIdForStrategy(entries, 'stringGetterSetterProjection');
    const newId = r'property:interface:vscode.Webview/$instance/markupSource';
    final declaration = declarations.singleWhere(
      (candidate) => candidate['id'] == oldId,
    );
    declaration['id'] = newId;
    declaration['name'] = 'markupSource';
    declaration['qualifiedName'] = 'vscode.Webview.markupSource';
    targets[targets.indexOf(oldId)] = newId;
    final entry = (entries.remove(oldId)! as Map<Object?, Object?>)
        .cast<String, Object?>();
    entry['declarationSha256'] = computeDeclarationFingerprint(
      declaration.cast<String, Object?>(),
    );
    entries[newId] = entry;

    final generated = VSCodeBindingGenerator().generate(
      inventory: inventory,
      overrides: overrides,
      project: _readJson('test/fixtures/host_extension/extension.json'),
    );
    final parity = generated.files['host/lib/generated/vscode_parity.g.dart']!;
    final facade = generated.files['host/lib/generated/vscode_facade.g.dart']!;

    expect(parity, contains('external JSString get markupSource;'));
    expect(parity, contains('external set markupSource(JSString value);'));
    expect(facade, contains("'$newId'"));
    expect(facade, contains('final value = markupSource.toDart;'));
    expect(facade, contains('markupSource = value.toJS;'));
  });

  test('derives Flutter View surface operation names from canonical IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    const renames = {
      'stringGetterProjection': 'policySource',
      'eventValue': 'onDidReceivePayload',
      'thenableBoolMethod': 'sendPayload',
      'unaryUriMethod': 'toSurfaceUri',
    };
    for (final rename in renames.entries) {
      final candidates = entries.entries.where(
        (entry) =>
            (entry.value! as Map<Object?, Object?>)['strategy'] == rename.key,
      );
      final id = rename.key == 'eventValue'
          ? candidates.singleWhere((entry) {
              final declaration = declarations.singleWhere(
                (candidate) => candidate['id'] == entry.key,
              );
              return declaration['kind'] == 'property';
            }).key
          : candidates.single.key;
      _renameProducerDeclaration(
        inventory,
        overrides,
        id,
        rename.value,
      );
    }

    final generated = VSCodeBindingGenerator().generate(
      inventory: inventory,
      overrides: overrides,
      project: _readJson('test/fixtures/host_extension/extension.json'),
    );
    final parity = generated.files['host/lib/generated/vscode_parity.g.dart']!;
    final facade = generated.files['host/lib/generated/vscode_facade.g.dart']!;

    expect(parity, contains('external JSString get policySource;'));
    expect(parity, contains('external Event<JSAny?> get onDidReceivePayload;'));
    expect(parity, contains('sendPayload(JSAny? message);'));
    expect(parity, contains('external Uri toSurfaceUri(Uri localResource);'));
    expect(facade, contains('final value = policySource.toDart;'));
    expect(facade, contains('final uri = toSurfaceUri(localResource);'));
    expect(facade, contains('await sendPayload(message).toDart'));
    expect(
      facade,
      contains('final registration = onDidReceivePayload(listener);'),
    );
  });

  test('derives panel, option, enum, and URI names from canonical IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();

    final panelCreationId = _entryIdForStrategy(
      entries,
      'webviewPanelCreation',
    );
    final windowNamespaceId = declarations.singleWhere(
      (candidate) => candidate['id'] == panelCreationId,
    )['parentId']! as String;
    _renameProducerDeclaration(
      inventory,
      overrides,
      panelCreationId,
      'openPanel',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      _entryIdForStrategy(entries, 'boolObjectField'),
      'allowScripts',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      _entryIdForStrategy(entries, 'uriArrayObjectField'),
      'assetRoots',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      _entryIdForStrategy(entries, 'voidEventValue'),
      'onClosed',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      _entryIdForStrategy(entries, 'uriJoinPath'),
      'combinePath',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      _entryIdForStrategy(entries, 'uriToString'),
      'formatUri',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      _entryIdForStrategy(entries, 'intEnumMember'),
      'Primary',
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      windowNamespaceId,
      'display',
    );

    final generated = VSCodeBindingGenerator().generate(
      inventory: inventory,
      overrides: overrides,
      project: _readJson('test/fixtures/host_extension/extension.json'),
    );
    final parity = generated.files['host/lib/generated/vscode_parity.g.dart']!;
    final facade = generated.files['host/lib/generated/vscode_facade.g.dart']!;

    expect(parity, contains('external Display get display;'));
    expect(parity, contains('extension type Display.fromJS(JSObject _)'));
    expect(parity, contains('WebviewPanel openPanel('));
    expect(parity, contains('bool allowScripts,'));
    expect(parity, contains('JSArray<Uri> assetRoots,'));
    expect(parity, contains('external VoidEvent get onClosed;'));
    expect(parity, contains("@JS('combinePath')"));
    expect(parity, contains("@JS('formatUri')"));
    expect(parity, contains('static const int primary = 1;'));
    expect(facade, contains('final api = display;'));
    expect(facade, contains('final panel = openPanel('));
    expect(facade, contains('allowScripts: true,'));
    expect(facade, contains('assetRoots: localResourceRoots.toJS,'));
    expect(facade, contains('final registration = onClosed(listener);'));
    expect(facade, contains('final uri = Uri.combinePath(base, pathSegment);'));
    expect(facade, contains('final result = formatUri(skipEncoding).toDart;'));
  });

  test('derives referenced host type names from canonical IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    _renameSelectedTypeReferences(
      inventory,
      overrides,
      const {'Uri': 'ResourceUri'},
    );
    _renameProducerDeclaration(
      inventory,
      overrides,
      'class:vscode.Uri',
      'ResourceUri',
    );

    final generated = VSCodeBindingGenerator().generate(
      inventory: inventory,
      overrides: overrides,
      project: _readJson('test/fixtures/host_extension/extension.json'),
    );
    final parity = generated.files['host/lib/generated/vscode_parity.g.dart']!;
    final facade = generated.files['host/lib/generated/vscode_facade.g.dart']!;

    expect(parity, contains('extension type ResourceUri._(JSObject _)'));
    expect(parity, contains('external ResourceUri get extensionUri;'));
    expect(parity, contains('JSArray<ResourceUri> localResourceRoots,'));
    expect(parity, contains('external ResourceUri asWebviewUri('));
    expect(parity, isNot(contains('extension type Uri._(JSObject _)')));
    expect(facade, contains('extension ResourceUriFacade on ResourceUri'));
    expect(facade, contains('ResourceUri joinHostUriPath(ResourceUri base'));
  });

  test('derives every selected parity type name from canonical IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    const renames = <String, String>{
      'Disposable': 'ResourceHandle',
      'Hover': 'Popup',
      'MarkdownString': 'RichText',
      'Range': 'Span',
      'ViewColumn': 'PanelColumn',
      'Thenable': 'AsyncResult',
      'CancellationToken': 'StopToken',
      'Event': 'Signal',
      'ExtensionContext': 'HostContext',
      'HoverProvider': 'PopupProvider',
      'TextDocument': 'Document',
      'Webview': 'Surface',
      'WebviewOptions': 'SurfaceOptions',
      'WebviewPanel': 'SurfacePanel',
    };

    _renameSelectedTypeReferences(inventory, overrides, renames);
    for (final rename in renames.entries) {
      final declaration = declarations.singleWhere(
        (candidate) =>
            candidate['name'] == rename.key &&
            {'class', 'enum', 'interface'}.contains(candidate['kind']),
      );
      _renameProducerDeclaration(
        inventory,
        overrides,
        declaration['id']! as String,
        rename.value,
      );
    }

    final generated = VSCodeBindingGenerator().generate(
      inventory: inventory,
      overrides: overrides,
      project: _readJson('test/fixtures/host_extension/extension.json'),
    );
    final parity = generated.files['host/lib/generated/vscode_parity.g.dart']!;
    final facade = generated.files['host/lib/generated/vscode_facade.g.dart']!;

    for (final name in renames.values) {
      expect(parity, contains(name), reason: name);
    }
    expect(parity, contains('external AsyncResult<T> executeCommand'));
    expect(parity, contains('external Signal<Document> get'));
    expect(parity, contains('external factory PopupProvider'));
    expect(parity, contains('extension type SurfacePanel.fromJS'));
    expect(parity, contains('extension type Surface.fromJS'));
    expect(facade, contains('extension SurfaceFacade on Surface'));
    expect(facade, contains('Popup createHostHover(RichText contents'));
    expect(facade, contains('Span createHostRange('));
  });

  test('derives emitted signature parameter names from canonical IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();

    void renameParameters(String strategy, List<String> names) {
      final id = _entryIdForStrategy(entries, strategy);
      final declaration = declarations.singleWhere(
        (candidate) => candidate['id'] == id,
      );
      final parameters = (declaration['parameters']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      for (var index = 0; index < names.length; index += 1) {
        parameters[index]['name'] = names[index];
      }
      (entries[id]! as Map<Object?, Object?>)['declarationSha256'] =
          computeDeclarationFingerprint(declaration.cast<String, Object?>());
    }

    renameParameters('commandExecution', ['actionId', 'arguments']);
    renameParameters(
      'commandRegistration',
      ['actionId', 'handler', 'receiver'],
    );
    renameParameters('unaryUriMethod', ['resource']);

    final parity = VSCodeBindingGenerator()
        .generate(
          inventory: inventory,
          overrides: overrides,
          project: _readJson('test/fixtures/host_extension/extension.json'),
        )
        .files['host/lib/generated/vscode_parity.g.dart']!;

    expect(parity, contains('JSString actionId,'));
    expect(parity, contains('JSFunction handler, ['));
    expect(parity, contains('JSAny? receiver,'));
    expect(parity, contains('asWebviewUri(Uri resource);'));
    expect(parity, isNot(contains('JSAny? thisArg,')));
  });

  test('attributes bindings only after the native operation succeeds', () {
    final generated = VSCodeBindingGenerator().generate(
      inventory: _readJson('tool/bindings/ir/vscode-1.129.1.json'),
      overrides: _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      ),
      project: _readJson('test/fixtures/host_extension/extension.json'),
    );
    final bootstrap = generated.files['host/bootstrap.cjs']!;
    final facade = generated.files['host/lib/generated/vscode_facade.g.dart']!;

    expect(
      bootstrap,
      contains(
        'const callbackResult = Reflect.apply(callback, this, args);\n'
        '  for (const bindingId of bindingIds)',
      ),
    );
    expect(
      bootstrap,
      contains('return callbackResult;'),
    );
    expect(
      facade,
      contains(
        'final registration = registerCommand(\n'
        '      command,\n'
        '      toHostCallback(callback),\n'
        '    );\n'
        '    observeHostBindings(',
      ),
    );
    expect(
      facade,
      contains(
        'final result = await postMessage(message).toDart;\n'
        '    final accepted = result.toDart;\n'
        '    if (accepted) {\n'
        '      observeHostBindings(',
      ),
    );
    expect(
      facade,
      contains(
        '        _bindingThenableInterface,\n'
        '      ]);\n'
        '    }\n'
        '    return accepted;',
      ),
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
        contains('const emittedExtensionKey = "$key";'),
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
      // The runtime module alone may use unsafe property access: its
      // hostFetch helper builds WHATWG fetch init objects dynamically.
      if (!entry.key.endsWith('vscode_runtime.g.dart')) {
        expect(
          entry.value,
          isNot(contains('dart:js_interop_unsafe')),
          reason: entry.key,
        );
      }
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
      'commandsContributionSchemaSha256':
          'a85c943ae42b2cdef0403070f78cfb9dbe7bcdc1fce7c57bf9ca2234d1e36a33',
    });
    final pinnedOverrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final pinnedContracts =
        (pinnedOverrides['hostContracts']! as Map<Object?, Object?>)
            .cast<String, Object?>();
    expect(coverage['hostContracts'], {
      'checkpoint4ExtensionHost': {
        'boundary': 'vscodeExtensionHost',
        'artifact': 'tool/bindings/contracts/checkpoint4-extension-host.json',
        'artifactSha256': ((pinnedContracts['checkpoint4ExtensionHost']!
                as Map<Object?, Object?>)['artifactSha256']!)
            .toString(),
      },
    });
    expect(coverage['hostEvidence'], {
      'kind': 'mechanicalAttribution',
      'meaning':
          '53 generated binding IDs were exercised by one real Extension '
              'Host Contract after its surrounding native behavior passed.',
      'independentBehavioralContracts': false,
    });
    expect(coverage['scope'], {
      'name': 'checkpoint4FlutterViewSlice',
      'fullApiParity': false,
      'selectedTargets': 60,
      'implementedTargets': 53,
      'reviewedExcludedTargets': 7,
    });
    expect(coverage['inventory'], {
      'logicalEntries': 2982,
      'sourceOccurrences': 2982,
      'publicLogicalEntries': 2972,
      'nonPublicLogicalEntries': 10,
    });
    expect(coverage['exclusions'], {
      'reviewedSemanticOverrides': 7,
      'nonPublicVisibility': 10,
    });
    expect(coverage['summary'], {
      'discovered': 2982,
      'semanticsReviewed': 53,
      'semanticsExcluded': 17,
      'semanticsPending': 2912,
      'bindingsEmitted': 53,
      'bindingsExcluded': 17,
      'bindingsPending': 2912,
      'hostVerified': 53,
      'hostNotApplicable': 17,
      'hostPending': 2912,
    });
    final ledgerEntries =
        (coverage['entries']! as List<Object?>).cast<Map<Object?, Object?>>();
    expect(ledgerEntries, hasLength(2982));
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
      {'status': 'verified', 'contract': 'checkpoint4ExtensionHost'},
    );
    const webviewPostMessageId =
        'method:vscode.Webview.postMessage@a2972cc260d088838e09de8dc683393276ed8c03d172023d9a807a9d585d71a1';
    expect(
      ledgerEntries.singleWhere(
        (entry) => entry['id'] == webviewPostMessageId,
      ),
      allOf(
        containsPair('selected', true),
        containsPair('semantics', {
          'status': 'reviewed',
          'basis': 'semanticOverride',
          'strategy': 'thenableBoolMethod',
        }),
        containsPair('binding', {
          'status': 'emitted',
          'artifacts': ['host/lib/generated/vscode_parity.g.dart'],
        }),
        containsPair('host', {
          'status': 'verified',
          'contract': 'checkpoint4ExtensionHost',
        }),
      ),
    );
    expect(
      ledgerEntries.singleWhere(
        (entry) => entry['id'] == 'interface:vscode.WebviewPanelOptions',
      ),
      allOf(
        containsPair('selected', true),
        containsPair(
          'semantics',
          allOf(
            containsPair('status', 'excluded'),
            containsPair('strategy', 'reviewedExcluded'),
            containsPair(
              'reason',
              'The first Flutter View uses no WebviewPanelOptions fields.',
            ),
          ),
        ),
        containsPair('binding', {'status': 'excluded'}),
        containsPair('host', {'status': 'notApplicable'}),
      ),
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

  test('rejects a Flutter View strategy assigned to the wrong IR entry', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    const htmlId = r'property:interface:vscode.Webview/$instance/html';
    final html =
        (entries[htmlId]! as Map<Object?, Object?>).cast<String, Object?>();
    html['strategy'] = 'stringGetterProjection';

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
              contains(htmlId),
            ),
      ),
    );
  });

  test('rejects a string enum value reviewed as an integer binding', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final enumMemberId = _entryIdForStrategy(entries, 'intEnumMember');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final enumMember = declarations.singleWhere(
      (declaration) => declaration['id'] == enumMemberId,
    );
    final initializer = (enumMember['initializer']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    initializer['value'] = '1';
    final override = (entries[enumMemberId]! as Map<Object?, Object?>)
        .cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      enumMember.cast<String, Object?>(),
    );

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
              contains(enumMemberId),
            ),
      ),
    );
  });

  test('rejects an optional member reviewed as a required projection', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final propertyId = entries.entries.firstWhere((entry) {
      final override =
          (entry.value! as Map<Object?, Object?>).cast<String, Object?>();
      return override['strategy'] == 'intGetterProjection';
    }).key;
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final property = declarations.singleWhere(
      (declaration) => declaration['id'] == propertyId,
    );
    property['optional'] = true;
    final override =
        (entries[propertyId]! as Map<Object?, Object?>).cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      property.cast<String, Object?>(),
    );

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
              contains(propertyId),
            ),
      ),
    );
  });

  test('rejects static drift for every emitted method strategy', () {
    const expectedStaticByStrategy = <String, bool>{
      'disposeMethod': false,
      'providerCallback': false,
      'thenableBoolMethod': false,
      'unaryUriMethod': false,
      'uriJoinPath': true,
      'uriToString': false,
    };
    final baseOverrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final baseEntries = (baseOverrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final cases = <({String id, String strategy, bool expectedStatic})>[
      for (final entry in baseEntries.entries)
        if (expectedStaticByStrategy.containsKey(
          (entry.value! as Map<Object?, Object?>)['strategy'],
        ))
          (
            id: entry.key,
            strategy:
                (entry.value! as Map<Object?, Object?>)['strategy']! as String,
            expectedStatic: expectedStaticByStrategy[
                (entry.value! as Map<Object?, Object?>)['strategy']]!,
          ),
    ];

    for (final mutation in cases) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == mutation.id)
          .cast<String, Object?>();
      final producerCanBeStatic = declarations.singleWhere(
            (candidate) => candidate['id'] == declaration['parentId'],
          )['kind'] ==
          'class';
      declaration['static'] = !mutation.expectedStatic;
      final mutatedId = _synchronizeProducerMutation(
        inventory,
        overrides,
        mutation.id,
      );

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
                producerCanBeStatic
                    ? 'WALKING_SLICE_PROFILE_MISMATCH'
                    : 'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                producerCanBeStatic ? contains(mutatedId) : contains('.static'),
              ),
        ),
        reason: '${mutation.strategy}: ${mutation.id}',
      );
    }
  });

  test('rejects optional drift for every emitted method strategy', () {
    const methodStrategies = <String>{
      'disposeMethod',
      'providerCallback',
      'thenableBoolMethod',
      'unaryUriMethod',
      'uriJoinPath',
      'uriToString',
    };
    final baseOverrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final baseEntries = (baseOverrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final cases = <({String id, String strategy})>[
      for (final entry in baseEntries.entries)
        if (methodStrategies.contains(
          (entry.value! as Map<Object?, Object?>)['strategy'],
        ))
          (
            id: entry.key,
            strategy:
                (entry.value! as Map<Object?, Object?>)['strategy']! as String,
          ),
    ];

    for (final mutation in cases) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == mutation.id)
          .cast<String, Object?>();
      declaration['optional'] = true;
      final mutatedId = _synchronizeProducerMutation(
        inventory,
        overrides,
        mutation.id,
      );

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
                contains(mutatedId),
              ),
        ),
        reason: '${mutation.strategy}: ${mutation.id}',
      );
    }
  });

  test('rejects parameter flag drift for every emitted callable strategy', () {
    const requiredParameter = (optional: false, rest: false);
    const optionalParameter = (optional: true, rest: false);
    const restParameter = (optional: false, rest: true);
    const expectedShapes = <String, List<({bool optional, bool rest})>>{
      'commandExecution': [requiredParameter, restParameter],
      'commandRegistration': [
        requiredParameter,
        requiredParameter,
        optionalParameter,
      ],
      'eventSubscription': [
        requiredParameter,
        optionalParameter,
        optionalParameter,
      ],
      'hoverProviderRegistration': [
        requiredParameter,
        requiredParameter,
      ],
      'markdownHoverConstructor': [
        requiredParameter,
        optionalParameter,
      ],
      'markdownStringConstructor': [
        optionalParameter,
        optionalParameter,
      ],
      'numericRangeConstructor': [
        requiredParameter,
        requiredParameter,
        requiredParameter,
        requiredParameter,
      ],
      'providerCallback': [
        requiredParameter,
        requiredParameter,
        requiredParameter,
      ],
      'thenableBoolMethod': [requiredParameter],
      'unaryUriMethod': [requiredParameter],
      'uriJoinPath': [requiredParameter, restParameter],
      'uriToString': [optionalParameter],
      'webviewPanelCreation': [
        requiredParameter,
        requiredParameter,
        requiredParameter,
        optionalParameter,
      ],
    };

    for (final shape in expectedShapes.entries) {
      for (var parameterIndex = 0;
          parameterIndex < shape.value.length;
          parameterIndex += 1) {
        for (final field in const ['optional', 'rest']) {
          final inventory = _readJson(
            'tool/bindings/ir/vscode-1.129.1.json',
          );
          final overrides = _readJson(
            'tool/bindings/overrides/vscode-1.129.1.json',
          );
          final entries = (overrides['entries']! as Map<Object?, Object?>)
              .cast<String, Object?>();
          final declarationId = _entryIdForStrategy(entries, shape.key);
          final declarations = (inventory['declarations']! as List<Object?>)
              .cast<Map<Object?, Object?>>();
          final declaration = declarations
              .singleWhere((candidate) => candidate['id'] == declarationId)
              .cast<String, Object?>();
          final parameters = (declaration['parameters']! as List<Object?>)
              .cast<Map<Object?, Object?>>();
          final expected = shape.value[parameterIndex];
          parameters[parameterIndex][field] = switch (field) {
            'optional' => !expected.optional,
            'rest' => !expected.rest,
            _ => throw StateError('Unknown parameter field $field'),
          };
          final mutatedId = _synchronizeProducerMutation(
            inventory,
            overrides,
            declarationId,
          );

          expect(
            () => VSCodeBindingGenerator().generate(
              inventory: inventory,
              overrides: overrides,
              project: _readJson(
                'test/fixtures/host_extension/extension.json',
              ),
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
                    contains(mutatedId),
                  ),
            ),
            reason: '${shape.key} parameter $parameterIndex $field',
          );
        }
      }
    }
  });

  test('rejects JSAny parameter types detached from emitted JSAny', () {
    const cases = <String, int>{
      'commandRegistration': 2,
      'eventSubscription': 1,
    };
    for (final mutation in cases.entries) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final entries = (overrides['entries']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      final declarationId = _entryIdForStrategy(entries, mutation.key);
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == declarationId)
          .cast<String, Object?>();
      final parameters = (declaration['parameters']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      parameters[mutation.value]['type'] = <String, Object?>{
        'kind': 'primitive',
        'name': 'string',
      };
      final mutatedId = _synchronizeProducerMutation(
        inventory,
        overrides,
        declarationId,
      );

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
                contains(mutatedId),
              ),
        ),
        reason: mutation.key,
      );
    }
  });

  test('rejects generic arity drift in emitted generic bindings', () {
    for (final strategy in const [
      'commandExecution',
      'eventType',
      'providerResultProjection',
      'thenableFutureBridge',
    ]) {
      for (final typeParameterCount in const [0, 2]) {
        final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
        final overrides = _readJson(
          'tool/bindings/overrides/vscode-1.129.1.json',
        );
        final entries = (overrides['entries']! as Map<Object?, Object?>)
            .cast<String, Object?>();
        final declarationId = _entryIdForStrategy(entries, strategy);
        final declarations = (inventory['declarations']! as List<Object?>)
            .cast<Map<Object?, Object?>>();
        final declaration = declarations
            .singleWhere((candidate) => candidate['id'] == declarationId)
            .cast<String, Object?>();
        declaration['typeParameters'] = <Object?>[
          for (var index = 0; index < typeParameterCount; index += 1)
            <String, Object?>{'name': 'T$index'},
        ];
        final mutatedId = _synchronizeProducerMutation(
          inventory,
          overrides,
          declarationId,
        );

        expect(
          () => VSCodeBindingGenerator().generate(
            inventory: inventory,
            overrides: overrides,
            project: _readJson(
              'test/fixtures/host_extension/extension.json',
            ),
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
                  contains(mutatedId),
                ),
          ),
          reason: '$strategy with $typeParameterCount type parameters',
        );
      }
    }
  });

  test('rejects constraints and defaults on emitted generic bindings', () {
    for (final strategy in const [
      'commandExecution',
      'eventType',
      'providerResultProjection',
      'thenableFutureBridge',
    ]) {
      for (final field in const ['constraint', 'default']) {
        final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
        final overrides = _readJson(
          'tool/bindings/overrides/vscode-1.129.1.json',
        );
        final entries = (overrides['entries']! as Map<Object?, Object?>)
            .cast<String, Object?>();
        final declarationId = _entryIdForStrategy(entries, strategy);
        final declarations = (inventory['declarations']! as List<Object?>)
            .cast<Map<Object?, Object?>>();
        final declaration = declarations
            .singleWhere((candidate) => candidate['id'] == declarationId)
            .cast<String, Object?>();
        final typeParameters = (declaration['typeParameters']! as List<Object?>)
            .cast<Map<Object?, Object?>>();
        typeParameters.single[field] = <String, Object?>{
          'kind': 'primitive',
          'name': 'string',
        };
        final mutatedId = _synchronizeProducerMutation(
          inventory,
          overrides,
          declarationId,
        );

        expect(
          () => VSCodeBindingGenerator().generate(
            inventory: inventory,
            overrides: overrides,
            project: _readJson(
              'test/fixtures/host_extension/extension.json',
            ),
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
                  contains(mutatedId),
                ),
          ),
          reason: '$strategy type parameter $field',
        );
      }
    }
  });

  test('rejects generics on emitted non-generic callables', () {
    const strategies = <String>{
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
    final baseOverrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final baseEntries = (baseOverrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final cases = <({String id, String strategy})>[
      for (final entry in baseEntries.entries)
        if (strategies.contains(
          (entry.value! as Map<Object?, Object?>)['strategy'],
        ))
          (
            id: entry.key,
            strategy:
                (entry.value! as Map<Object?, Object?>)['strategy']! as String,
          ),
    ];

    for (final mutation in cases) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == mutation.id)
          .cast<String, Object?>();
      declaration['typeParameters'] = <Object?>[
        <String, Object?>{'name': 'T'},
      ];
      final mutatedId = _synchronizeProducerMutation(
        inventory,
        overrides,
        mutation.id,
      );

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
                contains(mutatedId),
              ),
        ),
        reason: '${mutation.strategy}: ${mutation.id}',
      );
    }
  });

  test('rejects generics on emitted non-generic interface bindings', () {
    for (final strategy in const ['jsObjectLiteral', 'providerObject']) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final entries = (overrides['entries']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      final declarationId = _entryIdForStrategy(entries, strategy);
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == declarationId)
          .cast<String, Object?>();
      declaration['typeParameters'] = <Object?>[
        <String, Object?>{'name': 'T'},
      ];
      final mutatedId = _synchronizeProducerMutation(
        inventory,
        overrides,
        declarationId,
      );

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
                contains(mutatedId),
              ),
        ),
        reason: strategy,
      );
    }
  });

  test('rejects inherited shape on constructed interface projections', () {
    for (final strategy in const ['jsObjectLiteral', 'providerObject']) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final entries = (overrides['entries']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      final declarationId = _entryIdForStrategy(entries, strategy);
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == declarationId)
          .cast<String, Object?>();
      declaration['extends'] = <Object?>[
        <String, Object?>{
          'kind': 'reference',
          'name': 'ExtensionContext',
          'typeArguments': <Object?>[],
        },
      ];
      final override = (entries[declarationId]! as Map<Object?, Object?>)
          .cast<String, Object?>();
      override['declarationSha256'] = computeDeclarationFingerprint(
        declaration,
      );

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
                contains(declarationId),
              ),
        ),
        reason: strategy,
      );
    }
  });

  test('rejects abstract classes behind emitted native constructors', () {
    for (final constructorStrategy in const [
      'markdownHoverConstructor',
      'markdownStringConstructor',
      'numericRangeConstructor',
    ]) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final entries = (overrides['entries']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      final constructorId = _entryIdForStrategy(
        entries,
        constructorStrategy,
      );
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final constructor = declarations.singleWhere(
        (candidate) => candidate['id'] == constructorId,
      );
      final classId = constructor['parentId']! as String;
      final classDeclaration = declarations
          .singleWhere((candidate) => candidate['id'] == classId)
          .cast<String, Object?>();
      classDeclaration['abstract'] = true;
      final classOverride =
          (entries[classId]! as Map<Object?, Object?>).cast<String, Object?>();
      classOverride['declarationSha256'] = computeDeclarationFingerprint(
        classDeclaration,
      );

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
                contains(classId),
              ),
        ),
        reason: constructorStrategy,
      );
    }
  });

  test('rejects generics on emitted non-generic native host types', () {
    const strategies = {'nativeJsClass', 'opaqueHostObject'};
    final baseOverrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final baseEntries = (baseOverrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final cases = <String>[
      for (final entry in baseEntries.entries)
        if (strategies.contains(
          (entry.value! as Map<Object?, Object?>)['strategy'],
        ))
          entry.key,
    ];

    for (final declarationId in cases) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == declarationId)
          .cast<String, Object?>();
      declaration['typeParameters'] = <Object?>[
        <String, Object?>{'name': 'T'},
      ];
      final mutatedId = _synchronizeProducerMutation(
        inventory,
        overrides,
        declarationId,
      );

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
                contains(mutatedId),
              ),
        ),
        reason: declarationId,
      );
    }
  });

  test('rejects execute-command return types detached from its generic', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarationId = _entryIdForStrategy(entries, 'commandExecution');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == declarationId)
        .cast<String, Object?>();
    final returnType = (declaration['returnType']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    returnType['typeArguments'] = <Object?>[
      <String, Object?>{'kind': 'primitive', 'name': 'string'},
    ];
    final mutatedId = _synchronizeProducerMutation(
      inventory,
      overrides,
      declarationId,
    );

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
              contains(mutatedId),
            ),
      ),
    );
  });

  test('rejects Uri.joinPath rest elements detached from emitted JSString', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarationId = _entryIdForStrategy(entries, 'uriJoinPath');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == declarationId)
        .cast<String, Object?>();
    final parameters = (declaration['parameters']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final restType = (parameters[1]['type']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    restType['elementType'] = <String, Object?>{
      'kind': 'primitive',
      'name': 'number',
    };
    final mutatedId = _synchronizeProducerMutation(
      inventory,
      overrides,
      declarationId,
    );

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
              contains(mutatedId),
            ),
      ),
    );
  });

  test('rejects Event listeners detached from the Event generic', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarationId = _entryIdForStrategy(entries, 'eventSubscription');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == declarationId)
        .cast<String, Object?>();
    final parameters = (declaration['parameters']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final listener = (parameters.first['type']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final listenerParameters = (listener['parameters']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    listenerParameters.single['type'] = <String, Object?>{
      'kind': 'primitive',
      'name': 'string',
    };
    final mutatedId = _synchronizeProducerMutation(
      inventory,
      overrides,
      declarationId,
    );

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
              contains(mutatedId),
            ),
      ),
    );
  });

  test('rejects Thenable inheritance detached from its generic', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarationId = _entryIdForStrategy(
      entries,
      'thenableFutureBridge',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == declarationId)
        .cast<String, Object?>();
    final heritage = (declaration['extends']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    heritage.single['typeArguments'] = <Object?>[
      <String, Object?>{'kind': 'primitive', 'name': 'string'},
    ];
    final override = (entries[declarationId]! as Map<Object?, Object?>)
        .cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      declaration,
    );

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
              contains(declarationId),
            ),
      ),
    );
  });

  test('rejects ProviderResult unions detached from their generic', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarationId = _entryIdForStrategy(
      entries,
      'providerResultProjection',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == declarationId)
        .cast<String, Object?>();
    final union =
        (declaration['type']! as Map<Object?, Object?>).cast<String, Object?>();
    final types =
        (union['types']! as List<Object?>).cast<Map<Object?, Object?>>();
    types.first
      ..clear()
      ..addAll(<String, Object?>{
        'kind': 'primitive',
        'name': 'string',
      });
    final override = (entries[declarationId]! as Map<Object?, Object?>)
        .cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      declaration,
    );

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
              contains(declarationId),
            ),
      ),
    );
  });

  test('rejects a string selector projection without string support', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarationId = _entryIdForStrategy(
      entries,
      'stringSelectorProjection',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == declarationId)
        .cast<String, Object?>();
    final union =
        (declaration['type']! as Map<Object?, Object?>).cast<String, Object?>();
    (union['types']! as List<Object?>).removeWhere(
      (candidate) =>
          candidate is Map<Object?, Object?> &&
          candidate['kind'] == 'primitive' &&
          candidate['name'] == 'string',
    );
    final override = (entries[declarationId]! as Map<Object?, Object?>)
        .cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      declaration,
    );

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
              contains(declarationId),
            ),
      ),
    );
  });

  test('rejects Webview message events detached from their emitted value', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declarationId = entries.entries.singleWhere((entry) {
      final override = entry.value! as Map<Object?, Object?>;
      if (override['strategy'] != 'eventValue') {
        return false;
      }
      return declarations.singleWhere(
            (candidate) => candidate['id'] == entry.key,
          )['kind'] ==
          'property';
    }).key;
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == declarationId)
        .cast<String, Object?>();
    final type =
        (declaration['type']! as Map<Object?, Object?>).cast<String, Object?>();
    type['typeArguments'] = <Object?>[
      <String, Object?>{'kind': 'primitive', 'name': 'string'},
    ];
    final override = (entries[declarationId]! as Map<Object?, Object?>)
        .cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      declaration,
    );

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
              contains(declarationId),
            ),
      ),
    );
  });

  test('rejects Webview postMessage inputs detached from emitted JSAny', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarationId = _entryIdForStrategy(entries, 'thenableBoolMethod');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == declarationId)
        .cast<String, Object?>();
    final parameters = (declaration['parameters']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    parameters.single['type'] = <String, Object?>{
      'kind': 'primitive',
      'name': 'string',
    };
    final mutatedId = _synchronizeProducerMutation(
      inventory,
      overrides,
      declarationId,
    );

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
              contains(mutatedId),
            ),
      ),
    );
  });

  test('rejects inconsistent emitted disposal member names', () {
    final baseOverrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final baseEntries = (baseOverrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final disposeIds = <String>[
      for (final entry in baseEntries.entries)
        if ((entry.value! as Map<Object?, Object?>)['strategy'] ==
            'disposeMethod')
          entry.key,
    ];
    expect(disposeIds, hasLength(3));

    for (final declarationId in disposeIds) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final mutatedId = _renameProducerDeclaration(
        inventory,
        overrides,
        declarationId,
        'release',
      );

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
                contains(mutatedId),
              ),
        ),
        reason: declarationId,
      );
    }
  });

  test('derives the shared emitted disposal member name from IR', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final disposeIds = <String>[
      for (final entry in entries.entries)
        if ((entry.value! as Map<Object?, Object?>)['strategy'] ==
            'disposeMethod')
          entry.key,
    ];
    for (final declarationId in disposeIds) {
      _renameProducerDeclaration(
        inventory,
        overrides,
        declarationId,
        'release',
      );
    }

    final parity = VSCodeBindingGenerator()
        .generate(
          inventory: inventory,
          overrides: overrides,
          project: _readJson('test/fixtures/host_extension/extension.json'),
        )
        .files['host/lib/generated/vscode_parity.g.dart']!;

    expect(
      RegExp(r'external JSAny\? release\(\);').allMatches(parity),
      hasLength(3),
    );
    expect(parity, isNot(contains('external JSAny? dispose();')));
  });

  test('rejects return-type drift for emitted disposal methods', () {
    final baseOverrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final baseEntries = (baseOverrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final disposeIds = <String>[
      for (final entry in baseEntries.entries)
        if ((entry.value! as Map<Object?, Object?>)['strategy'] ==
            'disposeMethod')
          entry.key,
    ];

    for (final declarationId in disposeIds) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == declarationId)
          .cast<String, Object?>();
      declaration['returnType'] = <String, Object?>{
        'kind': 'primitive',
        'name': 'void',
      };
      final mutatedId = _synchronizeProducerMutation(
        inventory,
        overrides,
        declarationId,
      );

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
                contains(mutatedId),
              ),
        ),
        reason: declarationId,
      );
    }
  });

  test('rejects an event value that references the wrong host type', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final eventId = entries.entries.singleWhere((entry) {
      final override =
          (entry.value! as Map<Object?, Object?>).cast<String, Object?>();
      if (override['strategy'] != 'eventValue') {
        return false;
      }
      final declaration = declarations.singleWhere(
        (candidate) => candidate['id'] == entry.key,
      );
      return declaration['kind'] == 'variable';
    }).key;
    final event = declarations.singleWhere(
      (declaration) => declaration['id'] == eventId,
    );
    final type =
        (event['type']! as Map<Object?, Object?>).cast<String, Object?>();
    type['name'] = 'Thenable';
    final override =
        (entries[eventId]! as Map<Object?, Object?>).cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      event.cast<String, Object?>(),
    );

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
              contains(eventId),
            ),
      ),
    );
  });

  test('rejects incompatible relationships between selected strategies', () {
    void expectRejected(
      String strategy,
      void Function(Map<String, Object?> declaration) mutate,
    ) {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final entries = (overrides['entries']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      final declarationId = _entryIdForStrategy(entries, strategy);
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == declarationId)
          .cast<String, Object?>();
      mutate(declaration);
      final mutatedId = _synchronizeProducerMutation(
        inventory,
        overrides,
        declarationId,
      );

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
                contains(mutatedId),
              ),
        ),
        reason: strategy,
      );
    }

    expectRejected('commandExecution', (declaration) {
      final returnType = (declaration['returnType']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      returnType['name'] = 'Event';
    });
    expectRejected('thenableBoolMethod', (declaration) {
      final returnType = (declaration['returnType']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      returnType['name'] = 'Event';
    });
    expectRejected('webviewPanelCreation', (declaration) {
      final returnType = (declaration['returnType']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      returnType['name'] = 'Webview';
    });
    expectRejected('hoverProviderRegistration', (declaration) {
      final parameters = (declaration['parameters']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final providerType = (parameters[1]['type']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      providerType['name'] = 'CancellationToken';
    });
    expectRejected('providerCallback', (declaration) {
      final returnType = (declaration['returnType']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      returnType['name'] = 'Thenable';
    });
    expectRejected('uriArrayObjectField', (declaration) {
      final operator = (declaration['type']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      final array =
          (operator['type']! as Map<Object?, Object?>).cast<String, Object?>();
      final elementType = (array['elementType']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      elementType['name'] = 'TextDocument';
    });
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

  test(
    'rejects unknown selected declaration fields after fingerprint refresh',
    () {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final entries = (overrides['entries']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      final id = _entryIdForStrategy(entries, 'commandRegistration');
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == id)
          .cast<String, Object?>();
      declaration['futureSemantic'] = true;
      final override =
          (entries[id]! as Map<Object?, Object?>).cast<String, Object?>();
      override['declarationSha256'] = computeDeclarationFingerprint(
        declaration,
      );

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
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                allOf(
                  contains('inventory.declarations'),
                  contains('futureSemantic'),
                ),
              ),
        ),
      );
    },
  );

  test('rejects unknown selected declaration coverage fields', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final id = _entryIdForStrategy(entries, 'commandRegistration');
    final declaration = declarations.singleWhere(
      (candidate) => candidate['id'] == id,
    );
    final coverage = (declaration['coverage']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    coverage['inference'] = 'permitted';

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(contains('.coverage'), contains('inference')),
            ),
      ),
    );
  });

  test('rejects unknown fields in recursively nested selected types', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final id = _entryIdForStrategy(entries, 'commandRegistration');
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == id)
        .cast<String, Object?>();
    final parameters = (declaration['parameters']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final callback = (parameters[1]['type']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final callbackParameters = (callback['parameters']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final argumentArray =
        (callbackParameters.single['type']! as Map<Object?, Object?>)
            .cast<String, Object?>();
    final elementType = (argumentArray['elementType']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    elementType['futureTypeMeaning'] = true;
    final override =
        (entries[id]! as Map<Object?, Object?>).cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      declaration,
    );

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(contains('.elementType'), contains('futureTypeMeaning')),
            ),
      ),
    );
  });

  test('rejects unknown fields in recursively nested selected parameters', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final id = _entryIdForStrategy(entries, 'commandRegistration');
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == id)
        .cast<String, Object?>();
    final parameters = (declaration['parameters']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final callback = (parameters[1]['type']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final callbackParameters = (callback['parameters']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    callbackParameters.single['futureParameterMeaning'] = true;
    final override =
        (entries[id]! as Map<Object?, Object?>).cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      declaration,
    );

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('.parameters[0]'),
                contains('futureParameterMeaning'),
              ),
            ),
      ),
    );
  });

  test(
    'rejects unknown fields in recursively nested selected type parameters',
    () {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final entries = (overrides['entries']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      final id = _entryIdForStrategy(entries, 'commandRegistration');
      final declaration = declarations
          .singleWhere((candidate) => candidate['id'] == id)
          .cast<String, Object?>();
      final parameters = (declaration['parameters']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final callback = (parameters[1]['type']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      (callback['typeParameters']! as List<Object?>).add({
        'name': 'T',
        'futureTypeParameterMeaning': true,
      });
      final override =
          (entries[id]! as Map<Object?, Object?>).cast<String, Object?>();
      override['declarationSha256'] = computeDeclarationFingerprint(
        declaration,
      );

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
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                allOf(
                  contains('.typeParameters[0]'),
                  contains('futureTypeParameterMeaning'),
                ),
              ),
        ),
      );
    },
  );

  test('rejects unknown fields in selected canonical signatures', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final id = _entryIdForStrategy(entries, 'commandRegistration');
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == id)
        .cast<String, Object?>();
    final signature = (jsonDecode(declaration['canonicalSignature']! as String)
            as Map<Object?, Object?>)
        .cast<String, Object?>();
    signature['futureSignatureMeaning'] = true;
    declaration['canonicalSignature'] = jsonEncode(signature);
    _refreshProducerIdentity(inventory, overrides, id);

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('.canonicalSignature'),
                contains('futureSignatureMeaning'),
              ),
            ),
      ),
    );
  });

  test('rejects unknown fields in selected enum initializers', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final id = _entryIdForStrategy(entries, 'intEnumMember');
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == id)
        .cast<String, Object?>();
    final initializer = (declaration['initializer']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    initializer['futureInitializerMeaning'] = true;
    final override =
        (entries[id]! as Map<Object?, Object?>).cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      declaration,
    );

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('.initializer'),
                contains('futureInitializerMeaning'),
              ),
            ),
      ),
    );
  });

  test('rejects invalid selected declaration scalar values', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    );
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final entries = (overrides['entries']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final id = _entryIdForStrategy(entries, 'commandRegistration');
    final declaration = declarations
        .singleWhere((candidate) => candidate['id'] == id)
        .cast<String, Object?>();
    declaration['deprecated'] = 'future';
    final override =
        (entries[id]! as Map<Object?, Object?>).cast<String, Object?>();
    override['declarationSha256'] = computeDeclarationFingerprint(
      declaration,
    );

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
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(contains('.deprecated'), contains('future')),
            ),
      ),
    );
  });

  test('rejects raw member types in generic-scoped inline shapes', () {
    final inventory = _inventory(['interface:vscode.Box']);
    final declaration = (inventory['declarations']! as List<Object?>).single!
        as Map<String, Object?>;
    final shape = <String, Object?>{
      'members': [
        {
          'kind': 'property',
          'name': 'callback',
          'optional': false,
          'readonly': false,
          'type': {
            'kind': 'function',
            'typeParameters': <Object?>[],
            'parameters': <Object?>[],
            'returnType': {'kind': 'primitive', 'name': 'void'},
            'canonicalSignature': jsonEncode({
              'typeParameters': <Object?>[],
              'parameters': <Object?>[],
              'returnType': {'kind': 'primitive', 'name': 'void'},
            }),
          },
        },
      ],
    };
    declaration['typeParameters'] = [
      {
        'name': 'T',
        'constraint': {
          'kind': 'typeLiteral',
          'shape': shape,
          'shapeHash': _shapeHash(shape),
        },
      },
    ];
    final overrides = _schemaOverrideFor(declaration);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('.shape.members[0].type'),
            ),
      ),
    );
  });

  test('rejects raw generic references in parent-scoped signatures', () {
    final inventory = _inventory(['interface:vscode.Box']);
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<String, Object?>>();
    final parent = declarations.single;
    parent['typeParameters'] = [
      <String, Object?>{'name': 'T'},
    ];
    final canonicalSignature = jsonEncode({
      'typeParameters': <Object?>[],
      'parameters': <Object?>[],
      'returnType': {
        'kind': 'reference',
        'name': 'T',
        'typeArguments': <Object?>[],
      },
      'static': false,
      'optional': false,
    });
    final methodId =
        'method:vscode.Box.read@${_sha256String(canonicalSignature)}';
    declarations.add({
      'id': methodId,
      'kind': 'method',
      'name': 'read',
      'qualifiedName': 'vscode.Box.read',
      'parentId': parent['id'],
      'deprecated': false,
      'visibility': 'public',
      'overloadOrdinal': 0,
      'canonicalSignature': canonicalSignature,
      'typeParameters': <Object?>[],
      'parameters': <Object?>[],
      'returnType': {
        'kind': 'reference',
        'name': 'T',
        'typeArguments': <Object?>[],
      },
      'static': false,
      'optional': false,
      'abstract': false,
      'coverage': _pendingCoverage(),
    });
    final overrides = _schemaOverrideFor(parent);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('.canonicalSignature'), contains('T')),
            ),
      ),
    );
  });

  final sourceReceiptCases = <({
    String name,
    void Function(Map<String, Object?>, Map<String, Object?>) mutate,
  })>[
    (
      name: 'detached API digest',
      mutate: (inventory, overrides) {
        final source = (inventory['source']! as Map<Object?, Object?>)
            .cast<String, Object?>();
        source['inputSha256'] = '0' * 64;
      },
    ),
    (
      name: 'detached manifest projection digest',
      mutate: (inventory, overrides) {
        (inventory['manifestSchema']! as Map<Object?, Object?>)['inputSha256'] =
            '0' * 64;
        overrides['manifestSchemaSha256'] = '0' * 64;
      },
    ),
    (
      name: 'detached manifest-validator projection digest',
      mutate: (inventory, overrides) {
        (inventory['manifestValidator']!
            as Map<Object?, Object?>)['inputSha256'] = '0' * 64;
        overrides['manifestValidatorSha256'] = '0' * 64;
      },
    ),
    (
      name: 'detached commands projection digest',
      mutate: (inventory, overrides) {
        final schemas =
            (inventory['contributionSchemas']! as Map<Object?, Object?>)
                .cast<String, Object?>();
        (schemas['commands']! as Map<Object?, Object?>)['inputSha256'] =
            '0' * 64;
        overrides['commandsContributionSchemaSha256'] = '0' * 64;
      },
    ),
    (
      name: 'receipt from another product version',
      mutate: (inventory, overrides) {
        final input = _sourceInput(inventory, 'apiDeclarations');
        input['version'] = '1.128.0';
      },
    ),
    (
      name: 'noncanonical official source URL',
      mutate: (inventory, overrides) {
        final input = _sourceInput(inventory, 'apiDeclarations');
        input['source'] = 'https://example.invalid/vscode.d.ts';
      },
    ),
    (
      name: 'missing validation-helper receipt',
      mutate: (inventory, overrides) {
        final source = (inventory['source']! as Map<Object?, Object?>)
            .cast<String, Object?>();
        (source['inputs']! as List<Object?>).removeWhere(
          (value) =>
              (value! as Map<Object?, Object?>)['kind'] ==
              'contributionValidationHelperSource',
        );
      },
    ),
    (
      name: 'duplicate API receipt',
      mutate: (inventory, overrides) {
        final source = (inventory['source']! as Map<Object?, Object?>)
            .cast<String, Object?>();
        (source['inputs']! as List<Object?>).add(
          Map<String, Object?>.of(
            _sourceInput(inventory, 'apiDeclarations'),
          ),
        );
      },
    ),
  ];
  for (final testCase in sourceReceiptCases) {
    test('rejects ${testCase.name}', () {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final overrides = _readJson(
        'tool/bindings/overrides/vscode-1.129.1.json',
      );
      testCase.mutate(inventory, overrides);

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
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                contains('inventory.source'),
              ),
        ),
      );
    });
  }

  final impossibleOccurrenceCases = <(String, String)>[
    ('class', 'class:vscode.BranchCoverage'),
    ('type alias', 'typeAlias:vscode.AuthenticationForceNewSessionOptions'),
    (
      'enum member',
      'enumMember:enum:vscode.ChatResultFeedbackKind/Helpful',
    ),
    ('const variable', 'variable:vscode.authentication.onDidChangeSessions'),
  ];
  for (final testCase in impossibleOccurrenceCases) {
    test('rejects occurrenceCount on a nonmergeable ${testCase.$1}', () {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      declarations.singleWhere(
        (declaration) => declaration['id'] == testCase.$2,
      )['occurrenceCount'] = 2;

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
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                contains('occurrenceCount'),
              ),
        ),
      );
    });
  }

  test('rejects noncanonical canonicalSignature bytes', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declaration = _unselectedCallable(inventory);
    declaration['canonicalSignature'] =
        ' ${declaration['canonicalSignature']! as String}';

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('canonicalSignature'),
            ),
      ),
    );
  });

  test('rejects callable IDs detached from canonicalSignature hashes', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declaration = _unselectedCallable(inventory);
    final signature = (jsonDecode(declaration['canonicalSignature']! as String)
            as Map<Object?, Object?>)
        .cast<String, Object?>();
    signature['returnType'] = {'kind': 'primitive', 'name': 'undefined'};
    declaration['canonicalSignature'] = jsonEncode(signature);

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('.id'), contains('canonicalSignature')),
            ),
      ),
    );
  });

  test('rejects inline shapes detached from their shapeHash', () {
    final inventory = _inventory(['interface:vscode.Box']);
    final declaration = (inventory['declarations']! as List<Object?>).single!
        as Map<String, Object?>;
    final shape = <String, Object?>{
      'members': [
        {
          'kind': 'property',
          'name': 'value',
          'optional': false,
          'readonly': false,
          'type': {'kind': 'primitive', 'name': 'string'},
        },
      ],
    };
    declaration['typeParameters'] = [
      {
        'name': 'T',
        'constraint': {
          'kind': 'typeLiteral',
          'shape': shape,
          'shapeHash': '0' * 64,
        },
      },
    ];
    final overrides = _schemaOverrideFor(declaration);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('shapeHash'),
            ),
      ),
    );
  });

  test('rejects type-literal declaration IDs detached from shapeHash', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations.firstWhere(
      (candidate) => candidate['kind'] == 'typeLiteral',
    );
    declaration['shapeHash'] = '0' * 64;

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('qualifiedName'),
            ),
      ),
    );
  });

  test('rejects integers outside the JavaScript safe range', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations.firstWhere(
      (candidate) => candidate['kind'] == 'enumMember',
    );
    (declaration['initializer']! as Map<Object?, Object?>)['value'] =
        9007199254740992;

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('safe integer'),
            ),
      ),
    );
  });

  test('rejects excluded producer coverage on a public declaration', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final declaration = (inventory['declarations']! as List<Object?>).single!
        as Map<String, Object?>;
    declaration['coverage'] = {
      'discovery': 'discovered',
      'semantics': 'excluded',
      'binding': 'excluded',
      'host': 'notApplicable',
    };
    final overrides = _schemaOverrideFor(declaration);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('.coverage'),
            ),
      ),
    );
  });

  test('rejects pending producer coverage on a non-public declaration', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations.firstWhere(
      (candidate) => candidate['visibility'] != 'public',
    );
    declaration['coverage'] = _pendingCoverage();

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('.coverage'),
            ),
      ),
    );
  });

  final manifestProjectionCases =
      <({String name, void Function(Map<String, Object?>) mutate})>[
    (
      name: 'unknown manifest projection fields',
      mutate: (inventory) {
        (inventory['manifestSchema']!
            as Map<Object?, Object?>)['futureSemantics'] = true;
      },
    ),
    (
      name: 'unprojected nested manifest schema changes',
      mutate: (inventory) {
        final schema = (inventory['manifestSchema']! as Map<Object?, Object?>)
            .cast<String, Object?>();
        final properties = (schema['properties']! as Map<Object?, Object?>)
            .cast<String, Object?>();
        final engines = (properties['engines']! as Map<Object?, Object?>)
            .cast<String, Object?>();
        final engineProperties =
            (engines['properties']! as Map<Object?, Object?>)
                .cast<String, Object?>();
        (engineProperties['vscode']! as Map<Object?, Object?>)['type'] =
            'number';
      },
    ),
  ];
  for (final testCase in manifestProjectionCases) {
    test('rejects ${testCase.name}', () {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      testCase.mutate(inventory);

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
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                contains('inventory.manifestSchema'),
              ),
        ),
      );
    });
  }

  const producerDeclarationKinds = {
    'namespace',
    'interface',
    'class',
    'enum',
    'enumMember',
    'typeAlias',
    'variable',
    'property',
    'function',
    'constructor',
    'callSignature',
    'method',
    'indexSignature',
    'typeLiteral',
  };
  const derivedDeclarationFields = {
    'id',
    'name',
    'qualifiedName',
    'parentId',
  };
  for (final kind in producerDeclarationKinds) {
    for (final field in derivedDeclarationFields) {
      test('rejects $kind declarations with a detached $field', () {
        final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
        final declaration = _unselectedDeclarationOfKind(inventory, kind);
        declaration[field] = switch (field) {
          'id' => '${declaration[field]}-drift',
          'name' => '${declaration[field]}Drift',
          'qualifiedName' => '${declaration[field]}.drift',
          'parentId' => 'namespace:vscode.missing',
          _ => throw StateError('unreachable'),
        };
        _sortDeclarationsLikeProducer(inventory);

        expect(
          () => VSCodeBindingGenerator().generate(
            inventory: inventory,
            overrides: _readJson(
              'tool/bindings/overrides/vscode-1.129.1.json',
            ),
            project: _readJson(
              'test/fixtures/host_extension/extension.json',
            ),
          ),
          throwsA(
            isA<VSCodeBindingGenerationException>()
                .having(
                  (error) => error.code,
                  'code',
                  'INVALID_GENERATOR_INPUT',
                )
                .having(
                  (error) => error.message,
                  'message',
                  contains(field),
                ),
          ),
        );
      });
    }
  }

  final rawCanonicalCases =
      <({String name, Map<String, Object?> Function() declaration})>[
    (
      name: 'parameter types',
      declaration: () => _syntheticMethod(
            rawParameters: [
              _rawParameter('value', {'kind': 'primitive', 'name': 'string'}),
            ],
            canonicalParameters: [
              _canonicalParameter({'kind': 'primitive', 'name': 'number'}),
            ],
          ),
    ),
    (
      name: 'return types',
      declaration: () => _syntheticMethod(
            rawReturnType: {'kind': 'primitive', 'name': 'string'},
            canonicalReturnType: {'kind': 'primitive', 'name': 'number'},
          ),
    ),
    (
      name: 'type-parameter constraints',
      declaration: () => _syntheticMethod(
            rawTypeParameters: [
              {
                'name': 'T',
                'constraint': {'kind': 'primitive', 'name': 'string'},
              },
            ],
            canonicalTypeParameters: [
              {
                'constraint': {'kind': 'primitive', 'name': 'number'},
              },
            ],
          ),
    ),
    (
      name: 'method flags',
      declaration: () => _syntheticMethod(
            canonicalStatic: true,
            canonicalOptional: true,
          ),
    ),
  ];
  for (final testCase in rawCanonicalCases) {
    test('rejects divergent raw and canonical ${testCase.name}', () {
      final inventory = _inventory(['interface:vscode.Known']);
      (inventory['declarations']! as List<Object?>).add(
        testCase.declaration(),
      );

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
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                contains('canonicalSignature'),
              ),
        ),
      );
    });
  }

  test('rejects divergent raw and canonical nested function types', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final declarations = inventory['declarations']! as List<Object?>;
    final functionType = <String, Object?>{
      'kind': 'function',
      'typeParameters': <Object?>[],
      'parameters': [
        _rawParameter('value', {'kind': 'primitive', 'name': 'string'}),
      ],
      'returnType': {'kind': 'primitive', 'name': 'void'},
    };
    functionType['canonicalSignature'] = jsonEncode({
      'typeParameters': <Object?>[],
      'parameters': [
        _canonicalParameter({'kind': 'primitive', 'name': 'number'}),
      ],
      'returnType': {'kind': 'primitive', 'name': 'void'},
    });
    declarations.add({
      'id': r'property:interface:vscode.Known/$instance/callback',
      'kind': 'property',
      'name': 'callback',
      'qualifiedName': 'vscode.Known.callback',
      'parentId': 'interface:vscode.Known',
      'deprecated': false,
      'visibility': 'public',
      'optional': false,
      'readonly': false,
      'static': false,
      'abstract': false,
      'type': functionType,
      'coverage': _pendingCoverage(),
    });

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('canonicalSignature'),
            ),
      ),
    );
  });

  test('rejects canonical type-parameter indexes outside their scope', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final signature = jsonEncode({
      'typeParameters': <Object?>[<String, Object?>{}],
      'parameters': <Object?>[],
      'returnType': {'kind': 'typeParameter', 'index': 1},
      'static': false,
      'optional': false,
    });
    (inventory['declarations']! as List<Object?>).add({
      'id': 'method:vscode.Known.synthetic@${_sha256String(signature)}',
      'kind': 'method',
      'name': 'synthetic',
      'qualifiedName': 'vscode.Known.synthetic',
      'parentId': 'interface:vscode.Known',
      'deprecated': false,
      'visibility': 'public',
      'overloadOrdinal': 0,
      'canonicalSignature': signature,
      'typeParameters': [
        <String, Object?>{'name': 'T'},
      ],
      'parameters': <Object?>[],
      'returnType': {
        'kind': 'reference',
        'name': 'T',
        'typeArguments': <Object?>[],
      },
      'static': false,
      'optional': false,
      'abstract': false,
      'coverage': _pendingCoverage(),
    });

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('typeParameter'), contains('index')),
            ),
      ),
    );
  });

  test('rejects canonical outer type-parameter depths outside their scope', () {
    final inventory = _inventory(['interface:vscode.Box']);
    final declarations = inventory['declarations']! as List<Object?>;
    final parent = declarations.single! as Map<String, Object?>;
    parent['typeParameters'] = [
      <String, Object?>{'name': 'T'},
    ];
    final signature = jsonEncode({
      'typeParameters': <Object?>[],
      'parameters': <Object?>[],
      'returnType': {
        'kind': 'outerTypeParameter',
        'depth': 2,
        'index': 0,
      },
      'static': false,
      'optional': false,
    });
    declarations.add({
      'id': 'method:vscode.Box.synthetic@${_sha256String(signature)}',
      'kind': 'method',
      'name': 'synthetic',
      'qualifiedName': 'vscode.Box.synthetic',
      'parentId': 'interface:vscode.Box',
      'deprecated': false,
      'visibility': 'public',
      'overloadOrdinal': 0,
      'canonicalSignature': signature,
      'typeParameters': <Object?>[],
      'parameters': <Object?>[],
      'returnType': {
        'kind': 'reference',
        'name': 'T',
        'typeArguments': <Object?>[],
      },
      'static': false,
      'optional': false,
      'abstract': false,
      'coverage': _pendingCoverage(),
    });
    final overrides = _schemaOverrideFor(parent);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('outerTypeParameter'), contains('depth')),
            ),
      ),
    );
  });

  test('rejects registered type-literal references without declarations', () {
    final inventory = _inventory(['interface:vscode.Known']);
    (inventory['declarations']! as List<Object?>).add({
      'id': r'property:interface:vscode.Known/$instance/options',
      'kind': 'property',
      'name': 'options',
      'qualifiedName': 'vscode.Known.options',
      'parentId': 'interface:vscode.Known',
      'deprecated': false,
      'visibility': 'public',
      'optional': false,
      'readonly': false,
      'static': false,
      'abstract': false,
      'type': {
        'kind': 'typeLiteral',
        'id': 'typeLiteral:missing',
        'shapeHash': '0' * 64,
      },
      'coverage': _pendingCoverage(),
    });

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('typeLiteral:missing'), contains('declaration')),
            ),
      ),
    );
  });

  test('rejects registered type-literal declarations without inbound refs', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final orphanShape = <String, Object?>{'members': <Object?>[]};
    final hash = _shapeHash(orphanShape);
    (inventory['declarations']! as List<Object?>)
      ..add({
        'id': 'typeAlias:vscode.OrphanOwner',
        'kind': 'typeAlias',
        'name': 'OrphanOwner',
        'qualifiedName': 'vscode.OrphanOwner',
        'parentId': 'module:vscode',
        'deprecated': false,
        'visibility': 'public',
        'typeParameters': <Object?>[],
        'type': {'kind': 'primitive', 'name': 'string'},
        'coverage': _pendingCoverage(),
      })
      ..add({
        'id': 'typeLiteral:typeAlias:vscode.OrphanOwner/\$shape@$hash',
        'kind': 'typeLiteral',
        'name': r'$type',
        'qualifiedName': 'typeAlias:vscode.OrphanOwner.\$shape@$hash',
        'parentId': 'typeAlias:vscode.OrphanOwner',
        'deprecated': false,
        'visibility': 'public',
        'shapeHash': hash,
        'shape': orphanShape,
        'coverage': _pendingCoverage(),
      });
    _sortDeclarationsLikeProducer(inventory);

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('typeLiteral'), contains('inbound')),
            ),
      ),
    );
  });

  test('rejects declaration arrays outside producer sort order', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = inventory['declarations']! as List<Object?>;
    final first = declarations[0];
    declarations[0] = declarations[1];
    declarations[1] = first;

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('sort order'),
            ),
      ),
    );
  });

  final incompatibleParentCases = <(String, String, String)>[
    ('constructor', 'constructor', 'interface:vscode.AuthenticationProvider'),
    ('enum member', 'enumMember', 'class:vscode.BranchCoverage'),
    ('property', 'property', 'enum:vscode.ChatResultFeedbackKind'),
    ('method', 'method', 'enum:vscode.ChatResultFeedbackKind'),
  ];
  for (final testCase in incompatibleParentCases) {
    test('rejects ${testCase.$1} declarations under incompatible parents', () {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final declaration = _unselectedDeclarationOfKind(
        inventory,
        testCase.$2,
      );
      _reanchorDeclaration(inventory, declaration, testCase.$3);
      _sortDeclarationsLikeProducer(inventory);

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
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                contains('parentId'),
              ),
        ),
      );
    });
  }

  test('rejects non-public top-level producer declarations', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    _unselectedDeclarationOfKind(inventory, 'interface')
      ..['visibility'] = 'private'
      ..['coverage'] = {
        'discovery': 'discovered',
        'semantics': 'excluded',
        'binding': 'excluded',
        'host': 'notApplicable',
      };

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('visibility'),
            ),
      ),
    );
  });

  test('rejects variable constant flags detached from declarationKind', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final declaration = declarations.firstWhere(
      (candidate) => candidate['declarationKind'] == 'let',
    );
    declaration['constant'] = true;

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('constant'), contains('declarationKind')),
            ),
      ),
    );
  });

  test('rejects non-reference heritage nodes', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final targets = (_readJson(
      'tool/bindings/overrides/vscode-1.129.1.json',
    )['targets']! as List<Object?>)
        .cast<String>()
        .toSet();
    final declaration = declarations.firstWhere(
      (candidate) =>
          candidate['kind'] == 'interface' &&
          (candidate['extends']! as List<Object?>).isNotEmpty &&
          !targets.contains(candidate['id']),
    );
    (declaration['extends']! as List<Object?>).first = {
      'kind': 'primitive',
      'name': 'string',
    };

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('extends'), contains('reference')),
            ),
      ),
    );
  });

  test('rejects overload ordinals outside producer group order', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declaration = _soleUnselectedCallable(inventory);
    declaration['overloadOrdinal'] = 99;

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('overloadOrdinal'),
            ),
      ),
    );
  });

  final contextFlagCases = <(String, String)>[
    ('static', 'property'),
    ('abstract', 'method'),
  ];
  for (final testCase in contextFlagCases) {
    test('rejects ${testCase.$1} ${testCase.$2}s in interface contexts', () {
      final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
      final declarations = (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>();
      final declaration = declarations.firstWhere((candidate) {
        if (candidate['kind'] != testCase.$2) {
          return false;
        }
        return declarations.any(
          (parent) =>
              parent['id'] == candidate['parentId'] &&
              parent['kind'] == 'interface',
        );
      });
      declaration[testCase.$1] = true;

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
                'INVALID_GENERATOR_INPUT',
              )
              .having(
                (error) => error.message,
                'message',
                contains(testCase.$1),
              ),
        ),
      );
    });
  }

  test('rejects interface members that do not inherit visibility', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    declarations.firstWhere(
      (candidate) =>
          candidate['kind'] == 'method' &&
          declarations.any(
            (parent) =>
                parent['id'] == candidate['parentId'] &&
                parent['kind'] == 'interface',
          ),
    )
      ..['visibility'] = 'private'
      ..['coverage'] = {
        'discovery': 'discovered',
        'semantics': 'excluded',
        'binding': 'excluded',
        'host': 'notApplicable',
      };

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('visibility'),
            ),
      ),
    );
  });

  test('rejects registered type literals that do not inherit owner visibility',
      () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    declarations.firstWhere(
      (candidate) => candidate['kind'] == 'typeLiteral',
    )
      ..['visibility'] = 'private'
      ..['coverage'] = {
        'discovery': 'discovered',
        'semantics': 'excluded',
        'binding': 'excluded',
        'host': 'notApplicable',
      };

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('visibility'),
            ),
      ),
    );
  });

  test('rejects registered type-literal references rebound to other owners',
      () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final pair = _sameShapeTypeLiteralReferencePair(inventory);
    pair.first['id'] = pair.second['id'];

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('typeLiteral'), contains('owner')),
            ),
      ),
    );
  });

  test('rejects type-literal child shapes detached from parent shapeHash', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final pair = _singlePropertyTypeLiteral(inventory);
    pair.child['readonly'] = !(pair.child['readonly']! as bool);

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('shapeHash'), contains('children')),
            ),
      ),
    );
  });

  test('requires registered type-literal declarations to carry their shape',
      () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final pair = _singlePropertyTypeLiteral(inventory);
    pair.parent.remove('shape');

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('shape'),
            ),
      ),
    );
  });

  test('recomputes multi-member type-literal shape hashes from children', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final child = _multiPropertyTypeLiteralChild(inventory);
    child['readonly'] = !(child['readonly']! as bool);

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('shapeHash'), contains('children')),
            ),
      ),
    );
  });

  test('recomputes type-literal shape hashes over signature children', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    _tamperSignatureChildOfTypeLiteral(inventory);

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('shapeHash'), contains('children')),
            ),
      ),
    );
  });

  test('rejects detached properties typed by registered literals', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final child = _registeredLiteralTypedPropertyChild(inventory);
    child['optional'] = !(child['optional']! as bool);

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
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('shapeHash'), contains('children')),
            ),
      ),
    );
  });

  test('rejects registered shape members with malformed values', () {
    final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');
    final overrides = _readJson('tool/bindings/overrides/vscode-1.129.1.json');
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final literal = declarations
        .firstWhere(
          (candidate) =>
              candidate['kind'] == 'typeLiteral' &&
              declarations.any(
                (child) =>
                    child['parentId'] == candidate['id'] &&
                    child['kind'] == 'method',
              ),
        )
        .cast<String, Object?>();
    final shape = (jsonDecode(jsonEncode(literal['shape']))
            as Map<Object?, Object?>)
        .cast<String, Object?>();
    final members = (shape['members']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    members.firstWhere((member) => member['kind'] == 'method')['name'] = null;
    literal['shape'] = shape;
    final shapeHash = _shapeHash(shape);
    final oldId = literal['id']! as String;
    literal['shapeHash'] = shapeHash;
    _replaceRegisteredTypeLiteralShapeHash(inventory, oldId, shapeHash);
    _reindexProducerSubtree(inventory, overrides, oldId);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _readJson('test/fixtures/host_extension/extension.json'),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              contains('unsupported member schema'),
            ),
      ),
    );
  });

  test('rejects out-of-scope canonical refs in inline generic shapes', () {
    final inventory = _inventory(['interface:vscode.Box']);
    final declaration = (inventory['declarations']! as List<Object?>).single!
        as Map<String, Object?>;
    final shape = <String, Object?>{
      'members': [
        {
          'kind': 'property',
          'name': 'value',
          'optional': false,
          'readonly': false,
          'type': {'kind': 'typeParameter', 'index': 1},
        },
      ],
    };
    declaration['typeParameters'] = [
      {
        'name': 'T',
        'constraint': {
          'kind': 'typeLiteral',
          'shape': shape,
          'shapeHash': _shapeHash(shape),
        },
      },
    ];
    final overrides = _schemaOverrideFor(declaration);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _project(),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
            .having(
              (error) => error.message,
              'message',
              allOf(contains('typeParameter'), contains('index')),
            ),
      ),
    );
  });

  test('accepts raw types in unscoped inline type-literal shapes', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final declaration = (inventory['declarations']! as List<Object?>).single!
        as Map<String, Object?>;
    final optionsShape = <String, Object?>{
      'members': [
        {
          'kind': 'property',
          'name': 'enabled',
          'optional': false,
          'readonly': false,
          'type': {'kind': 'primitive', 'name': 'boolean'},
        },
      ],
    };
    final outerShape = <String, Object?>{
      'members': [
        {
          'kind': 'property',
          'name': 'value',
          'optional': false,
          'readonly': false,
          'type': {
            'kind': 'tuple',
            'elements': [
              {
                'name': 'callback',
                'optional': false,
                'rest': false,
                'type': {
                  'kind': 'function',
                  'typeParameters': <Object?>[],
                  'parameters': <Object?>[],
                  'returnType': {'kind': 'primitive', 'name': 'void'},
                  'canonicalSignature': jsonEncode({
                    'typeParameters': <Object?>[],
                    'parameters': <Object?>[],
                    'returnType': {'kind': 'primitive', 'name': 'void'},
                  }),
                },
              },
              {
                'name': 'options',
                'optional': false,
                'rest': false,
                'type': {
                  'kind': 'typeLiteral',
                  'shapeHash': _shapeHash(optionsShape),
                  'shape': optionsShape,
                },
              },
            ],
          },
        },
      ],
    };
    declaration['extends'] = [
      {
        'kind': 'reference',
        'name': 'Base',
        'typeArguments': [
          {
            'kind': 'typeLiteral',
            'shapeHash': _shapeHash(outerShape),
            'shape': outerShape,
          },
        ],
      },
    ];
    final overrides = _overrides({
      'interface:vscode.Known': 'opaqueJsObject',
    });
    final entry = ((overrides['entries']!
                as Map<Object?, Object?>)['interface:vscode.Known']!
            as Map<Object?, Object?>)
        .cast<String, Object?>();
    entry['declarationSha256'] = computeDeclarationFingerprint(declaration);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _project(),
      ),
      returnsNormally,
    );
  });

  test('accepts canonical type parameters in scoped inline shapes', () {
    final inventory = _inventory(['interface:vscode.Known']);
    final declaration = (inventory['declarations']! as List<Object?>).single!
        as Map<String, Object?>;
    final shape = <String, Object?>{
      'members': [
        {
          'kind': 'property',
          'name': 'value',
          'optional': false,
          'readonly': false,
          'type': {'kind': 'typeParameter', 'index': 0},
        },
      ],
    };
    declaration['typeParameters'] = [
      {
        'name': 'T',
        'constraint': {
          'kind': 'typeLiteral',
          'shapeHash': _shapeHash(shape),
          'shape': shape,
        },
      },
    ];
    final overrides = _overrides({
      'interface:vscode.Known': 'opaqueJsObject',
    });
    final entry = ((overrides['entries']!
                as Map<Object?, Object?>)['interface:vscode.Known']!
            as Map<Object?, Object?>)
        .cast<String, Object?>();
    entry['declarationSha256'] = computeDeclarationFingerprint(declaration);

    expect(
      () => VSCodeBindingGenerator().generate(
        inventory: inventory,
        overrides: overrides,
        project: _project(),
      ),
      returnsNormally,
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
      'product': {
        'name': 'Visual Studio Code',
        'version': '1.129.1',
        'commit': '0' * 40,
      },
      'parser': {'name': 'typescript', 'version': 'test'},
      'inputSha256':
          'ee11e767c8ab76f6c0de8dc88222796147a6f0bc82f3a1ec644e41b39b52f2cd',
      'manifestSchema': {
        'schemaUri': 'vscode://schemas/vscode-extensions',
        'standalone': false,
        'composition': 'Contributions are composed at runtime.',
      },
      'inputs': [
        {
          'name': 'VS Code API declarations',
          'kind': 'apiDeclarations',
          'path': 'vscode.d.ts',
          'version': '1.129.1',
          'commit': '0' * 40,
          'source': 'https://raw.githubusercontent.com/microsoft/vscode/'
              '${'0' * 40}/src/vscode-dts/vscode.d.ts',
          'sha256':
              'ee11e767c8ab76f6c0de8dc88222796147a6f0bc82f3a1ec644e41b39b52f2cd',
          'license': 'MIT',
          'licensePath': 'LICENSE.txt',
        },
        {
          'name': 'VS Code extension manifest schema source',
          'kind': 'extensionManifestSchemaSource',
          'path': 'extension-manifest-schema.ts',
          'version': '1.129.1',
          'commit': '0' * 40,
          'source': 'https://raw.githubusercontent.com/microsoft/vscode/'
              '${'0' * 40}/src/vs/workbench/services/extensions/common/'
              'extensionsRegistry.ts',
          'sha256':
              'feddc98984b755a95644674910aa8c671e3259f137698c581ec7e2837cb058aa',
          'license': 'MIT',
          'licensePath': 'LICENSE.txt',
        },
        {
          'name': 'VS Code extension manifest validator source',
          'kind': 'extensionManifestValidatorSource',
          'path': 'extension-validator.ts',
          'version': '1.129.1',
          'commit': '0' * 40,
          'source': 'https://raw.githubusercontent.com/microsoft/vscode/'
              '${'0' * 40}/src/vs/platform/extensions/common/'
              'extensionValidator.ts',
          'sha256':
              'e8ae92aa491ab138b6f625acbbcbd7c53ff187098066ff13aebb64615202dde1',
          'license': 'MIT',
          'licensePath': 'LICENSE.txt',
        },
        {
          'name': 'VS Code commands contribution schema source',
          'kind': 'contributionSchemaSource',
          'path': 'menusExtensionPoint.ts',
          'version': '1.129.1',
          'commit': '0' * 40,
          'source': 'https://raw.githubusercontent.com/microsoft/vscode/'
              '${'0' * 40}/src/vs/workbench/services/actions/common/'
              'menusExtensionPoint.ts',
          'sha256':
              'a85c943ae42b2cdef0403070f78cfb9dbe7bcdc1fce7c57bf9ca2234d1e36a33',
          'license': 'MIT',
          'licensePath': 'LICENSE.txt',
        },
        {
          'name': 'VS Code string validation helper source',
          'kind': 'contributionValidationHelperSource',
          'path': 'strings.ts',
          'version': '1.129.1',
          'commit': '0' * 40,
          'source': 'https://raw.githubusercontent.com/microsoft/vscode/'
              '${'0' * 40}/src/vs/base/common/strings.ts',
          'sha256':
              'c65ae37d623cf8a1dd0a5083cbb3f09f3433342accdc220c6bb8076aa12a1eec',
          'license': 'MIT',
          'licensePath': 'LICENSE.txt',
        },
        {
          'name': 'VS Code license',
          'kind': 'license',
          'path': 'LICENSE.txt',
          'version': '1.129.1',
          'commit': '0' * 40,
          'source': 'https://raw.githubusercontent.com/microsoft/vscode/'
              '${'0' * 40}/LICENSE.txt',
          'sha256':
              '9480271317925265e806a9a196aaa33410a962fa9d4d1e248a4a5187bc8c9df9',
          'license': 'MIT',
        },
      ],
      'contributionSchemas': ['commands'],
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
      'generatedManifestRules': [
        {'path': 'publisher', 'presence': 'optional', 'type': 'string'},
        {'path': 'name', 'presence': 'required', 'type': 'string'},
        {'path': 'version', 'presence': 'required', 'type': 'string'},
        {'path': 'engines', 'presence': 'required', 'type': 'object'},
        {
          'path': 'engines.vscode',
          'presence': 'required',
          'type': 'string',
        },
        {
          'path': 'activationEvents',
          'presence': 'optional',
          'type': 'string[]',
          'requiresAny': ['main', 'browser'],
        },
        {'path': 'main', 'presence': 'optional', 'type': 'string'},
      ],
      'versionPredicate': 'semver.valid',
      'engineVersionSyntax': {
        'source': r'^(\^|>=)?((\d+)|x)\.((\d+)|x)\.((\d+)|x)(\-.*)?$',
        'flags': '',
      },
      'validatorBodySha256':
          'a7df6554afff3fa5c5e021f793fc8a4662fc641ade451565a8ff59929cf5a171',
      'projectionLimits': {
        'remainingValidatorBranches': 'integrityPinnedByValidatorBodySha256',
        'semverValidImplementation': 'unprojectedExternal',
      },
    },
    'contributionSchemas': {
      'commands': {
        'inputSha256':
            'a85c943ae42b2cdef0403070f78cfb9dbe7bcdc1fce7c57bf9ca2234d1e36a33',
        'extensionPoint': 'commands',
        'accepts': ['object', 'array'],
        'itemSchema': {
          'type': 'object',
          'required': ['command', 'title'],
          'properties': {
            'category': {'type': 'string'},
            'command': {'type': 'string'},
            'enablement': {'type': 'string'},
            'icon': {
              'anyOf': [
                {'type': 'string'},
                {
                  'type': 'object',
                  'properties': {
                    'dark': {'type': 'string'},
                    'light': {'type': 'string'},
                  },
                },
              ],
            },
            'shortTitle': {'type': 'string'},
            'title': {'type': 'string'},
          },
        },
        'validation': {
          'whitespacePredicate': 'ecmascript-trim-empty',
          'nonWhitespaceStringProperties': ['command', 'title'],
          'icon': {
            'objectRequiredStringProperties': ['dark', 'light'],
          },
        },
      },
    },
    'module': {'id': 'module:vscode', 'name': 'vscode'},
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
  String commandsContributionSchemaSha256 =
      'a85c943ae42b2cdef0403070f78cfb9dbe7bcdc1fce7c57bf9ca2234d1e36a33',
  List<String>? targets,
}) {
  return {
    'schemaVersion': 1,
    'vscodeVersion': vscodeVersion,
    'manifestSchemaSha256': manifestSchemaSha256,
    'manifestValidatorSha256': manifestValidatorSha256,
    'commandsContributionSchemaSha256': commandsContributionSchemaSha256,
    'hostContracts': {
      'testExtensionHost': {
        'boundary': 'vscodeExtensionHost',
        'artifact': 'tool/bindings/contracts/test-extension-host.json',
        'artifactSha256':
            '0000000000000000000000000000000000000000000000000000000000000000',
      },
    },
    'targets': targets ?? strategies.keys.toList(),
    'entries': {
      for (final entry in strategies.entries)
        entry.key: {
          'strategy': entry.value,
          'declarationSha256': computeDeclarationFingerprint(
            _testDeclaration(entry.key),
          ),
          if (entry.value != 'reviewedExcluded')
            'hostContract': 'testExtensionHost',
        },
    },
  };
}

Map<String, Object?> _testDeclaration(String id) {
  return {
    'id': id,
    'kind': 'interface',
    'name': id.substring(id.lastIndexOf('.') + 1),
    'qualifiedName': id.substring(id.indexOf(':') + 1),
    'parentId': 'module:vscode',
    'deprecated': false,
    'typeParameters': <Object?>[],
    'extends': <Object?>[],
    'visibility': 'public',
    'coverage': {
      'discovery': 'discovered',
      'semantics': 'pending',
      'binding': 'pending',
      'host': 'pending',
    },
  };
}

Map<String, Object?> _pendingCoverage() {
  return {
    'discovery': 'discovered',
    'semantics': 'pending',
    'binding': 'pending',
    'host': 'pending',
  };
}

String _sha256String(String value) {
  return crypto.sha256.convert(utf8.encode(value)).toString();
}

String _shapeHash(Map<String, Object?> shape) {
  return _sha256String(jsonEncode(shape));
}

Map<String, Object?> _schemaOverrideFor(
  Map<String, Object?> declaration,
) {
  final id = declaration['id']! as String;
  final overrides = _overrides({id: 'opaqueJsObject'});
  final entry = ((overrides['entries']! as Map<Object?, Object?>)[id]!
          as Map<Object?, Object?>)
      .cast<String, Object?>();
  entry['declarationSha256'] = computeDeclarationFingerprint(declaration);
  return overrides;
}

Map<String, Object?> _sourceInput(
  Map<String, Object?> inventory,
  String kind,
) {
  final source =
      (inventory['source']! as Map<Object?, Object?>).cast<String, Object?>();
  final inputs =
      (source['inputs']! as List<Object?>).cast<Map<Object?, Object?>>();
  return inputs
      .singleWhere((candidate) => candidate['kind'] == kind)
      .cast<String, Object?>();
}

Map<String, Object?> _unselectedCallable(Map<String, Object?> inventory) {
  final override = _readJson(
    'tool/bindings/overrides/vscode-1.129.1.json',
  );
  final targets =
      (override['targets']! as List<Object?>).cast<String>().toSet();
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  return declarations
      .firstWhere(
        (candidate) =>
            const {
              'function',
              'constructor',
              'callSignature',
              'method',
              'indexSignature',
            }.contains(candidate['kind']) &&
            !targets.contains(candidate['id']),
      )
      .cast<String, Object?>();
}

Map<String, Object?> _unselectedDeclarationOfKind(
  Map<String, Object?> inventory,
  String kind,
) {
  final override = _readJson(
    'tool/bindings/overrides/vscode-1.129.1.json',
  );
  final targets =
      (override['targets']! as List<Object?>).cast<String>().toSet();
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final matches = declarations.where(
    (candidate) =>
        candidate['kind'] == kind && !targets.contains(candidate['id']),
  );
  if (matches.isNotEmpty) {
    return matches.first.cast<String, Object?>();
  }
  if (kind != 'callSignature') {
    throw StateError('No unselected $kind declaration.');
  }
  final occupiedParents = declarations
      .where((candidate) => candidate['kind'] == 'callSignature')
      .map((candidate) => candidate['parentId'])
      .toSet();
  final parent = declarations.firstWhere(
    (candidate) =>
        candidate['kind'] == 'interface' &&
        !targets.contains(candidate['id']) &&
        !occupiedParents.contains(candidate['id']),
  );
  final template = declarations.firstWhere(
    (candidate) => candidate['kind'] == 'callSignature',
  );
  final clone = (jsonDecode(jsonEncode(template)) as Map<Object?, Object?>)
      .cast<String, Object?>();
  final parentId = parent['id']! as String;
  final qualifiedName = '${parent['qualifiedName']}.\$call';
  clone
    ..['parentId'] = parentId
    ..['qualifiedName'] = qualifiedName
    ..['visibility'] = parent['visibility']
    ..['coverage'] = _pendingCoverage()
    ..remove('occurrenceCount');
  clone['id'] = 'callSignature:$qualifiedName@'
      '${_sha256String(clone['canonicalSignature']! as String)}';
  (inventory['declarations']! as List<Object?>).add(clone);
  _sortDeclarationsLikeProducer(inventory);
  return clone;
}

Map<String, Object?> _rawParameter(
  String name,
  Map<String, Object?> type,
) {
  return {
    'name': name,
    'optional': false,
    'rest': false,
    'type': type,
  };
}

Map<String, Object?> _canonicalParameter(Map<String, Object?> type) {
  return {'optional': false, 'rest': false, 'type': type};
}

Map<String, Object?> _syntheticMethod({
  List<Object?> rawTypeParameters = const [],
  List<Object?>? canonicalTypeParameters,
  List<Object?> rawParameters = const [],
  List<Object?>? canonicalParameters,
  Map<String, Object?> rawReturnType = const {
    'kind': 'primitive',
    'name': 'void',
  },
  Map<String, Object?>? canonicalReturnType,
  bool staticMember = false,
  bool optional = false,
  bool? canonicalStatic,
  bool? canonicalOptional,
}) {
  final canonicalSignature = jsonEncode({
    'typeParameters': canonicalTypeParameters ?? <Object?>[],
    'parameters': canonicalParameters ?? <Object?>[],
    'returnType': canonicalReturnType ?? rawReturnType,
    'static': canonicalStatic ?? staticMember,
    'optional': canonicalOptional ?? optional,
  });
  return {
    'id': 'method:vscode.Known.synthetic@'
        '${_sha256String(canonicalSignature)}',
    'kind': 'method',
    'name': 'synthetic',
    'qualifiedName': 'vscode.Known.synthetic',
    'parentId': 'interface:vscode.Known',
    'deprecated': false,
    'visibility': 'public',
    'overloadOrdinal': 0,
    'canonicalSignature': canonicalSignature,
    'typeParameters': rawTypeParameters,
    'parameters': rawParameters,
    'returnType': rawReturnType,
    'static': staticMember,
    'optional': optional,
    'abstract': false,
    'coverage': _pendingCoverage(),
  };
}

void _reanchorDeclaration(
  Map<String, Object?> inventory,
  Map<String, Object?> declaration,
  String parentId,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final parent = declarations.singleWhere(
    (candidate) => candidate['id'] == parentId,
  );
  final name = declaration['name']! as String;
  final qualifiedName = '${parent['qualifiedName']}.$name';
  declaration
    ..['parentId'] = parentId
    ..['qualifiedName'] = qualifiedName;
  final kind = declaration['kind']! as String;
  declaration['id'] = switch (kind) {
    'constructor' ||
    'method' =>
      '$kind:$qualifiedName@${_sha256String(declaration['canonicalSignature']! as String)}',
    'enumMember' => 'enumMember:$parentId/${Uri.encodeComponent(name)}',
    'property' =>
      'property:$parentId/${declaration['static'] == true ? r'$static' : r'$instance'}/${Uri.encodeComponent(name)}',
    _ => throw StateError('unsupported fixture kind $kind'),
  };
}

String _renameProducerDeclaration(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
  String declarationId,
  String name,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  declarations.singleWhere(
    (candidate) => candidate['id'] == declarationId,
  )['name'] = name;
  final renamedId = _reindexProducerSubtree(
    inventory,
    overrides,
    declarationId,
  )[declarationId]!;
  return _resynchronizeAncestorTypeLiterals(
    inventory,
    overrides,
    renamedId,
  );
}

String _resynchronizeAncestorTypeLiterals(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
  String declarationId,
) {
  const callableKinds = {
    'function',
    'constructor',
    'callSignature',
    'method',
    'indexSignature',
  };
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final tracked = declarations.singleWhere(
    (candidate) => candidate['id'] == declarationId,
  );
  var changed = true;
  var guard = 0;
  while (changed) {
    if (guard++ > 64) {
      throw StateError('Ancestor type-literal resynchronization diverged.');
    }
    changed = false;
    final byId = <String, Map<Object?, Object?>>{
      for (final candidate in declarations) candidate['id']! as String: candidate,
    };
    final declarationsById = <String, Map<String, Object?>>{
      for (final candidate in declarations)
        candidate['id']! as String: candidate.cast<String, Object?>(),
    };
    final childrenByParent = <String, List<Map<Object?, Object?>>>{};
    for (final declaration in declarations) {
      childrenByParent
          .putIfAbsent(declaration['parentId']! as String, () => [])
          .add(declaration);
    }
    var node = byId[tracked['parentId']];
    while (node != null) {
      if (node['kind'] == 'typeLiteral') {
        final literal = node.cast<String, Object?>();
        final shape = _rebuildFixtureTypeLiteralShape(
          literal,
          childrenByParent[literal['id']] ?? const [],
          declarationsById,
        );
        final shapeHash = _shapeHash(shape);
        if (jsonEncode(literal['shape']) != jsonEncode(shape) ||
            literal['shapeHash'] != shapeHash) {
          final oldId = literal['id']! as String;
          literal['shape'] = shape;
          if (literal['shapeHash'] != shapeHash) {
            literal['shapeHash'] = shapeHash;
            _replaceRegisteredTypeLiteralShapeHash(
              inventory,
              oldId,
              shapeHash,
            );
            _reindexProducerSubtree(inventory, overrides, oldId);
          }
          changed = true;
          break;
        }
      } else if (callableKinds.contains(node['kind'])) {
        final callable = node.cast<String, Object?>();
        final expected = _fixtureCanonicalSignature(
          callable,
          _fixtureInheritedScopes(callable, declarationsById),
        );
        if (callable['canonicalSignature'] != expected) {
          callable['canonicalSignature'] = expected;
          _reindexProducerSubtree(
            inventory,
            overrides,
            callable['id']! as String,
          );
          changed = true;
          break;
        }
      }
      node = byId[node['parentId']];
    }
  }
  _refreshOverrideFingerprints(inventory, overrides);
  _sortDeclarationsLikeProducer(inventory);
  return tracked['id']! as String;
}

String _synchronizeCallableProducerEncoding(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
  String declarationId,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final declaration = declarations
      .singleWhere((candidate) => candidate['id'] == declarationId)
      .cast<String, Object?>();
  final declarationsById = <String, Map<String, Object?>>{
    for (final candidate in declarations)
      candidate['id']! as String: candidate.cast<String, Object?>(),
  };
  declaration['canonicalSignature'] = _fixtureCanonicalSignature(
    declaration,
    _fixtureInheritedScopes(declaration, declarationsById),
  );
  final refreshedId = _reindexProducerSubtree(
    inventory,
    overrides,
    declarationId,
  )[declarationId]!;
  return _resynchronizeAncestorTypeLiterals(
    inventory,
    overrides,
    refreshedId,
  );
}

String _synchronizeProducerMutation(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
  String declarationId,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final declaration = declarations.singleWhere(
    (candidate) => candidate['id'] == declarationId,
  );
  if (const {
    'function',
    'constructor',
    'callSignature',
    'method',
    'indexSignature',
  }.contains(declaration['kind'])) {
    return _synchronizeCallableProducerEncoding(
      inventory,
      overrides,
      declarationId,
    );
  }
  _synchronizeDescendantProducerEncodings(
    inventory,
    overrides,
    declarationId,
  );
  _refreshOverrideFingerprints(inventory, overrides);
  _sortDeclarationsLikeProducer(inventory);
  return declarationId;
}

void _synchronizeDescendantProducerEncodings(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
  String rootId,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final childrenByParent = <String, List<Map<Object?, Object?>>>{};
  for (final declaration in declarations) {
    childrenByParent
        .putIfAbsent(declaration['parentId']! as String, () => [])
        .add(declaration);
  }
  final descendants = <Map<Object?, Object?>>[];
  final pending = <Map<Object?, Object?>>[
    ...?childrenByParent[rootId],
  ];
  while (pending.isNotEmpty) {
    final declaration = pending.removeAt(0);
    descendants.add(declaration);
    pending.addAll(
      childrenByParent[declaration['id']] ?? const <Map<Object?, Object?>>[],
    );
  }

  final declarationsById = <String, Map<String, Object?>>{
    for (final declaration in declarations)
      declaration['id']! as String: declaration.cast<String, Object?>(),
  };
  final changedTypeLiterals = <Map<Object?, Object?>>[];
  for (final typeLiteral in descendants.reversed
      .where((candidate) => candidate['kind'] == 'typeLiteral')) {
    final literal = typeLiteral.cast<String, Object?>();
    final shape = _rebuildFixtureTypeLiteralShape(
      literal,
      childrenByParent[literal['id']] ?? const [],
      declarationsById,
    );
    literal['shape'] = shape;
    final shapeHash = _shapeHash(shape);
    if (shapeHash == typeLiteral['shapeHash']) {
      continue;
    }
    final oldId = typeLiteral['id']! as String;
    typeLiteral['shapeHash'] = shapeHash;
    _replaceRegisteredTypeLiteralShapeHash(inventory, oldId, shapeHash);
    changedTypeLiterals.add(typeLiteral);
  }

  const callableKinds = {
    'function',
    'constructor',
    'callSignature',
    'method',
    'indexSignature',
  };
  final callableDescendants = descendants
      .where((candidate) => callableKinds.contains(candidate['kind']))
      .toList();
  for (final typeLiteral in changedTypeLiterals) {
    var parentId = typeLiteral['parentId']! as String;
    var hasCallableAncestor = false;
    while (parentId != rootId && declarationsById[parentId] != null) {
      final parent = declarationsById[parentId]!;
      if (callableKinds.contains(parent['kind'])) {
        hasCallableAncestor = true;
        break;
      }
      parentId = parent['parentId']! as String;
    }
    if (!hasCallableAncestor) {
      _refreshProducerIdentity(
        inventory,
        overrides,
        typeLiteral['id']! as String,
      );
    }
  }
  for (final callable in callableDescendants) {
    _synchronizeCallableProducerEncoding(
      inventory,
      overrides,
      callable['id']! as String,
    );
  }
}

Map<String, Object?> _matchFixtureShapeChild(
  List<Map<Object?, Object?>> children,
  Set<Map<Object?, Object?>> used,
  String kind,
  Object? name,
  int? ordinal,
) {
  final sameKind = children
      .where((candidate) => candidate['kind'] == kind && !used.contains(candidate))
      .toList();
  var matches = sameKind
      .where(
        (candidate) =>
            (name == null || candidate['name'] == name) &&
            (ordinal == null || candidate['overloadOrdinal'] == ordinal),
      )
      .toList();
  if (matches.isEmpty && sameKind.length == 1) {
    matches = sameKind;
  }
  if (matches.length != 1) {
    throw StateError('No unique $kind child for fixture shape member $name.');
  }
  used.add(matches.single);
  return matches.single.cast<String, Object?>();
}

Map<String, Object?> _rebuildFixtureTypeLiteralShape(
  Map<String, Object?> literal,
  List<Map<Object?, Object?>> children,
  Map<String, Map<String, Object?>> declarationsById,
) {
  final oldMembers = [
    for (final member
        in (literal['shape']! as Map<Object?, Object?>)['members']!
            as List<Object?>)
      (member! as Map<Object?, Object?>).cast<String, Object?>(),
  ];
  final ordinals = <String, int>{};
  final members = <Object?>[];
  final used = <Map<Object?, Object?>>{};
  for (final oldMember in oldMembers) {
    final kind = oldMember['kind']! as String;
    if (kind == 'property') {
      final child = _matchFixtureShapeChild(
        children,
        used,
        'property',
        oldMember['name'],
        null,
      );
      final scopes = _fixtureInheritedScopes(child, declarationsById);
      final rawType = child['type'];
      members.add(<String, Object?>{
        'kind': 'property',
        'name': child['name'],
        'optional': child['optional'],
        'readonly': child['readonly'],
        'type': scopes.any((scope) => scope.isNotEmpty)
            ? _fixtureCanonicalType(rawType, scopes)
            : rawType,
      });
    } else {
      final name = oldMember['name'];
      final ordinal = ordinals.update(
        '$kind@${name ?? ''}',
        (value) => value + 1,
        ifAbsent: () => 0,
      );
      final child = _matchFixtureShapeChild(
        children,
        used,
        kind,
        name,
        ordinal,
      );
      final canonical = (jsonDecode(
        _fixtureCanonicalSignature(
          child,
          _fixtureInheritedScopes(child, declarationsById),
        ),
      ) as Map<Object?, Object?>)
          .cast<String, Object?>();
      final member = <String, Object?>{
        'kind': kind,
        'signature': canonical,
      };
      if (kind == 'method') {
        canonical
          ..remove('static')
          ..remove('optional');
        member['name'] = child['name'];
        member['optional'] = child['optional'];
        member['static'] = child['static'];
        member['abstract'] = child['abstract'];
      }
      if (kind == 'indexSignature') {
        canonical.remove('readonly');
        member['readonly'] = child['readonly'];
      }
      members.add(member);
    }
  }
  return <String, Object?>{'members': members};
}

void _replaceRegisteredTypeLiteralShapeHash(
  Object? value,
  String typeLiteralId,
  String shapeHash,
) {
  if (value is List<Object?>) {
    for (final item in value) {
      _replaceRegisteredTypeLiteralShapeHash(item, typeLiteralId, shapeHash);
    }
    return;
  }
  if (value is! Map<Object?, Object?>) {
    return;
  }
  if (value['kind'] == 'typeLiteral' &&
      value['id'] == typeLiteralId &&
      !value.containsKey('name')) {
    value['shapeHash'] = shapeHash;
  }
  for (final child in value.values) {
    _replaceRegisteredTypeLiteralShapeHash(child, typeLiteralId, shapeHash);
  }
}

String _refreshProducerIdentity(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
  String declarationId,
) {
  return _reindexProducerSubtree(
    inventory,
    overrides,
    declarationId,
  )[declarationId]!;
}

Map<String, String> _reindexProducerSubtree(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
  String rootId,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final byOldId = <String, Map<Object?, Object?>>{
    for (final declaration in declarations)
      declaration['id']! as String: declaration,
  };
  if (!byOldId.containsKey(rootId)) {
    throw StateError('No producer declaration $rootId.');
  }
  final childrenByOldParent = <String, List<String>>{};
  for (final declaration in declarations) {
    final parentId = declaration['parentId']! as String;
    childrenByOldParent
        .putIfAbsent(parentId, () => <String>[])
        .add(declaration['id']! as String);
  }

  final oldIds = <String>[];
  final pending = <String>[rootId];
  while (pending.isNotEmpty) {
    final oldId = pending.removeAt(0);
    oldIds.add(oldId);
    pending.addAll(childrenByOldParent[oldId] ?? const <String>[]);
  }

  final replacements = <String, String>{};
  for (final oldId in oldIds) {
    final declaration = byOldId[oldId]!;
    final oldParentId = declaration['parentId']! as String;
    final parentId = replacements[oldParentId] ?? oldParentId;
    declaration['parentId'] = parentId;
    final kind = declaration['kind']! as String;
    final name = declaration['name']! as String;
    final parentQualifiedName = switch (parentId) {
      'module:vscode' => 'vscode',
      'global:global' => 'global',
      _ => declarations.singleWhere(
          (candidate) => candidate['id'] == parentId,
        )['qualifiedName']! as String,
    };
    final qualifiedName = kind == 'typeLiteral'
        ? '$parentId.\$shape@${declaration['shapeHash']}'
        : '$parentQualifiedName.$name';
    declaration['qualifiedName'] = qualifiedName;
    final newId = switch (kind) {
      'namespace' ||
      'interface' ||
      'class' ||
      'enum' ||
      'typeAlias' ||
      'variable' =>
        '$kind:$qualifiedName',
      'enumMember' => 'enumMember:$parentId/${Uri.encodeComponent(name)}',
      'property' =>
        'property:$parentId/${declaration['static'] == true ? r'$static' : r'$instance'}/${Uri.encodeComponent(name)}',
      'function' ||
      'constructor' ||
      'callSignature' ||
      'method' ||
      'indexSignature' =>
        '$kind:$qualifiedName@${_sha256String(declaration['canonicalSignature']! as String)}',
      'typeLiteral' =>
        'typeLiteral:$parentId/\$shape@${declaration['shapeHash']}',
      _ => throw StateError('Unsupported producer declaration kind $kind.'),
    };
    declaration['id'] = newId;
    replacements[oldId] = newId;
  }

  _replaceRegisteredTypeLiteralIds(inventory, replacements);
  _rekeyOverrideIds(overrides, replacements);
  _refreshOverrideFingerprints(inventory, overrides);
  _sortDeclarationsLikeProducer(inventory);
  return replacements;
}

void _replaceRegisteredTypeLiteralIds(
  Object? value,
  Map<String, String> replacements,
) {
  if (value is List<Object?>) {
    for (final item in value) {
      _replaceRegisteredTypeLiteralIds(item, replacements);
    }
    return;
  }
  if (value is! Map<Object?, Object?>) {
    return;
  }
  if (value['kind'] == 'typeLiteral' &&
      value.containsKey('shapeHash') &&
      !value.containsKey('name')) {
    final id = value['id'];
    if (id is String && replacements[id] != null) {
      value['id'] = replacements[id];
    }
  }
  for (final child in value.values) {
    _replaceRegisteredTypeLiteralIds(child, replacements);
  }
}

void _rekeyOverrideIds(
  Map<String, Object?> overrides,
  Map<String, String> replacements,
) {
  final entries = overrides['entries']! as Map<Object?, Object?>;
  final removals = overrides['removals'] as Map<Object?, Object?>?;
  for (final replacement in replacements.entries) {
    if (replacement.key == replacement.value) {
      continue;
    }
    if (entries.containsKey(replacement.key)) {
      entries[replacement.value] = entries.remove(replacement.key);
    }
    if (removals?.containsKey(replacement.key) ?? false) {
      removals![replacement.value] = removals.remove(replacement.key);
    }
  }
  final targets = overrides['targets']! as List<Object?>;
  for (var index = 0; index < targets.length; index += 1) {
    final target = targets[index]! as String;
    targets[index] = replacements[target] ?? target;
  }
}

void _refreshOverrideFingerprints(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final entries = overrides['entries']! as Map<Object?, Object?>;
  for (final entry in entries.entries) {
    final declaration = declarations.singleWhere(
      (candidate) => candidate['id'] == entry.key,
    );
    (entry.value! as Map<Object?, Object?>)['declarationSha256'] =
        computeDeclarationFingerprint(declaration.cast<String, Object?>());
  }
}

List<List<String>> _fixtureInheritedScopes(
  Map<String, Object?> declaration,
  Map<String, Map<String, Object?>> declarationsById,
) {
  final ancestors = <Map<String, Object?>>[];
  var parentId = declaration['parentId']! as String;
  while (parentId != 'module:vscode' && parentId != 'global:global') {
    final parent = declarationsById[parentId]!;
    ancestors.add(parent);
    parentId = parent['parentId']! as String;
  }
  return [
    for (final ancestor in ancestors.reversed)
      if (const {
        'interface',
        'class',
        'typeAlias',
        'function',
        'constructor',
        'callSignature',
        'method',
        'indexSignature',
      }.contains(ancestor['kind']))
        [
          for (final parameter in ancestor['typeParameters']! as List<Object?>)
            (parameter! as Map<Object?, Object?>)['name']! as String,
        ],
  ];
}

String _fixtureCanonicalSignature(
  Map<String, Object?> callable,
  List<List<String>> inheritedScopes,
) {
  final rawTypeParameters = callable['typeParameters']! as List<Object?>;
  final ownScope = <String>[
    for (final value in rawTypeParameters)
      (value! as Map<Object?, Object?>)['name']! as String,
  ];
  final scopes = [...inheritedScopes, ownScope];
  return jsonEncode({
    'typeParameters': [
      for (final value in rawTypeParameters)
        _fixtureCanonicalTypeParameter(
          (value! as Map<Object?, Object?>).cast<String, Object?>(),
          scopes,
        ),
    ],
    'parameters': [
      for (final value in callable['parameters']! as List<Object?>)
        _fixtureCanonicalParameter(
          (value! as Map<Object?, Object?>).cast<String, Object?>(),
          scopes,
        ),
    ],
    'returnType': _fixtureCanonicalType(callable['returnType'], scopes),
    if (callable['kind'] == 'method') ...{
      'static': callable['static'],
      'optional': callable['optional'],
    },
    if (callable['kind'] == 'indexSignature') 'readonly': callable['readonly'],
  });
}

Map<String, Object?> _fixtureCanonicalTypeParameter(
  Map<String, Object?> parameter,
  List<List<String>> scopes,
) {
  return {
    if (parameter.containsKey('constraint'))
      'constraint': _fixtureCanonicalType(parameter['constraint'], scopes),
    if (parameter.containsKey('default'))
      'default': _fixtureCanonicalType(parameter['default'], scopes),
  };
}

Map<String, Object?> _fixtureCanonicalParameter(
  Map<String, Object?> parameter,
  List<List<String>> scopes,
) {
  return {
    'optional': parameter['optional'],
    'rest': parameter['rest'],
    'type': _fixtureCanonicalType(parameter['type'], scopes),
  };
}

Object? _fixtureCanonicalType(
  Object? value,
  List<List<String>> scopes,
) {
  final type = (value! as Map<Object?, Object?>).cast<String, Object?>();
  final kind = type['kind'];
  if (kind == 'reference') {
    final name = type['name']! as String;
    for (var scopeIndex = scopes.length - 1; scopeIndex >= 0; scopeIndex -= 1) {
      final index = scopes[scopeIndex].indexOf(name);
      if (index >= 0) {
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
          for (final argument in type['typeArguments']! as List<Object?>)
            _fixtureCanonicalType(argument, scopes),
        ],
      },
    'array' => <String, Object?>{
        'kind': kind,
        'elementType': _fixtureCanonicalType(type['elementType'], scopes),
      },
    'union' || 'intersection' => <String, Object?>{
        'kind': kind,
        'types': [
          for (final item in type['types']! as List<Object?>)
            _fixtureCanonicalType(item, scopes),
        ],
      },
    'literal' => <String, Object?>{
        'kind': kind,
        'value': type['value'],
      },
    'tuple' => <String, Object?>{
        'kind': kind,
        'elements': [
          for (final value in type['elements']! as List<Object?>)
            _fixtureCanonicalTupleElement(
              (value! as Map<Object?, Object?>).cast<String, Object?>(),
              scopes,
            ),
        ],
      },
    'operator' => <String, Object?>{
        'kind': kind,
        'operator': type['operator'],
        'type': _fixtureCanonicalType(type['type'], scopes),
      },
    'function' => <String, Object?>{
        'kind': kind,
        'canonicalSignature': _synchronizeFixtureFunctionType(type, scopes),
      },
    'typeLiteral' => <String, Object?>{
        'kind': kind,
        'shapeHash': type['shapeHash'],
      },
    _ => throw StateError('Unsupported fixture type kind $kind.'),
  };
}

String _synchronizeFixtureFunctionType(
  Map<String, Object?> type,
  List<List<String>> inheritedScopes,
) {
  final signature = _fixtureCanonicalSignature(type, inheritedScopes);
  type['canonicalSignature'] = signature;
  return signature;
}

Map<String, Object?> _fixtureCanonicalTupleElement(
  Map<String, Object?> element,
  List<List<String>> scopes,
) {
  return {
    'optional': element['optional'],
    'rest': element['rest'],
    'type': _fixtureCanonicalType(element['type'], scopes),
  };
}

void _renameSelectedTypeReferences(
  Map<String, Object?> inventory,
  Map<String, Object?> overrides,
  Map<String, String> replacements,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final entries = overrides['entries']! as Map<Object?, Object?>;
  final selected = <Map<Object?, Object?>>[
    for (final id in entries.keys)
      declarations.singleWhere((candidate) => candidate['id'] == id),
  ];
  final childrenByParent = <String, List<Map<Object?, Object?>>>{};
  for (final declaration in declarations) {
    childrenByParent
        .putIfAbsent(declaration['parentId']! as String, () => [])
        .add(declaration);
  }
  final literalFirstChildren = <Map<Object?, Object?>>[];
  final literalDescendants = <Map<Object?, Object?>>[];
  for (final declaration in selected) {
    if (declaration['kind'] != 'typeLiteral') {
      continue;
    }
    final children = childrenByParent[declaration['id']] ?? const [];
    if (children.isNotEmpty) {
      literalFirstChildren.add(children.first);
    }
    final pending = [...children];
    while (pending.isNotEmpty) {
      final child = pending.removeAt(0);
      literalDescendants.add(child);
      pending.addAll(childrenByParent[child['id']] ?? const []);
    }
  }
  for (final declaration in [...selected, ...literalDescendants]) {
    _renameTypeReferences(declaration, replacements);
  }
  for (final declaration in selected) {
    if (const {
      'function',
      'constructor',
      'callSignature',
      'method',
      'indexSignature',
    }.contains(declaration['kind'])) {
      _refreshProducerIdentity(
        inventory,
        overrides,
        declaration['id']! as String,
      );
    }
  }
  for (final child in literalFirstChildren) {
    _resynchronizeAncestorTypeLiterals(
      inventory,
      overrides,
      child['id']! as String,
    );
  }
  _refreshOverrideFingerprints(inventory, overrides);
  _sortDeclarationsLikeProducer(inventory);
}

void _renameTypeReferences(
  Object? value,
  Map<String, String> replacements,
) {
  if (value is List<Object?>) {
    for (final item in value) {
      _renameTypeReferences(item, replacements);
    }
    return;
  }
  if (value is! Map<Object?, Object?>) {
    return;
  }
  if (value['kind'] == 'reference') {
    final name = value['name'];
    if (name is String && replacements[name] != null) {
      value['name'] = replacements[name];
    }
  }
  final canonicalSignature = value['canonicalSignature'];
  if (canonicalSignature is String) {
    final decoded = jsonDecode(canonicalSignature);
    _renameTypeReferences(decoded, replacements);
    value['canonicalSignature'] = jsonEncode(decoded);
  }
  for (final entry in value.entries) {
    if (entry.key != 'canonicalSignature') {
      _renameTypeReferences(entry.value, replacements);
    }
  }
}

void _sortDeclarationsLikeProducer(Map<String, Object?> inventory) {
  (inventory['declarations']! as List<Object?>).sort((leftValue, rightValue) {
    final left = leftValue! as Map<Object?, Object?>;
    final right = rightValue! as Map<Object?, Object?>;
    final qualified = (left['qualifiedName']! as String)
        .compareTo(right['qualifiedName']! as String);
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
    return (left['id']! as String).compareTo(right['id']! as String);
  });
}

Map<String, Object?> _soleUnselectedCallable(Map<String, Object?> inventory) {
  final override = _readJson(
    'tool/bindings/overrides/vscode-1.129.1.json',
  );
  final targets =
      (override['targets']! as List<Object?>).cast<String>().toSet();
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  final callables = declarations.where(
    (candidate) =>
        const {
          'function',
          'constructor',
          'callSignature',
          'method',
          'indexSignature',
        }.contains(candidate['kind']) &&
        !targets.contains(candidate['id']),
  );
  return callables.firstWhere((candidate) {
    final matches = callables.where(
      (other) =>
          other['kind'] == candidate['kind'] &&
          other['qualifiedName'] == candidate['qualifiedName'] &&
          other['static'] == candidate['static'],
    );
    return matches.length == 1;
  }).cast<String, Object?>();
}

({Map<String, Object?> first, Map<String, Object?> second})
    _sameShapeTypeLiteralReferencePair(Map<String, Object?> inventory) {
  final references = <Map<String, Object?>>[];

  void visit(Object? value) {
    if (value is List<Object?>) {
      value.forEach(visit);
      return;
    }
    if (value is! Map<Object?, Object?>) {
      return;
    }
    final map = value.cast<String, Object?>();
    if (map['kind'] == 'typeLiteral' && map.containsKey('id')) {
      references.add(map);
    }
    map.values.forEach(visit);
  }

  final declarations = inventory['declarations']! as List<Object?>;
  for (final declarationValue in declarations) {
    final declaration = declarationValue! as Map<Object?, Object?>;
    declaration.values.forEach(visit);
  }
  for (final first in references) {
    final second = references.cast<Map<String, Object?>?>().firstWhere(
          (candidate) =>
              candidate != null &&
              candidate['id'] != first['id'] &&
              candidate['shapeHash'] == first['shapeHash'],
          orElse: () => null,
        );
    if (second != null) {
      return (first: first, second: second);
    }
  }
  throw StateError('No same-shape registered type-literal pair found.');
}

({Map<String, Object?> parent, Map<String, Object?> child})
    _singlePropertyTypeLiteral(Map<String, Object?> inventory) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  for (final candidate in declarations) {
    if (candidate['kind'] != 'typeLiteral') {
      continue;
    }
    final children = declarations
        .where((child) => child['parentId'] == candidate['id'])
        .toList();
    if (children.length == 1 && children.single['kind'] == 'property') {
      return (
        parent: candidate.cast<String, Object?>(),
        child: children.single.cast<String, Object?>(),
      );
    }
  }
  throw StateError('No single-property type literal found.');
}

Map<String, Object?> _multiPropertyTypeLiteralChild(
  Map<String, Object?> inventory,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  for (final candidate in declarations) {
    if (candidate['kind'] != 'typeLiteral') {
      continue;
    }
    final children = declarations
        .where((child) => child['parentId'] == candidate['id'])
        .toList();
    if (children.length >= 2 &&
        children.every((child) => child['kind'] == 'property')) {
      return children.first.cast<String, Object?>();
    }
  }
  throw StateError('No multi-property type literal found.');
}

void _tamperSignatureChildOfTypeLiteral(Map<String, Object?> inventory) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  for (final candidate in declarations) {
    if (candidate['kind'] != 'indexSignature') {
      continue;
    }
    final parentId = candidate['parentId']! as String;
    if (!parentId.startsWith('typeLiteral:')) {
      continue;
    }
    final child = candidate.cast<String, Object?>();
    final canonical = (jsonDecode(child['canonicalSignature']! as String)
            as Map<Object?, Object?>)
        .cast<String, Object?>();
    canonical['returnType'] = {'kind': 'primitive', 'name': 'string'};
    final encodedCanonical = jsonEncode(canonical);
    final id = child['id']! as String;
    child['canonicalSignature'] = encodedCanonical;
    child['id'] = id.substring(0, id.length - 64) +
        crypto.sha256.convert(utf8.encode(encodedCanonical)).toString();
    child['returnType'] = {'kind': 'primitive', 'name': 'string'};
    return;
  }
  throw StateError('No signature-child type literal found.');
}

Map<String, Object?> _registeredLiteralTypedPropertyChild(
  Map<String, Object?> inventory,
) {
  final declarations = (inventory['declarations']! as List<Object?>)
      .cast<Map<Object?, Object?>>();
  for (final candidate in declarations) {
    if (candidate['kind'] != 'property') {
      continue;
    }
    final parentId = candidate['parentId'] as String?;
    if (parentId == null || !parentId.startsWith('typeLiteral:')) {
      continue;
    }
    if (_containsRegisteredLiteralReference(candidate['type'])) {
      return candidate.cast<String, Object?>();
    }
  }
  throw StateError('No registered-literal-typed property child found.');
}

bool _containsRegisteredLiteralReference(Object? value) {
  if (value is List<Object?>) {
    return value.any(_containsRegisteredLiteralReference);
  }
  if (value is! Map<Object?, Object?>) {
    return false;
  }
  if (value['kind'] == 'typeLiteral' && value.containsKey('id')) {
    return true;
  }
  return value.values.any(_containsRegisteredLiteralReference);
}

Map<String, Object?> _project() {
  return {
    'schemaVersion': 1,
    'apiTarget': '1.129.1',
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

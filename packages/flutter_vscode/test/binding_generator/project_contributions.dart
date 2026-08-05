part of '../binding_generator_test.dart';

/// Generation and the project descriptor and the manifest contributions projected from it.
void registerProjectContributionsTests() {
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
  test('rejects unprojected changes in each new contribution schema', () {
    // Double entry, same as commands: the importer derives each projection
    // from the pinned source and the generator carries an independently
    // reviewed copy. A drifted IR node must fail with the differing path,
    // never be absorbed.
    for (final schema in ['viewsContainers', 'views', 'configuration']) {
      final inventory = _inventory(['interface:vscode.Known']);
      final schemas =
          (inventory['contributionSchemas']! as Map<Object?, Object?>)
              .cast<String, Object?>();
      (schemas[schema]! as Map<Object?, Object?>)
          .cast<String, Object?>()
          .remove('validation');

      expect(
        () => VSCodeBindingGenerator().generate(
          inventory: inventory,
          overrides: _overrides({'interface:vscode.Known': 'opaqueJsObject'}),
          project: _project(),
        ),
        throwsA(
          isA<VSCodeBindingGenerationException>()
              .having((error) => error.code, 'code', 'INVALID_GENERATOR_INPUT')
              .having(
                (error) => error.message,
                'message',
                allOf(contains(schema), contains('unprojected change')),
              ),
        ),
        reason: schema,
      );
    }
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
  test('emits only the runtime modules beside the manifest outputs', () {
    final generator = VSCodeBindingGenerator();
    final generated = generator.generate(
      inventory: _inventory(['interface:vscode.Known']),
      overrides: _overrides({
        'interface:vscode.Known': 'opaqueJsObject',
      }),
      project: _project(),
    );

    expect(
      generated.files.keys.toSet(),
      {
        'host/lib/generated/vscode_runtime.g.dart',
        'host/lib/generated/host_exports.g.dart',
        'host/bootstrap.cjs',
        'package.json',
        'coverage.json',
      },
      reason: 'the API surface is the single dart-layer artifact; the '
          'generator owns only runtime, exports, bootstrap, and ledgers',
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
  test('emits view and configuration contributions from Dart-owned data', () {
    // A tree view renders only where its view id is contributed, and the
    // configuration API rejects reads of unregistered keys. Until the typed
    // manifest can declare both, every host-only extension needs a test
    // driver to inject them -- which is exactly what the shipped Pubspec
    // Lens example has had to do.
    final project = _readJson('test/fixtures/host_extension/extension.json')
      ..['viewsContainers'] = <String, Object?>{
        'activitybar': <Object?>[
          <String, Object?>{
            'id': 'fixtureContainer',
            'title': 'Fixture',
            'icon': 'media/fixture.svg',
          },
        ],
      }
      ..['views'] = <String, Object?>{
        'fixtureContainer': <Object?>[
          <String, Object?>{
            'id': 'fixture.tree',
            'name': 'Fixture Tree',
            // The pinned manifest schema requires a view icon, though the
            // runtime tolerates its absence; the build follows the schema.
            'icon': r'$(list-tree)',
          },
        ],
      }
      ..['configuration'] = <String, Object?>{
        'title': 'Fixture',
        'properties': <String, Object?>{
          'fixture.registryUrl': <String, Object?>{
            'type': 'string',
            'default': 'https://pub.dev',
            'description': 'Registry queried for the latest versions.',
          },
        },
      };

    final generated = VSCodeBindingGenerator().generate(
      inventory: _readJson('tool/bindings/ir/vscode-1.129.1.json'),
      overrides: _readJson('tool/bindings/overrides/vscode-1.129.1.json'),
      project: project,
    );

    final manifest =
        (jsonDecode(generated.files['package.json']!) as Map<Object?, Object?>)
            .cast<String, Object?>();
    final contributes = (manifest['contributes']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    expect(contributes['viewsContainers'], {
      'activitybar': [
        {
          'id': 'fixtureContainer',
          'title': 'Fixture',
          'icon': 'media/fixture.svg',
        },
      ],
    });
    expect(contributes['views'], {
      'fixtureContainer': [
        {'id': 'fixture.tree', 'name': 'Fixture Tree', 'icon': r'$(list-tree)'},
      ],
    });
    expect(contributes['configuration'], {
      'title': 'Fixture',
      'properties': {
        'fixture.registryUrl': {
          'type': 'string',
          'default': 'https://pub.dev',
          'description': 'Registry queried for the latest versions.',
        },
      },
    });
  });

  test('rejects contribution strings the pinned host rejects', () {
    final base = _readJson('test/fixtures/host_extension/extension.json');
    final broken = <Map<String, Object?>>[
      base
        ..['viewsContainers'] = <String, Object?>{
          'activitybar': <Object?>[
            <String, Object?>{'id': ' \t', 'title': 'F', 'icon': 'i.svg'},
          ],
        },
      _readJson('test/fixtures/host_extension/extension.json')
        ..['configuration'] = <String, Object?>{
          'properties': <String, Object?>{
            // The pinned schema's propertyNames pattern is \S+: a name
            // with no non-whitespace character is unregisterable.
            ' \t': <String, Object?>{'type': 'string'},
          },
        },
    ];
    for (final project in broken) {
      expect(
        () => VSCodeBindingGenerator().generate(
          inventory: _readJson('tool/bindings/ir/vscode-1.129.1.json'),
          overrides: _readJson('tool/bindings/overrides/vscode-1.129.1.json'),
          project: project,
        ),
        throwsA(
          isA<VSCodeBindingGenerationException>().having(
            (error) => error.code,
            'code',
            'INVALID_PROJECT_MANIFEST',
          ),
        ),
        reason: 'VS Code drops whitespace-only ids and names at runtime; '
            'the build must fail closed instead of shipping a dead view',
      );
    }
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
}

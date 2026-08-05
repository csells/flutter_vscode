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

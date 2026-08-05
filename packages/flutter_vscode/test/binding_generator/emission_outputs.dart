part of '../binding_generator_test.dart';

/// Generation and what a successful generation actually emits.
void registerEmissionOutputsTests() {
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
  test('validates the reviewed slice and emits an honest coverage ledger', () {
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
      first.files.keys.toSet(),
      {
        'host/lib/generated/host_exports.g.dart',
        'host/lib/generated/vscode_runtime.g.dart',
        'host/bootstrap.cjs',
        'package.json',
        'coverage.json',
      },
      reason: 'the retired facade and walking-slice parity must not return',
    );
    final runtime = first.files['host/lib/generated/vscode_runtime.g.dart']!;
    expect(runtime, contains('installGeneratedHostRuntime'));
    expect(runtime, contains('stackMappers'));
    expect(runtime, contains('callbackWrappers'));
    expect(runtime, isNot(contains('observeHostBindings')));
    expect(runtime, isNot(contains('observeHostCallback')));
    final bootstrap = first.files['host/bootstrap.cjs']!;
    expect(bootstrap, isNot(contains('bindingObservers')));
    expect(bootstrap, isNot(contains('observedBindingIds')));
    expect(bootstrap, isNot(contains('FLUTTER_VSCODE_HOST_EVIDENCE_PATH')));

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
          '53 reviewed binding IDs cite one real Extension Host Contract '
              'whose receipted gate passed its surrounding native behavior; '
              'the retired per-member observation mechanism no longer '
              'contributes evidence.',
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
          'artifacts': [
            'packages/dart_vscode/lib/src/generated/vscode_dart_layer.g.dart',
          ],
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
}

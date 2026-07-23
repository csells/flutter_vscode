import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../tool/binding_generator/parity_layer.dart' as parity;

const _libraryPath = 'lib/src/generated/vscode_parity_layer.g.dart';
const _ledgerPath = 'tool/bindings/parity-ledger.json';

Map<String, Object?> _readJson(String path) =>
    (jsonDecode(File(path).readAsStringSync()) as Map<Object?, Object?>)
        .cast<String, Object?>();

/// Returns the source of exactly one `extension type <name><...>(` block.
String _typeBlock(String source, String name) {
  final start = source.indexOf(RegExp('extension type $name[<(]'));
  if (start < 0) {
    fail('extension type $name not found');
  }
  final open = source.indexOf('{', start);
  var depth = 0;
  for (var index = open; index < source.length; index += 1) {
    if (source[index] == '{') depth += 1;
    if (source[index] == '}') {
      depth -= 1;
      if (depth == 0) {
        return source.substring(start, index + 1);
      }
    }
  }
  fail('unterminated block for $name');
}

void main() {
  final inventory = _readJson('tool/bindings/ir/vscode-1.129.1.json');

  test('P-1/P-3 checked-in parity layer matches mechanical regeneration', () {
    final artifacts = parity.emitParityLayer(inventory);
    expect(
      File(_libraryPath).readAsStringSync(),
      artifacts.library,
      reason: 'Regenerate with: dart tool/binding_generator/generate.dart '
          '--parity-layer .',
    );
    expect(File(_ledgerPath).readAsStringSync(), artifacts.ledger);
    expect(
      File('lib/vscode_parity.dart').readAsStringSync(),
      contains('src/generated/vscode_parity_layer.g.dart'),
      reason: 'the layer must be exported for Extension Authors',
    );
  });

  test('P-2 every public declaration is emitted or explicitly erased', () {
    final ledger = _readJson(_ledgerPath);
    final dispositions =
        (ledger['dispositions']! as Map<Object?, Object?>).cast<String, String>();
    const allowedErasures = {
      'emitted',
      'symbol-keyed-member',
      'thenable-as-jspromise',
      'non-public',
    };
    final declarations = (inventory['declarations']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    final missing = <String>[];
    for (final declaration in declarations) {
      final id = declaration['id']! as String;
      final disposition = dispositions[id];
      if (disposition == null) {
        missing.add(id);
      } else {
        expect(allowedErasures, contains(disposition), reason: id);
        if (declaration['visibility'] != 'public') {
          expect(disposition, 'non-public', reason: id);
        }
      }
    }
    expect(
      missing,
      isEmpty,
      reason: 'declarations with no recorded disposition',
    );
    expect(
      dispositions.length,
      declarations.length,
      reason: 'ledger must cover exactly the IR',
    );
  });

  test('P-3 the generated layer analyzes cleanly', () {
    final result = Process.runSync(
      'dart',
      ['analyze', '--fatal-infos', _libraryPath],
    );
    expect(
      result.exitCode,
      0,
      reason: '${result.stdout}\n${result.stderr}',
    );
  });

  group('P-4 structural rules on the real output', () {
    late final String source;
    setUpAll(() {
      source = File(_libraryPath).readAsStringSync();
    });

    test('reserved words are mangled and JS-bound', () {
      expect(source, contains("@JS('with')"));
      expect(source, contains(r'with$'));
      expect(source, contains("@JS('toString')"));
      expect(source, contains(r'toString$'));
    });

    test('overload sets expand with deterministic suffixes', () {
      expect(source, contains("@JS('showQuickPick')"));
      expect(source, matches(RegExp(r'showQuickPick\$2')));
    });

    test('numeric enums are int typedefs with module-rooted values', () {
      expect(source, contains('typedef ViewColumn = int;'));
      expect(source, matches(RegExp(r'external\s+int\s+get\s+File;')));
    });

    test('Thenable maps to JSPromise', () {
      expect(
        source,
        contains('typedef Thenable<T extends JSAny?> = JSPromise<T>;'),
      );
    });

    test('tuples get typed accessors over JSArray', () {
      expect(source, contains('typedef CharacterPair = JSTuple_'));
      expect(
        source,
        matches(RegExp(r'JSTuple_\w+\(JSArray<JSAny\?> _self\)')),
      );
    });

    test('index signatures use the only blessed operators', () {
      expect(source, contains('external JSAny? operator []('));
    });

    test('intersections implement both operands', () {
      expect(
        source,
        matches(
          RegExp(r'extension type JSIntersection_\w+[^{]*implements[^{]*Memento'),
        ),
      );
    });

    test('the module wrapper is the only root', () {
      expect(source, contains('extension type VscodeApi'));
      expect(source, matches(RegExp(r'external\s+WindowNs\s+get\s+window;')));
      expect(source, isNot(contains('globalThis')));
      expect(source, isNot(contains("@JS('vscode')")));
    });

    test('constructors go through the module class object', () {
      expect(source, matches(RegExp(r'Position\s+new\$\(')));
      expect(source, contains('callAsConstructorVarArgs'));
    });

    test('call-signature interfaces wrap JSFunction', () {
      expect(
        source,
        matches(
          RegExp(r'extension type Event<T extends JSAny\?>[^{]*JSFunction'),
        ),
      );
    });

    test('LUB union erasure holds at external boundaries', () {
      expect(source, contains('typedef DocumentSelector = JSAny;'));
      expect(source, contains('typedef Declaration = JSObject;'));
      expect(source, contains('typedef GlobPattern = JSAny;'));
    });

    test('registered type literals are extension types with typed members',
        () {
      expect(source, matches(RegExp(r'extension type JSAnon_\w+\(JSObject')));
      expect(
        'extension type JSAnon_'.allMatches(source).length,
        greaterThan(50),
      );
    });

    test('ctor-less classes still construct through the class object', () {
      final block = _typeBlock(source, 'EventEmitterCtor');
      expect(block, contains(r'new$'));
      final workspaceEdit = _typeBlock(source, 'WorkspaceEditCtor');
      expect(workspaceEdit, contains(r'new$'));
    });

    test('interfaces and type literals get object-literal factories', () {
      final documentFilter = _typeBlock(source, 'DocumentFilter');
      expect(
        documentFilter,
        contains(r'external factory DocumentFilter.lit$('),
      );
      expect(documentFilter, contains('String? language'));
      expect(source, matches(RegExp(r'external factory JSAnon_\w+\.lit\$\(')));
    });

    test('index signatures include the setter operator', () {
      expect(source, contains('external void operator []=('));
    });

    test('Promise and Thenable references map to JSPromise in signatures',
        () {
      expect(source, matches(RegExp('external JSPromise<[^>]+> ')));
    });

    test('overload suffixes sit directly on their JS binding', () {
      expect(
        source,
        matches(
          RegExp(r"@JS\('showQuickPick'\)\n  external [^\n]+showQuickPick\$2"),
        ),
      );
    });

    test('enum value objects are module-rooted on VscodeApi', () {
      final api = _typeBlock(source, 'VscodeApi');
      expect(api, contains('FileTypeValues get FileType;'));
      expect(api, contains('ViewColumnValues get ViewColumn;'));
    });

    test('optionality is nullable, readonly is getter-only', () {
      // The only mention of undefined is the documented conflation note.
      expect('undefined'.allMatches(source).length, 1);
      expect(source, contains('external String? get placeHolder;'));
      final document = _typeBlock(source, 'TextDocument');
      expect(document, contains('external Uri get uri;'));
      expect(
        document,
        isNot(contains('external set uri(')),
        reason: 'readonly properties must not emit setters',
      );
      final selectionGetter =
          RegExp(r'external\s+Selection\s+get\s+selection;');
      expect(source, matches(selectionGetter));
    });
  });

  test('V-4 the live smoke covers every API namespace family', () {
    final namespaces = [
      for (final declaration in (inventory['declarations']! as List<Object?>)
          .cast<Map<Object?, Object?>>())
        if (declaration['kind'] == 'namespace')
          declaration['name']! as String,
    ];
    expect(namespaces, isNotEmpty);
    final harness = File(
      'test/fixtures/host_extension/test/run.cjs',
    ).readAsStringSync();
    for (final namespace in namespaces) {
      expect(
        harness,
        contains("'$namespace'"),
        reason: 'the real-host smoke must exercise a representative of '
            'the $namespace family',
      );
    }
  });

  test('P-5 unmapped constructs fail generation with an actionable error',
      () {
    final synthetic = <String, Object?>{
      'schemaVersion': 1,
      'declarations': [
        {
          'id': 'typeAlias:vscode.Broken',
          'kind': 'typeAlias',
          'name': 'Broken',
          'qualifiedName': 'vscode.Broken',
          'parentId': 'module:vscode',
          'deprecated': false,
          'visibility': 'public',
          'typeParameters': <Object?>[],
          'type': {'kind': 'conditional'},
        },
      ],
    };
    expect(
      () => parity.emitParityLayer(synthetic),
      throwsA(
        isA<parity.ParityGenerationException>()
            .having((e) => e.declarationId, 'id', 'typeAlias:vscode.Broken')
            .having((e) => e.message, 'message', contains('conditional')),
      ),
    );
  });
}

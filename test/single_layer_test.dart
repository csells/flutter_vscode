import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// SL-1: one self-contained generated API artifact.
///
/// The mechanical dart layer carries the substrate (the former standalone
/// Parity Layer emission) inside `vscode_dart_layer.g.dart` instead of
/// importing it, the standalone parity artifact and its
/// `package:flutter_vscode/vscode_parity.dart` export retire, and
/// `flutter_vscode build` emits exactly one API artifact into projects.
void main() {
  const artifactPath = 'lib/src/generated/vscode_dart_layer.g.dart';

  group('the merged artifact is self-contained', () {
    late final String source;
    setUpAll(() {
      source = File(artifactPath).readAsStringSync();
    });

    test('it inlines the substrate types', () {
      expect(
        source,
        contains('extension type Position(JSObject _self)'),
        reason: 'substrate class wrappers must live inside the artifact',
      );
      expect(
        source,
        contains('extension type VscodeApi(JSObject _self)'),
        reason: 'the substrate module root must live inside the artifact',
      );
      expect(
        source,
        contains('typedef Thenable<T extends JSAny?> = JSPromise<T>;'),
        reason: 'substrate typedefs must live inside the artifact',
      );
      expect(
        source,
        contains('int _trimTrailingNulls('),
        reason: 'the substrate trimming helper must live inside the artifact',
      );
    });

    test('it keeps the dart-layer types beside the substrate', () {
      expect(source, contains('extension type VscodeApiDart(VscodeApi'));
      expect(source, contains(r'Stream<S> _eventStream$<S>('));
    });

    test('it imports no parity artifact', () {
      expect(
        source,
        isNot(contains('vscode_parity_layer')),
        reason: 'the artifact must not reference the retired parity file',
      );
    });
  });

  test('the standalone parity artifact and its export are retired', () {
    expect(
      File('lib/vscode_parity.dart').existsSync(),
      isFalse,
      reason: 'the parity export retires with its artifact',
    );
    expect(
      File('lib/src/generated/vscode_parity_layer.g.dart').existsSync(),
      isFalse,
      reason: 'the standalone parity artifact retires',
    );
    final generated = Directory('lib/src/generated')
        .listSync()
        .whereType<File>()
        .map((file) => p.basename(file.path))
        .toList()
      ..sort();
    expect(
      generated,
      ['vscode_dart_layer.g.dart'],
      reason: 'lib/src/generated must hold exactly one API artifact',
    );
    expect(
      File('lib/vscode_dart.dart').readAsStringSync(),
      isNot(contains('vscode_parity_layer.g.dart')),
      reason: 'the one API export must not re-export the retired artifact',
    );
  });

  test('built project trees carry no standalone parity artifact', () {
    for (final generatedRoot in [
      'test/fixtures/host_extension/host/lib/generated',
      'extensions/coverage_treemap/host/lib/generated',
    ]) {
      final names = Directory(generatedRoot)
          .listSync()
          .whereType<File>()
          .map((file) => p.basename(file.path));
      expect(
        names,
        isNot(contains('vscode_parity_layer.g.dart')),
        reason: '$generatedRoot must not carry the retired parity artifact',
      );
      expect(
        names,
        contains('vscode_dart_layer.g.dart'),
        reason: '$generatedRoot must carry the one merged artifact',
      );
    }
    expect(
      File('lib/src/cli/build_command.dart').readAsStringSync(),
      isNot(contains('vscode_parity_layer.g.dart')),
      reason: 'build must emit only the merged artifact',
    );
  });
}

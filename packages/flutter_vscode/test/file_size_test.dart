import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'support/repository.dart';

/// No hand-written file grows past the point where a newcomer can hold it.
///
/// The upstream review named this directly: files of several thousand lines
/// "will be hard for anyone but the author to maintain". Generated artifacts
/// are exempt -- their size is the emitter's business and nobody reads them
/// top to bottom -- but everything a person writes and reviews is bounded.
///
/// The limit is a ratchet, not a target. It exists so that the next file to
/// cross it fails here rather than being noticed years later.
void main() {
  const limit = 1200;

  test('no hand-written Dart file exceeds the maintainability limit', () {
    final offenders = <String, int>{};
    for (final root in ['packages', 'extensions']) {
      final directory = Directory(repoPath(root));
      for (final entity in directory.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }
        final path = p.relative(entity.path, from: repositoryRoot.path);
        final generated = path.contains('/generated/') ||
            path.endsWith('.g.dart') ||
            path.contains('/.dart_tool/') ||
            path.contains('/build/') ||
            path.contains('/out/');
        if (generated) {
          continue;
        }
        final lines = entity.readAsLinesSync().length;
        if (lines > limit) {
          offenders[path] = lines;
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'these files are past the point of being reviewable; split '
          'them by concern:\n'
          '${offenders.entries.map((e) => '  ${e.key}: ${e.value}').join('\n')}',
    );
  });
}

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Nested Dart packages whose standalone `dart analyze` must enforce
/// the repository's strict lint set (D-9: the root include silently
/// fails to resolve outside the root package context).
List<Directory> _nestedPackages() {
  final roots = [
    Directory('extensions'),
    Directory('test/fixtures/host_extension'),
  ];
  final packages = <Directory>[];
  for (final root in roots) {
    for (final entity in root.listSync(recursive: true)) {
      if (entity is! File || p.basename(entity.path) != 'pubspec.yaml') {
        continue;
      }
      if (entity.path.contains('.dart_tool')) {
        continue;
      }
      final package = entity.parent;
      if (Directory(p.join(package.path, 'lib')).existsSync()) {
        packages.add(package);
      }
    }
  }
  return packages..sort((a, b) => a.path.compareTo(b.path));
}

void main() {
  test('every nested package wires the strict lint set', () {
    final packages = _nestedPackages();
    expect(packages, isNotEmpty);
    for (final package in packages) {
      final options = File(p.join(package.path, 'analysis_options.yaml'));
      expect(
        options.existsSync(),
        isTrue,
        reason: '${package.path} needs analysis_options.yaml so standalone '
            'dart analyze enforces the strict lint set',
      );
      expect(
        options.readAsStringSync(),
        contains('package:very_good_analysis/analysis_options.yaml'),
        reason: '${package.path} must include the strict lint set',
      );
      expect(
        File(p.join(package.path, 'pubspec.yaml')).readAsStringSync(),
        contains('very_good_analysis'),
        reason: '${package.path} must depend on very_good_analysis so the '
            'include resolves in standalone analysis',
      );
    }
  });

  test(
    'a violating probe fails standalone analysis in a nested package',
    () async {
      final temporary = await Directory.systemTemp.createTemp(
        'flutter_vscode_nested_lint_',
      );
      addTearDown(() => temporary.delete(recursive: true));
      final source = Directory('extensions/coverage_treemap/shared');
      final copy = Directory(p.join(temporary.path, 'shared'));
      await Process.run('cp', ['-R', source.path, copy.path]);
      // Violates only the strict set (prefer_single_quotes), never the
      // default analyzer, so failure proves the include resolved.
      File(p.join(copy.path, 'lib', 'probe.dart'))
          .writeAsStringSync('final String probe = "double quoted";\n');

      final resolve = await Process.run(
        'dart',
        ['pub', 'get'],
        workingDirectory: copy.path,
      );
      expect(
        resolve.exitCode,
        0,
        reason: '${resolve.stdout}\n${resolve.stderr}',
      );
      final analysis = await Process.run(
        'dart',
        ['analyze', '--fatal-infos'],
        workingDirectory: copy.path,
      );
      expect(
        analysis.exitCode,
        isNot(0),
        reason: 'The strict lint set is not active in nested packages: '
            'the probe passed analysis.\n${analysis.stdout}',
      );
      expect(
        '${analysis.stdout}',
        contains('prefer_single_quotes'),
        reason: 'The failure must come from the strict set, not from an '
            'unrelated diagnostic.\n${analysis.stdout}',
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

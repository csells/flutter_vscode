import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Enumerates the pinned VS Code baselines shipped with this checkout.
///
/// A baseline counts only when its pinned-inputs directory carries a
/// `pins.json`; the structural test below proves the IR and Semantic
/// Override files form exactly the same version set.
List<String> _pinnedVersions() {
  final root = Directory(p.join('tool', 'bindings', 'inputs', 'vscode'));
  return [
    for (final entity in root.listSync())
      if (entity is Directory &&
          RegExp(r'^\d+\.\d+\.\d+$').hasMatch(p.basename(entity.path)) &&
          File(p.join(entity.path, 'pins.json')).existsSync())
        p.basename(entity.path),
  ]..sort();
}

Map<String, Object?> _readJson(String path) =>
    (jsonDecode(File(path).readAsStringSync()) as Map<Object?, Object?>)
        .cast<String, Object?>();

void main() {
  test('D-8a at least two pinned baselines ship consistent artifacts', () {
    final versions = _pinnedVersions();
    expect(versions, contains('1.129.1'), reason: 'the seed baseline');
    expect(
      versions.length,
      greaterThanOrEqualTo(2),
      reason: 'multi-baseline support requires a second pinned VS Code '
          'release beside the 1.129.1 seed',
    );

    List<String> fileVersions(String directory) => [
          for (final entity in Directory(directory).listSync())
            if (entity is File &&
                RegExp(r'^vscode-\d+\.\d+\.\d+\.json$')
                    .hasMatch(p.basename(entity.path)))
              p
                  .basename(entity.path)
                  .replaceFirst('vscode-', '')
                  .replaceFirst('.json', ''),
        ]..sort();
    expect(
      fileVersions(p.join('tool', 'bindings', 'ir')),
      versions,
      reason: 'every pinned-inputs baseline needs exactly one IR and no '
          'IR may be orphaned',
    );
    expect(
      fileVersions(p.join('tool', 'bindings', 'overrides')),
      versions,
      reason: 'every baseline needs exactly one same-version Semantic '
          'Override file and no override file may be orphaned',
    );

    for (final version in versions) {
      final pinDirectory =
          p.join('tool', 'bindings', 'inputs', 'vscode', version);
      final pins = _readJson(p.join(pinDirectory, 'pins.json'));
      final product =
          (pins['product']! as Map<Object?, Object?>).cast<String, Object?>();
      expect(product['version'], version, reason: '$version pins.json');
      for (final input in (pins['inputs']! as List<Object?>)
          .cast<Map<Object?, Object?>>()) {
        final path = input['path']! as String;
        final pinned = File(p.join(pinDirectory, path));
        expect(pinned.existsSync(), isTrue, reason: '$version $path');
        expect(
          sha256.convert(pinned.readAsBytesSync()).toString(),
          input['sha256'],
          reason: '$version $path must match its pinned checksum',
        );
      }

      final inventory =
          _readJson(p.join('tool', 'bindings', 'ir', 'vscode-$version.json'));
      final inventoryProduct = ((inventory['source']!
              as Map<Object?, Object?>)['product']! as Map<Object?, Object?>)
          .cast<String, Object?>();
      expect(inventoryProduct['version'], version, reason: '$version IR');

      final overrides = _readJson(
        p.join('tool', 'bindings', 'overrides', 'vscode-$version.json'),
      );
      expect(
        overrides['vscodeVersion'],
        version,
        reason: '$version Semantic Overrides',
      );
    }
  });

  test(
    'D-8b build names every pinned API target for an unknown target',
    () async {
      final versions = _pinnedVersions();
      expect(
        versions.length,
        greaterThanOrEqualTo(2),
        reason: 'the actionable error must select among plural baselines',
      );
      final workspace = await Directory.systemTemp.createTemp(
        'flutter_vscode_cli_unknown_target_',
      );
      addTearDown(() => workspace.delete(recursive: true));
      final executable = p.join(
        Directory.current.path,
        'bin',
        'flutter_vscode.dart',
      );
      final create = await Process.run(
        'dart',
        [executable, 'create', 'my_extension'],
        workingDirectory: workspace.path,
      );
      expect(create.exitCode, 0, reason: '${create.stdout}\n${create.stderr}');
      final descriptor = File(
        p.join(workspace.path, 'my_extension', 'extension.dart'),
      );
      descriptor.writeAsStringSync(
        descriptor
            .readAsStringSync()
            .replaceFirst("'apiTarget': '1.129.1'", "'apiTarget': '9.9.9'"),
      );

      final build = await Process.run(
        'dart',
        [executable, 'build'],
        workingDirectory: p.join(workspace.path, 'my_extension'),
      );

      expect(build.exitCode, 1, reason: '${build.stdout}\n${build.stderr}');
      expect(build.stderr, contains('No pinned binding inputs'));
      for (final version in versions) {
        expect(
          build.stderr,
          contains(version),
          reason: 'the error must name pinned target $version so the '
              'author can correct apiTarget without reading source',
        );
      }
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'D-8c a scaffolded project builds against each pinned baseline',
    () async {
      final versions = _pinnedVersions();
      expect(
        versions.length,
        greaterThanOrEqualTo(2),
        reason: 'a fixture must build against plural baselines',
      );
      final executable = p.join(
        Directory.current.path,
        'bin',
        'flutter_vscode.dart',
      );
      for (final version in versions) {
        final workspace = await Directory.systemTemp.createTemp(
          'flutter_vscode_cli_baseline_',
        );
        addTearDown(() => workspace.delete(recursive: true));
        final create = await Process.run(
          'dart',
          [executable, 'create', 'my_extension'],
          workingDirectory: workspace.path,
        );
        expect(
          create.exitCode,
          0,
          reason: '$version: ${create.stdout}\n${create.stderr}',
        );
        final project = Directory(p.join(workspace.path, 'my_extension'));
        final descriptor = File(p.join(project.path, 'extension.dart'));
        descriptor.writeAsStringSync(
          descriptor.readAsStringSync().replaceFirst(
                "'apiTarget': '1.129.1'",
                "'apiTarget': '$version'",
              ),
        );

        final build = await Process.run(
          'dart',
          [executable, 'build'],
          workingDirectory: project.path,
        );

        expect(
          build.exitCode,
          0,
          reason: '$version: ${build.stdout}\n${build.stderr}',
        );
        final manifest = _readJson(p.join(project.path, 'package.json'));
        expect(
          manifest['engines'],
          <String, Object?>{'vscode': version},
          reason: '$version must select its own engine floor',
        );
        for (final artifact in [
          p.join('host', 'lib', 'generated', 'vscode_facade.g.dart'),
          p.join('host', 'lib', 'generated', 'vscode_parity_layer.g.dart'),
          p.join('out', 'extension.dart.js'),
        ]) {
          expect(
            File(p.join(project.path, artifact)).existsSync(),
            isTrue,
            reason: '$version must emit $artifact',
          );
        }
      }
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}

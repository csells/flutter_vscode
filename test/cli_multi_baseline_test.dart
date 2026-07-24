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
}

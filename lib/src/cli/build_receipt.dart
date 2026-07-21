import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

/// Repository-relative location of the deterministic build receipt.
const buildReceiptPath = '.dart_tool/flutter_vscode/build.json';

/// Records the exact inputs and Framework-Managed Artifacts from a build.
Future<void> writeBuildReceipt({
  required Directory projectRoot,
  required String apiTarget,
  required List<String> inputPaths,
  required List<String> artifactPaths,
}) async {
  final receipt = <String, Object?>{
    'schemaVersion': 1,
    'apiTarget': apiTarget,
    'inputs': await _digests(projectRoot, inputPaths),
    'artifacts': await _digests(projectRoot, artifactPaths),
  };
  const encoder = JsonEncoder.withIndent('  ');
  final output = _projectFile(projectRoot, buildReceiptPath);
  await output.parent.create(recursive: true);
  await output.writeAsString('${encoder.convert(receipt)}\n', flush: true);
}

/// Returns every reason the current project differs from its last build.
Future<List<String>> validateBuildReceipt({
  required Directory projectRoot,
  required String apiTarget,
  required List<String> inputPaths,
  required List<String> artifactPaths,
}) async {
  final receiptFile = _projectFile(projectRoot, buildReceiptPath);
  if (!receiptFile.existsSync()) {
    return const ['$buildReceiptPath is missing'];
  }

  Object? decoded;
  try {
    decoded = jsonDecode(await receiptFile.readAsString());
  } on FormatException {
    return const ['$buildReceiptPath is not valid JSON'];
  }
  if (decoded is! Map<String, Object?> ||
      !_hasExactKeys(decoded, {
        'apiTarget',
        'artifacts',
        'inputs',
        'schemaVersion',
      }) ||
      decoded['schemaVersion'] != 1 ||
      decoded['apiTarget'] != apiTarget ||
      decoded['inputs'] is! Map<String, Object?> ||
      decoded['artifacts'] is! Map<String, Object?>) {
    return const ['$buildReceiptPath has an unsupported structure'];
  }

  final problems = <String>[];
  await _validateGroup(
    projectRoot: projectRoot,
    label: 'build input',
    recorded: decoded['inputs']! as Map<String, Object?>,
    currentPaths: inputPaths,
    problems: problems,
  );
  await _validateGroup(
    projectRoot: projectRoot,
    label: 'Framework-Managed Artifact',
    recorded: decoded['artifacts']! as Map<String, Object?>,
    currentPaths: artifactPaths,
    problems: problems,
  );
  return problems;
}

Future<Map<String, Object?>> _digests(
  Directory projectRoot,
  List<String> paths,
) async {
  final result = <String, Object?>{};
  for (final path in paths.toSet().toList()..sort()) {
    final file = _projectFile(projectRoot, path);
    if (!file.existsSync()) {
      throw FileSystemException('Build receipt input is missing', file.path);
    }
    result[path] = await _digest(file);
  }
  return result;
}

Future<void> _validateGroup({
  required Directory projectRoot,
  required String label,
  required Map<String, Object?> recorded,
  required List<String> currentPaths,
  required List<String> problems,
}) async {
  final current = currentPaths.toSet();
  final previous = recorded.keys.toSet();
  for (final path in previous.difference(current).toList()..sort()) {
    problems.add('$label $path is missing');
  }
  for (final path in current.difference(previous).toList()..sort()) {
    problems.add('$label $path was added after build');
  }
  for (final path in current.intersection(previous).toList()..sort()) {
    final expected = recorded[path];
    if (expected is! String || !RegExp(r'^[0-9a-f]{64}$').hasMatch(expected)) {
      problems.add('$label $path has an invalid recorded digest');
      continue;
    }
    final actual = await _digest(_projectFile(projectRoot, path));
    if (actual != expected) {
      problems.add('$label $path changed after build');
    }
  }
}

Future<String> _digest(File file) async =>
    sha256.convert(await file.readAsBytes()).toString();

File _projectFile(Directory root, String relativePath) => File(
      p.joinAll([root.path, ...p.posix.split(relativePath)]),
    );

bool _hasExactKeys(Map<String, Object?> value, Set<String> expected) =>
    value.length == expected.length && value.keys.toSet().containsAll(expected);

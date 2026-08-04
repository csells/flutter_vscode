import 'dart:io';

import 'package:flutter_vscode/src/cli/build_receipt.dart';
import 'package:flutter_vscode/src/cli/project_layout.dart';

/// Enumerates the author-owned inputs a build reads, in stable order.
List<String> buildInputPaths(Directory root) {
  final paths = <String>[];
  for (final descriptor in ['extension.dart', 'extension.json']) {
    if (projectFile(root, descriptor).existsSync()) {
      paths.add(descriptor);
    }
  }
  for (final path in [
    'host/pubspec.yaml',
    'host/pubspec.lock',
    'shared/pubspec.yaml',
  ]) {
    if (projectFile(root, path).existsSync()) {
      paths.add(path);
    }
  }
  for (final sourceRoot in ['host/lib', 'shared/lib']) {
    final directory = Directory(projectFile(root, sourceRoot).path);
    if (!directory.existsSync()) {
      continue;
    }
    for (final entity in safeFiles(
      directory,
      description: '$sourceRoot source tree',
    )) {
      final relative = relativeProjectPath(root, entity);
      if (!relative.startsWith('host/lib/generated/') &&
          !relative.startsWith('shared/lib/generated/')) {
        paths.add(relative);
      }
    }
  }
  for (final view in discoverViews(root)) {
    for (final file in safeFiles(
      view.root,
      description: 'Flutter View ${view.name} source tree',
      excludedTopLevelNames: const {'.dart_tool', 'build'},
    )) {
      paths.add(relativeProjectPath(root, file));
    }
  }
  return paths.toSet().toList()..sort();
}

/// Enumerates the Framework-Managed Artifacts a build owns, in stable order.
List<String> managedArtifactPaths(Directory root) {
  final paths = <String>[];
  for (final path in [
    '.vscode/launch.json',
    'coverage.json',
    'host/bootstrap.cjs',
    'package.json',
  ]) {
    if (projectFile(root, path).existsSync()) {
      paths.add(path);
    }
  }
  for (final artifactRoot in [
    'host/lib/generated',
    'out',
    'shared/lib/generated',
  ]) {
    final directory = Directory(projectFile(root, artifactRoot).path);
    if (!directory.existsSync()) {
      continue;
    }
    for (final entity in safeFiles(
      directory,
      description: '$artifactRoot Framework-Managed Artifact tree',
    )) {
      paths.add(relativeProjectPath(root, entity));
    }
  }
  return paths.toSet().toList()..sort();
}

/// Digests the framework, generator, and pinned inputs for [apiTarget].
Future<BuildToolIdentity> frameworkToolIdentity(
  Directory packageRoot,
  String apiTarget,
) async =>
    BuildToolIdentity(
      frameworkSha256: await digestPackagePaths(
        packageRoot: packageRoot,
        relativePaths: const [
          'bin/flutter_vscode.dart',
          'lib',
          'pubspec.yaml',
          'tool/check_host_imports.dart',
        ],
      ),
      generatorSha256: await digestPackagePaths(
        packageRoot: packageRoot,
        relativePaths: const [
          'tool/binding_generator',
        ],
      ),
      bindingInputsSha256: await digestPackagePaths(
        packageRoot: packageRoot,
        relativePaths: [
          'tool/bindings/inputs/vscode/$apiTarget',
          'tool/bindings/ir/vscode-$apiTarget.json',
          'tool/bindings/overrides/vscode-$apiTarget.json',
        ],
      ),
    );

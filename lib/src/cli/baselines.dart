import 'dart:io';
import 'dart:isolate';

import 'package:flutter_vscode/src/cli/cli_exception.dart';
import 'package:flutter_vscode/src/cli/json_object.dart';
import 'package:path/path.dart' as p;

/// The Project API Target assumed when a legacy descriptor names none.
///
/// This is the single default: the `create` scaffold, binding-input
/// selection, and packaging all interpolate this constant.
const defaultApiTarget = '1.129.1';

/// The exact-stable-version grammar every Project API Target must match.
final RegExp apiTargetPattern = RegExp(r'^\d+\.\d+\.\d+$');

/// The pinned binding inputs selected for one Project API Target.
final class BindingInputs {
  /// Creates the selected inputs for [apiTarget].
  const BindingInputs({
    required this.apiTarget,
    required this.inventory,
    required this.overrides,
  });

  /// The resolved Project API Target.
  final String apiTarget;

  /// The imported canonical IR for the target.
  final Map<String, Object?> inventory;

  /// The same-version Semantic Override file for the target.
  final Map<String, Object?> overrides;
}

/// Selects the pinned binding inputs for [project]'s API target.
///
/// When [requireApiTarget] is set the descriptor must declare a non-empty
/// `apiTarget`; otherwise a missing value falls back to [defaultApiTarget].
Future<BindingInputs> selectBindingInputs({
  required Directory packageRoot,
  required Map<String, Object?> project,
  required bool requireApiTarget,
}) async {
  final value = project['apiTarget'];
  if (requireApiTarget && (value is! String || value.isEmpty)) {
    throw const CliException(
      'extension.dart must declare a non-empty Project API Target in '
      "'apiTarget'.",
      code: 'INVALID_PROJECT_API_TARGET',
    );
  }
  final apiTarget = value is String ? value : defaultApiTarget;
  if (!apiTargetPattern.hasMatch(apiTarget)) {
    throw CliException(
      'Project API Target $apiTarget must be an exact stable VS Code version.',
      code: 'INVALID_PROJECT_API_TARGET',
    );
  }
  final available = pinnedApiTargets(packageRoot);
  if (!available.contains(apiTarget)) {
    final listed = available.isEmpty ? 'none' : available.join(', ');
    throw CliException(
      'No pinned binding inputs are available for Project API Target '
      '$apiTarget. Pinned API Targets shipped with this flutter_vscode '
      'version: $listed.',
      code: 'UNAVAILABLE_PROJECT_API_TARGET',
    );
  }
  final inventoryFile = File(
    p.join(
      packageRoot.path,
      'tool',
      'bindings',
      'ir',
      'vscode-$apiTarget.json',
    ),
  );
  final overridesFile = File(
    p.join(
      packageRoot.path,
      'tool',
      'bindings',
      'overrides',
      'vscode-$apiTarget.json',
    ),
  );
  return BindingInputs(
    apiTarget: apiTarget,
    inventory: await readJsonObject(inventoryFile),
    overrides: await readJsonObject(overridesFile),
  );
}

/// Enumerates the pinned VS Code baselines shipped with this package.
///
/// A version counts only when all three artifacts exist: the pinned-inputs
/// directory with its `pins.json`, the imported IR, and the same-version
/// Semantic Override file. The result is sorted numerically so error
/// messages read oldest to newest.
List<String> pinnedApiTargets(Directory packageRoot) {
  final inputsRoot = Directory(
    p.join(packageRoot.path, 'tool', 'bindings', 'inputs', 'vscode'),
  );
  if (!inputsRoot.existsSync()) {
    return const [];
  }
  bool isPinned(String version) =>
      File(p.join(inputsRoot.path, version, 'pins.json')).existsSync() &&
      File(
        p.join(
          packageRoot.path,
          'tool',
          'bindings',
          'ir',
          'vscode-$version.json',
        ),
      ).existsSync() &&
      File(
        p.join(
          packageRoot.path,
          'tool',
          'bindings',
          'overrides',
          'vscode-$version.json',
        ),
      ).existsSync();
  final targets = [
    for (final entity in inputsRoot.listSync())
      if (entity is Directory &&
          apiTargetPattern.hasMatch(p.basename(entity.path)) &&
          isPinned(p.basename(entity.path)))
        p.basename(entity.path),
  ];
  int numeric(String version, int index) =>
      int.parse(version.split('.')[index]);
  targets.sort((left, right) {
    for (var index = 0; index < 3; index += 1) {
      final order = numeric(left, index) - numeric(right, index);
      if (order != 0) {
        return order;
      }
    }
    return 0;
  });
  return targets;
}

/// Locates the installed flutter_vscode package root.
///
/// The pinned baselines, generator sources, and framework resources the
/// commands read all live beneath this directory.
Future<Directory> resolvePackageRoot() async {
  final library = await Isolate.resolvePackageUri(
    Uri.parse('package:flutter_vscode/flutter_vscode.dart'),
  );
  if (library == null || library.scheme != 'file') {
    throw const CliException(
      'Could not locate the flutter_vscode package.',
      code: 'FRAMEWORK_PACKAGE_NOT_FOUND',
    );
  }
  return Directory(p.dirname(p.dirname(library.toFilePath())));
}

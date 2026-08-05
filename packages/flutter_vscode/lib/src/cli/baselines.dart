import 'dart:io';
import 'dart:isolate';

import 'package:flutter_vscode/src/cli/cli_exception.dart';
import 'package:flutter_vscode/src/cli/json_object.dart';
import 'package:path/path.dart' as p;

/// The one VS Code baseline this `flutter_vscode` release ships bindings for.
///
/// The package version *is* the baseline. A project builds against whatever
/// this release pins; it does not choose. The maintainer moves the baseline
/// by importing newer pinned inputs, regenerating, and publishing, so an
/// author who needs an older VS Code API depends on the `flutter_vscode`
/// release that shipped it — ordinary package versioning rather than a
/// selector inside the package.
const shippedApiTarget = '1.129.1';

/// The pinned binding inputs this release ships.
final class BindingInputs {
  /// Creates the shipped inputs.
  const BindingInputs({required this.inventory, required this.overrides});

  /// The imported canonical IR for the shipped baseline.
  final Map<String, Object?> inventory;

  /// The same-version Semantic Override file for the shipped baseline.
  final Map<String, Object?> overrides;
}

/// Loads the pinned binding inputs shipped with this package.
Future<BindingInputs> loadBindingInputs(Directory packageRoot) async {
  final inventoryFile = File(
    p.join(
      packageRoot.path,
      'tool',
      'bindings',
      'ir',
      'vscode-$shippedApiTarget.json',
    ),
  );
  final overridesFile = File(
    p.join(
      packageRoot.path,
      'tool',
      'bindings',
      'overrides',
      'vscode-$shippedApiTarget.json',
    ),
  );
  if (!inventoryFile.existsSync() || !overridesFile.existsSync()) {
    throw const CliException(
      'This flutter_vscode installation is missing its pinned binding '
      'inputs for VS Code $shippedApiTarget.',
      code: 'MISSING_FRAMEWORK_RESOURCE',
    );
  }
  return BindingInputs(
    inventory: await readJsonObject(inventoryFile),
    overrides: await readJsonObject(overridesFile),
  );
}

/// Locates the installed `dart_vscode` package root.
///
/// Generated Host Dart imports `package:dart_vscode/dart_vscode.dart`, so a
/// scaffolded project has to reach whichever copy of that package this CLI
/// is running against. Once `dart_vscode` is published a scaffold can carry
/// an ordinary hosted constraint instead.
Future<Directory> resolveDartVscodeRoot() async {
  final library = await Isolate.resolvePackageUri(
    Uri.parse('package:dart_vscode/dart_vscode.dart'),
  );
  if (library == null || library.scheme != 'file') {
    throw const CliException(
      'Could not locate the dart_vscode package.',
      code: 'FRAMEWORK_PACKAGE_NOT_FOUND',
    );
  }
  return Directory(p.dirname(p.dirname(library.toFilePath())));
}

/// Locates the installed flutter_vscode package root.
///
/// The pinned baseline, generator sources, and framework resources the
/// commands read all live beneath this directory.
Future<Directory> resolvePackageRoot() async {
  final library = await Isolate.resolvePackageUri(
    Uri.parse('package:flutter_vscode/manifest.dart'),
  );
  if (library == null || library.scheme != 'file') {
    throw const CliException(
      'Could not locate the flutter_vscode package.',
      code: 'FRAMEWORK_PACKAGE_NOT_FOUND',
    );
  }
  return Directory(p.dirname(p.dirname(library.toFilePath())));
}

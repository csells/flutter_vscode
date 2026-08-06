import 'dart:io';
import 'dart:isolate';

import 'package:flutter_vscode/src/cli/cli_exception.dart';
import 'package:path/path.dart' as p;

// The VS Code baseline itself lives in package:dart_vscode as
// `vscodeApiVersion`: the API layer, contribution semantics, and manifest
// engines pin all ship there and move together. This module only locates
// installed package roots.

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
/// The framework sources the build receipt digests live beneath this
/// directory.
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

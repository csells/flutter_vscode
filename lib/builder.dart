// This file is the entry point for the build_runner.
// It configures the code generator.

import 'package:build/build.dart';
import 'package:flutter_vscode/src/vscode_generator.dart';
import 'package:flutter_vscode/src/vscode_ts_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Configures the build process for the VS Code Dart generator.
///
/// This function is referenced in `build.yaml` and tells `build_runner`
/// how to apply the [VSCodeGenerator] to the user's source code.
Builder vscodeDartGenerator(BuilderOptions options) {
  return SharedPartBuilder([VSCodeGenerator()], 'vscode');
}

/// Configures the build process for the VS Code TypeScript generator.
///
/// This function is referenced in `build.yaml` and tells `build_runner`
/// how to apply the [VSCodeTsGenerator] to the user's source code.
Builder vscodeTsGenerator(BuilderOptions options) {
  return VSCodeTsGenerator();
}

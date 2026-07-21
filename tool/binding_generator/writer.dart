/// Safe file writer for deterministic binding artifacts.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

import 'generator.dart';

/// Writes [generated] beneath [outputRoot] in stable path order.
Future<void> writeGeneratedBindings(
  VSCodeGeneratedBindings generated,
  Directory outputRoot,
) async {
  final rootPath = p.normalize(p.absolute(outputRoot.path));
  final paths = generated.files.keys.toList()..sort();
  for (final relativePath in paths) {
    if (p.isAbsolute(relativePath)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OUTPUT_PATH',
        'Generated output path must be relative: $relativePath.',
      );
    }
    final outputPath = p.normalize(p.join(rootPath, relativePath));
    if (!p.isWithin(rootPath, outputPath)) {
      throw VSCodeBindingGenerationException(
        'INVALID_OUTPUT_PATH',
        'Generated output path escapes the output root: $relativePath.',
      );
    }
    final output = File(outputPath);
    await output.parent.create(recursive: true);
    await output.writeAsString(generated.files[relativePath]!, flush: true);
  }
}

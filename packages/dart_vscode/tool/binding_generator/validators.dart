/// Leaf scalar validators of the binding pipeline. The JSON coercion
/// helpers live in `package:dart_vscode` (shared with author-data
/// contribution projection) and are re-exported here; the digest and
/// integer validators are maintainer-tool concerns.
library;

import 'package:dart_vscode/src/contributions/json_values.dart';

import 'generator.dart';

export 'package:dart_vscode/src/contributions/ecmascript_whitespace.dart';
export 'package:dart_vscode/src/contributions/json_values.dart';

/// Requires a value to be a lowercase SHA-256 digest.
String sha256Digest(Object? value, String path) {
  final result = string(value, path);
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(result)) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a lowercase SHA-256 digest.',
    );
  }
  return result;
}

/// Reads an optional integer, substituting a default when absent.
int integerOrDefault(
  Object? value, {
  required int defaultValue,
  required String path,
}) {
  if (value == null) {
    return defaultValue;
  }
  if (value is! int) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be an integer.',
    );
  }
  return value;
}

/// Requires a value to be an integer.
int integer(Object? value, String path) {
  if (value is! int) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be an integer.',
    );
  }
  return value;
}

/// Leaf scalar validators shared by the generator, the IR
/// validation projection, the coverage ledger, and the manifest
/// projection: each coerces one JSON value or raises an
/// actionable generation failure.
library;

import 'ecmascript_whitespace.dart';
import 'generator.dart';

/// Requires a value to be a JSON array.
List<Object?> objectList(Object? value, String path) {
  if (value is! List<Object?>) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a JSON array.',
    );
  }
  return value;
}

/// Requires a value to be a string-keyed JSON object.
Map<String, Object?> objectMap(Object? value, String path) {
  if (value is! Map<Object?, Object?>) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a JSON object.',
    );
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw VSCodeBindingGenerationException(
        'INVALID_GENERATOR_INPUT',
        '$path contains a non-string key.',
      );
    }
    result[entry.key! as String] = entry.value;
  }
  return result;
}

/// Requires a value to be a string.
String string(Object? value, String path) {
  if (value is! String) {
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      '$path must be a string.',
    );
  }
  return value;
}

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

/// Requires a value to be a non-empty string.
String nonEmptyString(Object? value, String path) {
  final result = string(value, path);
  if (result.isEmpty) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      '$path must not be empty.',
    );
  }
  return result;
}

/// Requires a value to be a lower-kebab extension identifier component.
String extensionIdentifierComponent(Object? value, String path) {
  final result = nonEmptyString(value, path);
  if (!RegExp(r'^[a-z0-9][a-z0-9-]*$').hasMatch(result)) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      '$path "$result" is unsafe for a packaged extension identifier. '
          'flutter_vscode requires lower-kebab components: start with a '
          'lowercase ASCII letter or digit, then use only lowercase ASCII '
          'letters, digits, or hyphens.',
    );
  }
  return result;
}

/// Requires a value to contain a non-whitespace character.
String nonWhitespaceString(Object? value, String path) {
  final result = string(value, path);
  if (isEcmaScriptFalsyOrWhitespace(result)) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      '$path must contain a non-whitespace character.',
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

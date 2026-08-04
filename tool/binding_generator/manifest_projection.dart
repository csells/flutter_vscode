/// The manifest and contribution projection: the pinned upstream
/// manifest schema, manifest validator, and commands contribution
/// schema checks, plus the Extension Project descriptor and
/// command contribution validation.
library;

import 'dart:convert';

import 'generator.dart';
import 'validators.dart';

/// Validates the pinned manifest schema projection and returns its input hash.
String validateManifestSchema(Map<String, Object?> inventory) {
  final schema = objectMap(
    inventory['manifestSchema'],
    'inventory.manifestSchema',
  );
  final inputSha256 = sha256Digest(
    schema['inputSha256'],
    'inventory.manifestSchema.inputSha256',
  );
  const expectedProjection = <String, Object?>{
    'schemaUri': 'vscode://schemas/vscode-extensions',
    'standalone': false,
    'properties': <String, Object?>{
      'activationEvents': <String, Object?>{
        'type': 'array',
        'items': <String, Object?>{'type': 'string'},
      },
      'contributes': <String, Object?>{'type': 'object'},
      'displayName': <String, Object?>{'type': 'string'},
      'engines': <String, Object?>{
        'type': 'object',
        'properties': <String, Object?>{
          'vscode': <String, Object?>{'type': 'string'},
        },
      },
      'publisher': <String, Object?>{'type': 'string'},
    },
  };
  final projection = Map<String, Object?>.of(schema)..remove('inputSha256');
  if (jsonEncode(projection) != jsonEncode(expectedProjection)) {
    final differingPath = _firstJsonDifferencePath(
      expectedProjection,
      projection,
      'inventory.manifestSchema',
    );
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Pinned manifest schema contains an unprojected change. First '
          'differing path: $differingPath. Regenerate the IR from the pinned '
          'input; if upstream changed, review and update the generator '
          'projection before retrying.',
    );
  }
  return inputSha256;
}

/// Validates the pinned manifest validator projection and returns its input hash.
String validateManifestValidator(Map<String, Object?> inventory) {
  final validator = objectMap(
    inventory['manifestValidator'],
    'inventory.manifestValidator',
  );
  final inputSha256 = sha256Digest(
    validator['inputSha256'],
    'inventory.manifestValidator.inputSha256',
  );
  const expectedProjection = <String, Object?>{
    'generatedManifestRules': <Object?>[
      <String, Object?>{
        'path': 'publisher',
        'presence': 'optional',
        'type': 'string',
      },
      <String, Object?>{
        'path': 'name',
        'presence': 'required',
        'type': 'string',
      },
      <String, Object?>{
        'path': 'version',
        'presence': 'required',
        'type': 'string',
      },
      <String, Object?>{
        'path': 'engines',
        'presence': 'required',
        'type': 'object',
      },
      <String, Object?>{
        'path': 'engines.vscode',
        'presence': 'required',
        'type': 'string',
      },
      <String, Object?>{
        'path': 'activationEvents',
        'presence': 'optional',
        'type': 'string[]',
        'requiresAny': <Object?>['main', 'browser'],
      },
      <String, Object?>{
        'path': 'main',
        'presence': 'optional',
        'type': 'string',
      },
    ],
    'versionPredicate': 'semver.valid',
    'engineVersionSyntax': <String, Object?>{
      'source': r'^(\^|>=)?((\d+)|x)\.((\d+)|x)\.((\d+)|x)(\-.*)?$',
      'flags': '',
    },
    'validatorBodySha256':
        'a7df6554afff3fa5c5e021f793fc8a4662fc641ade451565a8ff59929cf5a171',
    'projectionLimits': <String, Object?>{
      'remainingValidatorBranches': 'integrityPinnedByValidatorBodySha256',
      'semverValidImplementation': 'unprojectedExternal',
    },
  };
  final projection = Map<String, Object?>.of(validator)..remove('inputSha256');
  if (jsonEncode(projection) != jsonEncode(expectedProjection)) {
    final differingPath = _firstJsonDifferencePath(
      expectedProjection,
      projection,
      'inventory.manifestValidator',
    );
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Pinned manifest validator contains an unprojected change. '
          'First differing path: $differingPath. Regenerate the IR from the '
          'pinned input; if upstream changed, review and update the generator '
          'projection before retrying.',
    );
  }
  return inputSha256;
}

/// Validates the pinned commands contribution schema and returns its input hash.
String validateCommandsContributionSchema(
  Map<String, Object?> inventory,
) {
  final schemas = objectMap(
    inventory['contributionSchemas'],
    'inventory.contributionSchemas',
  );
  if (schemas.keys.length != 1 || !schemas.containsKey('commands')) {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Inventory must contain exactly the commands contribution schema.',
    );
  }
  final commands = objectMap(
    schemas['commands'],
    'inventory.contributionSchemas.commands',
  );
  final inputSha256 = sha256Digest(
    commands['inputSha256'],
    'inventory.contributionSchemas.commands.inputSha256',
  );
  const expectedProjection = <String, Object?>{
    'extensionPoint': 'commands',
    'accepts': <Object?>['object', 'array'],
    'itemSchema': <String, Object?>{
      'type': 'object',
      'required': <Object?>['command', 'title'],
      'properties': <String, Object?>{
        'category': <String, Object?>{'type': 'string'},
        'command': <String, Object?>{'type': 'string'},
        'enablement': <String, Object?>{'type': 'string'},
        'icon': <String, Object?>{
          'anyOf': <Object?>[
            <String, Object?>{'type': 'string'},
            <String, Object?>{
              'type': 'object',
              'properties': <String, Object?>{
                'dark': <String, Object?>{'type': 'string'},
                'light': <String, Object?>{'type': 'string'},
              },
            },
          ],
        },
        'shortTitle': <String, Object?>{'type': 'string'},
        'title': <String, Object?>{'type': 'string'},
      },
    },
    'validation': <String, Object?>{
      'whitespacePredicate': 'ecmascript-trim-empty',
      'nonWhitespaceStringProperties': <Object?>['command', 'title'],
      'icon': <String, Object?>{
        'objectRequiredStringProperties': <Object?>['dark', 'light'],
      },
    },
  };
  final projection = Map<String, Object?>.of(commands)..remove('inputSha256');
  if (jsonEncode(projection) != jsonEncode(expectedProjection)) {
    final differingPath = _firstJsonDifferencePath(
      expectedProjection,
      projection,
      'inventory.contributionSchemas.commands',
    );
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Commands contribution schema contains an unprojected change. '
          'First differing path: $differingPath. Regenerate the IR from the '
          'pinned inputs; if upstream changed, review and update the generator '
          'projection before retrying.',
    );
  }
  return inputSha256;
}

String _firstJsonDifferencePath(
  Object? expected,
  Object? actual,
  String path,
) {
  if (expected is Map<Object?, Object?> && actual is Map<Object?, Object?>) {
    final expectedKeys = expected.keys.whereType<String>().toSet();
    final actualKeys = actual.keys.whereType<String>().toSet();
    if (expectedKeys.length != expected.length ||
        actualKeys.length != actual.length) {
      return path;
    }
    final keys = {...expectedKeys, ...actualKeys}.toList()..sort();
    for (final key in keys) {
      final childPath = '$path.$key';
      if (!expected.containsKey(key) || !actual.containsKey(key)) {
        return childPath;
      }
      if (jsonEncode(expected[key]) != jsonEncode(actual[key])) {
        return _firstJsonDifferencePath(
          expected[key],
          actual[key],
          childPath,
        );
      }
    }
    return path;
  }
  if (expected is List<Object?> && actual is List<Object?>) {
    final sharedLength =
        expected.length < actual.length ? expected.length : actual.length;
    for (var index = 0; index < sharedLength; index++) {
      if (jsonEncode(expected[index]) != jsonEncode(actual[index])) {
        return _firstJsonDifferencePath(
          expected[index],
          actual[index],
          '$path[$index]',
        );
      }
    }
    return '$path[$sharedLength]';
  }
  return path;
}

/// Validates and projects the command contributions of an Extension Project.
List<Map<String, Object?>> projectCommands(Object? value) {
  if (value == null) {
    return const [];
  }
  final result = <Map<String, Object?>>[];
  final identifiers = <String>{};
  const supportedKeys = {
    'category',
    'command',
    'enablement',
    'icon',
    'shortTitle',
    'title',
  };
  for (final rawCommand in objectList(value, 'project.commands')) {
    final command = objectMap(rawCommand, 'project.commands entry');
    final unknown = command.keys
        .where((key) => !supportedKeys.contains(key))
        .toList()
      ..sort();
    if (unknown.isNotEmpty) {
      throw VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'Unknown command contribution fields: ${unknown.join(', ')}.',
      );
    }
    final identifier = nonWhitespaceString(
      command['command'],
      'project.commands entry.command',
    );
    if (!identifiers.add(identifier)) {
      throw VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'Duplicate command contribution $identifier.',
      );
    }
    final title = nonWhitespaceString(
      command['title'],
      'project.commands entry.title',
    );
    result.add(<String, Object?>{
      'command': identifier,
      'title': title,
      for (final key in ['shortTitle', 'category', 'enablement'])
        if (command[key] != null)
          key: string(command[key], 'project.commands entry.$key'),
      if (command['icon'] != null) 'icon': _projectCommandIcon(command['icon']),
    });
  }
  return result;
}

Object _projectCommandIcon(Object? value) {
  if (value is String) {
    return value;
  }
  final icon = objectMap(value, 'project.commands entry.icon');
  final unknown = icon.keys
      .where((key) => key != 'dark' && key != 'light')
      .toList()
    ..sort();
  if (unknown.isNotEmpty ||
      !icon.containsKey('dark') ||
      !icon.containsKey('light')) {
    throw const VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      'Command icon must be a string or an object containing both dark and '
          'light string paths and no other fields.',
    );
  }
  return <String, Object?>{
    'dark': string(icon['dark'], 'project.commands entry.icon.dark'),
    'light': string(
      icon['light'],
      'project.commands entry.icon.light',
    ),
  };
}

/// Validates the key set and schema version of an Extension Project descriptor.
void validateProjectDescriptor(Map<String, Object?> project) {
  const expectedKeys = {
    'activationEvents',
    'commands',
    'description',
    'displayName',
    'name',
    'publisher',
    'schemaVersion',
    'version',
  };
  final unexpected =
      project.keys.where((key) => !expectedKeys.contains(key)).toList()..sort();
  if (unexpected.isNotEmpty) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_DESCRIPTOR',
      'Unknown project descriptor fields: ${unexpected.join(', ')}.',
    );
  }
  if (project['schemaVersion'] != 1) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_DESCRIPTOR',
      'project.schemaVersion must be 1, found ${project['schemaVersion']}.',
    );
  }
}

/// Whether a version string is a strict semantic version.
bool isStrictSemanticVersion(String value) {
  final match = RegExp(
    r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)'
    r'(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
    r'(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$',
  ).firstMatch(value);
  if (match == null) {
    return false;
  }
  final preRelease = match.group(4);
  if (preRelease == null) {
    return true;
  }
  return preRelease.split('.').every(
        (part) =>
            !RegExp(r'^\d+$').hasMatch(part) ||
            part == '0' ||
            !part.startsWith('0'),
      );
}

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
  const expectedSchemas = [
    'commands',
    'configuration',
    'views',
    'viewsContainers',
  ];
  final schemaNames = schemas.keys.toList()..sort();
  if (schemaNames.join(',') != expectedSchemas.join(',')) {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Inventory must contain exactly the commands, configuration, views, '
          'and viewsContainers contribution schemas.',
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

/// The shared view item schema, reviewed against the pinned extraction.
const _viewItemSchema = <String, Object?>{
  'type': 'object',
  'required': <Object?>['id', 'name', 'icon'],
  'properties': <String, Object?>{
    'accessibilityHelpContent': <String, Object?>{'type': 'string'},
    'contextualTitle': <String, Object?>{'type': 'string'},
    'icon': <String, Object?>{'type': 'string'},
    'id': <String, Object?>{'type': 'string'},
    'initialSize': <String, Object?>{'type': 'number'},
    'name': <String, Object?>{'type': 'string'},
    'type': <String, Object?>{
      'type': 'string',
      'enum': <Object?>['tree', 'webview'],
    },
    'visibility': <String, Object?>{
      'type': 'string',
      'enum': <Object?>['visible', 'hidden', 'collapsed'],
    },
    'when': <String, Object?>{'type': 'string'},
  },
};

/// Validates the pinned views and viewsContainers schemas; returns their
/// shared input hash. Both live in one pinned source file, so one hash
/// covers both -- the generator refuses an inventory where they diverge.
String validateViewsContributionSchemas(Map<String, Object?> inventory) {
  final schemas = objectMap(
    inventory['contributionSchemas'],
    'inventory.contributionSchemas',
  );
  final containers = objectMap(
    schemas['viewsContainers'],
    'inventory.contributionSchemas.viewsContainers',
  );
  final views = objectMap(
    schemas['views'],
    'inventory.contributionSchemas.views',
  );
  final containersSha256 = sha256Digest(
    containers['inputSha256'],
    'inventory.contributionSchemas.viewsContainers.inputSha256',
  );
  final viewsSha256 = sha256Digest(
    views['inputSha256'],
    'inventory.contributionSchemas.views.inputSha256',
  );
  if (containersSha256 != viewsSha256) {
    throw const VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'views and viewsContainers must share one pinned source file.',
    );
  }
  const expectedContainers = <String, Object?>{
    'extensionPoint': 'viewsContainers',
    'accepts': <Object?>['object'],
    'locations': <Object?>['activitybar', 'panel', 'secondarySidebar'],
    'itemSchema': <String, Object?>{
      'type': 'object',
      'required': <Object?>['id', 'title', 'icon'],
      'properties': <String, Object?>{
        'icon': <String, Object?>{'type': 'string'},
        'id': <String, Object?>{
          'type': 'string',
          'pattern': r'^[a-zA-Z0-9_-]+$',
        },
        'title': <String, Object?>{'type': 'string'},
      },
    },
    'validation': <String, Object?>{
      'whitespacePredicate': 'ecmascript-trim-empty',
      'idPattern': r'^[a-zA-Z0-9_-]+$',
      'requiredStringProperties': <Object?>['id', 'title', 'icon'],
      'nonWhitespaceStringProperties': <Object?>['id'],
      'whitespaceWarningProperties': <Object?>['title'],
    },
  };
  const expectedViews = <String, Object?>{
    'extensionPoint': 'views',
    'accepts': <Object?>['object'],
    'locations': <Object?>['debug', 'explorer', 'scm', 'test'],
    'remoteLocations': <Object?>['remote'],
    'additionalLocations': true,
    'itemSchema': _viewItemSchema,
    'remoteItemSchema': <String, Object?>{
      'type': 'object',
      'required': <Object?>['id', 'name'],
      'properties': <String, Object?>{
        'group': <String, Object?>{'type': 'string'},
        'id': <String, Object?>{'type': 'string'},
        'name': <String, Object?>{'type': 'string'},
        'remoteName': <String, Object?>{
          'type': <Object?>['string', 'array'],
          'items': <String, Object?>{'type': 'string'},
        },
        'when': <String, Object?>{'type': 'string'},
      },
    },
    'validation': <String, Object?>{
      'requiredStringProperties': <Object?>['id', 'name'],
      'optionalStringProperties': <Object?>['when', 'icon', 'contextualTitle'],
      'visibilityEnum': <Object?>['visible', 'hidden', 'collapsed'],
    },
  };
  _expectReviewedProjection(
    containers,
    expectedContainers,
    'inventory.contributionSchemas.viewsContainers',
  );
  _expectReviewedProjection(
    views,
    expectedViews,
    'inventory.contributionSchemas.views',
  );
  return viewsSha256;
}

/// Validates the pinned configuration schema; returns its input hash.
String validateConfigurationContributionSchema(
  Map<String, Object?> inventory,
) {
  final schemas = objectMap(
    inventory['contributionSchemas'],
    'inventory.contributionSchemas',
  );
  final configuration = objectMap(
    schemas['configuration'],
    'inventory.contributionSchemas.configuration',
  );
  final inputSha256 = sha256Digest(
    configuration['inputSha256'],
    'inventory.contributionSchemas.configuration.inputSha256',
  );
  const expected = <String, Object?>{
    'extensionPoint': 'configuration',
    'accepts': <Object?>['object', 'array'],
    'entrySchema': <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'order': <String, Object?>{'type': 'integer'},
        'properties': <String, Object?>{
          'type': 'object',
          'propertyNames': <String, Object?>{'pattern': r'\S+'},
          'additionalProperties': <String, Object?>{},
        },
        'title': <String, Object?>{'type': 'string'},
      },
    },
    'validation': <String, Object?>{
      'propertyNamePattern': r'\S+',
      'titleType': 'string',
    },
  };
  _expectReviewedProjection(
    configuration,
    expected,
    'inventory.contributionSchemas.configuration',
  );
  return inputSha256;
}

void _expectReviewedProjection(
  Map<String, Object?> actual,
  Map<String, Object?> expected,
  String path,
) {
  final projection = Map<String, Object?>.of(actual)..remove('inputSha256');
  if (jsonEncode(projection) != jsonEncode(expected)) {
    final differingPath = _firstJsonDifferencePath(expected, projection, path);
    throw VSCodeBindingGenerationException(
      'INVALID_GENERATOR_INPUT',
      'Contribution schema at $path contains an unprojected change. First '
          'differing path: $differingPath. Regenerate the IR from the pinned '
          'inputs; if upstream changed, review and update the generator '
          'projection before retrying.',
    );
  }
}

/// Projects author viewsContainers data against the pinned schema.
Map<String, Object?> projectViewsContainers(Object? value) {
  if (value == null) {
    return const {};
  }
  const locations = {'activitybar', 'panel', 'secondarySidebar'};
  final idPattern = RegExp(r'^[a-zA-Z0-9_-]+$');
  final result = <String, Object?>{};
  final byLocation = objectMap(value, 'project.viewsContainers');
  final identifiers = <String>{};
  for (final location in byLocation.keys.toList()..sort()) {
    if (!locations.contains(location)) {
      throw VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'Unknown views container location $location; the pinned VS Code '
            'accepts ${locations.join(', ')}.',
      );
    }
    final containers = <Map<String, Object?>>[];
    for (final rawContainer in objectList(
      byLocation[location],
      'project.viewsContainers.$location',
    )) {
      final container = objectMap(
        rawContainer,
        'project.viewsContainers.$location entry',
      );
      final unknown = container.keys
          .where((key) => !{'id', 'title', 'icon'}.contains(key))
          .toList()
        ..sort();
      if (unknown.isNotEmpty) {
        throw VSCodeBindingGenerationException(
          'INVALID_PROJECT_MANIFEST',
          'Unknown views container fields: ${unknown.join(', ')}.',
        );
      }
      final identifier = nonWhitespaceString(
        container['id'],
        'project.viewsContainers.$location entry.id',
      );
      if (!idPattern.hasMatch(identifier)) {
        throw VSCodeBindingGenerationException(
          'INVALID_PROJECT_MANIFEST',
          'Views container id $identifier must match '
              '${idPattern.pattern}.',
        );
      }
      if (!identifiers.add(identifier)) {
        throw VSCodeBindingGenerationException(
          'INVALID_PROJECT_MANIFEST',
          'Duplicate views container $identifier.',
        );
      }
      containers.add(<String, Object?>{
        'id': identifier,
        // A whitespace-only title is a warning in the pinned host, not an
        // error; the projection matches the platform instead of exceeding
        // it.
        'title': string(
          container['title'],
          'project.viewsContainers.$location entry.title',
        ),
        'icon': string(
          container['icon'],
          'project.viewsContainers.$location entry.icon',
        ),
      });
    }
    result[location] = containers;
  }
  return result;
}

/// Projects author views data against the pinned schema.
Map<String, Object?> projectViews(
  Object? value, {
  required Set<String> contributedContainers,
}) {
  if (value == null) {
    return const {};
  }
  const knownLocations = {'debug', 'explorer', 'scm', 'test'};
  const remoteLocations = {'remote'};
  const optionalStrings = {
    'when',
    'icon',
    'contextualTitle',
    'accessibilityHelpContent',
  };
  const visibilityEnum = {'visible', 'hidden', 'collapsed'};
  const typeEnum = {'tree', 'webview'};
  final result = <String, Object?>{};
  final byLocation = objectMap(value, 'project.views');
  final identifiers = <String>{};
  for (final location in byLocation.keys.toList()..sort()) {
    if (remoteLocations.contains(location)) {
      throw VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'The $location views container needs the contribViewsRemote API '
            'proposal, which stable extensions cannot enable.',
      );
    }
    if (!knownLocations.contains(location) &&
        !contributedContainers.contains(location)) {
      throw VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'Views location $location is neither a built-in container '
            '(${knownLocations.join(', ')}) nor one contributed by this '
            'extension.',
      );
    }
    final views = <Map<String, Object?>>[];
    for (final rawView in objectList(
      byLocation[location],
      'project.views.$location',
    )) {
      final view = objectMap(rawView, 'project.views.$location entry');
      final unknown = view.keys
          .where(
            (key) => !{
              'id',
              'name',
              'icon',
              'type',
              'visibility',
              'initialSize',
              ...optionalStrings,
            }.contains(key),
          )
          .toList()
        ..sort();
      if (unknown.isNotEmpty) {
        throw VSCodeBindingGenerationException(
          'INVALID_PROJECT_MANIFEST',
          'Unknown view fields: ${unknown.join(', ')}.',
        );
      }
      final identifier = nonWhitespaceString(
        view['id'],
        'project.views.$location entry.id',
      );
      if (!identifiers.add(identifier)) {
        throw VSCodeBindingGenerationException(
          'INVALID_PROJECT_MANIFEST',
          'Duplicate view $identifier.',
        );
      }
      final projected = <String, Object?>{
        'id': identifier,
        'name': string(view['name'], 'project.views.$location entry.name'),
        // Required by the pinned manifest schema, though the runtime
        // tolerates its absence: the build follows the schema.
        'icon': string(view['icon'], 'project.views.$location entry.icon'),
      };
      final type = view['type'];
      if (type != null) {
        final typed = string(type, 'project.views.$location entry.type');
        if (!typeEnum.contains(typed)) {
          throw VSCodeBindingGenerationException(
            'INVALID_PROJECT_MANIFEST',
            'View type $typed must be one of ${typeEnum.join(', ')}.',
          );
        }
        projected['type'] = typed;
      }
      final visibility = view['visibility'];
      if (visibility != null) {
        final typed = string(
          visibility,
          'project.views.$location entry.visibility',
        );
        if (!visibilityEnum.contains(typed)) {
          throw VSCodeBindingGenerationException(
            'INVALID_PROJECT_MANIFEST',
            'View visibility $typed must be one of '
                '${visibilityEnum.join(', ')}.',
          );
        }
        projected['visibility'] = typed;
      }
      final initialSize = view['initialSize'];
      if (initialSize != null) {
        if (initialSize is! num) {
          throw const VSCodeBindingGenerationException(
            'INVALID_PROJECT_MANIFEST',
            'View initialSize must be a number.',
          );
        }
        projected['initialSize'] = initialSize;
      }
      for (final key in optionalStrings) {
        if (view[key] != null) {
          projected[key] = string(
            view[key],
            'project.views.$location entry.$key',
          );
        }
      }
      views.add(projected);
    }
    result[location] = views;
  }
  return result;
}

/// Projects author configuration data against the pinned schema.
Map<String, Object?> projectConfiguration(Object? value) {
  if (value == null) {
    return const {};
  }
  final entry = objectMap(value, 'project.configuration');
  final unknown = entry.keys
      .where((key) => !{'title', 'order', 'properties'}.contains(key))
      .toList()
    ..sort();
  if (unknown.isNotEmpty) {
    throw VSCodeBindingGenerationException(
      'INVALID_PROJECT_MANIFEST',
      'Unknown configuration fields: ${unknown.join(', ')}.',
    );
  }
  final result = <String, Object?>{};
  if (entry['title'] != null) {
    result['title'] = string(entry['title'], 'project.configuration.title');
  }
  final order = entry['order'];
  if (order != null) {
    if (order is! int) {
      throw const VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'configuration.order must be an integer.',
      );
    }
    result['order'] = order;
  }
  final properties = objectMap(
    entry['properties'],
    'project.configuration.properties',
  );
  final nonWhitespace = RegExp(r'\S');
  final projected = <String, Object?>{};
  for (final name in properties.keys.toList()..sort()) {
    if (!nonWhitespace.hasMatch(name)) {
      throw const VSCodeBindingGenerationException(
        'INVALID_PROJECT_MANIFEST',
        'Configuration property names must contain a non-whitespace '
            'character.',
      );
    }
    // The pinned schema accepts any draft-07 schema as a property value;
    // the projection passes the author value through untouched.
    projected[name] = objectMap(
      properties[name],
      'project.configuration.properties.$name',
    );
  }
  result['properties'] = projected;
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
    'configuration',
    'views',
    'viewsContainers',
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

import 'dart:io';

import 'package:flutter_vscode/src/cli/project_descriptor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Writes [source] as an `extension.dart` descriptor and parses it.
Future<Map<String, Object?>> _parse(String source) async {
  final directory = await Directory.systemTemp.createTemp(
    'flutter_vscode_descriptor_unit_',
  );
  addTearDown(() => directory.delete(recursive: true));
  final descriptor = File(p.join(directory.path, 'extension.dart'))
    ..writeAsStringSync(source);
  return readProjectDescriptor(descriptor);
}

Matcher _throwsActionably(String fragment) => throwsA(
      isA<FormatException>().having(
        (error) => error.message,
        'message',
        contains(fragment),
      ),
    );

void main() {
  test('parses the typed manifest declaration into the descriptor map',
      () async {
    final project = await _parse('''
import 'package:flutter_vscode/manifest.dart';

/// Dart-owned extension metadata consumed by `flutter_vscode build`.
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension '
      'written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: ['onLanguage:json'],
  commands: [
    ExtensionCommand(
      command: 'my-extension.hello',
      title: 'Say Hello from Dart',
    ),
    ExtensionCommand(command: 'my-extension.bye', title: 'Say Goodbye'),
  ],
);
''');

    expect(project, <String, Object?>{
      'schemaVersion': 1,
      'name': 'my-extension',
      'displayName': 'My Extension',
      'description': 'A VS Code extension written in Dart.',
      'version': '0.0.1',
      'publisher': 'local',
      'activationEvents': <Object?>['onLanguage:json'],
      'commands': <Object?>[
        <String, Object?>{
          'command': 'my-extension.hello',
          'title': 'Say Hello from Dart',
        },
        <String, Object?>{
          'command': 'my-extension.bye',
          'title': 'Say Goodbye',
        },
      ],
      'viewsContainers': <String, Object?>{},
      'views': <String, Object?>{},
      'configuration': null,
    });
  });

  test('parses view, container, and configuration declarations', () async {
    final project = await _parse(r'''
import 'package:flutter_vscode/manifest.dart';

/// Dart-owned extension metadata consumed by `flutter_vscode build`.
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
  viewsContainers: {
    'activitybar': [
      ExtensionViewContainer(
        id: 'myContainer',
        title: 'Mine',
        icon: r'$(package)',
      ),
    ],
  },
  views: {
    'myContainer': [
      ExtensionView(
        id: 'my.tree',
        name: 'My Tree',
        icon: r'$(list-tree)',
        visibility: 'collapsed',
      ),
    ],
  },
  configuration: ExtensionConfiguration(
    title: 'Mine',
    properties: {
      'my.setting': {'type': 'string', 'default': 'x'},
    },
  ),
);
''');

    expect(project['viewsContainers'], <String, Object?>{
      'activitybar': <Object?>[
        <String, Object?>{
          'id': 'myContainer',
          'title': 'Mine',
          'icon': r'$(package)',
        },
      ],
    });
    expect(project['views'], <String, Object?>{
      'myContainer': <Object?>[
        <String, Object?>{
          'id': 'my.tree',
          'name': 'My Tree',
          'icon': r'$(list-tree)',
          'type': null,
          'when': null,
          'visibility': 'collapsed',
          'contextualTitle': null,
          'initialSize': null,
        },
      ],
    });
    expect(project['configuration'], <String, Object?>{
      'title': 'Mine',
      'order': null,
      'properties': <String, Object?>{
        'my.setting': <String, Object?>{'type': 'string', 'default': 'x'},
      },
    });
  });

  test('injects the const defaults the manifest type declares', () async {
    final project = await _parse('''
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
);
''');

    expect(project['schemaVersion'], 1);
    expect(project['commands'], isEmpty);
  });

  test('accepts an explicit const constructor invocation', () async {
    final project = await _parse('''
const extension = const ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
  commands: [const ExtensionCommand(command: 'a.b', title: 'T')],
);
''');

    expect(project['name'], 'my-extension');
    expect(project['commands'], <Object?>[
      <String, Object?>{'command': 'a.b', 'title': 'T'},
    ]);
  });

  test('rejects the retired map-literal descriptor actionably', () {
    expect(
      _parse('''
const extension = <String, Object?>{
  'schemaVersion': 1,
  'name': 'my-extension',
};
'''),
      _throwsActionably('const extension = ExtensionManifest('),
    );
  });

  test('rejects imports other than the manifest library', () {
    expect(
      _parse('''
import 'dart:io';

const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
);
'''),
      _throwsActionably('package:flutter_vscode/manifest.dart'),
    );
  });

  test('rejects identifier references as argument values', () {
    expect(
      _parse('''
const extension = ExtensionManifest(
  name: someName,
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
);
'''),
      _throwsActionably('references'),
    );
  });

  test('rejects string interpolation', () {
    expect(
      _parse(r'''
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My ${1 + 1} Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
);
'''),
      _throwsActionably('interpolation'),
    );
  });

  test('rejects function-call values', () {
    expect(
      _parse('''
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: readVersion(),
  publisher: 'local',
  activationEvents: [],
);
'''),
      _throwsActionably('function calls'),
    );
  });

  test('rejects unknown named arguments actionably', () {
    expect(
      _parse('''
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
  colour: 'blue',
);
'''),
      _throwsActionably('colour'),
    );
  });

  test('rejects positional arguments', () {
    expect(
      _parse('''
const extension = ExtensionManifest(
  'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
);
'''),
      _throwsActionably('named'),
    );
  });

  test('rejects duplicate named arguments', () {
    expect(
      _parse('''
const extension = ExtensionManifest(
  name: 'my-extension',
  name: 'my-other-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
);
'''),
      _throwsActionably('duplicate'),
    );
  });

  test('rejects missing required arguments actionably', () {
    expect(
      _parse('''
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  activationEvents: [],
);
'''),
      _throwsActionably('publisher'),
    );
  });

  test('rejects unknown command arguments actionably', () {
    expect(
      _parse('''
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
  commands: [
    ExtensionCommand(command: 'a.b', title: 'T', when: 'never'),
  ],
);
'''),
      _throwsActionably('when'),
    );
  });

  test('rejects a command missing its title', () {
    expect(
      _parse('''
const extension = ExtensionManifest(
  name: 'my-extension',
  displayName: 'My Extension',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [],
  commands: [ExtensionCommand(command: 'a.b')],
);
'''),
      _throwsActionably('title'),
    );
  });

  test('rejects executable descriptor shapes', () {
    expect(
      _parse('''
final extension = createManifest();

ExtensionManifest createManifest() => throw UnimplementedError();
'''),
      _throwsActionably('const extension = ExtensionManifest('),
    );
  });

  test(
    'descriptor type errors surface in dart analyze of the project',
    () async {
      final workspace = await Directory.systemTemp.createTemp(
        'flutter_vscode_descriptor_analyze_',
      );
      addTearDown(() => workspace.delete(recursive: true));
      final executable = p.join(
        Directory.current.path,
        'bin',
        'flutter_vscode.dart',
      );
      final create = await Process.run(
        'dart',
        [executable, 'create', 'my_extension'],
        workingDirectory: workspace.path,
      );
      expect(create.exitCode, 0, reason: '${create.stdout}\n${create.stderr}');
      final project = Directory(p.join(workspace.path, 'my_extension'));
      final get = await Process.run(
        'dart',
        const ['pub', 'get'],
        workingDirectory: project.path,
      );
      expect(get.exitCode, 0, reason: '${get.stdout}\n${get.stderr}');
      final descriptor = File(p.join(project.path, 'extension.dart'));
      descriptor.writeAsStringSync(
        descriptor
            .readAsStringSync()
            .replaceFirst("version: '0.0.1'", 'version: 1'),
      );

      final analyze = await Process.run(
        'dart',
        const ['analyze', 'extension.dart'],
        workingDirectory: project.path,
      );

      expect(
        analyze.exitCode,
        isNot(0),
        reason: 'A wrongly typed descriptor must fail dart analyze.\n'
            '${analyze.stdout}\n${analyze.stderr}',
      );
      expect('${analyze.stdout}', contains('argument_type_not_assignable'));
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

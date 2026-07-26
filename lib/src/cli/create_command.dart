import 'dart:io';

import 'package:flutter_vscode/src/cli/baselines.dart';
import 'package:flutter_vscode/src/cli/binding_toolchain.dart';
import 'package:flutter_vscode/src/cli/cli_exception.dart';
import 'package:flutter_vscode/src/cli/host_commands_source.dart';
import 'package:flutter_vscode/src/cli/project_descriptor.dart';
import 'package:path/path.dart' as p;

/// Scaffolds a new Extension Project named [name] beneath [workspace].
Future<void> createProject(
  Directory workspace,
  String name, {
  required BindingToolchain toolchain,
}) async {
  if (!RegExp(r'^[a-z][a-z0-9]*(?:_[a-z0-9]+)*$').hasMatch(name)) {
    throw const CliException(
      'Project names must use lowercase_with_underscores.',
      code: 'INVALID_PROJECT_NAME',
      exitCode: 64,
    );
  }
  final root = Directory(p.join(workspace.path, name));
  if (root.existsSync()) {
    throw CliException(
      'Target already exists: ${root.path}',
      code: 'CREATE_TARGET_EXISTS',
    );
  }

  Directory(p.join(root.path, 'host', 'lib')).createSync(recursive: true);
  Directory(p.join(root.path, 'shared', 'lib')).createSync(recursive: true);
  Directory(p.join(root.path, 'views')).createSync(recursive: true);
  final manifestName = name.replaceAll('_', '-');

  final displayName = name
      .split('_')
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
  final packageRoot = await resolvePackageRoot();
  final descriptor = File(p.join(root.path, 'extension.dart'))
    ..writeAsStringSync('''
import 'package:flutter_vscode/manifest.dart';

/// Dart-owned extension metadata consumed by `flutter_vscode build`.
const extension = ExtensionManifest(
  apiTarget: '$defaultApiTarget',
  name: '$manifestName',
  displayName: '$displayName',
  description: 'A VS Code extension written in Dart.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: ['onLanguage:json'],
  commands: [
    ExtensionCommand(
      command: '$manifestName.hello',
      title: 'Say Hello from Dart',
    ),
  ],
);
''');
  // The root pubspec exists solely so the typed descriptor resolves
  // `package:flutter_vscode/manifest.dart` for the author's analyzer;
  // the build itself never reads it.
  File(p.join(root.path, 'pubspec.yaml')).writeAsStringSync('''
name: $name
publish_to: none

environment:
  sdk: ^3.12.0

dependencies:
  flutter_vscode:
    path: ${packageRoot.path}
''');
  File(p.join(root.path, 'host', 'pubspec.yaml')).writeAsStringSync('''
name: ${name}_host
publish_to: none

environment:
  sdk: ^3.12.0

dependencies:
  ${name}_shared:
    path: ../shared
''');
  File(p.join(root.path, 'shared', 'pubspec.yaml')).writeAsStringSync('''
name: ${name}_shared
publish_to: none

environment:
  sdk: ^3.12.0
''');
  File(p.join(root.path, 'host', 'lib', 'extension.dart'))
      .writeAsStringSync(_hostEntrypoint(name, manifestName));
  File(p.join(root.path, 'shared', 'lib', 'shared.dart')).writeAsStringSync(
    [
      '/// Shared values used by host and views.',
      "const helloMessage = 'Hello from Dart';",
      '',
    ].join('\n'),
  );

  final project = await readProjectDescriptor(descriptor);
  final bindingInputs = await selectBindingInputs(
    packageRoot: packageRoot,
    project: project,
    requireApiTarget: true,
  );
  final generated = toolchain.generateBindings(
    inventory: bindingInputs.inventory,
    overrides: bindingInputs.overrides,
    project: project,
  );
  await toolchain.writeBindings(
    {
      for (final entry in generated.entries)
        if (entry.key.startsWith('host/lib/generated/')) entry.key: entry.value,
      'host/lib/generated/vscode_dart_layer.g.dart':
          toolchain.emitDartLayerLibrary(bindingInputs.inventory),
      'host/lib/generated/host_commands.g.dart': hostCommandsSource,
    },
    root,
  );
}

String _hostEntrypoint(String projectName, String manifestName) => '''
import 'dart:js_interop';

import 'package:${projectName}_host/generated/host_exports.g.dart';
// The complete typed VS Code API generated into this project. Wrap the
// raw activation module with VscodeApi(rawVscode), or enter the
// Dart-first ergonomics layer over it with VscodeApi(rawVscode).dart.
import 'package:${projectName}_host/generated/vscode_dart_layer.g.dart';
// Runtime helpers: toHostPromise, toHostCallback, hostFetch.
import 'package:${projectName}_host/generated/vscode_runtime.g.dart';
import 'package:${projectName}_shared/shared.dart';

const _helloCommand = '$manifestName.hello';

@JSExport()
class _Extension {
  JSPromise<JSAny?> activate(
    JSObject rawContext,
    JSObject rawVscode,
  ) {
    final context = ExtensionContext(rawContext);
    final vscode = VscodeApi(rawVscode);

    final hello = (() => helloMessage.toJS).toJS;
    context.subscriptions.toDart.add(
      JSAnon_ffa2e03c40a2(
        vscode.commands.registerCommand(_helloCommand, toHostCallback(hello)),
      ),
    );

    final provideHover =
        (
              TextDocument document,
              Position position,
              CancellationToken token,
            ) {
              final contents = vscode.MarkdownString.new\$(
                'Hover from Dart at '
                        '\${position.line.toInt()}:'
                        '\${position.character.toInt()}'
                    .toJS,
              );
              final range =
                  vscode.Range.new\$\$2(0.toJS, 0.toJS, 0.toJS, 5.toJS);
              return vscode.Hover.new\$(contents, range);
            }
            .toJS;
    final provider = HoverProvider.lit\$(
      provideHover: toHostCallback(provideHover),
    );
    context.subscriptions.toDart.add(
      JSAnon_ffa2e03c40a2(
        vscode.languages.registerHoverProvider('json'.toJS, provider),
      ),
    );
    return Future<JSAny?>.value(null).toJS;
  }

  JSPromise<JSAny?> deactivate() => Future<JSAny?>.value(null).toJS;
}

void main() {
  registerHostExports(createJSInteropWrapper(_Extension()));
}
''';

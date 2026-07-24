import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive.dart';
import 'package:flutter_vscode/src/cli/build_receipt.dart';
import 'package:flutter_vscode/src/cli/flutter_view_host_source.dart';
import 'package:flutter_vscode/src/cli/project_descriptor.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

import '../tool/binding_generator/generator.dart';
import '../tool/binding_generator/parity_layer.dart';
import '../tool/binding_generator/writer.dart';
import '../tool/check_host_imports.dart';

Future<void> main(List<String> arguments) async {
  try {
    switch (arguments) {
      case ['create', final name]:
        await _createProject(name);
      case ['build']:
        await _buildProject(Directory.current);
      case ['build', '--watch']:
        await _buildWatch(Directory.current);
      case ['package']:
        await _packageProject(Directory.current);
      case ['doctor']:
        await _doctorProject(Directory.current);
      case ['test']:
        await _testProject(Directory.current);
      default:
        throw const _CliException(
          'Usage: flutter_vscode '
          '<create <project_name>|build [--watch]|package|doctor|test>',
          code: 'INVALID_USAGE',
          exitCode: 64,
        );
    }
  } on _CliException catch (error) {
    stderr.writeln('${error.code}: ${error.message}');
    exitCode = error.exitCode;
  } on VSCodeBindingGenerationException catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  } on HostDartSourceException catch (error) {
    final source = p
        .relative(error.path, from: Directory.current.path)
        .split(p.separator)
        .join('/');
    stderr.writeln(
      'INVALID_HOST_DART: $source:${error.line}:${error.column}: '
      '${error.message} Fix the Dart syntax and rerun flutter_vscode build.',
    );
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln('INVALID_PROJECT_DATA: Invalid project data: $error');
    exitCode = 1;
  } on FileSystemException catch (error) {
    stderr.writeln(
      'FILE_SYSTEM_ERROR: File system error: ${error.message} (${error.path})',
    );
    exitCode = 1;
  } on ProcessException catch (error) {
    stderr.writeln(
      'TOOL_COMMAND_START_FAILED: Could not start ${error.executable}: '
      '${error.message}',
    );
    exitCode = 1;
  }
}

Future<void> _createProject(String name) async {
  if (!RegExp(r'^[a-z][a-z0-9]*(?:_[a-z0-9]+)*$').hasMatch(name)) {
    throw const _CliException(
      'Project names must use lowercase_with_underscores.',
      code: 'INVALID_PROJECT_NAME',
      exitCode: 64,
    );
  }
  final root = Directory(p.join(Directory.current.path, name));
  if (root.existsSync()) {
    throw _CliException(
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
  final descriptor = File(p.join(root.path, 'extension.dart'))
    ..writeAsStringSync('''
/// Dart-owned extension metadata consumed by `flutter_vscode build`.
const extension = <String, Object?>{
  'schemaVersion': 1,
  'apiTarget': '1.129.1',
  'name': '$manifestName',
  'displayName': '$displayName',
  'description': 'A VS Code extension written in Dart.',
  'version': '0.0.1',
  'publisher': 'local',
  'activationEvents': <String>['onLanguage:json'],
  'commands': <Map<String, Object?>>[
    <String, Object?>{
      'command': '$manifestName.hello',
      'title': 'Say Hello from Dart',
    },
  ],
};
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

  final packageRoot = await _resolvePackageRoot();
  final project = await readProjectDescriptor(descriptor);
  final bindingInputs = await _selectBindingInputs(
    packageRoot: packageRoot,
    project: project,
    requireApiTarget: true,
  );
  final generated = VSCodeBindingGenerator().generate(
    inventory: bindingInputs.inventory,
    overrides: bindingInputs.overrides,
    project: project,
  );
  await writeGeneratedBindings(
    VSCodeGeneratedBindings({
      for (final entry in generated.files.entries)
        if (entry.key.startsWith('host/lib/generated/')) entry.key: entry.value,
    }),
    root,
  );
}

String _hostEntrypoint(String projectName, String manifestName) => '''
import 'dart:js_interop';

import 'package:${projectName}_host/generated/vscode_facade.g.dart';
// The complete typed VS Code API is also generated into this project:
//   import 'package:${projectName}_host/generated/vscode_parity_layer.g.dart';
// Wrap the raw activation module with VscodeApi(rawVscode) to use it.
import 'package:${projectName}_shared/shared.dart';

const _helloCommand = '$manifestName.hello';

@JSExport()
class _Extension {
  JSPromise<JSAny?> activate(
    JSObject rawContext,
    JSObject rawVscode,
  ) {
    final context = ExtensionContext.fromJS(rawContext);
    final vscode = VSCode.fromJS(rawVscode);

    final hello = (() => helloMessage.toJS).toJS;
    context.subscriptions.toDart.add(
      vscode.commands.registerCommandCallback(_helloCommand.toJS, hello),
    );

    final provideHover =
        (
              TextDocument document,
              Position position,
              CancellationToken token,
            ) {
              final contents = MarkdownString(
                'Hover from Dart at \${position.line}:\${position.character}'
                    .toJS,
              );
              return Hover(contents, Range(0, 0, 0, 5));
            }
            .toJS;
    final provider = HoverProvider(provideHover: provideHover);
    context.subscriptions.toDart.add(
      vscode.languages.registerHoverProvider('json'.toJS, provider),
    );
    return Future<JSAny?>.value(null).toJS;
  }

  JSPromise<JSAny?> deactivate() => Future<JSAny?>.value(null).toJS;
}

void main() {
  registerHostExports(createJSInteropWrapper(_Extension()));
}
''';

Future<void> _buildProject(Directory root) async {
  _validateProjectLayout(root);
  final dartDescriptor = File(p.join(root.path, 'extension.dart'));
  final jsonDescriptor = File(p.join(root.path, 'extension.json'));
  final hostRoot = Directory(p.join(root.path, 'host'));
  final entrypoint = File(p.join(hostRoot.path, 'lib', 'extension.dart'));
  if ((!dartDescriptor.existsSync() && !jsonDescriptor.existsSync()) ||
      !entrypoint.existsSync()) {
    throw const _CliException(
      'Run build from an Extension Project containing extension.dart and '
      'host/lib/extension.dart.',
      code: 'BUILD_NOT_EXTENSION_PROJECT',
      exitCode: 64,
    );
  }
  if (dartDescriptor.existsSync() && jsonDescriptor.existsSync()) {
    throw const _CliException(
      'Extension Project contains both extension.dart and extension.json. '
      'Remove the obsolete descriptor.',
      code: 'AMBIGUOUS_PROJECT_DESCRIPTOR',
    );
  }

  final views = _discoverViews(root);
  _validateFlutterViewLayout(root, views);
  final packageRoot = await _resolvePackageRoot();
  final project = dartDescriptor.existsSync()
      ? await readProjectDescriptor(dartDescriptor)
      : await _readJson(jsonDescriptor);
  final bindingInputs = await _selectBindingInputs(
    packageRoot: packageRoot,
    project: project,
    requireApiTarget: dartDescriptor.existsSync(),
  );
  final generated = VSCodeBindingGenerator().generate(
    inventory: bindingInputs.inventory,
    overrides: bindingInputs.overrides,
    project: project,
  );
  final generatedRoot = Directory(
    p.join(hostRoot.path, 'lib', 'generated'),
  );
  if (generatedRoot.existsSync()) {
    await generatedRoot.delete(recursive: true);
  }
  await writeGeneratedBindings(generated, root);
  final parityArtifacts = emitParityLayer(bindingInputs.inventory);
  await File(p.join(generatedRoot.path, 'vscode_parity_layer.g.dart'))
      .writeAsString(parityArtifacts.library);
  if (views.isNotEmpty) {
    final protocolSource = File(
      p.join(packageRoot.path, 'lib', 'src', 'view_protocol.dart'),
    );
    if (!protocolSource.existsSync()) {
      throw const _CliException(
        'flutter_vscode is missing its Host/Flutter View protocol source.',
        code: 'MISSING_FRAMEWORK_RESOURCE',
      );
    }
    await protocolSource.copy(
      p.join(generatedRoot.path, 'view_protocol.g.dart'),
    );
    await File(p.join(generatedRoot.path, 'flutter_view_host.g.dart'))
        .writeAsString(flutterViewHostSource);
  } else {
    final staleModule = File(
      p.join(generatedRoot.path, 'flutter_view_host.g.dart'),
    );
    if (staleModule.existsSync()) {
      await staleModule.delete();
    }
  }

  await _run(
    'dart',
    const ['pub', 'get'],
    workingDirectory: hostRoot.path,
    description: 'resolve Host Dart dependencies',
  );
  final packageConfig = File(
    p.join(hostRoot.path, '.dart_tool', 'package_config.json'),
  );
  final guardPackageConfig = await _writeDirectoryAwarePackageConfig(
    packageConfig,
  );
  late final List<String> violations;
  try {
    violations = _checkHostAndSharedImports(
      hostRoot: hostRoot,
      sharedRoot: Directory(p.join(root.path, 'shared')),
      packageConfig: guardPackageConfig,
    );
  } finally {
    await guardPackageConfig.delete();
  }
  if (violations.isNotEmpty) {
    throw _CliException(
      formatHostImportViolations(violations).trimRight(),
      code: 'HOST_IMPORT_BOUNDARY_VIOLATION',
    );
  }

  final out = Directory(p.join(root.path, 'out'));
  if (out.existsSync()) {
    await out.delete(recursive: true);
  }
  await out.create(recursive: true);
  await _run(
    'dart',
    [
      'compile',
      'js',
      '--server-mode',
      '--fatal-warnings',
      '-O2',
      entrypoint.path,
      '--output',
      p.join(out.path, 'extension.dart.js'),
    ],
    workingDirectory: hostRoot.path,
    description: 'compile Host Dart',
  );
  await File(p.join(hostRoot.path, 'bootstrap.cjs')).copy(
    p.join(out.path, 'bootstrap.cjs'),
  );
  for (final view in views) {
    await _run(
      'flutter',
      const ['pub', 'get'],
      workingDirectory: view.root.path,
      description: 'resolve Flutter View ${view.name} dependencies',
    );
    final output = p.join(out.path, 'views', view.name);
    await _run(
      'flutter',
      [
        'build',
        'web',
        '--release',
        '--output=$output',
        '--no-web-resources-cdn',
        '--csp',
        '--pwa-strategy',
        'none',
        '--no-tree-shake-icons',
      ],
      workingDirectory: view.root.path,
      description: 'build Flutter View ${view.name}',
    );
  }
  _viewOutputFiles(root, views);
  await _writeLaunchConfiguration(root);
  final toolIdentity = await _buildToolIdentity(
    packageRoot,
    bindingInputs.apiTarget,
  );
  await writeBuildReceipt(
    projectRoot: root,
    apiTarget: bindingInputs.apiTarget,
    toolIdentity: toolIdentity,
    inputPaths: _buildInputPaths(root),
    artifactPaths: _managedArtifactPaths(root),
  );
  stdout.writeln('Built ${root.path}');
}

List<String> _buildInputPaths(Directory root) {
  final paths = <String>[];
  for (final descriptor in ['extension.dart', 'extension.json']) {
    if (_projectFile(root, descriptor).existsSync()) {
      paths.add(descriptor);
    }
  }
  for (final path in [
    'host/pubspec.yaml',
    'host/pubspec.lock',
    'shared/pubspec.yaml',
  ]) {
    if (_projectFile(root, path).existsSync()) {
      paths.add(path);
    }
  }
  for (final sourceRoot in ['host/lib', 'shared/lib']) {
    final directory = Directory(_projectFile(root, sourceRoot).path);
    if (!directory.existsSync()) {
      continue;
    }
    for (final entity in _safeFiles(
      directory,
      description: '$sourceRoot source tree',
    )) {
      final relative = _relativeProjectPath(root, entity);
      if (!relative.startsWith('host/lib/generated/')) {
        paths.add(relative);
      }
    }
  }
  for (final view in _discoverViews(root)) {
    for (final file in _safeFiles(
      view.root,
      description: 'Flutter View ${view.name} source tree',
      excludedTopLevelNames: const {'.dart_tool', 'build'},
    )) {
      paths.add(_relativeProjectPath(root, file));
    }
  }
  return paths.toSet().toList()..sort();
}

List<String> _managedArtifactPaths(Directory root) {
  final paths = <String>[];
  for (final path in [
    '.vscode/launch.json',
    'coverage.json',
    'host/bootstrap.cjs',
    'package.json',
  ]) {
    if (_projectFile(root, path).existsSync()) {
      paths.add(path);
    }
  }
  for (final artifactRoot in ['host/lib/generated', 'out']) {
    final directory = Directory(_projectFile(root, artifactRoot).path);
    if (!directory.existsSync()) {
      continue;
    }
    for (final entity in _safeFiles(
      directory,
      description: '$artifactRoot Framework-Managed Artifact tree',
    )) {
      paths.add(_relativeProjectPath(root, entity));
    }
  }
  return paths.toSet().toList()..sort();
}

String _relativeProjectPath(Directory root, File file) =>
    p.relative(file.path, from: root.path).split(p.separator).join('/');

File _projectFile(Directory root, String relativePath) =>
    File(p.joinAll([root.path, ...p.posix.split(relativePath)]));

Future<void> _buildWatch(Directory root) async {
  Future<void> buildOnce() async {
    try {
      await _buildProject(root);
    } on _CliException catch (error) {
      stderr.writeln('${error.code}: ${error.message}');
    } on HostDartSourceException catch (error) {
      final source = p
          .relative(error.path, from: root.path)
          .split(p.separator)
          .join('/');
      stderr.writeln(
        'INVALID_HOST_DART: $source:${error.line}:${error.column}: '
        '${error.message}',
      );
    } on Object catch (error) {
      stderr.writeln('WATCH_BUILD_FAILED: $error');
    }
  }

  await buildOnce();
  stdout.writeln('Watching for changes; press Ctrl+C to stop.');

  bool relevant(FileSystemEvent event) {
    final path = event.path;
    final separator = p.separator;
    if (path.contains('$separator.dart_tool') ||
        path.contains('${separator}generated$separator') ||
        path.endsWith('${separator}generated') ||
        path.contains('${separator}out$separator') ||
        path.contains('${separator}build$separator')) {
      return false;
    }
    return true;
  }

  final events = StreamController<FileSystemEvent>();
  void watchTree(String path) {
    final directory = Directory(path);
    if (directory.existsSync()) {
      directory.watch(recursive: true).listen(events.add);
    }
  }

  watchTree(p.join(root.path, 'host', 'lib'));
  watchTree(p.join(root.path, 'shared', 'lib'));
  for (final view in _discoverViews(root)) {
    watchTree(p.join(view.root.path, 'lib'));
  }
  root.watch().where((event) {
    final name = p.basename(event.path);
    return name == 'extension.dart' || name == 'extension.json';
  }).listen(events.add);

  var pending = false;
  var running = false;
  Future<void> schedule() async {
    pending = true;
    if (running) {
      return;
    }
    running = true;
    while (pending) {
      pending = false;
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await buildOnce();
    }
    running = false;
  }

  events.stream.where(relevant).listen((_) => unawaited(schedule()));
  await Completer<void>().future;
}

Future<void> _doctorProject(Directory root) async {
  final checks = <(String, bool, String?)>[];

  Future<void> checkTool(String label, String executable) async {
    try {
      final result = await Process.run(executable, const ['--version']);
      final banner =
          '${result.stdout}${result.stderr}'.trim().split('\n').first.trim();
      checks.add((label, result.exitCode == 0, banner));
    } on ProcessException {
      checks.add((label, false, 'not found on PATH'));
    }
  }

  await checkTool('Dart SDK', 'dart');
  await checkTool('Flutter SDK', 'flutter');

  final dartDescriptor = File(p.join(root.path, 'extension.dart'));
  final jsonDescriptor = File(p.join(root.path, 'extension.json'));
  final insideProject =
      dartDescriptor.existsSync() || jsonDescriptor.existsSync();
  if (insideProject) {
    const requiredPaths = [
      'host',
      'host/lib',
      'host/lib/extension.dart',
      'shared',
      'shared/lib',
      'views',
    ];
    final missing = [
      for (final relative in requiredPaths)
        if (FileSystemEntity.typeSync(p.join(root.path, relative)) ==
            FileSystemEntityType.notFound)
          relative,
    ];
    if (missing.isNotEmpty) {
      checks.add(
        (
          'Project layout',
          false,
          'missing ${missing.join(', ')} — run flutter_vscode create for a '
              'reference layout',
        ),
      );
    } else {
      try {
        _validateProjectLayout(root);
        checks.add(('Project layout', true, null));
      } on _CliException catch (error) {
        checks.add(('Project layout', false, error.message));
      }
    }
    try {
      final project = await readProjectDescriptor(
        dartDescriptor.existsSync() ? dartDescriptor : jsonDescriptor,
      );
      final target = project['apiTarget'];
      if (target is String && target.isNotEmpty) {
        final packageRoot = await _resolvePackageRoot();
        final pins = File(
          p.join(
            packageRoot.path,
            'tool',
            'bindings',
            'inputs',
            'vscode',
            target,
            'pins.json',
          ),
        );
        checks.add(
          (
            'API target $target',
            pins.existsSync(),
            pins.existsSync()
                ? null
                : 'this flutter_vscode has no pinned inputs for $target',
          ),
        );
      } else {
        checks.add(
          (
            'API target',
            false,
            'apiTarget is missing from the project descriptor',
          ),
        );
      }
    } on Object catch (error) {
      checks.add(('Project descriptor', false, '$error'));
    }
  }

  var failures = 0;
  for (final (label, ok, detail) in checks) {
    final suffix = detail == null || detail.isEmpty ? '' : ': $detail';
    stdout.writeln('${ok ? '[ok]' : '[!!]'} $label$suffix');
    if (!ok) {
      failures += 1;
    }
  }
  if (!insideProject) {
    stdout.writeln(
      'This directory is not an Extension Project (no extension.dart); '
      'toolchain checks only.',
    );
  }
  if (failures == 0) {
    stdout.writeln('No issues found.');
  } else {
    stdout.writeln('$failures issue(s) found.');
    exitCode = 1;
  }
}

Future<void> _testProject(Directory root) async {
  _validateProjectLayout(root);
  final suites = <(String, Directory, String)>[];
  final shared = Directory(p.join(root.path, 'shared'));
  if (Directory(p.join(shared.path, 'test')).existsSync()) {
    suites.add(('shared', shared, 'dart'));
  }
  final host = Directory(p.join(root.path, 'host'));
  if (Directory(p.join(host.path, 'test')).existsSync()) {
    suites.add(('host', host, 'dart'));
  }
  for (final view in _discoverViews(root)) {
    if (Directory(p.join(view.root.path, 'test')).existsSync()) {
      suites.add(('views/${view.name}', view.root, 'flutter'));
    }
  }
  if (suites.isEmpty) {
    stdout.writeln(
      'No test suites found. Add tests under shared/test, host/test, or '
      'views/<name>/test.',
    );
    return;
  }
  var failures = 0;
  for (final (label, directory, tool) in suites) {
    stdout.writeln('--- $label');
    final resolve = await Process.run(
      tool,
      const ['pub', 'get'],
      workingDirectory: directory.path,
    );
    if (resolve.exitCode != 0) {
      stdout
        ..write(resolve.stdout)
        ..write(resolve.stderr);
      failures += 1;
      continue;
    }
    final run = await Process.run(
      tool,
      const ['test'],
      workingDirectory: directory.path,
    );
    stdout
      ..write(run.stdout)
      ..write(run.stderr);
    if (run.exitCode != 0) {
      failures += 1;
    }
  }
  if (failures == 0) {
    stdout.writeln('All suites passed.');
  } else {
    stdout.writeln('$failures suite(s) failed.');
    exitCode = 1;
  }
}

void _validateProjectLayout(Directory root) {
  _validateRealProjectDirectories(
    root,
    const [
      'host',
      'host/lib',
      'host/lib/generated',
      'host/.dart_tool',
      'shared',
      'shared/lib',
      'shared/.dart_tool',
      'views',
      'out',
      'build',
      '.dart_tool',
      '.dart_tool/flutter_vscode',
      '.vscode',
    ],
  );
  _validateRealProjectFileTargets(
    root,
    const [
      '.dart_tool/flutter_vscode/build.json',
      '.vscode/launch.json',
      'coverage.json',
      'host/.dart_tool/flutter_vscode_package_config.json',
      'host/.dart_tool/package_config.json',
      'host/bootstrap.cjs',
      'package.json',
    ],
  );
}

void _validateFlutterViewLayout(Directory root, List<_FlutterView> views) {
  _validateRealProjectDirectories(
    root,
    [
      for (final view in views) ...[
        'views/${view.name}',
        'views/${view.name}/lib',
        'views/${view.name}/.dart_tool',
        'views/${view.name}/build',
        'out/views/${view.name}',
      ],
    ],
  );
}

void _validateRealProjectDirectories(
  Directory root,
  Iterable<String> relativePaths,
) =>
    _validateRealProjectPaths(
      root,
      relativePaths,
      allowFinalFile: false,
    );

void _validateRealProjectFileTargets(
  Directory root,
  Iterable<String> relativePaths,
) =>
    _validateRealProjectPaths(
      root,
      relativePaths,
      allowFinalFile: true,
    );

void _validateRealProjectPaths(
  Directory root,
  Iterable<String> relativePaths, {
  required bool allowFinalFile,
}) {
  final rootPath = p.normalize(p.absolute(root.path));
  if (FileSystemEntity.typeSync(rootPath, followLinks: false) !=
      FileSystemEntityType.directory) {
    throw _CliException(
      'Extension Project root must be a real directory: $rootPath.',
      code: 'UNSAFE_PROJECT_LAYOUT',
    );
  }
  final realRoot = Directory(rootPath).resolveSymbolicLinksSync();
  for (final relativePath in relativePaths) {
    final segments = p.posix.split(relativePath);
    var current = rootPath;
    for (var index = 0; index < segments.length; index += 1) {
      final segment = segments[index];
      current = p.join(current, segment);
      final type = FileSystemEntity.typeSync(current, followLinks: false);
      if (type == FileSystemEntityType.notFound) {
        break;
      }
      if (type == FileSystemEntityType.link) {
        throw _CliException(
          '$relativePath must not use a symbolic-link ancestor: '
          '${p.relative(current, from: rootPath)}. Remove the link and use '
          'a real directory inside the Extension Project.',
          code: 'UNSAFE_PROJECT_LAYOUT',
        );
      }
      final isLast = index == segments.length - 1;
      final validType = allowFinalFile && isLast
          ? type == FileSystemEntityType.file
          : type == FileSystemEntityType.directory;
      if (!validType) {
        throw _CliException(
          '$relativePath has an unsafe existing entry at '
          '${p.relative(current, from: rootPath)}. Use real directories and '
          '${allowFinalFile ? 'a regular target file' : 'a real directory'}.',
          code: 'UNSAFE_PROJECT_LAYOUT',
        );
      }
      final realCurrent = type == FileSystemEntityType.directory
          ? Directory(current).resolveSymbolicLinksSync()
          : File(current).resolveSymbolicLinksSync();
      if (realCurrent != realRoot && !p.isWithin(realRoot, realCurrent)) {
        throw _CliException(
          '$relativePath resolves outside the Extension Project at '
          '${p.relative(current, from: rootPath)}. Move it inside '
          '$rootPath.',
          code: 'UNSAFE_PROJECT_LAYOUT',
        );
      }
    }
  }
}

List<_FlutterView> _discoverViews(Directory root) {
  final viewsRoot = Directory(p.join(root.path, 'views'));
  final rootType = FileSystemEntity.typeSync(
    viewsRoot.path,
    followLinks: false,
  );
  if (rootType == FileSystemEntityType.notFound) {
    return const [];
  }
  if (rootType != FileSystemEntityType.directory) {
    throw const _CliException(
      'views must be a real directory, not a file or symbolic link.',
      code: 'INVALID_FLUTTER_VIEW',
    );
  }
  final entities = viewsRoot.listSync(followLinks: false)
    ..sort((left, right) => left.path.compareTo(right.path));
  final views = <_FlutterView>[];
  for (final entity in entities) {
    final name = p.basename(entity.path);
    final type = FileSystemEntity.typeSync(entity.path, followLinks: false);
    if (type != FileSystemEntityType.directory ||
        !RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name)) {
      throw _CliException(
        'Malformed Flutter View views/$name. View names must use '
        'lowercase_with_underscores and each direct child of views must be a '
        'real directory.',
        code: 'INVALID_FLUTTER_VIEW',
      );
    }
    final view = _FlutterView(name, Directory(entity.path));
    for (final requiredPath in ['pubspec.yaml', 'lib/main.dart']) {
      final file = File(p.join(view.root.path, requiredPath));
      if (FileSystemEntity.typeSync(file.path, followLinks: false) !=
          FileSystemEntityType.file) {
        throw _CliException(
          'Malformed Flutter View views/$name: $requiredPath must be a real '
          'file.',
          code: 'INVALID_FLUTTER_VIEW',
        );
      }
    }
    _safeFiles(
      view.root,
      description: 'Flutter View $name source tree',
      excludedTopLevelNames: const {'.dart_tool', 'build'},
    );
    views.add(view);
  }
  return views;
}

List<File> _safeFiles(
  Directory root, {
  required String description,
  Set<String> excludedTopLevelNames = const {},
}) {
  final rootPath = p.normalize(p.absolute(root.path));
  if (FileSystemEntity.typeSync(rootPath, followLinks: false) !=
      FileSystemEntityType.directory) {
    throw _CliException(
      '$description must be a real directory.',
      code: 'UNSAFE_PROJECT_LAYOUT',
    );
  }
  final files = <File>[];

  void visit(Directory directory) {
    final entities = directory.listSync(followLinks: false)
      ..sort((left, right) => left.path.compareTo(right.path));
    for (final entity in entities) {
      final normalized = p.normalize(p.absolute(entity.path));
      if (!p.isWithin(rootPath, normalized)) {
        throw _CliException(
          '$description contains a path escape.',
          code: 'UNSAFE_PROJECT_LAYOUT',
        );
      }
      final relative = p.relative(normalized, from: rootPath);
      final segments = p.split(relative);
      if (segments.length == 1 &&
          excludedTopLevelNames.contains(segments.single)) {
        continue;
      }
      if (segments.any(
        (segment) =>
            segment.isEmpty ||
            segment == '.' ||
            segment == '..' ||
            segment.contains(r'\'),
      )) {
        throw _CliException(
          '$description contains an unsafe path: $relative.',
          code: 'UNSAFE_PROJECT_LAYOUT',
        );
      }
      final type = FileSystemEntity.typeSync(normalized, followLinks: false);
      if (type == FileSystemEntityType.link) {
        throw _CliException(
          '$description contains a symbolic link: $relative.',
          code: 'UNSAFE_PROJECT_LAYOUT',
        );
      }
      if (type == FileSystemEntityType.directory) {
        visit(Directory(normalized));
      } else if (type == FileSystemEntityType.file) {
        files.add(File(normalized));
      } else {
        throw _CliException(
          '$description contains an unsupported file-system entry: $relative.',
          code: 'UNSAFE_PROJECT_LAYOUT',
        );
      }
    }
  }

  visit(Directory(rootPath));
  return files;
}

List<File> _viewOutputFiles(Directory root, List<_FlutterView> views) {
  final outputRoot = Directory(p.join(root.path, 'out', 'views'));
  if (views.isEmpty) {
    if (FileSystemEntity.typeSync(outputRoot.path, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw const _CliException(
        'Host-Only Extension output unexpectedly contains out/views.',
        code: 'INVALID_VIEW_OUTPUT',
      );
    }
    return const [];
  }
  if (FileSystemEntity.typeSync(outputRoot.path, followLinks: false) !=
      FileSystemEntityType.directory) {
    throw const _CliException(
      'Flutter View build output out/views is missing or malformed.',
      code: 'INVALID_VIEW_OUTPUT',
    );
  }
  final expectedNames = views.map((view) => view.name).toSet();
  final entities = outputRoot.listSync(followLinks: false)
    ..sort((left, right) => left.path.compareTo(right.path));
  final actualNames = <String>{};
  final files = <File>[];
  for (final entity in entities) {
    final name = p.basename(entity.path);
    if (FileSystemEntity.typeSync(entity.path, followLinks: false) !=
            FileSystemEntityType.directory ||
        !expectedNames.contains(name) ||
        !actualNames.add(name)) {
      throw _CliException(
        'Flutter View output contains an unexpected or malformed entry: '
        'out/views/$name.',
        code: 'INVALID_VIEW_OUTPUT',
      );
    }
    files.addAll(
      _safeFiles(
        Directory(entity.path),
        description: 'Flutter View $name output tree',
      ),
    );
  }
  if (!_setsEqual(actualNames, expectedNames)) {
    final missing = expectedNames.difference(actualNames).toList()..sort();
    throw _CliException(
      'Flutter View output is missing: ${missing.join(', ')}.',
      code: 'INVALID_VIEW_OUTPUT',
    );
  }
  files.sort((left, right) => left.path.compareTo(right.path));
  return files;
}

Future<File> _writeDirectoryAwarePackageConfig(File packageConfig) async {
  final decoded = jsonDecode(await packageConfig.readAsString());
  if (decoded is! Map<String, Object?> ||
      decoded['packages'] is! List<Object?>) {
    throw const FormatException('Host package config is malformed.');
  }
  final packages = decoded['packages']! as List<Object?>;
  for (final package in packages) {
    if (package is! Map<String, Object?> || package['rootUri'] is! String) {
      continue;
    }
    final rootUri = Uri.parse(package['rootUri']! as String);
    if (!rootUri.path.endsWith('/')) {
      package['rootUri'] = rootUri.replace(path: '${rootUri.path}/').toString();
    }
  }
  final normalized = File(
    p.join(
      packageConfig.parent.path,
      'flutter_vscode_package_config.json',
    ),
  );
  await normalized.writeAsString(jsonEncode(decoded), flush: true);
  return normalized;
}

List<String> _checkHostAndSharedImports({
  required Directory hostRoot,
  required Directory sharedRoot,
  required File packageConfig,
}) {
  final sources = <File>[];
  for (final sourceRoot in [hostRoot, sharedRoot]) {
    if (!sourceRoot.existsSync()) {
      continue;
    }
    for (final entity in sourceRoot.listSync(recursive: true)) {
      if (entity is! File || p.extension(entity.path) != '.dart') {
        continue;
      }
      final relative = p.relative(entity.path, from: sourceRoot.path);
      final segments = p.split(relative);
      if (segments.contains('.dart_tool')) {
        continue;
      }
      // Package test directories never execute inside the Extension Host.
      if (segments.first == 'test') {
        continue;
      }
      sources.add(entity);
    }
  }
  sources.sort((left, right) => left.path.compareTo(right.path));
  final violations = <String>{};
  for (final source in sources) {
    violations.addAll(
      checkHostImports(entrypoint: source, packageConfig: packageConfig),
    );
  }
  return violations.toList()..sort();
}

Future<_BindingInputs> _selectBindingInputs({
  required Directory packageRoot,
  required Map<String, Object?> project,
  required bool requireApiTarget,
}) async {
  final value = project['apiTarget'];
  if (requireApiTarget && (value is! String || value.isEmpty)) {
    throw const _CliException(
      'extension.dart must declare a non-empty Project API Target in '
      "'apiTarget'.",
      code: 'INVALID_PROJECT_API_TARGET',
    );
  }
  final apiTarget = value is String ? value : '1.129.1';
  if (!RegExp(r'^\d+\.\d+\.\d+$').hasMatch(apiTarget)) {
    throw _CliException(
      'Project API Target $apiTarget must be an exact stable VS Code version.',
      code: 'INVALID_PROJECT_API_TARGET',
    );
  }
  final inventoryFile = File(
    p.join(
      packageRoot.path,
      'tool',
      'bindings',
      'ir',
      'vscode-$apiTarget.json',
    ),
  );
  final overridesFile = File(
    p.join(
      packageRoot.path,
      'tool',
      'bindings',
      'overrides',
      'vscode-$apiTarget.json',
    ),
  );
  if (!inventoryFile.existsSync() || !overridesFile.existsSync()) {
    throw _CliException(
      'No pinned binding inputs are available for Project API Target '
      '$apiTarget. Choose a target shipped with this flutter_vscode version.',
      code: 'UNAVAILABLE_PROJECT_API_TARGET',
    );
  }
  return _BindingInputs(
    apiTarget: apiTarget,
    inventory: await _readJson(inventoryFile),
    overrides: await _readJson(overridesFile),
  );
}

Future<Directory> _resolvePackageRoot() async {
  final library = await Isolate.resolvePackageUri(
    Uri.parse('package:flutter_vscode/flutter_vscode.dart'),
  );
  if (library == null || library.scheme != 'file') {
    throw const _CliException(
      'Could not locate the flutter_vscode package.',
      code: 'FRAMEWORK_PACKAGE_NOT_FOUND',
    );
  }
  return Directory(p.dirname(p.dirname(library.toFilePath())));
}

Future<BuildToolIdentity> _buildToolIdentity(
  Directory packageRoot,
  String apiTarget,
) async =>
    BuildToolIdentity(
      frameworkSha256: await _packageFilesDigest(
        packageRoot,
        const [
          'bin/flutter_vscode.dart',
          'lib',
          'pubspec.yaml',
          'tool/check_host_imports.dart',
        ],
      ),
      generatorSha256: await _packageFilesDigest(
        packageRoot,
        const [
          'tool/binding_generator',
        ],
      ),
      bindingInputsSha256: await _packageFilesDigest(
        packageRoot,
        [
          'tool/bindings/inputs/vscode/$apiTarget',
          'tool/bindings/ir/vscode-$apiTarget.json',
          'tool/bindings/overrides/vscode-$apiTarget.json',
        ],
      ),
    );

Future<String> _packageFilesDigest(
  Directory packageRoot,
  List<String> relativePaths,
) =>
    digestPackagePaths(
      packageRoot: packageRoot,
      relativePaths: relativePaths,
    );

Future<Map<String, Object?>> _readJson(File file) async {
  return _decodeJsonObject(await file.readAsString(), file.path);
}

Map<String, Object?> _decodeJsonObject(String source, String description) {
  final decoded = jsonDecode(source);
  if (decoded is! Map<Object?, Object?>) {
    throw FormatException('$description must contain a JSON object.');
  }
  return decoded.cast<String, Object?>();
}

Future<void> _run(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
  required String description,
}) async {
  late final ProcessResult result;
  try {
    result = await Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
    );
  } on ProcessException catch (error) {
    throw _CliException(
      'Could not start $description with $executable: ${error.message}',
      code: 'TOOL_COMMAND_START_FAILED',
    );
  }
  if (result.exitCode != 0) {
    throw _CliException(
      'Failed to $description.\n${result.stdout}${result.stderr}',
      code: 'TOOL_COMMAND_FAILED',
    );
  }
}

Future<void> _writeLaunchConfiguration(Directory root) async {
  const encoder = JsonEncoder.withIndent('  ');
  final file = File(p.join(root.path, '.vscode', 'launch.json'));
  await file.parent.create(recursive: true);
  await file.writeAsString(
    '${encoder.convert(<String, Object?>{
          'version': '0.2.0',
          'configurations': <Object?>[
            <String, Object?>{
              'name': 'Run Extension',
              'type': 'extensionHost',
              'request': 'launch',
              'args': <String>[
                r'--extensionDevelopmentPath=${workspaceFolder}',
              ],
              'outFiles': <String>[r'${workspaceFolder}/out/**/*.js'],
            },
          ],
        })}\n',
  );
}

Future<void> _packageProject(Directory root) async {
  _validateProjectLayout(root);
  final dartDescriptor = File(p.join(root.path, 'extension.dart'));
  final jsonDescriptor = File(p.join(root.path, 'extension.json'));
  if (!dartDescriptor.existsSync() && !jsonDescriptor.existsSync()) {
    throw const _CliException(
      'Run package from an Extension Project containing extension.dart.',
      code: 'PACKAGE_NOT_EXTENSION_PROJECT',
      exitCode: 64,
    );
  }
  final project = dartDescriptor.existsSync()
      ? await readProjectDescriptor(dartDescriptor)
      : await _readJson(jsonDescriptor);
  final views = _discoverViews(root);
  _validateFlutterViewLayout(root, views);
  final viewOutputFiles = _viewOutputFiles(root, views);
  final apiTarget = project['apiTarget'];
  final currentApiTarget = apiTarget is String ? apiTarget : '1.129.1';
  final packageRoot = await _resolvePackageRoot();
  final toolIdentity = await _buildToolIdentity(packageRoot, currentApiTarget);
  final receiptProblems = await validateBuildReceipt(
    projectRoot: root,
    apiTarget: currentApiTarget,
    toolIdentity: toolIdentity,
    inputPaths: _buildInputPaths(root),
    artifactPaths: _managedArtifactPaths(root),
  );
  if (receiptProblems.isNotEmpty) {
    throw _CliException(
      'Framework-Managed Artifacts are stale or malformed:\n'
      '${receiptProblems.map((problem) => '- $problem').join('\n')}\n'
      'Run flutter_vscode build before packaging.',
      code: 'STALE_BUILD_ARTIFACTS',
    );
  }
  final manifestFile = File(p.join(root.path, 'package.json'));
  final artifacts = <String, File>{
    'extension/package.json': manifestFile,
    'extension/out/bootstrap.cjs': File(
      p.join(root.path, 'out', 'bootstrap.cjs'),
    ),
    'extension/out/extension.dart.js': File(
      p.join(root.path, 'out', 'extension.dart.js'),
    ),
    'extension/out/extension.dart.js.map': File(
      p.join(root.path, 'out', 'extension.dart.js.map'),
    ),
    for (final file in viewOutputFiles)
      'extension/${_relativeProjectPath(root, file)}': file,
  };
  final missing = [
    for (final entry in artifacts.entries)
      if (!entry.value.existsSync()) entry.key,
  ];
  if (missing.isNotEmpty) {
    throw _CliException(
      'Build artifacts are missing (${missing.join(', ')}). '
      'Run flutter_vscode build first.',
      code: 'MISSING_BUILD_ARTIFACTS',
    );
  }

  final manifest = await _readJson(manifestFile);
  final name = _manifestIdentifierComponent(manifest, 'name');
  final version = _manifestString(manifest, 'version');
  final publisher = _manifestIdentifierComponent(manifest, 'publisher');
  final displayName = _manifestXmlText(manifest, 'displayName');
  final description = _manifestXmlText(manifest, 'description');
  final buildRoot = p.normalize(p.absolute(p.join(root.path, 'build')));
  final outputPath = p.normalize(p.join(buildRoot, '$name-$version.vsix'));
  if (!p.isWithin(buildRoot, outputPath)) {
    throw _CliException(
      'Normalized VSIX output $outputPath escapes the managed build '
      'directory $buildRoot. Use a safe extension name and semantic version, '
      'then run flutter_vscode build again.',
      code: 'UNSAFE_PACKAGE_OUTPUT',
    );
  }
  _validateRealProjectFileTargets(
    root,
    [
      p
          .relative(outputPath, from: p.absolute(root.path))
          .split(p.separator)
          .join('/'),
    ],
  );
  final engines = manifest['engines'];
  if (engines is! Map<Object?, Object?> || engines['vscode'] is! String) {
    throw const _CliException(
      'Generated package.json has no engines.vscode value.',
      code: 'INVALID_MANAGED_MANIFEST',
    );
  }
  final vscodeVersion = engines['vscode']! as String;
  final contentTypes = _contentTypesForParts([
    'extension.vsixmanifest',
    ...artifacts.keys,
  ]);
  final vsixManifest = '''
<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011">
  <Metadata>
    <Identity Language="en-US" Id="${_xml(name)}" Version="${_xml(version)}" Publisher="${_xml(publisher)}" />
    <DisplayName>${_xml(displayName)}</DisplayName>
    <Description xml:space="preserve">${_xml(description)}</Description>
    <Properties>
      <Property Id="Microsoft.VisualStudio.Code.Engine" Value="${_xml(vscodeVersion)}" />
      <Property Id="Microsoft.VisualStudio.Services.Content.Pricing" Value="Free" />
    </Properties>
    <Categories>Other</Categories>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code" />
  </Installation>
  <Dependencies />
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true" />
  </Assets>
</PackageManifest>
'''
      .trimLeft();

  final contents = <String, List<int>>{
    '[Content_Types].xml': utf8.encode(contentTypes),
    'extension.vsixmanifest': utf8.encode(vsixManifest),
    for (final entry in artifacts.entries)
      entry.key: await entry.value.readAsBytes(),
  };
  final archive = Archive();
  for (final path in contents.keys.toList()..sort()) {
    final bytes = contents[path]!;
    final file = ArchiveFile.noCompress(path, bytes.length, bytes)
      ..mode = 0x1a4;
    archive.addFile(file);
  }
  final bytes = ZipEncoder().encode(
    archive,
    modified: DateTime.utc(1980),
  );
  _validateAssembledVsix(bytes, contents);
  final output = File(outputPath);
  await output.parent.create(recursive: true);
  await output.writeAsBytes(bytes, flush: true);
  stdout.writeln('Packaged ${output.path}');
}

String _contentTypesForParts(List<String> partPaths) {
  final defaults = <String, String>{
    'vsixmanifest': 'text/xml',
    'json': 'application/json',
    'cjs': 'application/javascript',
    'js': 'application/javascript',
    'map': 'application/json',
  };
  final extraDefaults = <String, String>{};
  final overrides = <String, String>{};
  for (final path in partPaths.toSet().toList()..sort()) {
    final extension =
        p.posix.extension(path).replaceFirst('.', '').toLowerCase();
    if (extension.isEmpty) {
      final basename = p.posix.basename(path);
      overrides[_opcPartName(path)] =
          basename == 'NOTICES' || basename == '.last_build_id'
              ? 'text/plain'
              : 'application/octet-stream';
      continue;
    }
    if (!defaults.containsKey(extension)) {
      extraDefaults[extension] = _contentTypeForExtension(extension);
    }
  }

  final output = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="utf-8"?>')
    ..writeln(
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">',
    );
  for (final entry in defaults.entries) {
    output.writeln(
      '  <Default Extension="${_xml(entry.key)}" '
      'ContentType="${_xml(entry.value)}" />',
    );
  }
  for (final extension in extraDefaults.keys.toList()..sort()) {
    output.writeln(
      '  <Default Extension="${_xml(extension)}" '
      'ContentType="${_xml(extraDefaults[extension]!)}" />',
    );
  }
  for (final partName in overrides.keys.toList()..sort()) {
    output.writeln(
      '  <Override PartName="${_xml(partName)}" '
      'ContentType="${_xml(overrides[partName]!)}" />',
    );
  }
  output.writeln('</Types>');
  return output.toString();
}

String _contentTypeForExtension(String extension) => switch (extension) {
      'bin' || 'data' || 'frag' || 'symbols' => 'application/octet-stream',
      'css' => 'text/css',
      'gif' => 'image/gif',
      'gz' => 'application/gzip',
      'htm' || 'html' => 'text/html',
      'ico' => 'image/x-icon',
      'jpeg' || 'jpg' => 'image/jpeg',
      'mjs' => 'application/javascript',
      'otf' => 'font/otf',
      'png' => 'image/png',
      'svg' => 'image/svg+xml',
      'ttf' => 'font/ttf',
      'txt' || 'md' => 'text/plain',
      'wasm' => 'application/wasm',
      'webmanifest' => 'application/manifest+json',
      'webp' => 'image/webp',
      'woff' => 'font/woff',
      'woff2' => 'font/woff2',
      'xml' => 'application/xml',
      _ => 'application/octet-stream',
    };

String _opcPartName(String path) =>
    '/${p.posix.split(path).map(Uri.encodeComponent).join('/')}';

void _validateAssembledVsix(
  List<int> bytes,
  Map<String, List<int>> expectedContents,
) {
  late final Archive decoded;
  try {
    decoded = ZipDecoder().decodeBytes(bytes, verify: true);
  } on ArchiveException catch (error) {
    throw _CliException(
      'Assembled VSIX is not a valid ZIP archive: $error',
      code: 'INVALID_VSIX',
    );
  }
  final expectedPaths = expectedContents.keys.toList()..sort();
  final actualPaths = decoded.map((entry) => entry.name).toList();
  if (!_stringListsEqual(actualPaths, expectedPaths)) {
    throw _CliException(
      'Assembled VSIX has unexpected entries: ${actualPaths.join(', ')}.',
      code: 'INVALID_VSIX',
    );
  }
  for (final entry in decoded) {
    final expected = expectedContents[entry.name]!;
    final actual = entry.readBytes();
    if (!entry.isFile ||
        entry.isSymbolicLink ||
        entry.compression != CompressionType.none ||
        entry.unixPermissions != 0x1a4 ||
        actual == null ||
        !_bytesEqual(actual, expected)) {
      throw _CliException(
        'Assembled VSIX entry ${entry.name} failed exact validation.',
        code: 'INVALID_VSIX',
      );
    }
  }
  for (final path in const ['[Content_Types].xml', 'extension.vsixmanifest']) {
    late final String source;
    try {
      source = utf8.decode(expectedContents[path]!);
    } on FormatException {
      throw _CliException(
        'Assembled VSIX entry $path is not valid UTF-8 XML.',
        code: 'INVALID_VSIX',
      );
    }
    if (!_containsOnlyXml10Characters(source)) {
      throw _CliException(
        'Assembled VSIX entry $path contains a character forbidden by '
        'XML 1.0.',
        code: 'INVALID_VSIX',
      );
    }
    try {
      XmlDocument.parse(source);
    } on XmlParserException {
      throw _CliException(
        'Assembled VSIX entry $path is not valid XML 1.0.',
        code: 'INVALID_VSIX',
      );
    }
  }
}

bool _containsOnlyXml10Characters(String source) => source.runes.every(
      (character) =>
          character == 0x9 ||
          character == 0xa ||
          character == 0xd ||
          (character >= 0x20 && character <= 0xd7ff) ||
          (character >= 0xe000 && character <= 0xfffd) ||
          (character >= 0x10000 && character <= 0x10ffff),
    );

bool _stringListsEqual(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

bool _bytesEqual(List<int> left, List<int> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

bool _setsEqual(Set<String> left, Set<String> right) =>
    left.length == right.length && left.containsAll(right);

String _manifestString(Map<String, Object?> manifest, String key) {
  final value = manifest[key];
  if (value is! String || value.isEmpty) {
    throw _CliException(
      'Generated package.json has no $key value.',
      code: 'INVALID_MANAGED_MANIFEST',
    );
  }
  return value;
}

String _manifestXmlText(Map<String, Object?> manifest, String key) {
  final value = _manifestString(manifest, key);
  if (!_containsOnlyXml10Characters(value)) {
    throw _CliException(
      'Generated package.json $key contains a character forbidden by XML '
      '1.0. Remove control characters from extension.dart, run '
      'flutter_vscode build, and package again.',
      code: 'INVALID_PROJECT_MANIFEST',
    );
  }
  return value;
}

String _manifestIdentifierComponent(
  Map<String, Object?> manifest,
  String key,
) {
  final value = _manifestString(manifest, key);
  if (!RegExp(r'^[a-z0-9][a-z0-9-]*$').hasMatch(value)) {
    throw _CliException(
      'Generated package.json $key "$value" is unsafe for a packaged '
      'extension identifier. flutter_vscode requires lower-kebab '
      'components; update extension.dart and run flutter_vscode build again.',
      code: 'INVALID_PROJECT_MANIFEST',
    );
  }
  return value;
}

String _xml(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');

final class _CliException implements Exception {
  const _CliException(
    this.message, {
    required this.code,
    this.exitCode = 1,
  });

  final String code;
  final String message;
  final int exitCode;
}

final class _BindingInputs {
  const _BindingInputs({
    required this.apiTarget,
    required this.inventory,
    required this.overrides,
  });

  final String apiTarget;
  final Map<String, Object?> inventory;
  final Map<String, Object?> overrides;
}

final class _FlutterView {
  const _FlutterView(this.name, this.root);

  final String name;
  final Directory root;
}

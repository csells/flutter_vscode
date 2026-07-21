import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('create scaffolds a host-only Extension Project', () async {
    final workspace = await Directory.systemTemp.createTemp(
      'flutter_vscode_cli_create_',
    );
    addTearDown(() => workspace.delete(recursive: true));
    final executable = p.join(
      Directory.current.path,
      'bin',
      'flutter_vscode.dart',
    );

    final result = await Process.run(
      'dart',
      [executable, 'create', 'my_extension'],
      workingDirectory: workspace.path,
    );

    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
    final project = Directory(p.join(workspace.path, 'my_extension'));
    expect(
      [
        p.join('host', 'lib', 'extension.dart'),
        p.join('host', 'pubspec.yaml'),
        p.join('shared', 'lib', 'shared.dart'),
        p.join('shared', 'pubspec.yaml'),
        'extension.dart',
      ],
      everyElement(
        predicate<String>(
          (path) => File(p.join(project.path, path)).existsSync(),
          'is a scaffolded file',
        ),
      ),
    );
    expect(Directory(p.join(project.path, 'views')).existsSync(), isTrue);
    expect(File(p.join(project.path, 'extension.json')).existsSync(), isFalse);

    final hostPubspec = File(
      p.join(project.path, 'host', 'pubspec.yaml'),
    ).readAsStringSync();
    expect(hostPubspec, contains('my_extension_shared:'));
    expect(hostPubspec, contains('path: ../shared'));
    final hostSource = File(
      p.join(project.path, 'host', 'lib', 'extension.dart'),
    ).readAsStringSync();
    expect(
      hostSource,
      contains("import 'package:my_extension_shared/shared.dart';"),
    );

    final authorFiles = await project
        .list(recursive: true)
        .where((entity) => entity is File)
        .cast<File>()
        .map((file) => p.relative(file.path, from: project.path))
        .toList();
    expect(
      authorFiles.where(
        (path) =>
            path.endsWith('.js') ||
            path.endsWith('.ts') ||
            path == 'package.json',
      ),
      isEmpty,
    );
  });

  test('create keeps extension metadata in Dart', () async {
    final workspace = await Directory.systemTemp.createTemp(
      'flutter_vscode_cli_dart_metadata_',
    );
    addTearDown(() => workspace.delete(recursive: true));
    final executable = p.join(
      Directory.current.path,
      'bin',
      'flutter_vscode.dart',
    );

    final result = await Process.run(
      'dart',
      [executable, 'create', 'my_extension'],
      workingDirectory: workspace.path,
    );

    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
    final source = File(
      p.join(workspace.path, 'my_extension', 'extension.dart'),
    ).readAsStringSync();
    expect(source, contains('const extension = <String, Object?>{'));
    expect(source, contains("'apiTarget': '1.129.1'"));
    expect(source, contains("'name': 'my-extension'"));
    expect(source, contains("'publisher': 'local'"));
  });

  test('create puts command and hover behavior in Host Dart', () async {
    final workspace = await Directory.systemTemp.createTemp(
      'flutter_vscode_cli_host_source_',
    );
    addTearDown(() => workspace.delete(recursive: true));
    final executable = p.join(
      Directory.current.path,
      'bin',
      'flutter_vscode.dart',
    );

    final result = await Process.run(
      'dart',
      [executable, 'create', 'my_extension'],
      workingDirectory: workspace.path,
    );

    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
    final source = File(
      p.join(
        workspace.path,
        'my_extension',
        'host',
        'lib',
        'extension.dart',
      ),
    ).readAsStringSync();
    expect(source, contains("'my-extension.hello'"));
    expect(source, contains('registerCommand'));
    expect(source, contains('registerHoverProvider'));
    expect(source, contains('registerHostExports'));
  });
}

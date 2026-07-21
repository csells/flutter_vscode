import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test(
    'locally activated CLI creates, builds, and packages an extension',
    () async {
      final temporary = await Directory.systemTemp.createTemp(
        'flutter_vscode_global_activation_',
      );
      addTearDown(() => temporary.delete(recursive: true));
      final cache = Directory(p.join(temporary.path, 'pub-cache'));
      final workspace = Directory(p.join(temporary.path, 'workspace'));
      final packageCopy = Directory(p.join(temporary.path, 'package'));
      await workspace.create();
      await _copyPackage(Directory.current, packageCopy);
      final environment = <String, String>{
        ...Platform.environment,
        'PUB_CACHE': cache.path,
      };

      final activate = await Process.run(
        'dart',
        [
          'pub',
          'global',
          'activate',
          '--source',
          'path',
          packageCopy.path,
        ],
        environment: environment,
      );
      expect(
        activate.exitCode,
        0,
        reason: '${activate.stdout}\n${activate.stderr}',
      );

      final executable = p.join(
        cache.path,
        'bin',
        Platform.isWindows ? 'flutter_vscode.bat' : 'flutter_vscode',
      );
      final create = await Process.run(
        executable,
        const ['create', 'activated_extension'],
        workingDirectory: workspace.path,
        environment: environment,
      );

      expect(create.exitCode, 0, reason: '${create.stdout}\n${create.stderr}');
      final project = Directory(
        p.join(workspace.path, 'activated_extension'),
      );
      expect(
        File(
          p.join(
            project.path,
            'host',
            'lib',
            'extension.dart',
          ),
        ).existsSync(),
        isTrue,
      );
      final build = await Process.run(
        executable,
        const ['build'],
        workingDirectory: project.path,
        environment: environment,
      );
      expect(build.exitCode, 0, reason: '${build.stdout}\n${build.stderr}');
      final package = await Process.run(
        executable,
        const ['package'],
        workingDirectory: project.path,
        environment: environment,
      );
      expect(
        package.exitCode,
        0,
        reason: '${package.stdout}\n${package.stderr}',
      );
      expect(
        File(
          p.join(
            project.path,
            'build',
            'activated-extension-0.0.1.vsix',
          ),
        ).existsSync(),
        isTrue,
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

Future<void> _copyPackage(Directory source, Directory destination) async {
  const excludedNames = {
    '.dart_tool',
    '.git',
    'build',
    'node_modules',
    'out',
  };
  await destination.create(recursive: true);
  await for (final entity in source.list()) {
    final name = p.basename(entity.path);
    if (excludedNames.contains(name)) {
      continue;
    }
    final target = p.join(destination.path, name);
    if (entity is Directory) {
      await _copyPackage(entity, Directory(target));
    } else if (entity is File) {
      await entity.copy(target);
    }
  }
}

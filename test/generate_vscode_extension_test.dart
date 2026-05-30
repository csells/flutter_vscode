import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../bin/generate_vscode_extension.dart' as generator;

void main() {
  group('generate_vscode_extension CLI', () {
    test('scaffolds a VS Code extension project structure', () async {
      final originalDir = Directory.current;
      final tempDir = await Directory.systemTemp.createTemp('flutter_vscode_test_');

      try {
        Directory.current = tempDir;

        generator.main();

        // Core structure
        expect(Directory('${tempDir.path}/.vscode').existsSync(), isTrue);
        expect(Directory('${tempDir.path}/scripts').existsSync(), isTrue);
        expect(Directory('${tempDir.path}/src').existsSync(), isTrue);
        expect(Directory('${tempDir.path}/lib').existsSync(), isTrue);
        expect(Directory('${tempDir.path}/web').existsSync(), isTrue);

        // Key files
        final packageJson =
            File('${tempDir.path}/package.json').readAsStringSync();
        expect(packageJson, contains('"main": "./out/extension.js"'));
        expect(
          packageJson,
          contains('"vscode:prepublish": "npm run compile"'),
        );

        final launchJson =
            File('${tempDir.path}/.vscode/launch.json').readAsStringSync();
        expect(launchJson, contains('"type": "extensionHost"'));

        final tsConfig =
            File('${tempDir.path}/tsconfig.json').readAsStringSync();
        expect(tsConfig, contains('"outDir": "out"'));

        final webIndex =
            File('${tempDir.path}/web/index.html').readAsStringSync();
        expect(webIndex, contains('History pushState blocked for webview'));

        final gitignore =
            File('${tempDir.path}/.gitignore').readAsStringSync();
        expect(gitignore, contains('node_modules/'));
        expect(gitignore, contains('*.handlers.ts'));
      } finally {
        Directory.current = originalDir;
        await tempDir.delete(recursive: true);
      }
    });

    test('does not overwrite existing user-edited scaffold files', () async {
      final originalDir = Directory.current;
      final tempDir = await Directory.systemTemp.createTemp('flutter_vscode_test_');

      try {
        Directory.current = tempDir;

        // Pre-existing user files that should not be clobbered.
        Directory('${tempDir.path}/src').createSync(recursive: true);
        Directory('${tempDir.path}/web').createSync(recursive: true);
        File('${tempDir.path}/package.json').writeAsStringSync('{"name":"user-package"}');
        File('${tempDir.path}/tsconfig.json').writeAsStringSync('{"compilerOptions":{"strict":false}}');
        File('${tempDir.path}/src/extension.ts').writeAsStringSync('// custom extension');
        File('${tempDir.path}/web/index.html').writeAsStringSync('<html>custom</html>');

        generator.main();

        expect(
          File('${tempDir.path}/package.json').readAsStringSync(),
          '{"name":"user-package"}',
        );
        expect(
          File('${tempDir.path}/tsconfig.json').readAsStringSync(),
          '{"compilerOptions":{"strict":false}}',
        );
        expect(
          File('${tempDir.path}/src/extension.ts').readAsStringSync(),
          '// custom extension',
        );
        expect(
          File('${tempDir.path}/web/index.html').readAsStringSync(),
          '<html>custom</html>',
        );
      } finally {
        Directory.current = originalDir;
        await tempDir.delete(recursive: true);
      }
    });
  });
}

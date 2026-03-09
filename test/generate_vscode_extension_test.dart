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
  });
}

// this is a generator, having prints to interact with the user is important

// ignore_for_file: avoid_print -- this is a script that is run by the user to generate the extension

import 'dart:io';
import 'package:path/path.dart' as p;

enum _WritePolicy { createOnly }

class _ScaffoldSummary {
  final List<String> created = <String>[];
  final List<String> updated = <String>[];
  final List<String> skipped = <String>[];

  void printToStdout() {
    print('');
    print('Scaffold summary:');
    print('  Created: ${created.length}');
    print('  Updated: ${updated.length}');
    print('  Skipped: ${skipped.length}');
  }
}

void main() {
  final currentDirectory = Directory.current.path;
  print('Generating VSCode extension files in: $currentDirectory');
  final summary = _ScaffoldSummary();

  try {
    // Create all necessary directories and files
    _createDirectories(currentDirectory);
    _createLaunchConfig(currentDirectory, summary);
    _createCompileScript(currentDirectory, summary);
    _createExtensionFile(currentDirectory, summary);
    _createVSCodeApiController(currentDirectory, summary);
    _createPackageJson(currentDirectory, summary);
    _createTsConfig(currentDirectory, summary);
    _createWebFolder(currentDirectory, summary);
    _updateGitignore(currentDirectory, summary);

    print('');
    print('✅ VSCode extension files generated successfully!');
    summary.printToStdout();
    print('Next steps:');
    print('1. Run: npm install');
    print('2. Press F5 in VS Code to run the extension');
  } on Object catch (e, stackTrace) {
    print('');
    print('❌ Error generating VSCode extension files:');
    print('Error: $e');
    print('');
    print('Stack trace:');
    print(stackTrace);
    print('');
    print('Common solutions:');
    print('• Check you have write permissions in the current directory');
    print('• Ensure you have sufficient disk space');
    print('• Try running from a different directory');
    print('• Close any files that might be open in editors');
    exit(1);
  }
}

void _createDirectories(String currentDirectory) {
  Directory(p.join(currentDirectory, '.vscode')).createSync(recursive: true);
  Directory(p.join(currentDirectory, 'out')).createSync(recursive: true);
  Directory(p.join(currentDirectory, 'scripts')).createSync(recursive: true);
  Directory(p.join(currentDirectory, 'src')).createSync(recursive: true);
  Directory(p.join(currentDirectory, 'lib')).createSync(recursive: true);
}

void _createLaunchConfig(String currentDirectory, _ScaffoldSummary summary) {
  _writeFile(
    path: p.join(currentDirectory, '.vscode', 'launch.json'),
    contents: _getLaunchJson(),
    summary: summary,
    policy: _WritePolicy.createOnly,
  );
}

void _createCompileScript(String currentDirectory, _ScaffoldSummary summary) {
  final file = File(p.join(currentDirectory, 'scripts', 'compile.sh'));
  final wrote = _writeFile(
    path: file.path,
    contents: _getCompileScript(),
    summary: summary,
    policy: _WritePolicy.createOnly,
  );

  if (wrote && (Platform.isLinux || Platform.isMacOS)) {
    Process.runSync('chmod', ['+x', file.path]);
  }
}

void _createExtensionFile(String currentDirectory, _ScaffoldSummary summary) {
  // Try to copy from template if it exists
  final templatePath =
      p.join(Directory.current.path, 'tool', 'extension.ts.template');
  final file = File(p.join(currentDirectory, 'src', 'extension.ts'));
  if (File(templatePath).existsSync()) {
    final content = File(templatePath).readAsStringSync();
    _writeFile(
      path: file.path,
      contents: content,
      summary: summary,
      policy: _WritePolicy.createOnly,
    );
  } else {
    _writeFile(
      path: file.path,
      contents: _getExtensionTs(),
      summary: summary,
      policy: _WritePolicy.createOnly,
    );
  }
}

void _createVSCodeApiController(
    String currentDirectory, _ScaffoldSummary summary) {
  _writeFile(
    path: p.join(currentDirectory, 'lib', 'vscode_api.dart'),
    contents: _getVSCodeApiControllerDart(),
    summary: summary,
    policy: _WritePolicy.createOnly,
  );
}

void _createPackageJson(String currentDirectory, _ScaffoldSummary summary) {
  _writeFile(
    path: p.join(currentDirectory, 'package.json'),
    contents: _getPackageJson(),
    summary: summary,
    policy: _WritePolicy.createOnly,
  );
}

void _createTsConfig(String currentDirectory, _ScaffoldSummary summary) {
  _writeFile(
    path: p.join(currentDirectory, 'tsconfig.json'),
    contents: _getTsConfig(),
    summary: summary,
    policy: _WritePolicy.createOnly,
  );
}

void _createWebFolder(String currentDirectory, _ScaffoldSummary summary) {
  // Create web directory structure
  Directory(p.join(currentDirectory, 'web')).createSync(recursive: true);
  Directory(p.join(currentDirectory, 'web', 'icons'))
      .createSync(recursive: true);

  // Create or modify index.html for VSCode webview compatibility
  _writeFile(
    path: p.join(currentDirectory, 'web', 'index.html'),
    contents: _getWebIndexHtml(),
    summary: summary,
    policy: _WritePolicy.createOnly,
  );

  // Create flutter_bootstrap.js
  _writeFile(
    path: p.join(currentDirectory, 'web', 'flutter_bootstrap.js'),
    contents: _getFlutterBootstrapJs(),
    summary: summary,
    policy: _WritePolicy.createOnly,
  );

  // Create manifest.json
  _writeFile(
    path: p.join(currentDirectory, 'web', 'manifest.json'),
    contents: _getManifestJson(),
    summary: summary,
    policy: _WritePolicy.createOnly,
  );

  // Copy favicon if it exists from example, otherwise create a placeholder
  final exampleFavicon =
      File(p.join(Directory.current.path, 'example', 'web', 'favicon.png'));
  final targetFavicon = File(p.join(currentDirectory, 'web', 'favicon.png'));
  if (exampleFavicon.existsSync() && !targetFavicon.existsSync()) {
    exampleFavicon.copySync(targetFavicon.path);
    summary.created.add(p.relative(targetFavicon.path, from: currentDirectory));
  } else if (targetFavicon.existsSync()) {
    summary.skipped.add(p.relative(targetFavicon.path, from: currentDirectory));
  }

  // Copy icons from example if they exist
  final iconsDir =
      Directory(p.join(Directory.current.path, 'example', 'web', 'icons'));
  if (iconsDir.existsSync()) {
    for (final file in iconsDir.listSync()) {
      if (file is File) {
        final targetPath =
            p.join(currentDirectory, 'web', 'icons', p.basename(file.path));
        final targetFile = File(targetPath);
        if (!targetFile.existsSync()) {
          file.copySync(targetPath);
          summary.created.add(p.relative(targetPath, from: currentDirectory));
        } else {
          summary.skipped.add(p.relative(targetPath, from: currentDirectory));
        }
      }
    }
  }
}

void _updateGitignore(String currentDirectory, _ScaffoldSummary summary) {
  final file = File(p.join(currentDirectory, '.gitignore'));
  final entries = [
    '# VSCode extension specific',
    'node_modules/',
    'out/',
    '*.vsix',
    '',
    '# Flutter build output',
    'build/',
    '',
    '# Dart/Flutter generated files',
    '*.g.dart',
    '*.g.part',
    '',
    '# TypeScript generated files',
    '*.handlers.ts',
    '',
    '# IDE files',
    '.vscode/settings.json',
  ];

  if (file.existsSync()) {
    final existing = file.readAsStringSync();
    final newEntries = <String>[];

    for (final entry in entries) {
      if (entry.isEmpty || entry.startsWith('#')) continue;
      if (!existing.contains(entry)) {
        newEntries.add(entry);
      }
    }

    if (newEntries.isNotEmpty) {
      file.writeAsStringSync(
        '\n# VSCode extension entries\n${newEntries.join('\n')}\n',
        mode: FileMode.append,
      );
      summary.updated.add('.gitignore');
    } else {
      summary.skipped.add('.gitignore');
    }
  } else {
    file.writeAsStringSync('${entries.join('\n')}\n');
    summary.created.add('.gitignore');
  }
}

bool _writeFile({
  required String path,
  required String contents,
  required _ScaffoldSummary summary,
  required _WritePolicy policy,
}) {
  final file = File(path);
  final relativePath = p.relative(path, from: Directory.current.path);

  if (file.existsSync()) {
    if (policy == _WritePolicy.createOnly) {
      summary.skipped.add(relativePath);
      return false;
    }

    final currentContents = file.readAsStringSync();
    if (currentContents == contents) {
      summary.skipped.add(relativePath);
      return false;
    }

    file.writeAsStringSync(contents);
    summary.updated.add(relativePath);
    return true;
  }

  file.writeAsStringSync(contents);
  summary.created.add(relativePath);
  return true;
}

String _getLaunchJson() {
  return r'''
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run Extension",
      "type": "extensionHost",
      "request": "launch",
      "runtimeExecutable": "${execPath}",
      "args": [
        "--extensionDevelopmentPath=${workspaceRoot}",
        "--disable-extensions"
      ],
      "outFiles": ["${workspaceFolder}/build/web/*.js"],
      "preLaunchTask": "npm: vscode:prepublish"
    }
  ]
}
''';
}

String _getCompileScript() {
  return '''
#!/bin/bash

# Generate Dart code using build_runner
dart run build_runner build --delete-conflicting-outputs

# Compile TypeScript
tsc -p ./

# Build Flutter web
flutter build web --no-web-resources-cdn --csp --pwa-strategy none --no-tree-shake-icons
''';
}

String _getExtensionTs() {
  return '''
import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

// This extension is a starting template for a Flutter VSCode extension.
// Extension configuration and commands will be generated by build_runner.
// You can customize this file as needed for your specific extension logic.

export function activate(context: vscode.ExtensionContext) {
    console.log('Flutter VSCode extension is now active!');

    // Extension initialization code will be generated here by build_runner
    // based on your Flutter app configuration.

    // TODO: Add your extension initialization logic here
}

export function deactivate() {
    console.log('Flutter VSCode extension deactivated.');
}
''';
}

String _getPackageJson() {
  return '''
{
  "name": "your_extension_name",
  "displayName": "Your Extension Display Name",
  "description": "Describe your extension",
  "version": "0.0.1",
  "publisher": "your_publisher",
  "engines": {
    "vscode": "^1.75.0"
  },
  "categories": [
    "Other"
  ],
  "activationEvents": [],
  "main": "./out/extension.js",
  "files": [
    "out",
    "build/web"
  ],
  "contributes": {
  },
  "scripts": {
    "vscode:prepublish": "npm run compile",
    "compile": "scripts/compile.sh",
    "watch": "tsc -watch -p ./"
  },
  "devDependencies": {
    "@eslint/js": "^9.13.0",
    "@stylistic/eslint-plugin": "^2.9.0",
    "@types/node": "^24.0.14",
    "@types/vscode": "^1.73.0",
    "@vscode/wasm-component-model": "^1.0.2",
    "eslint": "^9.13.0",
    "typescript": "^5.8.2",
    "typescript-eslint": "^8.26.0"
  }
}''';
}

String _getTsConfig() {
  return '''
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es2020",
    "outDir": "out",
    "lib": ["es2020"],
    "sourceMap": true,
    "rootDir": ".",
    "strict": true,
    "moduleResolution": "node",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*.ts", "lib/**/*.handlers.ts"],
  "exclude": ["node_modules", "out", "build", "web"]
}''';
}

String _getVSCodeApiControllerDart() {
  return r'''
import 'package:flutter_vscode/flutter_vscode.dart';

part 'vscode_api.vscode.g.part';

/// Put your `@VSCodeController` classes in this file (or create more).
///
/// Running:
///   dart run build_runner build
///
/// will generate:
/// - `lib/vscode_api.vscode.g.part` (Dart implementation)
/// - `lib/vscode_api.handlers.ts` (TypeScript handlers used by `src/extension.ts`)
@VSCodeController()
abstract class VSCodeApi {
  /// Calls `vscode.window.showInformationMessage(...)` in the extension host.
  @VSCodeCommand('window.showInformationMessage')
  Future<void> info(String message);

  /// Calls `vscode.window.showInputBox(...)` and returns the result.
  @VSCodeCommand('window.showInputBox')
  Future<String?> inputBox(String prompt);
}

VSCodeApi createVSCodeApi() => _$VSCodeApi();
''';
}

String _getWebIndexHtml() {
  return '''
\u003c!DOCTYPE html>
\u003chtml>
\u003chead>
  \u003cbase href="\$FLUTTER_BASE_HREF">

  \u003cmeta charset="UTF-8">
  \u003cmeta content="IE=Edge" http-equiv="X-UA-Compatible">
  \u003cmeta name="description" content="A new Flutter project.">

  \u003cscript>
    // Disable history API for webview compatibility
    window.history.replaceState = function() {
      console.log('History replaceState blocked for webview compatibility');
    };
    window.history.pushState = function() {
      console.log('History pushState blocked for webview compatibility');
    };
  \u003c/script>

  \u003ctitle>Your Flutter VSCode Extension\u003c/title>
  \u003clink rel="manifest" href="manifest.json">
\u003c/head>
\u003cbody>
  \u003cscript src="main.dart.js" async>\u003c/script>
\u003c/body>
\u003c/html>
''';
}

String _getFlutterBootstrapJs() {
  return '''
{{flutter_js}}
{{flutter_build_config}}

// the below loader ensures that the local copy of canvasKit is used
// and there is no attempt to download it. Attempting to download it
// will cause the extension to fail as remote resources are blocked

_flutter.loader.load({
    config: {
        canvasKitBaseUrl: "canvaskit/"
    },
});
''';
}

String _getManifestJson() {
  return '''
{
  "name": "Flutter VSCode Extension",
  "short_name": "Flutter VSCode",
  "start_url": "./",
  "display": "standalone",
  "background_color": "#0175C2",
  "theme_color": "#0175C2",
  "description": "A Flutter app for VSCode extension",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-maskable-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    },
    {
      "src": "icons/Icon-maskable-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}''';
}

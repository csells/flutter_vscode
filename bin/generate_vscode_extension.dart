// this is a generator, having prints to interact with the user is important

// ignore_for_file: avoid_print -- this is a script that is run by the user to generate the extension

import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

enum _WritePolicy { createOnly }

/// Override package root resolution in tests.
@visibleForTesting
String? debugPackageRootOverride;

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
    _createVscodeInvokeFile(currentDirectory, summary);
    _createVSCodeApiController(currentDirectory, summary);
    _createPackageJson(currentDirectory, summary);
    _createTsConfig(currentDirectory, summary);
    _createWebFolder(currentDirectory, summary);
    _createConsumerAgentsMd(currentDirectory, summary);
    _copyLegacyAgentSkills(currentDirectory, summary);
    _updateGitignore(currentDirectory, summary);

    print('');
    print('✅ VSCode extension files generated successfully!');
    summary.printToStdout();
    print('Next steps:');
    print('1. Run: npm install');
    print('2. Run: dart run build_runner build --delete-conflicting-outputs');
    print('3. Run: npm run compile');
    print('4. Press F5 in VS Code to run the extension');
    print('');
    print(
      'Agent toolkit: AGENTS.md and agent-skills/ are ready for AI-assisted development.',
    );
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
  Directory(p.join(currentDirectory, 'agent-skills'))
      .createSync(recursive: true);
  Directory(p.join(currentDirectory, 'out')).createSync(recursive: true);
  Directory(p.join(currentDirectory, 'scripts')).createSync(recursive: true);
  Directory(p.join(currentDirectory, 'src')).createSync(recursive: true);
  Directory(p.join(currentDirectory, 'lib')).createSync(recursive: true);
}

void _createConsumerAgentsMd(
  String currentDirectory,
  _ScaffoldSummary summary,
) {
  final templateCandidates = [
    p.join(
      _flutterVscodePackageRoot(),
      'docs',
      'templates',
      'consumer-agents-v0.md',
    ),
    p.join(_flutterVscodePackageRoot(), 'tool', 'consumer-agents.md.template'),
  ];

  String? contents;
  for (final templatePath in templateCandidates) {
    final templateFile = File(templatePath);
    if (templateFile.existsSync()) {
      contents = templateFile.readAsStringSync();
      break;
    }
  }

  if (contents == null) {
    summary.skipped.add('AGENTS.md');
    return;
  }

  _writeFile(
    path: p.join(currentDirectory, 'AGENTS.md'),
    contents: contents,
    summary: summary,
    policy: _WritePolicy.createOnly,
  );
}

void _copyLegacyAgentSkills(
  String currentDirectory,
  _ScaffoldSummary summary,
) {
  final skillsSource = Directory(
    p.join(_flutterVscodePackageRoot(), 'tool', 'legacy-agent-skills'),
  );
  if (!skillsSource.existsSync()) {
    summary.skipped.add('agent-skills/');
    return;
  }

  final skillsTarget = p.join(currentDirectory, 'agent-skills');
  for (final entity in skillsSource.listSync()) {
    if (entity is Directory) {
      _copyDirectoryCreateOnly(
        source: entity,
        targetPath: p.join(skillsTarget, p.basename(entity.path)),
        currentDirectory: currentDirectory,
        summary: summary,
      );
    } else if (entity is File) {
      final targetPath = p.join(skillsTarget, p.basename(entity.path));
      if (File(targetPath).existsSync()) {
        summary.skipped.add(p.relative(targetPath, from: currentDirectory));
      } else {
        entity.copySync(targetPath);
        summary.created.add(p.relative(targetPath, from: currentDirectory));
      }
    }
  }
}

void _copyDirectoryCreateOnly({
  required Directory source,
  required String targetPath,
  required String currentDirectory,
  required _ScaffoldSummary summary,
}) {
  final targetDir = Directory(targetPath);
  if (!targetDir.existsSync()) {
    targetDir.createSync(recursive: true);
  }

  for (final entity in source.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }

    final relativePath = p.relative(entity.path, from: source.path);
    final destination = p.join(targetPath, relativePath);
    final destinationFile = File(destination);

    if (destinationFile.existsSync()) {
      summary.skipped.add(p.relative(destination, from: currentDirectory));
      continue;
    }

    destinationFile.parent.createSync(recursive: true);
    entity.copySync(destination);
    summary.created.add(p.relative(destination, from: currentDirectory));
  }
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
  final templatePath =
      p.join(_flutterVscodePackageRoot(), 'tool', 'extension.ts.template');
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

void _createVscodeInvokeFile(
  String currentDirectory,
  _ScaffoldSummary summary,
) {
  final templatePath =
      p.join(_flutterVscodePackageRoot(), 'tool', 'vscode_invoke.ts');
  final file = File(p.join(currentDirectory, 'src', 'vscode_invoke.ts'));
  if (File(templatePath).existsSync()) {
    final content = File(templatePath).readAsStringSync();
    _writeFile(
      path: file.path,
      contents: content,
      summary: summary,
      policy: _WritePolicy.createOnly,
    );
  } else {
    summary.skipped.add('src/vscode_invoke.ts');
  }
}

void _createVSCodeApiController(
  String currentDirectory,
  _ScaffoldSummary summary,
) {
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

  // Copy favicon if it exists in the package example, otherwise skip.
  final exampleFavicon = File(
    p.join(_flutterVscodePackageRoot(), 'example', 'web', 'favicon.png'),
  );
  final targetFavicon = File(p.join(currentDirectory, 'web', 'favicon.png'));
  if (exampleFavicon.existsSync() && !targetFavicon.existsSync()) {
    exampleFavicon.copySync(targetFavicon.path);
    summary.created.add(p.relative(targetFavicon.path, from: currentDirectory));
  } else if (targetFavicon.existsSync()) {
    summary.skipped.add(p.relative(targetFavicon.path, from: currentDirectory));
  }

  // Copy icons from the package example if they exist.
  final iconsDir = Directory(
    p.join(_flutterVscodePackageRoot(), 'example', 'web', 'icons'),
  );
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
  final templatePath =
      p.join(_flutterVscodePackageRoot(), 'tool', 'extension.ts.template');
  if (File(templatePath).existsSync()) {
    return File(templatePath).readAsStringSync();
  }

  return r'''
import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

import { handleCommand } from '../lib/vscode_api.handlers';

export function activate(context: vscode.ExtensionContext) {
    const provider = new FlutterWebviewProvider(context.extensionUri);

    context.subscriptions.push(
        vscode.window.registerWebviewViewProvider(FlutterWebviewProvider.viewType, provider)
    );

    context.subscriptions.push(provider.statusBarItem);
}

class FlutterWebviewProvider implements vscode.WebviewViewProvider {
    public static readonly viewType = 'flutterVSCode.view';

    public view?: vscode.WebviewView;
    private _statusBarItem: vscode.StatusBarItem;

    constructor(
        private readonly _extensionUri: vscode.Uri,
    ) {
        this._statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
        this._statusBarItem.text = "$(flutter) Flutter VS Code";
        this._statusBarItem.tooltip = "Flutter VS Code webview";
        this._statusBarItem.show();
    }

    public get statusBarItem(): vscode.StatusBarItem {
        return this._statusBarItem;
    }

    public resolveWebviewView(
        webviewView: vscode.WebviewView,
        context: vscode.WebviewViewResolveContext,
        _token: vscode.CancellationToken,
    ) {
        this.view = webviewView;

        webviewView.webview.options = {
            enableScripts: true,
            localResourceRoots: [
                vscode.Uri.joinPath(this._extensionUri, 'build', 'web')
            ]
        };

        webviewView.webview.html = this._getHtml(webviewView.webview);

        webviewView.webview.onDidReceiveMessage(async (message) => {
            await handleCommand(message, webviewView.webview);
        });
    }

    _getHtml(webview: vscode.Webview): string {
        const webviewUri = webview.asWebviewUri(vscode.Uri.joinPath(this._extensionUri, "build", "web"));

        const indexHtmlPath = path.join(this._extensionUri.fsPath, "build", "web", "index.html");
        let indexHtml = '';
        try {
            indexHtml = fs.readFileSync(indexHtmlPath, 'utf8');
        } catch (error) {
            console.error('Could not read build/web/index.html:', error);
            return `<html><body><h1>Error: Could not load Flutter app</h1><p>build/web/index.html not found</p></body></html>`;
        }

        indexHtml = indexHtml.replace('<base href="/">', '<base href="' + webviewUri + '/">');
        return indexHtml;
    }
}

export function deactivate() {}
''';
}

String _getPackageJson() {
  return r'''
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
    "viewsContainers": {
      "activitybar": [
        {
          "id": "flutter-vscode-sidebar",
          "title": "Flutter VS Code",
          "icon": "$(flutter)"
        }
      ]
    },
    "views": {
      "flutter-vscode-sidebar": [
        {
          "type": "webview",
          "icon": "web/icons/Icon-192.png",
          "id": "flutterVSCode.view",
          "name": "Flutter Webview"
        }
      ]
    }
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

String _flutterVscodePackageRoot() {
  final override = debugPackageRootOverride;
  if (override != null) {
    return override;
  }

  final fromConfig = _packageRootFromConfig();
  if (fromConfig != null) {
    return fromConfig;
  }

  if (Platform.script.scheme == 'file') {
    var dir = Directory(p.dirname(Platform.script.toFilePath()));
    for (var depth = 0; depth < 12; depth++) {
      if (File(p.join(dir.path, 'tool', 'extension.ts.template'))
          .existsSync()) {
        return dir.path;
      }
      dir = dir.parent;
    }
  }

  throw StateError(
    'Could not locate the flutter_vscode package root. '
    'Ensure flutter_vscode is listed in pubspec.yaml and run `dart pub get`.',
  );
}

String? _packageRootFromConfig() {
  final configFile = File(
    p.join(Directory.current.path, '.dart_tool', 'package_config.json'),
  );
  if (!configFile.existsSync()) {
    return null;
  }

  final config =
      jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
  final packages = config['packages'] as List<dynamic>?;
  if (packages == null) {
    return null;
  }

  for (final package in packages) {
    final packageMap = package as Map<String, dynamic>;
    if (packageMap['name'] == 'flutter_vscode') {
      final rootUri = packageMap['rootUri'] as String?;
      if (rootUri == null) {
        return null;
      }
      return Uri.parse(rootUri).toFilePath();
    }
  }

  return null;
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
import 'package:flutter_vscode/runtime.dart';

part 'vscode_api.vscode.g.part';

/// Put your `@VSCodeController` classes in this file (or create more).
///
/// Running:
///   dart run build_runner build --delete-conflicting-outputs
///
/// will generate:
/// - `lib/vscode_api.vscode.g.part` (Dart implementation)
/// - `lib/vscode_api.handlers.ts` (TypeScript handlers used by `src/extension.ts`)
///
/// More API patterns: see AGENTS.md and `agent-skills/flutter-vscode-add-command/`.
@VSCodeController()
abstract class VSCodeApi {
  /// Calls `vscode.window.showInformationMessage(...)`.
  @VSCodeCommand('window.showInformationMessage')
  Future<void> info(String message);

  /// Calls `vscode.window.showWarningMessage(...)`.
  @VSCodeCommand('window.showWarningMessage')
  Future<void> warning(String message);

  /// Calls `vscode.window.showErrorMessage(...)`.
  @VSCodeCommand('window.showErrorMessage')
  Future<void> error(String message);

  /// Calls `vscode.window.showInputBox(...)` with an options map.
  ///
  /// Example: `inputBox({'prompt': 'Name?', 'placeHolder': 'Jane Doe'})`
  @VSCodeCommand('window.showInputBox')
  Future<String?> inputBox(Map<String, dynamic> options);

  /// Calls `vscode.window.showQuickPick(...)` with string items.
  @VSCodeCommand('window.showQuickPick')
  Future<String?> quickPick(List<String> items);
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

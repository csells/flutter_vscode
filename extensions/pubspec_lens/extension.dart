import 'package:flutter_vscode/manifest.dart';

/// Dart-owned extension metadata consumed by `flutter_vscode build`.
const extension = ExtensionManifest(
  apiTarget: '1.129.1',
  name: 'pubspec-lens',
  displayName: 'Pubspec Lens',
  description: 'Dependency intelligence for pubspec.yaml: hovers, '
      'outdated-pin diagnostics, CodeLens updates, and a dependency tree.',
  version: '0.0.1',
  publisher: 'local',
  activationEvents: [
    'onLanguage:yaml',
    'workspaceContains:pubspec.yaml',
  ],
  commands: [
    ExtensionCommand(
      command: 'pubspec-lens.refresh',
      title: 'Pubspec Lens: Refresh',
    ),
    ExtensionCommand(
      command: 'pubspec-lens.update',
      title: 'Pubspec Lens: Apply Suggested Constraint',
    ),
    ExtensionCommand(
      command: 'pubspec-lens.smoke',
      title: 'Pubspec Lens: Smoke Report (diagnostics)',
    ),
  ],
);

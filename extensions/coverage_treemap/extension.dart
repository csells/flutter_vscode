/// Dart-owned extension metadata consumed by `flutter_vscode build`.
const extension = <String, Object?>{
  'schemaVersion': 1,
  'apiTarget': '1.129.1',
  'name': 'coverage-treemap',
  'displayName': 'Coverage Treemap',
  'description': 'A VS Code extension written in Dart.',
  'version': '0.0.1',
  'publisher': 'local',
  'activationEvents': <String>['onLanguage:json'],
  'commands': <Map<String, Object?>>[
    <String, Object?>{
      'command': 'coverage-treemap.hello',
      'title': 'Say Hello from Dart',
    },
  ],
};

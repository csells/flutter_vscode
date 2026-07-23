/// Dart-owned extension metadata consumed by `flutter_vscode build`.
const extension = <String, Object?>{
  'schemaVersion': 1,
  'apiTarget': '1.129.1',
  'name': 'coverage-treemap',
  'displayName': 'Coverage Treemap',
  'description': 'Line coverage in your editor and a coverage treemap.',
  'version': '0.0.1',
  'publisher': 'local',
  'activationEvents': <String>['onStartupFinished'],
  'commands': <Map<String, Object?>>[
    <String, Object?>{
      'command': 'coverage-treemap.showTreemap',
      'title': 'Coverage: Show Treemap',
    },
    <String, Object?>{
      'command': 'coverage-treemap.refresh',
      'title': 'Coverage: Refresh',
    },
    <String, Object?>{
      'command': 'coverage-treemap.toggleLineHighlights',
      'title': 'Coverage: Toggle Line Highlights',
    },
    <String, Object?>{
      'command': 'coverage-treemap.smoke',
      'title': 'Coverage: Smoke Snapshot (diagnostics)',
    },
  ],
};

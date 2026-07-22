import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('CLI regenerates the walking slice byte-for-byte', () async {
    final temporary = await Directory.systemTemp.createTemp(
      'flutter_vscode_binding_cli_',
    );
    addTearDown(() => temporary.delete(recursive: true));
    final first = Directory(p.join(temporary.path, 'first'));
    final second = Directory(p.join(temporary.path, 'second'));

    for (final output in [first, second]) {
      final result = await Process.run(
        'dart',
        [
          'tool/binding_generator/generate.dart',
          '--inventory',
          'tool/bindings/ir/vscode-1.129.1.json',
          '--overrides',
          'tool/bindings/overrides/vscode-1.129.1.json',
          '--project',
          'test/fixtures/host_extension/extension.json',
          '--output-root',
          output.path,
        ],
        workingDirectory: Directory.current.path,
      );
      expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
    }

    final firstFiles = await _readTree(first);
    final secondFiles = await _readTree(second);
    expect(firstFiles, secondFiles);
    expect(
      firstFiles.keys,
      containsAll({
        'coverage.json',
        'host/bootstrap.cjs',
        'host/lib/generated/host_exports.g.dart',
        'host/lib/generated/vscode_facade.g.dart',
        'host/lib/generated/vscode_parity.g.dart',
        'host/lib/generated/vscode_runtime.g.dart',
        'package.json',
      }),
    );

    final checkedInFiles = await _readManagedFixtureTree(
      Directory('test/fixtures/host_extension'),
    );
    final nonBindingFiles =
        checkedInFiles.keys.toSet().difference(firstFiles.keys.toSet());
    expect(
      nonBindingFiles,
      anyOf(isEmpty, {'host/lib/generated/view_protocol.g.dart'}),
      reason: 'Only the CLI-owned shared view protocol may live beside the '
          'binding generator outputs.',
    );
    for (final entry in firstFiles.entries) {
      if (!_bytesEqual(checkedInFiles[entry.key]!, entry.value)) {
        fail(
          'Checked-in generated artifact ${entry.key} is stale. '
          'Run dart tool/binding_generator/generate.dart with the pinned '
          'inventory, overrides, and project descriptor.',
        );
      }
    }
  });

  test('rejected webview delivery records no successful bindings', () async {
    final temporary = await Directory.systemTemp.createTemp(
      'flutter_vscode_post_message_probe_',
    );
    addTearDown(() => temporary.delete(recursive: true));
    final auditSource = File(p.join(temporary.path, 'audit.dart'));
    final compiledAudit = File(p.join(temporary.path, 'audit.js'));
    final nodeProbe = File(p.join(temporary.path, 'probe.cjs'));
    final hostPackageConfig = p.join(
      'test',
      'fixtures',
      'host_extension',
      'host',
      '.dart_tool',
      'package_config.json',
    );
    final runtime = File(
      'test/fixtures/host_extension/host/lib/generated/vscode_runtime.g.dart',
    ).readAsStringSync();
    final extensionKey = RegExp(
      r"@JS\('__flutterVscode\.bindingObservers\.([^']+)'\)",
    ).firstMatch(runtime)!.group(1)!;

    await auditSource.writeAsString('''
import 'dart:js_interop';

import 'package:flutter_vscode_host_fixture/generated/vscode_facade.g.dart';

@JS('auditProbe')
external set _auditProbe(JSFunction value);

void main() {
  _auditProbe = ((JSObject rawWebview) => Webview.fromJS(rawWebview)
      .postMessageFuture(null)
      .then((value) => value.toJS)
      .toJS).toJS;
}
''');
    await nodeProbe.writeAsString('''
const observed = [];
globalThis.self = globalThis;
globalThis.__flutterVscode = {
  bindingObservers: {
    ${jsonEncode(extensionKey)}: (id) => observed.push(id),
  },
};
require(process.argv[2]);
(async () => {
  const accepted = await globalThis.auditProbe({
    postMessage() { return Promise.resolve(false); },
  });
  if (accepted !== false || observed.length !== 0) {
    console.error(JSON.stringify({accepted, observed}));
    process.exitCode = 1;
  }
})();
''');

    final compile = await Process.run(
      'dart',
      [
        'compile',
        'js',
        '--packages=$hostPackageConfig',
        auditSource.path,
        '-o',
        compiledAudit.path,
      ],
      workingDirectory: Directory.current.path,
    );
    expect(
      compile.exitCode,
      0,
      reason: '${compile.stdout}\n${compile.stderr}',
    );

    final probe = await Process.run(
      'node',
      [nodeProbe.path, compiledAudit.path],
      workingDirectory: Directory.current.path,
    );
    expect(probe.exitCode, 0, reason: '${probe.stdout}\n${probe.stderr}');
  });
}

Future<Map<String, List<int>>> _readTree(Directory root) async {
  final files = await root
      .list(recursive: true)
      .where((entity) => entity is File)
      .cast<File>()
      .toList();
  files.sort((left, right) => left.path.compareTo(right.path));
  return {
    for (final file in files)
      p.relative(file.path, from: root.path): await file.readAsBytes(),
  };
}

Future<Map<String, List<int>>> _readManagedFixtureTree(Directory root) async {
  final generatedRoot = Directory(
    p.join(root.path, 'host', 'lib', 'generated'),
  );
  final files = <File>[
    File(p.join(root.path, 'coverage.json')),
    File(p.join(root.path, 'host', 'bootstrap.cjs')),
    File(p.join(root.path, 'package.json')),
    ...await generatedRoot
        .list(recursive: true)
        .where((entity) => entity is File)
        .cast<File>()
        .toList(),
  ]..sort((left, right) => left.path.compareTo(right.path));
  return {
    for (final file in files)
      p.relative(file.path, from: root.path): await file.readAsBytes(),
  };
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

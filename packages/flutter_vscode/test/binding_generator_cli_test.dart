import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../tool/binding_generator/parity_report.dart' as parity;
import 'support/repository.dart';

void main() {
  test('checked-in parity report matches mechanical regeneration', () {
    final coverage = (jsonDecode(
      File('test/fixtures/host_extension/coverage.json').readAsStringSync(),
    ) as Map<Object?, Object?>)
        .cast<String, Object?>();
    final inventory = (jsonDecode(
      File('tool/bindings/ir/vscode-1.129.1.json').readAsStringSync(),
    ) as Map<Object?, Object?>)
        .cast<String, Object?>();
    expect(
      File(repoPath('docs/reference/parity.md')).readAsStringSync(),
      parity.buildParityReport(coverage, inventory),
      reason: 'The parity report is a Framework-Managed doc. Refresh it '
          'with: dart tool/binding_generator/generate.dart --parity .',
    );
  });

  test('CLI regenerates the binding outputs byte-for-byte', () async {
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
        'host/lib/generated/vscode_runtime.g.dart',
        'package.json',
      }),
    );
    expect(
      firstFiles.keys,
      isNot(
        anyElement(
          anyOf(
            contains('vscode_facade.g.dart'),
            contains('vscode_parity.g.dart'),
          ),
        ),
      ),
      reason: 'the retired facade and walking-slice parity must not return',
    );

    final checkedInFiles = await _readManagedFixtureTree(
      Directory('test/fixtures/host_extension'),
    );
    final nonBindingFiles =
        checkedInFiles.keys.toSet().difference(firstFiles.keys.toSet());
    const cliOwnedArtifacts = {
      'host/lib/generated/flutter_view_host.g.dart',
      'host/lib/generated/host_commands.g.dart',
      'host/lib/generated/view_protocol.g.dart',
    };
    expect(
      nonBindingFiles.difference(cliOwnedArtifacts),
      isEmpty,
      reason: 'Only the CLI-owned shared view protocol and the one API '
          'layer may live beside the binding generator outputs.',
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

  test('the runtime host fetch helper performs a real HTTP request', () async {
    final temporary = await Directory.systemTemp.createTemp(
      'flutter_vscode_host_fetch_probe_',
    );
    addTearDown(() => temporary.delete(recursive: true));
    final auditSource = File(p.join(temporary.path, 'audit.dart'));
    final compiledAudit = File(p.join(temporary.path, 'audit.js'));
    final nodeProbe = File(p.join(temporary.path, 'probe.cjs'));
    // The fixture host package is a member of the repository's pub
    // workspace, so it resolves through the workspace root's config.
    final hostPackageConfig =
        repoPath(p.join('.dart_tool', 'package_config.json'));

    await auditSource.writeAsString(r'''
import 'dart:js_interop';

import 'package:flutter_vscode_host_fixture/generated/vscode_runtime.g.dart';

@JS('fetchProbe')
external set _fetchProbe(JSFunction value);

void main() {
  _fetchProbe = ((JSString url) => toHostPromise(
        hostFetch(url.toDart).then(
          (response) => '${response.status}:${response.body}'.toJS,
        ),
      )).toJS;
}
''');
    await nodeProbe.writeAsString(r'''
const http = require('node:http');
globalThis.self = globalThis;
require(process.argv[2]);
const server = http.createServer((request, response) => {
  response.writeHead(200, {'content-type': 'text/plain'});
  response.end('pong-body');
});
server.listen(0, '127.0.0.1', async () => {
  try {
    const port = server.address().port;
    const result =
      await globalThis.fetchProbe(`http://127.0.0.1:${port}/ping`);
    if (result !== '200:pong-body') {
      console.error(`unexpected: ${result}`);
      process.exitCode = 1;
    }
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  } finally {
    server.close();
  }
});
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

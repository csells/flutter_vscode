import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test(
    'failed native listener disposal stays owned until close retries',
    () async {
      final temporary = await Directory.systemTemp.createTemp(
        'flutter_vscode_transport_dispose_probe_',
      );
      addTearDown(() => temporary.delete(recursive: true));
      final probeSource = File(p.join(temporary.path, 'probe.dart'));
      final compiledProbe = File(p.join(temporary.path, 'probe.js'));
      final nodeHarness = File(p.join(temporary.path, 'harness.cjs'));
      final hostPackageConfig = p.join(
        'test',
        'fixtures',
        'host_extension',
        'host',
        '.dart_tool',
        'package_config.json',
      );
      final runtime = File(
        'test/fixtures/host_extension/host/lib/generated/'
        'vscode_runtime.g.dart',
      ).readAsStringSync();
      final extensionKey = RegExp(
        r"@JS\('__flutterVscode\.bindingObservers\.([^']+)'\)",
      ).firstMatch(runtime)!.group(1)!;

      await probeSource.writeAsString('''
import 'dart:js_interop';

import 'package:flutter_vscode_host_fixture/generated/vscode_facade.g.dart';
import 'package:flutter_vscode_host_fixture/host_webview_transport.dart';

@JS('transportDisposeProbe')
external set _transportDisposeProbe(JSFunction value);

void main() {
  _transportDisposeProbe = ((JSObject rawWebview) =>
      _runProbe(Webview.fromJS(rawWebview)).toJS).toJS;
}

Future<JSAny?> _runProbe(Webview webview) async {
  final transport = HostWebviewTransport(webview);
  var firstCloseThrew = false;
  try {
    await transport.close();
  } on Object {
    firstCloseThrew = true;
  }
  final countAfterFailure = transport.receivingSubscriptionCount;

  await transport.close();
  final countAfterRetry = transport.receivingSubscriptionCount;

  await transport.close();
  final countAfterIdempotentClose = transport.receivingSubscriptionCount;

  return <String, Object?>{
    'firstCloseThrew': firstCloseThrew,
    'countAfterFailure': countAfterFailure,
    'countAfterRetry': countAfterRetry,
    'countAfterIdempotentClose': countAfterIdempotentClose,
  }.jsify();
}
''');
      await nodeHarness.writeAsString('''
'use strict';

const assert = require('node:assert/strict');

let disposeCalls = 0;
let listenerActive = true;
globalThis.self = globalThis;
globalThis.__flutterVscode = {
  bindingObservers: {
    ${jsonEncode(extensionKey)}: () => {},
  },
};
require(process.argv[2]);

(async () => {
  const report = await globalThis.transportDisposeProbe({
    onDidReceiveMessage() {
      return {
        dispose() {
          disposeCalls += 1;
          if (disposeCalls === 1) {
            throw new Error('injected native listener disposal failure');
          }
          listenerActive = false;
        },
      };
    },
    postMessage() {
      return Promise.resolve(true);
    },
  });

  assert.equal(report.firstCloseThrew, true);
  assert.equal(report.countAfterFailure, 1);
  assert.equal(report.countAfterRetry, 0);
  assert.equal(report.countAfterIdempotentClose, 0);
  assert.equal(disposeCalls, 2);
  assert.equal(listenerActive, false);
})().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
''');

      final compile = await Process.run(
        'dart',
        [
          'compile',
          'js',
          '--packages=$hostPackageConfig',
          probeSource.path,
          '-o',
          compiledProbe.path,
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
        [nodeHarness.path, compiledProbe.path],
        workingDirectory: Directory.current.path,
      );
      expect(probe.exitCode, 0, reason: '${probe.stdout}\n${probe.stderr}');
    },
  );
}

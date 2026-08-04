import 'dart:io';

import 'package:flutter_vscode/src/cli/host_commands_source.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('ExtensionCommands template interface', () {
    test('register() takes an ordinary-Dart handler', () {
      expect(
        hostCommandsSource,
        contains('final class ExtensionCommands'),
        reason: 'one small object holds the context/api seam so call '
            'sites carry only a name and behavior',
      );
      expect(
        hostCommandsSource,
        contains('FutureOr<Object?> Function(List<Object?> arguments)'),
        reason: 'handlers are ordinary Dart: dartified arguments in, a '
            'protocol-safe value (or Future of one) out',
      );
      expect(
        hostCommandsSource,
        contains('Disposable register(String name, CommandHandler handler)'),
        reason: 'registration returns the native registration for callers '
            'that dispose early',
      );
    });

    test('the module owns every interop seam the ceremony used to', () {
      expect(
        hostCommandsSource,
        contains('toHostCallback('),
        reason: 'synchronous throws must retain mapped Dart stack frames',
      );
      expect(
        hostCommandsSource,
        contains('toHostPromise'),
        reason: 'handler futures must cross as host promises with mapped '
            'failure stacks',
      );
      expect(
        hostCommandsSource,
        contains('.dartify()'),
        reason: 'invocation arguments must reach the handler as Dart values',
      );
      expect(
        hostCommandsSource,
        contains('context.subscriptions'),
        reason: 'registrations must ride the extension lifetime',
      );
    });

    test('the checked-in Host fixture module mirrors the template', () {
      expect(
        File(
          'test/fixtures/host_extension/host/lib/generated/'
          'host_commands.g.dart',
        ).existsSync(),
        isTrue,
        reason: 'the module is emitted for every project, so the fixture '
            '(a view-bearing project) must carry it; rebuild with '
            'scripts/build_host_fixture.sh',
      );
      expect(
        File(
          'test/fixtures/host_extension/host/lib/generated/'
          'host_commands.g.dart',
        ).readAsStringSync(),
        hostCommandsSource,
        reason: 'Rebuild the fixture (scripts/build_host_fixture.sh) after '
            'changing the template.',
      );
    });

    test(
      'build emits the module byte-for-byte for a host-only project',
      () async {
        final workspace = await Directory.systemTemp.createTemp(
          'flutter_vscode_cli_host_commands_',
        );
        addTearDown(() => workspace.delete(recursive: true));
        final executable = p.join(
          Directory.current.path,
          'bin',
          'flutter_vscode.dart',
        );
        final create = await Process.run(
          'dart',
          [executable, 'create', 'my_extension'],
          workingDirectory: workspace.path,
        );
        expect(
          create.exitCode,
          0,
          reason: '${create.stdout}\n${create.stderr}',
        );
        final project = Directory(p.join(workspace.path, 'my_extension'));
        final module = File(
          p.join(
            project.path,
            'host',
            'lib',
            'generated',
            'host_commands.g.dart',
          ),
        );
        expect(
          module.existsSync(),
          isTrue,
          reason: 'create must scaffold the module so command registration '
              'analyzes before the first build',
        );

        final build = await Process.run(
          'dart',
          [executable, 'build'],
          workingDirectory: project.path,
        );
        expect(build.exitCode, 0, reason: '${build.stdout}\n${build.stderr}');
        expect(
          module.existsSync(),
          isTrue,
          reason: 'a host-only project must carry the command module',
        );
        expect(
          module.readAsStringSync(),
          hostCommandsSource,
          reason: 'The emitted module must match the framework template '
              'byte-for-byte',
        );
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    test(
      'a registered handler receives dartified arguments and its Future '
      'result round-trips to the host',
      () async {
        final temporary = await Directory.systemTemp.createTemp(
          'flutter_vscode_host_commands_probe_',
        );
        addTearDown(() => temporary.delete(recursive: true));
        final probeSource = File(p.join(temporary.path, 'probe.dart'));
        final compiledProbe = File(p.join(temporary.path, 'probe.js'));
        final nodeHarness = File(p.join(temporary.path, 'harness.cjs'));
        // The fixture host package is a member of the repository's pub
        // workspace, so it resolves through the workspace root's config.
        final hostPackageConfig = p.join('.dart_tool', 'package_config.json');
        final extensionKey = RegExp(r'stackMappers\.(e_[0-9a-f]{64})')
            .firstMatch(
              File(
                'test/fixtures/host_extension/host/lib/generated/'
                'vscode_runtime.g.dart',
              ).readAsStringSync(),
            )!
            .group(1)!;

        await probeSource.writeAsString('''
import 'dart:js_interop';

import 'package:flutter_vscode_host_fixture/generated/host_commands.g.dart';
import 'package:flutter_vscode/vscode_dart.dart';

@JS('hostCommandsProbe')
external set _hostCommandsProbe(JSFunction value);

void main() {
  _hostCommandsProbe = ((JSObject rawContext, JSObject rawVscode) {
    final commands = ExtensionCommands(
      context: ExtensionContext(rawContext),
      api: VscodeApi(rawVscode).dart,
    );
    commands.register('probe.echo', (arguments) async {
      await Future<void>.delayed(Duration.zero);
      return <String, Object?>{
        'argumentCount': arguments.length,
        'arguments': arguments,
      };
    });
    commands.register('probe.fail', (arguments) async {
      throw StateError('deliberate probe failure');
    });
    return commands.register('probe.text', (arguments) => 'plain text').isA<JSObject>();
  }).toJS;
}
''');
        await nodeHarness.writeAsString('''
'use strict';

const assert = require('node:assert/strict');

globalThis.self = globalThis;
globalThis.__flutterVscode = {
  stackMappers: { $extensionKey: (stack) => stack },
  callbackWrappers: {
    $extensionKey: (callback) =>
      function (...args) {
        return Reflect.apply(callback, this, args);
      },
  },
};
require(process.argv[2]);

const read = (value, key) =>
  value instanceof Map ? value.get(key) : value[key];

(async () => {
  const subscriptions = [];
  const registered = new Map();
  const registrationIsDisposable = globalThis.hostCommandsProbe(
    { subscriptions },
    {
      commands: {
        registerCommand(name, callback) {
          registered.set(name, callback);
          return { dispose() {} };
        },
      },
    },
  );

  assert.equal(registrationIsDisposable, true);
  assert.equal(registered.size, 3);
  assert.equal(subscriptions.length, 3);
  for (const subscription of subscriptions) {
    assert.equal(typeof subscription.dispose, 'function');
  }

  const echoed = await registered.get('probe.echo')(41, {
    linesFound: 7,
    tags: ['a', true],
  });
  assert.equal(read(echoed, 'argumentCount'), 2);
  const echoedArguments = read(echoed, 'arguments');
  assert.equal(echoedArguments[0], 41);
  assert.equal(read(echoedArguments[1], 'linesFound'), 7);
  assert.deepEqual([...read(echoedArguments[1], 'tags')], ['a', true]);

  const bare = await registered.get('probe.echo')();
  assert.equal(read(bare, 'argumentCount'), 0);
  assert.deepEqual([...read(bare, 'arguments')], []);

  assert.equal(await registered.get('probe.text')(), 'plain text');

  let rejection;
  try {
    await registered.get('probe.fail')();
  } catch (error) {
    rejection = error;
  }
  assert.ok(rejection, 'a throwing handler must reject the host promise');
  assert.match(String(rejection.message), /deliberate probe failure/);
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
      timeout: const Timeout(Duration(minutes: 3)),
    );
  });
}

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('full repository gate installs and exercises the packaged extension',
      () {
    final fullGate = File('scripts/test_all.sh').readAsStringSync();

    expect(fullGate, contains('./scripts/test_packaged_extension.sh'));
  });

  test('CI enforces analysis, package proof, and a clean checkout', () {
    final workflow = File('.github/workflows/test.yml').readAsStringSync();

    expect(workflow, contains('flutter analyze'));
    expect(workflow, contains('./scripts/test_all.sh'));
    expect(
      workflow,
      contains('dart pub publish --dry-run --ignore-warnings'),
    );
    expect(workflow, contains('git diff --exit-code'));
    expect(workflow, contains('git status --porcelain'));
  });

  test('checked-in Host fixture protocol matches the public runtime source',
      () {
    final runtimeProtocol =
        File('lib/src/view_protocol.dart').readAsBytesSync();
    final checkedInFixture = File(
      'test/fixtures/host_extension/host/lib/generated/view_protocol.g.dart',
    ).readAsBytesSync();

    expect(
      checkedInFixture,
      orderedEquals(runtimeProtocol),
      reason:
          'Regenerate the checked-in Host fixture before running its build.',
    );
  });

  test('the Host fixture composes the framework view-host skeleton', () {
    final fixture = File(
      'test/fixtures/host_extension/host/lib/extension.dart',
    ).readAsStringSync();

    expect(
      fixture,
      contains('FlutterViewHost.open('),
      reason: 'the fixture must compose the framework-owned view host',
    );
    for (final skeleton in [
      'String _viewHtml(',
      'createFlutterViewPanel(',
      'HostViewSession.connect(',
      'Content-Security-Policy',
    ]) {
      expect(
        fixture,
        isNot(contains(skeleton)),
        reason: 'only adversity machinery may stay fixture-owned; '
            '"$skeleton" belongs to FlutterViewHost',
      );
    }
  });

  test('published package excludes repository-only hardening fixtures', () {
    final pubIgnore = File('.pubignore').readAsLinesSync().toSet();

    expect(
      pubIgnore,
      containsAll({
        '/test/',
        '/specs/',
        '**/build/',
        '/tool/binding_importer/',
        '/tool/extension_host_test/',
        '/extensions/',
      }),
    );
    expect(pubIgnore, isNot(contains('/tool/binding_generator/')));
    expect(pubIgnore, isNot(contains('/tool/bindings/')));
    expect(pubIgnore, isNot(contains('/tool/bindings/contracts/')));
    expect(pubIgnore, isNot(contains('/tool/bindings/inputs/')));
    expect(pubIgnore, isNot(contains('/tool/legacy-agent-skills/')));
    expect(
      File(
        'tool/bindings/contracts/checkpoint4-extension-host.json',
      ).lengthSync(),
      lessThan(16 * 1024),
    );
  });

  test('shipped example extensions honor the consumer guardrails', () {
    final areaReadme = File('extensions/README.md').readAsStringSync();
    expect(
      areaReadme,
      contains('consumes the framework the way an Extension'),
      reason: 'extensions/README.md must record the guardrails',
    );
    expect(
      File('README.md').readAsStringSync(),
      contains('extensions/'),
      reason: 'the root README must route readers to the shipped examples',
    );
    final aggregate = File('scripts/test_all.sh').readAsStringSync();
    expect(
      aggregate,
      contains('test_coverage_extension.sh'),
      reason: 'the aggregate gate must run the example-extension gate',
    );
    final extensionDirs = Directory('extensions')
        .listSync()
        .whereType<Directory>();
    expect(extensionDirs, isNotEmpty);
    for (final extension in extensionDirs) {
      for (final root in ['host', 'shared']) {
        final dir = Directory(p.join(extension.path, root, 'lib'));
        if (!dir.existsSync()) {
          continue;
        }
        for (final entity in dir.listSync(recursive: true)) {
          if (entity is! File || !entity.path.endsWith('.dart')) {
            continue;
          }
          final source = entity.readAsStringSync();
          expect(
            source,
            isNot(contains("import 'package:flutter_vscode/")),
            reason: '${entity.path} must consume only generated files, '
                'never the framework package directly (guardrail)',
          );
        }
      }
    }
  });

  test('the startup measurement is documented from gate output', () {
    final doc = File('docs/reference/startup.md').readAsStringSync();
    expect(
      doc,
      contains('webview load to first rendered frame'),
      reason: 'the doc must define what the measurement covers',
    );
    expect(
      doc,
      contains('viewColdStartMs'),
      reason: 'the doc must name the gate field it cites',
    );
    expect(
      doc,
      contains('Recorded'),
      reason: 'the doc must carry a recording-time value from a gate run',
    );
    for (final harness in [
      'test/fixtures/host_extension/test/run.cjs',
      'test/fixtures/packaged_test_driver/test/run.cjs',
    ]) {
      expect(
        File(harness).readAsStringSync(),
        contains('viewColdStartMs'),
        reason: '$harness must assert and print the measurement',
      );
    }
  });

  test('packaged E2E activates the pub-filtered framework contents', () {
    final packagedGate =
        File('scripts/test_packaged_extension.sh').readAsStringSync();

    expect(
      packagedGate,
      contains('dart tool/pub_archive_list.dart'),
      reason: "staging must consume pub's actual archive file selection",
    );
    expect(
      packagedGate,
      isNot(contains('rsync')),
      reason: 'no rsync approximation of the publish archive may remain',
    );
    expect(
      packagedGate,
      isNot(contains(r'VIEW_FIXTURE_ROOT="${PACKAGE_COPY}/test/fixtures')),
    );
    expect(
      packagedGate,
      contains(
        r'"override:flutter_vscode@{path: ${PACKAGE_COPY}}"',
      ),
    );
  });

  test('Extension Host gates use fresh invocation-scoped VS Code caches', () {
    for (final path in [
      'scripts/test_host_extension.sh',
      'scripts/test_packaged_extension.sh',
    ]) {
      final gate = File(path).readAsStringSync();

      expect(gate, contains('mktemp -d'), reason: path);
      expect(
        gate,
        contains(r'TEMP_ROOT="$(cd "${TEMP_ROOT}" && pwd -P)"'),
        reason: path,
      );
      expect(
        gate,
        contains(r'CACHE_ROOT="${TEMP_ROOT}/vscode-test-cache"'),
        reason: path,
      );
      expect(gate, contains('trap cleanup EXIT'), reason: path);
      expect(gate, contains(r'rm -rf "${TEMP_ROOT}"'), reason: path);
      expect(
        gate,
        contains(r'--volume "${CACHE_ROOT}:/vscode-test-cache"'),
        reason: path,
      );
      expect(gate, isNot(contains('docker volume create')), reason: path);
      expect(gate, isNot(contains('CACHE_VOLUME=')), reason: path);
    }
  });

  test('Host fixture resolves the receipted root package before its CLI', () {
    final builder = File('scripts/build_host_fixture.sh').readAsStringSync();
    const repositoryRoot = r'${REPO_ROOT}';
    const resolution = 'flutter pub get --enforce-lockfile --no-example '
        '--directory="$repositoryRoot"';
    const cli = 'dart "$repositoryRoot/bin/flutter_vscode.dart" build';

    expect(builder, contains(resolution));
    expect(builder, contains(cli));
    expect(builder.indexOf(resolution), lessThan(builder.indexOf(cli)));
  });

  test('lock-enforced Host builds include a trackable root lockfile', () {
    expect(
      FileSystemEntity.typeSync('pubspec.lock'),
      FileSystemEntityType.file,
    );

    final ignored = Process.runSync(
      'git',
      ['check-ignore', '--quiet', '--', 'pubspec.lock'],
    );
    expect(
      ignored.exitCode,
      1,
      reason: 'pubspec.lock must survive a fresh repository checkout.',
    );

    final repositoryFiles = Process.runSync(
      'git',
      ['ls-files', '--cached', '--', 'pubspec.lock'],
    );
    expect(repositoryFiles.exitCode, 0);
    expect(
      (repositoryFiles.stdout as String).trim(),
      'pubspec.lock',
      reason: 'pubspec.lock must be committed, not merely untracked and '
          'unignored, so a fresh checkout satisfies --enforce-lockfile.',
    );

    final committedFiles = Process.runSync(
      'git',
      ['ls-tree', '--name-only', 'HEAD', '--', 'pubspec.lock'],
    );
    expect(committedFiles.exitCode, 0);
    expect(
      (committedFiles.stdout as String).trim(),
      'pubspec.lock',
      reason: 'pubspec.lock must exist in the HEAD tree, not merely the '
          'index, so a fresh checkout satisfies --enforce-lockfile.',
    );
  });

  test('parity report is linked from the reference index', () {
    expect(
      File('docs/reference/index.md').readAsStringSync(),
      contains('parity.md'),
      reason: 'the generated parity burn-down must be discoverable',
    );
    expect(
      File('docs/reference/parity.md').readAsStringSync(),
      contains('defect'),
      reason: "the report must state the vision's missing-path-is-a-defect "
          'rule',
    );
  });

  test('legacy v0 surfaces are labeled or gone', () {
    expect(
      File('bin/init.dart').existsSync(),
      isFalse,
      reason: 'the dead v0 scaffolder must not ship',
    );

    final prdHead =
        File('PRD.md').readAsLinesSync().take(5).join('\n').toLowerCase();
    expect(
      prdHead,
      contains('historical'),
      reason: 'PRD.md describes the v0 product and must say so up front',
    );

    final exampleMainHead = File('example/lib/main.dart')
        .readAsLinesSync()
        .take(10)
        .join('\n')
        .toLowerCase();
    expect(
      exampleMainHead,
      contains('legacy'),
      reason: 'the pub.dev example surface must label the v0 demo as legacy',
    );
    final exampleReadme = File('example/README.md');
    expect(
      exampleReadme.existsSync(),
      isTrue,
      reason: 'example/ must present the current Dart-host path',
    );
    expect(
      exampleReadme.readAsStringSync(),
      contains('flutter_vscode create'),
      reason: 'example/README.md must route readers to the v1 workflow',
    );

    final markerPattern =
        RegExp('generate_vscode_extension|VSCodeWebViewHelper');
    final labelPattern = RegExp('legacy|historical', caseSensitive: false);
    final surfaces = <File>[
      File('README.md'),
      File('PRD.md'),
      ...Directory('docs')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.md')),
    ];
    for (final surface in surfaces) {
      final contents = surface.readAsStringSync();
      if (markerPattern.hasMatch(contents)) {
        expect(
          labelPattern.hasMatch(contents),
          isTrue,
          reason: '${surface.path} mentions a v0 entry point and must carry '
              'a legacy or historical label',
        );
      }
    }
  });

  test('generated Host API guide registers providers synchronously', () {
    final guide =
        File('docs/reference/generated-host-api.md').readAsStringSync();

    expect(guide, isNot(contains('Future<JSAny?>(()')));
    expect(guide, contains('Future<JSAny?>.value(null).toJS'));
    expect(
      guide.indexOf('registerCommand'),
      lessThan(guide.indexOf('Future<JSAny?>.value(null).toJS')),
      reason: 'the activation example must register through the single '
          "layer's registerCommand before returning its settled future",
    );
    expect(guide, contains('toHostCallback'));
  });
}

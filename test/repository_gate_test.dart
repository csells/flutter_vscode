import 'dart:io';

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

  test('packaged E2E activates the pub-filtered framework contents', () {
    final packagedGate =
        File('scripts/test_packaged_extension.sh').readAsStringSync();

    expect(
      packagedGate,
      contains(r'--exclude-from="${REPO_ROOT}/.pubignore"'),
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

  test('generated Host API guide registers providers synchronously', () {
    final guide =
        File('docs/reference/generated-host-api.md').readAsStringSync();

    expect(guide, isNot(contains('Future<JSAny?>(()')));
    expect(guide, contains('Future<JSAny?>.value(null).toJS'));
    expect(
      guide.indexOf('registerCommandCallback'),
      lessThan(guide.indexOf('Future<JSAny?>.value(null).toJS')),
    );
  });
}

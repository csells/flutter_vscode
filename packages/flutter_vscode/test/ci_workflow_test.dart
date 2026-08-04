@Tags(['gate'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'support/repository.dart';

/// Runs the CI workflow's own steps in a runner-like Linux container.
///
/// The steps are read out of `.github/workflows/test.yml` rather than
/// restated here: a second copy of the commands is a second copy to forget,
/// and this repository has already paid for that lesson once. Whatever CI
/// runs is what this runs.
///
/// `uses:` steps have no command to execute. `actions/checkout` is stood in
/// for by the clone below and `subosito/flutter-action` by the image, which
/// is the only place this test approximates rather than reproduces.
///
/// What it proves: the workflow's commands succeed on Linux, from a clean
/// clone, with the paths, working directories, and nested Docker that CI
/// will use. What it does not prove: x86 behaviour. GitHub's runners are
/// x86_64 and this runs at the host's architecture, because emulating
/// Electron and xvfb is slow enough to make the test useless as a check.
///
/// This test must never run inside the workflow it executes. The gate job
/// runs `test_all.sh`, which runs `flutter test`, so that script excludes
/// the `gate` tag -- without it, the workflow test invokes itself.
void main() {
  const image = 'flutter-vscode-ci-runner:local';

  test(
    'the CI workflow steps pass in a runner-like container',
    () async {
      final docker = await Process.run('docker', ['info']);
      expect(
        docker.exitCode,
        0,
        reason: 'this gate needs a running Docker daemon; a missing one is a '
            'failure, never a skip',
      );

      // A clone, not the working tree: CI runs committed state, and mounting
      // the live checkout would let the container rewrite its `.dart_tool`
      // with container paths.
      final temporary = Directory.systemTemp.createTempSync(
        'flutter_vscode_ci_workflow_',
      );
      addTearDown(() => temporary.deleteSync(recursive: true));
      final checkout = p.join(temporary.path, 'flutter_vscode');
      // A runner keeps one filesystem across steps. Each step here is a fresh
      // container, so without a shared cache the packages `pub get` fetches
      // vanish before the next step -- and `dart format` then cannot resolve
      // the `include:` in analysis_options.yaml and quietly formats to
      // different settings.
      final pubCache = Directory(p.join(temporary.path, 'pub-cache'))
        ..createSync(recursive: true);
      final clone = await Process.run('git', [
        'clone',
        '--quiet',
        '--shared',
        repositoryRoot.path,
        checkout,
      ]);
      expect(clone.exitCode, 0, reason: clone.stderr.toString());

      final workflow = loadYaml(
        File(repoPath('.github/workflows/test.yml')).readAsStringSync(),
      ) as YamlMap;
      final jobs = workflow['jobs'] as YamlMap;
      final pinnedFlutter = _pinnedFlutterVersion(jobs);

      final runnerRoot = p.join(
        repositoryRoot.path,
        'packages',
        'flutter_vscode',
        'tool',
        'ci_runner',
      );
      final build = await Process.run('docker', [
        'build',
        '--file',
        p.join(runnerRoot, 'Dockerfile'),
        '--build-arg',
        'FLUTTER_VERSION=$pinnedFlutter',
        '--tag',
        image,
        runnerRoot,
      ]);
      expect(
        build.exitCode,
        0,
        reason: '${build.stdout}\n${build.stderr}',
      );

      var executed = 0;
      for (final job in jobs.entries) {
        final steps = (job.value as YamlMap)['steps'] as YamlList;
        for (final step in steps.cast<YamlMap>()) {
          final command = step['run'] as String?;
          if (command == null) {
            continue;
          }
          final relative = step['working-directory'] as String?;
          final result = await Process.run('docker', [
            'run',
            '--rm',
            // Identical path inside and out, so the gate's nested `docker run
            // -v` mounts resolve against the host daemon.
            '--volume',
            '$checkout:$checkout',
            '--volume',
            '/var/run/docker.sock:/var/run/docker.sock',
            '--volume',
            '${pubCache.path}:${pubCache.path}',
            '--env',
            'PUB_CACHE=${pubCache.path}',
            '--workdir',
            if (relative == null) checkout else p.join(checkout, relative),
            image,
            'bash',
            '-lc',
            command,
          ]);
          expect(
            result.exitCode,
            0,
            reason: 'workflow job "${job.key}", step "${step['name']}" failed\n'
                '${result.stdout}\n${result.stderr}',
          );
          executed += 1;
        }
      }

      expect(
        executed,
        greaterThanOrEqualTo(6),
        reason: 'every `run:` step in the workflow must have been executed; '
            'a workflow that grew steps this test skipped would pass falsely',
      );
    },
    timeout: const Timeout(Duration(hours: 2)),
  );
}

/// The exact Flutter version the workflow pins, so the container verifies the
/// toolchain CI uses rather than whatever the base image happened to ship.
String _pinnedFlutterVersion(YamlMap jobs) {
  for (final job in jobs.entries) {
    final steps = (job.value as YamlMap)['steps'] as YamlList;
    for (final step in steps.cast<YamlMap>()) {
      final version = (step['with'] as YamlMap?)?['flutter-version'];
      if (version != null) {
        return version.toString();
      }
    }
  }
  throw StateError(
    'the workflow must pin an exact flutter-version; a floating channel '
    'cannot be reproduced in a container or in CI',
  );
}

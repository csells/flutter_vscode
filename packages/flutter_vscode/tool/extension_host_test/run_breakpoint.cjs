'use strict';

const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const {runTests} = require('@vscode/test-electron');

const repositoryRoot = path.resolve(__dirname, '../..');
const fixtureRoot = path.join(
  repositoryRoot,
  'test',
  'fixtures',
  'host_extension',
);
const driverRoot = path.join(
  repositoryRoot,
  'test',
  'fixtures',
  'breakpoint_driver',
);
const fixtureManifest = require(path.join(fixtureRoot, 'package.json'));
const vscodeVersion = fixtureManifest.engines.vscode;
const inspectPort = Number(
  process.env.FLUTTER_VSCODE_BREAKPOINT_INSPECT_PORT ?? '9339',
);
const mapPath =
  process.env.FLUTTER_VSCODE_BREAKPOINT_MAP_PATH ??
  path.join(fixtureRoot, 'out', 'extension.dart.js.map');

async function main() {
  if (!fs.existsSync(mapPath)) {
    throw new Error(
      `Fixture source map does not exist: ${mapPath} — run ` +
        'scripts/build_host_fixture.sh first',
    );
  }
  console.log(
    `[breakpoint-test] launching VS Code ${vscodeVersion} with ` +
      `--inspect-extensions=${inspectPort}`,
  );
  // A short temp profile keeps VS Code's IPC socket path under the OS
  // limit even when the repository lives at a deep path.
  const profileRoot = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-breakpoint-host-'),
  );
  try {
    // The fixture and the driver both load as development extensions: the
    // fixture provides the compiled Dart host under test; the driver arms a
    // breakpoint through the Extension Host inspector and triggers the
    // mapped Dart line.
    await runTests({
      version: vscodeVersion,
      cachePath:
        process.env.VSCODE_TEST_CACHE_PATH ??
        path.join(__dirname, '.vscode-test'),
      extensionDevelopmentPath: [fixtureRoot, driverRoot],
      extensionTestsPath: path.join(driverRoot, 'test', 'run.cjs'),
      extensionTestsEnv: {
        FLUTTER_VSCODE_BREAKPOINT_INSPECT_PORT: String(inspectPort),
        FLUTTER_VSCODE_BREAKPOINT_MAP_PATH: mapPath,
      },
      launchArgs: [
        '--disable-extensions',
        `--user-data-dir=${path.join(profileRoot, 'user-data')}`,
        `--inspect-extensions=${inspectPort}`,
      ],
    });
  } finally {
    fs.rmSync(profileRoot, {recursive: true, force: true});
  }
  console.log(
    '[breakpoint-test] breakpoint bound through the source map and paused ' +
      'on the Dart line',
  );
}

main().catch((error) => {
  console.error('[breakpoint-test] failed');
  console.error(error);
  process.exitCode = 1;
});

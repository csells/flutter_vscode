const path = require('node:path');
const {runTests} = require('@vscode/test-electron');

const repositoryRoot = path.resolve(__dirname, '../..');
const fixtureRoot = path.join(
  repositoryRoot,
  'test',
  'fixtures',
  'host_extension',
);
const fixtureManifest = require(path.join(fixtureRoot, 'package.json'));
const vscodeVersion = fixtureManifest.engines.vscode;

async function main() {
  console.log(`[host-test] launching pinned VS Code ${vscodeVersion}`);
  await runTests({
    version: vscodeVersion,
    cachePath:
      process.env.VSCODE_TEST_CACHE_PATH ??
      path.join(__dirname, '.vscode-test'),
    extensionDevelopmentPath: fixtureRoot,
    extensionTestsPath: path.join(fixtureRoot, 'test', 'run.cjs'),
    launchArgs: ['--disable-extensions'],
  });

  console.log('[host-test] launching activation-failure host');
  await runTests({
    version: vscodeVersion,
    cachePath:
      process.env.VSCODE_TEST_CACHE_PATH ??
      path.join(__dirname, '.vscode-test'),
    extensionDevelopmentPath: fixtureRoot,
    extensionTestsPath: path.join(
      fixtureRoot,
      'test',
      'activation_failure.cjs',
    ),
    extensionTestsEnv: {
      FLUTTER_VSCODE_HOST_TEST_FAIL_ACTIVATION: '1',
    },
    launchArgs: ['--disable-extensions'],
  });
}

main().catch((error) => {
  console.error('[host-test] failed');
  console.error(error);
  process.exitCode = 1;
});

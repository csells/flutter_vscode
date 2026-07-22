const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const {runTests} = require('@vscode/test-electron');
const {
  verifyHostContractEvidenceFiles,
  verifyHostContractSourceFiles,
} = require('./host_contract.cjs');

const repositoryRoot = path.resolve(__dirname, '../..');
const fixtureRoot = path.join(
  repositoryRoot,
  'test',
  'fixtures',
  'host_extension',
);
const fixtureManifest = require(path.join(fixtureRoot, 'package.json'));
const vscodeVersion = fixtureManifest.engines.vscode;
const contractId = 'checkpoint4ExtensionHost';
const contractPath = path.join(
  repositoryRoot,
  'tool',
  'bindings',
  'contracts',
  'checkpoint4-extension-host.json',
);

async function main() {
  verifyHostContractSourceFiles({
    contractId,
    contract: JSON.parse(fs.readFileSync(contractPath, 'utf8')),
    repositoryRoot,
  });
  const evidenceRoot = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-host-evidence-'),
  );
  const evidencePath = path.join(evidenceRoot, 'observed.json');
  try {
    console.log(
      `[host-test] launching fresh VS Code test runtime ${vscodeVersion}`,
    );
    await runTests({
      version: vscodeVersion,
      cachePath:
        process.env.VSCODE_TEST_CACHE_PATH ??
        path.join(__dirname, '.vscode-test'),
      extensionDevelopmentPath: fixtureRoot,
      extensionTestsPath: path.join(fixtureRoot, 'test', 'run.cjs'),
      extensionTestsEnv: {
        FLUTTER_VSCODE_HOST_EVIDENCE_PATH: evidencePath,
      },
      launchArgs: ['--disable-extensions'],
    });

    const counts = verifyHostContractEvidenceFiles({
      contractId,
      contractPath,
      evidencePath,
      repositoryRoot,
    });
    console.log(
      `[host-test] verified ${counts.observedCount} exact Host Contract bindings`,
    );

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
  } finally {
    fs.rmSync(evidenceRoot, {recursive: true, force: true});
  }
}

main().catch((error) => {
  console.error('[host-test] failed');
  console.error(error);
  process.exitCode = 1;
});

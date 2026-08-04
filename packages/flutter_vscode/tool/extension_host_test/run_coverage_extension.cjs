'use strict';

const childProcess = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const {
  downloadAndUnzipVSCode,
  resolveCliArgsFromVSCodeExecutablePath,
  runTests,
} = require('@vscode/test-electron');

const packageRoot = path.resolve(__dirname, '../..');
const driverRoot = path.join(
  packageRoot,
  'test',
  'fixtures',
  'coverage_treemap_driver',
);
const extensionProject = process.env.FLUTTER_VSCODE_COVERAGE_PROJECT;
if (!extensionProject) {
  throw new Error('FLUTTER_VSCODE_COVERAGE_PROJECT is required');
}
const workspacePath = process.env.FLUTTER_VSCODE_COVERAGE_WORKSPACE;
if (!workspacePath) {
  throw new Error('FLUTTER_VSCODE_COVERAGE_WORKSPACE is required');
}
const manifest = require(path.join(extensionProject, 'package.json'));
const vscodeVersion = manifest.engines.vscode;
const vsixPath = path.join(
  extensionProject,
  'build',
  `${manifest.name}-${manifest.version}.vsix`,
);

function installVsix(vscodeExecutablePath, extensionsDir, userDataDir) {
  const [cliPath, ...cliArguments] =
    resolveCliArgsFromVSCodeExecutablePath(vscodeExecutablePath, {
      reuseMachineInstall: true,
    });
  const result = childProcess.spawnSync(
    cliPath,
    [
      ...cliArguments,
      '--install-extension',
      vsixPath,
      '--force',
      `--extensions-dir=${extensionsDir}`,
      `--user-data-dir=${userDataDir}`,
    ],
    {
      encoding: 'utf8',
      stdio: 'pipe',
    },
  );

  if (result.error) {
    throw result.error;
  }
  if (result.status !== 0) {
    throw new Error(
      [
        `VS Code CLI failed to install ${vsixPath}.`,
        result.stdout,
        result.stderr,
      ].join('\n'),
    );
  }
  process.stdout.write(result.stdout);
  process.stderr.write(result.stderr);
}

async function main() {
  if (!fs.existsSync(vsixPath)) {
    throw new Error(`Packaged extension does not exist: ${vsixPath}`);
  }
  if (!fs.existsSync(path.join(workspacePath, 'coverage', 'lcov.info'))) {
    throw new Error(`Workspace has no coverage data: ${workspacePath}`);
  }

  const profileRoot = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-coverage-host-'),
  );
  const extensionsDir = path.join(profileRoot, 'extensions');
  const userDataDir = path.join(profileRoot, 'user-data');
  fs.mkdirSync(extensionsDir, {recursive: true});
  fs.mkdirSync(path.join(userDataDir, 'User'), {recursive: true});
  fs.writeFileSync(
    path.join(userDataDir, 'User', 'settings.json'),
    JSON.stringify({'workbench.startupEditor': 'none'}),
  );

  try {
    console.log(
      `[coverage-treemap-test] resolving VS Code test runtime ${vscodeVersion}`,
    );
    const vscodeExecutablePath = await downloadAndUnzipVSCode({
      version: vscodeVersion,
      cachePath:
        process.env.VSCODE_TEST_CACHE_PATH ??
        path.join(__dirname, '.vscode-test'),
    });

    console.log(`[coverage-treemap-test] installing ${vsixPath}`);
    installVsix(vscodeExecutablePath, extensionsDir, userDataDir);

    console.log('[coverage-treemap-test] launching the coverage workspace');
    await runTests({
      vscodeExecutablePath,
      extensionDevelopmentPath: driverRoot,
      extensionTestsPath: path.join(driverRoot, 'test', 'run.cjs'),
      launchArgs: [
        workspacePath,
        `--extensions-dir=${extensionsDir}`,
        `--user-data-dir=${userDataDir}`,
        // Surfaces webview renderer console output (CSP violations,
        // resource failures, JS errors) in the harness log.
        '--enable-logging',
      ],
    });
  } finally {
    fs.rmSync(profileRoot, {recursive: true, force: true});
  }
}

main().catch((error) => {
  console.error('[coverage-treemap-test] failed');
  console.error(error);
  process.exitCode = 1;
});

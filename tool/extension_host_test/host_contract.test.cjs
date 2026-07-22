'use strict';

const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {
  verifyHostContractEvidence,
  verifyHostContractEvidenceFiles,
  verifyHostContractSourceFiles,
} = require('./host_contract.cjs');

const contractId = 'checkpoint4ExtensionHost';
const contract = {
  schemaVersion: 1,
  id: contractId,
  boundary: 'vscodeExtensionHost',
  attributedBindings: ['binding:a', 'binding:b'],
};
const canonicalArtifactPath = path.resolve(
  __dirname,
  '../bindings/contracts/checkpoint4-extension-host.json',
);
const canonicalSourcePaths = Object.fromEntries(
  Object.entries(JSON.parse(
    fs.readFileSync(canonicalArtifactPath, 'utf8'),
  ).sources).map(([sourceId, receipt]) => [sourceId, receipt.path]),
);

function sha256(bytes) {
  return crypto.createHash('sha256').update(bytes).digest('hex');
}

function createCanonicalRepository() {
  const repositoryRoot = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-host-source-test-'),
  );
  const sources = {};
  for (const [sourceId, sourcePath] of Object.entries(canonicalSourcePaths)) {
    const sourceBytes = `${sourceId}\n`;
    const sourceFile = path.join(repositoryRoot, ...sourcePath.split('/'));
    fs.mkdirSync(path.dirname(sourceFile), {recursive: true});
    fs.writeFileSync(sourceFile, sourceBytes);
    sources[sourceId] = {path: sourcePath, sha256: sha256(sourceBytes)};
  }
  return {repositoryRoot, contract: {...contract, sources}};
}

test('Host Contract source receipts reject a canonical source rebound', () => {
  const repositoryRoot = path.resolve(__dirname, '../..');
  const artifact = JSON.parse(fs.readFileSync(path.join(
    repositoryRoot,
    'tool',
    'bindings',
    'contracts',
    'checkpoint4-extension-host.json',
  ), 'utf8'));
  for (const receipt of Object.values(artifact.sources)) {
    receipt.sha256 = crypto
      .createHash('sha256')
      .update(fs.readFileSync(path.join(repositoryRoot, receipt.path)))
      .digest('hex');
  }
  artifact.sources.bindingGenerator = {...artifact.sources.viewLibrary};

  assert.throws(
    () => verifyHostContractSourceFiles({
      contractId,
      contract: artifact,
      repositoryRoot,
    }),
    /source bindingGenerator path must be tool\/binding_generator\/generator\.dart; found lib\/view\.dart/,
  );
});

test('Host Contract source receipts reject a missing source', () => {
  const fixture = createCanonicalRepository();
  const runner = fixture.contract.sources.runner;
  fs.rmSync(path.join(fixture.repositoryRoot, runner.path));
  try {
    assert.throws(
      () => verifyHostContractSourceFiles({
        contractId,
        contract: fixture.contract,
        repositoryRoot: fixture.repositoryRoot,
      }),
      /source runner is missing: scripts\/test_host_extension\.sh/,
    );
  } finally {
    fs.rmSync(fixture.repositoryRoot, {recursive: true, force: true});
  }
});

test('Host Contract source receipts reject changed source bytes', () => {
  const fixture = createCanonicalRepository();
  const runner = fixture.contract.sources.runner;
  try {
    fs.writeFileSync(
      path.join(fixture.repositoryRoot, runner.path),
      'changed\n',
    );
    assert.throws(
      () => verifyHostContractSourceFiles({
        contractId,
        contract: fixture.contract,
        repositoryRoot: fixture.repositoryRoot,
      }),
      /source runner SHA-256 mismatch: scripts\/test_host_extension\.sh/,
    );
  } finally {
    fs.rmSync(fixture.repositoryRoot, {recursive: true, force: true});
  }
});

test('Host Contract source receipts reject paths outside the repository', () => {
  const fixture = createCanonicalRepository();
  fixture.contract.sources.runner = {
    path: '../outside.cjs',
    sha256: sha256('trusted source\n'),
  };
  try {
    assert.throws(
      () => verifyHostContractSourceFiles({
        contractId,
        contract: fixture.contract,
        repositoryRoot: fixture.repositoryRoot,
      }),
      /source runner path must be scripts\/test_host_extension\.sh; found \.\.\/outside\.cjs/,
    );
  } finally {
    fs.rmSync(fixture.repositoryRoot, {recursive: true, force: true});
  }
});

test('launcher verifies source receipts before starting the Extension Host', () => {
  const launcher = fs.readFileSync(path.join(__dirname, 'run.cjs'), 'utf8');
  const preflight = launcher.indexOf('verifyHostContractSourceFiles({');
  const launch = launcher.indexOf('await runTests({');

  assert.notEqual(preflight, -1);
  assert.notEqual(launch, -1);
  assert.ok(preflight < launch);
});

test('real-host evidence must contain every emitted contract binding', () => {
  assert.throws(
    () => verifyHostContractEvidence({
      contractId,
      contract,
      evidence: {
        schemaVersion: 1,
        contract: contractId,
        boundary: 'vscodeExtensionHost',
        observedBindingIds: ['binding:a'],
      },
    }),
    /missing \[binding:b\]/,
  );
});

test('real-host evidence cannot claim an unledgered binding', () => {
  assert.throws(
    () => verifyHostContractEvidence({
      contractId,
      contract,
      evidence: {
        schemaVersion: 1,
        contract: contractId,
        boundary: 'vscodeExtensionHost',
        observedBindingIds: ['binding:a', 'binding:b', 'binding:extra'],
      },
    }),
    /extra \[binding:extra\]/,
  );
});

test('real-host evidence cannot satisfy the ledger with duplicate claims', () => {
  assert.throws(
    () => verifyHostContractEvidence({
      contractId,
      contract,
      evidence: {
        schemaVersion: 1,
        contract: contractId,
        boundary: 'vscodeExtensionHost',
        observedBindingIds: ['binding:a', 'binding:a', 'binding:b'],
      },
    }),
    /duplicate \[binding:a\]/,
  );
});

test('real-host evidence is bound to its schema, contract, and boundary', () => {
  for (const evidence of [
    {
      schemaVersion: 2,
      contract: contractId,
      boundary: 'vscodeExtensionHost',
      observedBindingIds: ['binding:a', 'binding:b'],
    },
    {
      schemaVersion: 1,
      contract: 'someOtherContract',
      boundary: 'vscodeExtensionHost',
      observedBindingIds: ['binding:a', 'binding:b'],
    },
    {
      schemaVersion: 1,
      contract: contractId,
      boundary: 'unitTest',
      observedBindingIds: ['binding:a', 'binding:b'],
    },
  ]) {
    assert.throws(
      () => verifyHostContractEvidence({contractId, contract, evidence}),
      /invalid metadata/,
    );
  }
});

test('launcher-facing verifier reads evidence files and reports exact count', () => {
  const fixture = createCanonicalRepository();
  const contractPath = path.join(fixture.repositoryRoot, 'contract.json');
  const evidencePath = path.join(fixture.repositoryRoot, 'evidence.json');
  try {
    fs.writeFileSync(
      contractPath,
      JSON.stringify(fixture.contract),
    );
    fs.writeFileSync(evidencePath, JSON.stringify({
      schemaVersion: 1,
      contract: contractId,
      boundary: 'vscodeExtensionHost',
      observedBindingIds: ['binding:a', 'binding:b'],
    }));

    assert.deepEqual(
      verifyHostContractEvidenceFiles({
        contractId,
        contractPath,
        evidencePath,
        repositoryRoot: fixture.repositoryRoot,
      }),
      {expectedCount: 2, observedCount: 2},
    );
  } finally {
    fs.rmSync(fixture.repositoryRoot, {recursive: true, force: true});
  }
});

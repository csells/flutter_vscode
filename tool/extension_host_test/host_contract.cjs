'use strict';

const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');

const CANONICAL_SOURCE_PATHS = Object.freeze({
  activationFailureTest:
    'test/fixtures/host_extension/test/activation_failure.cjs',
  bindingGenerator: 'tool/binding_generator/generator.dart',
  bindingWriter: 'tool/binding_generator/writer.dart',
  bootstrapLifecycleTest:
    'tool/extension_host_test/bootstrap_lifecycle.test.cjs',
  buildReceipt: 'lib/src/cli/build_receipt.dart',
  builder: 'scripts/build_host_fixture.sh',
  canonicalInventory: 'tool/bindings/ir/vscode-1.129.1.json',
  canonicalViewProtocol: 'lib/src/view_protocol.dart',
  cli: 'bin/flutter_vscode.dart',
  container: 'tool/extension_host_test/Dockerfile',
  contractWriter: 'tool/binding_generator/contract.dart',
  ecmascriptWhitespace:
    'tool/binding_generator/ecmascript_whitespace.dart',
  evidenceIntegrityTest: 'test/binding_evidence_test.dart',
  fixtureHost: 'test/fixtures/host_extension/host/lib/extension.dart',
  fixtureHostPackage: 'test/fixtures/host_extension/host/pubspec.yaml',
  fixtureHostPackageLock:
    'test/fixtures/host_extension/host/pubspec.lock',
  fixtureManifest: 'test/fixtures/host_extension/package.json',
  fixtureProject: 'test/fixtures/host_extension/extension.json',
  fixtureSharedContract:
    'test/fixtures/host_extension/shared/lib/fixture_view_contract.dart',
  fixtureSharedPackage:
    'test/fixtures/host_extension/shared/pubspec.yaml',
  fixtureTransport:
    'test/fixtures/host_extension/host/lib/generated/flutter_view_host.g.dart',
  fixtureView: 'test/fixtures/host_extension/views/main/lib/main.dart',
  fixtureViewIndex:
    'test/fixtures/host_extension/views/main/web/index.html',
  fixtureViewPackage:
    'test/fixtures/host_extension/views/main/pubspec.yaml',
  fixtureViewPackageLock:
    'test/fixtures/host_extension/views/main/pubspec.lock',
  flutterViewHostTemplate: 'lib/src/cli/flutter_view_host_source.dart',
  frameworkPackage: 'pubspec.yaml',
  frameworkPackageLock: 'pubspec.lock',
  generatedBootstrap: 'test/fixtures/host_extension/host/bootstrap.cjs',
  generatedFacade:
    'test/fixtures/host_extension/host/lib/generated/vscode_facade.g.dart',
  generatedHostExports:
    'test/fixtures/host_extension/host/lib/generated/host_exports.g.dart',
  generatedParity:
    'test/fixtures/host_extension/host/lib/generated/vscode_parity.g.dart',
  generatedParityLayer:
    'test/fixtures/host_extension/host/lib/generated/' +
    'vscode_parity_layer.g.dart',
  generatedRuntime:
    'test/fixtures/host_extension/host/lib/generated/vscode_runtime.g.dart',
  generatedViewProtocol:
    'test/fixtures/host_extension/host/lib/generated/view_protocol.g.dart',
  harnessPackage: 'tool/extension_host_test/package.json',
  harnessPackageLock: 'tool/extension_host_test/package-lock.json',
  hostImportChecker: 'tool/check_host_imports.dart',
  launcher: 'tool/extension_host_test/run.cjs',
  projectDescriptor: 'lib/src/cli/project_descriptor.dart',
  runner: 'scripts/test_host_extension.sh',
  test: 'test/fixtures/host_extension/test/run.cjs',
  verifier: 'tool/extension_host_test/host_contract.cjs',
  verifierTest: 'tool/extension_host_test/host_contract.test.cjs',
  viewLibrary: 'lib/view.dart',
  viewTransport: 'lib/src/view_transport_web.dart',
});

function verifyHostContractSourceFiles({contractId, contract, repositoryRoot}) {
  const sources = contract?.sources;
  if (
    contract?.schemaVersion !== 1 ||
    contract.id !== contractId ||
    contract.boundary !== 'vscodeExtensionHost' ||
    sources === null ||
    typeof sources !== 'object' ||
    Array.isArray(sources) ||
    Object.keys(sources).length === 0
  ) {
    throw new Error(`Host Contract ${contractId} source schema is invalid.`);
  }

  const sourceIds = Object.keys(sources).sort();
  const canonicalSourceIds = Object.keys(CANONICAL_SOURCE_PATHS).sort();
  if (JSON.stringify(sourceIds) !== JSON.stringify(canonicalSourceIds)) {
    throw new Error(
      `Host Contract ${contractId} source keys must be exactly ` +
      `[${canonicalSourceIds.join(', ')}]; found [${sourceIds.join(', ')}].`,
    );
  }

  const realRepositoryRoot = fs.realpathSync(repositoryRoot);
  if (!fs.statSync(realRepositoryRoot).isDirectory()) {
    throw new Error(
      `Host Contract ${contractId} repository root is not a directory.`,
    );
  }

  for (const [sourceId, receipt] of Object.entries(sources)) {
    if (
      receipt === null ||
      typeof receipt !== 'object' ||
      Array.isArray(receipt) ||
      Object.keys(receipt).sort().join(',') !== 'path,sha256' ||
      typeof receipt.path !== 'string' ||
      receipt.path.length === 0 ||
      typeof receipt.sha256 !== 'string' ||
      !/^[0-9a-f]{64}$/.test(receipt.sha256)
    ) {
      throw new Error(
        `Host Contract ${contractId} source ${sourceId} receipt is invalid.`,
      );
    }
    const canonicalPath = CANONICAL_SOURCE_PATHS[sourceId];
    if (receipt.path !== canonicalPath) {
      throw new Error(
        `Host Contract ${contractId} source ${sourceId} path must be ` +
        `${canonicalPath}; found ${receipt.path}.`,
      );
    }
    const segments = receipt.path.split('/');
    if (
      path.posix.isAbsolute(receipt.path) ||
      receipt.path.includes('\\') ||
      path.posix.normalize(receipt.path) !== receipt.path ||
      segments.some((segment) =>
        segment.length === 0 || segment === '.' || segment === '..')
    ) {
      throw new Error(
        `Host Contract ${contractId} source ${sourceId} path escapes ` +
        `repository: ${receipt.path}`,
      );
    }
    const sourcePath = path.resolve(realRepositoryRoot, ...segments);
    const relativeSourcePath = path.relative(realRepositoryRoot, sourcePath);
    if (
      path.isAbsolute(relativeSourcePath) ||
      relativeSourcePath === '..' ||
      relativeSourcePath.startsWith(`..${path.sep}`)
    ) {
      throw new Error(
        `Host Contract ${contractId} source ${sourceId} path escapes ` +
        `repository: ${receipt.path}`,
      );
    }
    if (!fs.existsSync(sourcePath)) {
      throw new Error(
        `Host Contract ${contractId} source ${sourceId} is missing: ` +
        receipt.path,
      );
    }
    const realSourcePath = fs.realpathSync(sourcePath);
    const relativeRealSourcePath = path.relative(
      realRepositoryRoot,
      realSourcePath,
    );
    if (
      path.isAbsolute(relativeRealSourcePath) ||
      relativeRealSourcePath === '..' ||
      relativeRealSourcePath.startsWith(`..${path.sep}`)
    ) {
      throw new Error(
        `Host Contract ${contractId} source ${sourceId} path escapes ` +
        `repository: ${receipt.path}`,
      );
    }
    if (!fs.statSync(realSourcePath).isFile()) {
      throw new Error(
        `Host Contract ${contractId} source ${sourceId} is not a file: ` +
        receipt.path,
      );
    }
    const actualSha256 = crypto
      .createHash('sha256')
      .update(fs.readFileSync(realSourcePath))
      .digest('hex');
    if (actualSha256 !== receipt.sha256) {
      throw new Error(
        `Host Contract ${contractId} source ${sourceId} SHA-256 mismatch: ` +
        receipt.path,
      );
    }
  }

  return {sourceCount: Object.keys(sources).length};
}

function verifyHostContractEvidence({contractId, contract, evidence}) {
  if (
    contract?.schemaVersion !== 1 ||
    contract.id !== contractId ||
    contract.boundary !== 'vscodeExtensionHost' ||
    !Array.isArray(contract.attributedBindings) ||
    contract.attributedBindings.some((id) => typeof id !== 'string') ||
    new Set(contract.attributedBindings).size !==
      contract.attributedBindings.length
  ) {
    throw new Error(`Host Contract ${contractId} artifact is invalid.`);
  }
  if (
    evidence?.schemaVersion !== 1 ||
    evidence.contract !== contractId ||
    evidence.boundary !== 'vscodeExtensionHost' ||
    !Array.isArray(evidence.observedBindingIds) ||
    evidence.observedBindingIds.some((id) => typeof id !== 'string')
  ) {
    throw new Error(
      `Host Contract ${contractId} evidence has invalid metadata.`,
    );
  }
  const expected = [...contract.attributedBindings].sort();
  const observed = [...evidence.observedBindingIds].sort();
  const expectedSet = new Set(expected);
  const observedSet = new Set(observed);
  const missing = expected.filter((id) => !observedSet.has(id));
  const extra = observed.filter((id) => !expectedSet.has(id));
  const duplicate = observed.filter(
    (id, index) => index > 0 && observed[index - 1] === id,
  );

  if (missing.length > 0 || extra.length > 0 || duplicate.length > 0) {
    throw new Error(
      `Host Contract ${contractId} evidence mismatch: ` +
      `missing [${missing.join(', ')}]; extra [${extra.join(', ')}]; ` +
      `duplicate [${duplicate.join(', ')}]`,
    );
  }

  return {expectedCount: expected.length, observedCount: observed.length};
}

function verifyHostContractEvidenceFiles({
  contractId,
  contractPath,
  evidencePath,
  repositoryRoot,
}) {
  const contract = JSON.parse(fs.readFileSync(contractPath, 'utf8'));
  const evidence = JSON.parse(fs.readFileSync(evidencePath, 'utf8'));
  verifyHostContractSourceFiles({contractId, contract, repositoryRoot});
  return verifyHostContractEvidence({contractId, contract, evidence});
}

module.exports = {
  verifyHostContractEvidence,
  verifyHostContractEvidenceFiles,
  verifyHostContractSourceFiles,
};

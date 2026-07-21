const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {verifyPinnedInputs} = require('../src/pins.cjs');

test('checksum mismatch names the input and both hashes', (context) => {
  const directory = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-pins-'),
  );
  context.after(() => fs.rmSync(directory, {recursive: true, force: true}));

  const expected = crypto.createHash('sha256').update('original').digest('hex');
  const actual = crypto.createHash('sha256').update('changed').digest('hex');
  fs.writeFileSync(path.join(directory, 'vscode.d.ts'), 'changed');
  const manifestPath = path.join(directory, 'pins.json');
  fs.writeFileSync(
    manifestPath,
    `${JSON.stringify(
      {
        schemaVersion: 1,
        inputs: [
          {
            name: 'VS Code API declarations',
            kind: 'apiDeclarations',
            path: 'vscode.d.ts',
            version: '1.129.1',
            commit: 'test-commit',
            source: 'https://example.invalid/vscode.d.ts',
            sha256: expected,
            license: 'MIT',
          },
        ],
      },
      null,
      2,
    )}\n`,
  );

  assert.throws(
    () => verifyPinnedInputs(manifestPath),
    (error) => {
      assert.equal(error.code, 'PIN_CHECKSUM_MISMATCH');
      assert.match(error.message, /VS Code API declarations/);
      assert.match(error.message, new RegExp(expected));
      assert.match(error.message, new RegExp(actual));
      return true;
    },
  );
});

test('missing pin provenance fails before importing an input', (context) => {
  const directory = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-pin-metadata-'),
  );
  context.after(() => fs.rmSync(directory, {recursive: true, force: true}));
  const contents = 'pinned';
  const sha256 = crypto.createHash('sha256').update(contents).digest('hex');
  fs.writeFileSync(path.join(directory, 'vscode.d.ts'), contents);
  const manifestPath = path.join(directory, 'pins.json');
  fs.writeFileSync(
    manifestPath,
    `${JSON.stringify(
      {
        schemaVersion: 1,
        inputs: [
          {
            name: 'VS Code API declarations',
            kind: 'apiDeclarations',
            path: 'vscode.d.ts',
            version: '1.129.1',
            commit: 'test-commit',
            source: 'https://example.invalid/vscode.d.ts',
            sha256,
          },
        ],
      },
      null,
      2,
    )}\n`,
  );

  assert.throws(
    () => verifyPinnedInputs(manifestPath),
    (error) => {
      assert.equal(error.code, 'PIN_METADATA_INVALID');
      assert.match(error.message, /inputs\[0\]\.license/);
      return true;
    },
  );
});

test('unknown pinned input kinds fail closed', (context) => {
  const directory = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-pin-kind-'),
  );
  context.after(() => fs.rmSync(directory, {recursive: true, force: true}));
  const contents = 'pinned';
  const sha256 = crypto.createHash('sha256').update(contents).digest('hex');
  fs.writeFileSync(path.join(directory, 'future.schema.json'), contents);
  const manifestPath = path.join(directory, 'pins.json');
  fs.writeFileSync(
    manifestPath,
    `${JSON.stringify(
      {
        schemaVersion: 1,
        inputs: [
          {
            name: 'Future schema',
            kind: 'futureSchemaKind',
            path: 'future.schema.json',
            version: '1.129.1',
            commit: 'test-commit',
            source: 'https://example.invalid/future.schema.json',
            sha256,
            license: 'MIT',
          },
        ],
      },
      null,
      2,
    )}\n`,
  );

  assert.throws(
    () => verifyPinnedInputs(manifestPath),
    (error) => {
      assert.equal(error.code, 'PIN_METADATA_INVALID');
      assert.match(error.message, /inputs\[0\]\.kind/);
      assert.match(error.message, /futureSchemaKind/);
      return true;
    },
  );
});

test('repository VS Code inputs match their recorded checksums', () => {
  const manifestPath = path.resolve(
    __dirname,
    '..',
    '..',
    'bindings',
    'inputs',
    'vscode',
    '1.129.1',
    'pins.json',
  );

  assert.doesNotThrow(() => verifyPinnedInputs(manifestPath));

  const pins = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  const commands = pins.inputs.find(
    (input) => input.kind === 'contributionSchemaSource',
  );
  assert.deepEqual(commands, {
    name: 'VS Code commands contribution schema source',
    kind: 'contributionSchemaSource',
    path: 'menusExtensionPoint.ts',
    version: '1.129.1',
    commit: '8a7abeba6e03ea3af87bfbce9a1b7e48fed567b8',
    source:
      'https://raw.githubusercontent.com/microsoft/vscode/' +
      '8a7abeba6e03ea3af87bfbce9a1b7e48fed567b8/src/vs/workbench/' +
      'services/actions/common/menusExtensionPoint.ts',
    sha256:
      'a85c943ae42b2cdef0403070f78cfb9dbe7bcdc1fce7c57bf9ca2234d1e36a33',
    license: 'MIT',
    licensePath: 'LICENSE.txt',
  });
  const whitespaceHelper = pins.inputs.find(
    (input) => input.kind === 'contributionValidationHelperSource',
  );
  assert.deepEqual(whitespaceHelper, {
    name: 'VS Code string validation helper source',
    kind: 'contributionValidationHelperSource',
    path: 'strings.ts',
    version: '1.129.1',
    commit: '8a7abeba6e03ea3af87bfbce9a1b7e48fed567b8',
    source:
      'https://raw.githubusercontent.com/microsoft/vscode/' +
      '8a7abeba6e03ea3af87bfbce9a1b7e48fed567b8/src/vs/base/common/' +
      'strings.ts',
    sha256:
      'c65ae37d623cf8a1dd0a5083cbb3f09f3433342accdc220c6bb8076aa12a1eec',
    license: 'MIT',
    licensePath: 'LICENSE.txt',
  });
  assert.deepEqual(pins.contributionSchemas, ['commands']);
});

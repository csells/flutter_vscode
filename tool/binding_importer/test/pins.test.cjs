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
});

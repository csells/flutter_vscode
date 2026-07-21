const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const {spawnSync} = require('node:child_process');
const test = require('node:test');

test('CLI emits byte-identical canonical IR from verified pinned inputs', (context) => {
  const directory = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-ir-'),
  );
  context.after(() => fs.rmSync(directory, {recursive: true, force: true}));
  const pinsPath = path.resolve(
    __dirname,
    '../../bindings/inputs/vscode/1.129.1/pins.json',
  );
  const firstPath = path.join(directory, 'first.json');
  const secondPath = path.join(directory, 'second.json');

  for (const outputPath of [firstPath, secondPath]) {
    const result = spawnSync(
      process.execPath,
      [
        path.resolve(__dirname, '../src/cli.cjs'),
        '--pins',
        pinsPath,
        '--output',
        outputPath,
      ],
      {encoding: 'utf8'},
    );
    assert.equal(result.status, 0, result.stderr);
  }

  const first = fs.readFileSync(firstPath, 'utf8');
  const second = fs.readFileSync(secondPath, 'utf8');
  assert.equal(first, second);
  assert.equal(first.endsWith('\n'), true);
  const ir = JSON.parse(first);
  assert.deepEqual({
    product: ir.source.product,
    parser: ir.source.parser,
    inputSha256: ir.source.inputSha256,
  }, {
    product: {
      name: 'Visual Studio Code',
      version: '1.129.1',
      commit: '8a7abeba6e03ea3af87bfbce9a1b7e48fed567b8',
    },
    parser: {
      name: 'typescript',
      version: '6.0.0-dev.20260416',
    },
    inputSha256:
      'ee11e767c8ab76f6c0de8dc88222796147a6f0bc82f3a1ec644e41b39b52f2cd',
  });
  const pins = JSON.parse(fs.readFileSync(pinsPath, 'utf8'));
  assert.deepEqual(ir.source.inputs, pins.inputs);
  assert.deepEqual(ir.source.manifestSchema, pins.manifestSchema);
  assert.deepEqual(ir.source.contributionSchemas, pins.contributionSchemas);
  assert.deepEqual(ir.manifestSchema, {
    inputSha256:
      'feddc98984b755a95644674910aa8c671e3259f137698c581ec7e2837cb058aa',
    schemaUri: 'vscode://schemas/vscode-extensions',
    standalone: false,
    properties: {
      activationEvents: {type: 'array', items: {type: 'string'}},
      contributes: {type: 'object'},
      displayName: {type: 'string'},
      engines: {
        type: 'object',
        properties: {vscode: {type: 'string'}},
      },
      publisher: {type: 'string'},
    },
  });
  assert.deepEqual(ir.manifestValidator, {
    inputSha256:
      'e8ae92aa491ab138b6f625acbbcbd7c53ff187098066ff13aebb64615202dde1',
  });
  assert.equal(ir.declarations.length, 2979);
});

test('CLI check rejects stale canonical IR with an actionable error', (context) => {
  const directory = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-stale-ir-'),
  );
  context.after(() => fs.rmSync(directory, {recursive: true, force: true}));
  const pinsPath = path.resolve(
    __dirname,
    '../../bindings/inputs/vscode/1.129.1/pins.json',
  );
  const staleIrPath = path.join(directory, 'vscode-1.129.1.json');
  fs.writeFileSync(staleIrPath, '{}\n');

  const result = spawnSync(
    process.execPath,
    [
      path.resolve(__dirname, '../src/cli.cjs'),
      '--pins',
      pinsPath,
      '--check',
      staleIrPath,
    ],
    {encoding: 'utf8'},
  );

  assert.equal(result.status, 1);
  assert.match(result.stderr, /^IR_DRIFT: /);
  assert.match(result.stderr, /does not match freshly generated output/);
  assert.match(result.stderr, /Regenerate it with:/);
  assert.match(result.stderr, /--output/);
  assert.match(result.stderr, new RegExp(escapeRegExp(staleIrPath)));
});

test('repository canonical IR matches freshly imported pinned inputs', () => {
  const pinsPath = path.resolve(
    __dirname,
    '../../bindings/inputs/vscode/1.129.1/pins.json',
  );
  const canonicalIrPath = path.resolve(
    __dirname,
    '../../bindings/ir/vscode-1.129.1.json',
  );

  const result = spawnSync(
    process.execPath,
    [
      path.resolve(__dirname, '../src/cli.cjs'),
      '--pins',
      pinsPath,
      '--check',
      canonicalIrPath,
    ],
    {encoding: 'utf8'},
  );

  assert.equal(result.status, 0, result.stderr);
});

test('CLI fails closed instead of ignoring contribution schemas', (context) => {
  const directory = fs.mkdtempSync(
    path.join(os.tmpdir(), 'flutter-vscode-contribution-schema-'),
  );
  context.after(() => fs.rmSync(directory, {recursive: true, force: true}));
  const sourcePinsPath = path.resolve(
    __dirname,
    '../../bindings/inputs/vscode/1.129.1/pins.json',
  );
  const sourceDirectory = path.dirname(sourcePinsPath);
  const pins = JSON.parse(fs.readFileSync(sourcePinsPath, 'utf8'));
  pins.inputs = pins.inputs.map((input) => ({
    ...input,
    path: path.resolve(sourceDirectory, input.path),
  }));
  pins.contributionSchemas = [{name: 'commands'}];
  const pinsPath = path.join(directory, 'pins.json');
  fs.writeFileSync(pinsPath, `${JSON.stringify(pins, null, 2)}\n`);

  const result = spawnSync(
    process.execPath,
    [
      path.resolve(__dirname, '../src/cli.cjs'),
      '--pins',
      pinsPath,
      '--output',
      path.join(directory, 'inventory.json'),
    ],
    {encoding: 'utf8'},
  );

  assert.equal(result.status, 1);
  assert.match(result.stderr, /^CONTRIBUTION_SCHEMAS_UNSUPPORTED: /);
  assert.match(result.stderr, /commands/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

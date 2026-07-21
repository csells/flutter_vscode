const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');

function verifyPinnedInputs(manifestPath) {
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  const directory = path.dirname(manifestPath);

  if (manifest.schemaVersion !== 1 || !Array.isArray(manifest.inputs)) {
    invalidMetadata('schemaVersion must be 1 and inputs must be an array');
  }

  const requiredFields = [
    'name',
    'kind',
    'path',
    'version',
    'commit',
    'source',
    'sha256',
    'license',
  ];
  const supportedKinds = new Set([
    'apiDeclarations',
    'extensionManifestSchemaSource',
    'extensionManifestValidatorSource',
    'license',
  ]);
  for (const [index, input] of manifest.inputs.entries()) {
    for (const field of requiredFields) {
      if (typeof input?.[field] !== 'string' || input[field].length === 0) {
        invalidMetadata(`inputs[${index}].${field} must be a non-empty string`);
      }
    }
    if (!supportedKinds.has(input.kind)) {
      invalidMetadata(
        `inputs[${index}].kind is unsupported: ${JSON.stringify(input.kind)}`,
      );
    }
    if (!/^[a-f0-9]{64}$/.test(input.sha256)) {
      invalidMetadata(`inputs[${index}].sha256 must be lowercase SHA-256`);
    }
    let source;
    try {
      source = new URL(input.source);
    } catch {
      invalidMetadata(`inputs[${index}].source must be an absolute URL`);
    }
    if (source.protocol !== 'https:') {
      invalidMetadata(`inputs[${index}].source must use HTTPS`);
    }
  }

  for (const input of manifest.inputs) {
    const inputPath = path.resolve(directory, input.path);
    const actual = crypto
      .createHash('sha256')
      .update(fs.readFileSync(inputPath))
      .digest('hex');
    if (actual !== input.sha256) {
      const error = new Error(
        `${input.name} checksum mismatch: expected ${input.sha256}, ` +
          `actual ${actual} (${input.path})`,
      );
      error.code = 'PIN_CHECKSUM_MISMATCH';
      throw error;
    }
  }
}

function invalidMetadata(detail) {
  const error = new Error(`Invalid pin metadata: ${detail}.`);
  error.code = 'PIN_METADATA_INVALID';
  throw error;
}

module.exports = {verifyPinnedInputs};

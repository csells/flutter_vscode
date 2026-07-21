#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');

const ts = require('typescript');

const {importVscodeDeclarations} = require('./importer.cjs');
const {
  extractManifestSchemaProjection,
} = require('./manifest_schema.cjs');
const {verifyPinnedInputs} = require('./pins.cjs');

function main(arguments_) {
  const options = parseArguments(arguments_);
  verifyPinnedInputs(options.pins);

  const pinSet = JSON.parse(fs.readFileSync(options.pins, 'utf8'));
  if (pinSet.parser?.name !== 'typescript' || pinSet.parser.version !== ts.version) {
    throw cliError(
      'PARSER_PIN_MISMATCH',
      `Pinned parser ${pinSet.parser?.name}@${pinSet.parser?.version} does ` +
      `not match typescript@${ts.version}.`,
    );
  }
  if (!Array.isArray(pinSet.contributionSchemas)) {
    throw cliError(
      'PIN_METADATA_INVALID',
      'pins.json contributionSchemas must be an array.',
    );
  }
  if (pinSet.contributionSchemas.length > 0) {
    throw cliError(
      'CONTRIBUTION_SCHEMAS_UNSUPPORTED',
      'The walking slice has no generated contributions, so contribution ' +
        `schemas must remain empty; found ${JSON.stringify(
          pinSet.contributionSchemas,
        )}.`,
    );
  }
  const apiInputs = pinSet.inputs.filter(
    (input) => input.kind === 'apiDeclarations',
  );
  if (apiInputs.length !== 1) {
    throw cliError(
      'API_INPUT_PIN_INVALID',
      `Expected exactly one apiDeclarations input, found ${apiInputs.length}.`,
    );
  }

  const apiInput = apiInputs[0];
  const inputPath = path.resolve(path.dirname(options.pins), apiInput.path);
  const manifestInputs = pinSet.inputs.filter(
    (input) => input.kind === 'extensionManifestSchemaSource',
  );
  if (manifestInputs.length !== 1) {
    throw cliError(
      'MANIFEST_INPUT_PIN_INVALID',
      'Expected exactly one extensionManifestSchemaSource input, found ' +
        `${manifestInputs.length}.`,
    );
  }
  const manifestInputPath = path.resolve(
    path.dirname(options.pins),
    manifestInputs[0].path,
  );
  const manifestValidatorInputs = pinSet.inputs.filter(
    (input) => input.kind === 'extensionManifestValidatorSource',
  );
  if (manifestValidatorInputs.length !== 1) {
    throw cliError(
      'MANIFEST_VALIDATOR_INPUT_PIN_INVALID',
      'Expected exactly one extensionManifestValidatorSource input, found ' +
        `${manifestValidatorInputs.length}.`,
    );
  }
  const inventory = importVscodeDeclarations(
    fs.readFileSync(inputPath, 'utf8'),
    inputPath,
  );
  const output = {
    schemaVersion: inventory.schemaVersion,
    source: {
      product: pinSet.product,
      parser: pinSet.parser,
      inputSha256: apiInput.sha256,
      manifestSchema: pinSet.manifestSchema,
      inputs: pinSet.inputs,
      contributionSchemas: pinSet.contributionSchemas,
    },
    manifestSchema: {
      inputSha256: manifestInputs[0].sha256,
      ...extractManifestSchemaProjection(
        fs.readFileSync(manifestInputPath, 'utf8'),
        manifestInputPath,
      ),
    },
    manifestValidator: {
      inputSha256: manifestValidatorInputs[0].sha256,
    },
    module: inventory.module,
    declarations: inventory.declarations,
  };

  const serializedOutput = `${JSON.stringify(output, null, 2)}\n`;
  if (options.output !== undefined) {
    fs.mkdirSync(path.dirname(options.output), {recursive: true});
    fs.writeFileSync(options.output, serializedOutput);
    return;
  }

  const checkedInOutput = fs.readFileSync(options.check);
  if (!checkedInOutput.equals(Buffer.from(serializedOutput, 'utf8'))) {
    throw cliError(
      'IR_DRIFT',
      `Checked-in IR ${options.check} does not match freshly generated ` +
        `output. Regenerate it with: node ${JSON.stringify(__filename)} ` +
        `--pins ${JSON.stringify(options.pins)} --output ` +
        JSON.stringify(options.check),
    );
  }
}

function parseArguments(arguments_) {
  const options = {};
  for (let index = 0; index < arguments_.length; index += 2) {
    const name = arguments_[index];
    const value = arguments_[index + 1];
    if (
      (name !== '--pins' && name !== '--output' && name !== '--check') ||
      value === undefined
    ) {
      throw cliError('INVALID_ARGUMENTS', usage());
    }
    const key = name.slice(2);
    if (options[key] !== undefined) {
      throw cliError('INVALID_ARGUMENTS', `Duplicate argument ${name}.`);
    }
    options[key] = path.resolve(value);
  }
  const destinationCount =
    Number(options.output !== undefined) + Number(options.check !== undefined);
  if (!options.pins || destinationCount !== 1) {
    throw cliError('INVALID_ARGUMENTS', usage());
  }
  return options;
}

function usage() {
  return (
    'Usage: cli.cjs --pins <pins.json> ' +
    '(--output <inventory.json> | --check <inventory.json>)'
  );
}

function cliError(code, message) {
  const error = new Error(message);
  error.code = code;
  return error;
}

try {
  main(process.argv.slice(2));
} catch (error) {
  console.error(`${error.code ?? 'IMPORT_FAILED'}: ${error.message}`);
  process.exitCode = 1;
}

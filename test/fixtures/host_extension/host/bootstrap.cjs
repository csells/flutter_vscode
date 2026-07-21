'use strict';

const crypto = require('node:crypto');
const manifest = require('../package.json');
const vscode = require('vscode');

process.setSourceMapsEnabled?.(true);
globalThis.self ??= globalThis;
const namespace = (globalThis.__flutterVscode ??= Object.create(null));
namespace.hosts ??= Object.create(null);
namespace.apis ??= Object.create(null);
const extensionId = `${manifest.publisher}.${manifest.name}`;
const extensionKey = `e_${crypto
  .createHash('sha256')
  .update(extensionId)
  .digest('hex')}`;
namespace.apis[extensionKey] = vscode;

require('../out/extension.dart.js');

const host = namespace.hosts[extensionKey];
if (!host) {
  throw new Error('Dart host did not register its lifecycle exports.');
}

const failActivation =
  process.env.FLUTTER_VSCODE_HOST_TEST_FAIL_ACTIVATION === '1';

exports.activate = (context) =>
  host.activate(context, vscode, failActivation);
exports.deactivate = () => host.deactivate();

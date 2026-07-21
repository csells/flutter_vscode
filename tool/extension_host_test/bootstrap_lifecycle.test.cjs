const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const Module = require('node:module');
const path = require('node:path');
const test = require('node:test');

const repositoryRoot = path.resolve(__dirname, '../..');
const fixtureRoot = path.join(
  repositoryRoot,
  'test',
  'fixtures',
  'host_extension',
);
const bootstrapPath = path.join(fixtureRoot, 'out', 'bootstrap.cjs');
const dartBundlePath = path.join(fixtureRoot, 'out', 'extension.dart.js');
const extensionId = 'flutter-vscode-test.host-extension-fixture';
const extensionKey = `e_${crypto
  .createHash('sha256')
  .update(extensionId)
  .digest('hex')}`;

test('failed activation cleans up Dart-owned subscriptions', async () => {
  let contextDisposals = 0;
  let eventDisposals = 0;
  const disposable = {
    dispose() {
      contextDisposals += 1;
    },
  };
  const fakeVscode = {
    commands: {
      registerCommand(command) {
        if (command === 'flutter-vscode.host-test.openEventCount') {
          throw new Error('injected activation failure');
        }
        return disposable;
      },
    },
    languages: {
      registerHoverProvider() {
        return disposable;
      },
    },
    workspace: {
      onDidOpenTextDocument() {
        return {
          dispose() {
            eventDisposals += 1;
          },
        };
      },
    },
  };
  const context = {subscriptions: []};

  const originalLoad = Module._load;
  const hadSelf = Object.hasOwn(globalThis, 'self');
  const originalSelf = globalThis.self;
  const originalNamespace = globalThis.__flutterVscode;

  Module._load = function load(request, parent, isMain) {
    if (request === 'vscode') {
      return fakeVscode;
    }
    return originalLoad.call(this, request, parent, isMain);
  };

  delete require.cache[bootstrapPath];
  delete require.cache[dartBundlePath];
  delete globalThis.__flutterVscode;

  try {
    const lifecycle = require(bootstrapPath);
    assert.notEqual(
      globalThis.__flutterVscode.hosts[extensionKey],
      undefined,
    );
    assert.notEqual(
      globalThis.__flutterVscode.apis[extensionKey],
      undefined,
    );
    assert.equal(
      globalThis.__flutterVscode.hosts.e_host_extension_fixture,
      undefined,
    );
    await assert.rejects(lifecycle.activate(context), (error) => {
      assert.match(error.message, /injected activation failure/);
      assert.match(error.stack, /extension\.dart/);
      return true;
    });
    assert.equal(eventDisposals, 1);
    assert.equal(contextDisposals, 0);

    await lifecycle.deactivate();
    await lifecycle.deactivate();
    assert.equal(eventDisposals, 1);
    assert.equal(contextDisposals, 0);
  } finally {
    Module._load = originalLoad;
    delete require.cache[bootstrapPath];
    delete require.cache[dartBundlePath];
    if (originalNamespace === undefined) {
      delete globalThis.__flutterVscode;
    } else {
      globalThis.__flutterVscode = originalNamespace;
    }
    if (hadSelf) {
      globalThis.self = originalSelf;
    } else {
      delete globalThis.self;
    }
  }
});

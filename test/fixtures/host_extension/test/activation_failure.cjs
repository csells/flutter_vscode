const assert = require('node:assert/strict');
const vscode = require('vscode');

const extensionId = 'flutter-vscode-test.host-extension-fixture';
const eventCountCommandId = 'flutter-vscode.host-test.openEventCount';

async function run() {
  console.log('[host-test] RED/GREEN: real-host activation failure');

  const extension = vscode.extensions.getExtension(extensionId);
  assert.ok(extension, `Expected VS Code to discover ${extensionId}`);
  assert.equal(extension.isActive, false, 'Fixture activated before the test');

  await assert.rejects(extension.activate(), (error) => {
    assert.match(error.message, /Dart host activation failed intentionally/);
    assert.match(error.stack, /extension\.dart/);
    return true;
  });

  assert.equal(
    await vscode.commands.executeCommand(eventCountCommandId),
    0,
  );
  await vscode.workspace.openTextDocument({
    language: 'plaintext',
    content: 'event after failed activation',
  });
  assert.equal(
    await vscode.commands.executeCommand(eventCountCommandId),
    0,
  );
}

module.exports = {run};

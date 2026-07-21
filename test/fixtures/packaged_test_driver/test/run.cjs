'use strict';

const assert = require('node:assert/strict');
const path = require('node:path');
const vscode = require('vscode');

function isInside(parent, child) {
  const relative = path.relative(path.resolve(parent), path.resolve(child));
  return relative !== '' && !relative.startsWith(`..${path.sep}`) &&
    relative !== '..' && !path.isAbsolute(relative);
}

async function run() {
  console.log('[packaged-host-test] checking installed extension auto-activation');

  const extensionsDir =
    process.env.FLUTTER_VSCODE_PACKAGED_EXTENSIONS_DIR;
  assert.ok(extensionsDir, 'The isolated extensions directory was not passed');
  const targetExtensionId = process.env.FLUTTER_VSCODE_PACKAGED_EXTENSION_ID;
  assert.ok(targetExtensionId, 'The scaffolded extension id was not passed');
  const commandId = process.env.FLUTTER_VSCODE_PACKAGED_COMMAND_ID;
  assert.ok(commandId, 'The scaffolded command id was not passed');
  const commandResult = process.env.FLUTTER_VSCODE_PACKAGED_COMMAND_RESULT;
  assert.ok(commandResult, 'The scaffolded command result was not passed');

  const extension = vscode.extensions.getExtension(targetExtensionId);
  assert.ok(extension, `Expected VS Code to discover ${targetExtensionId}`);
  assert.equal(
    isInside(extensionsDir, extension.extensionPath),
    true,
    `Expected ${extension.extensionPath} to be installed inside ${extensionsDir}`,
  );
  assert.equal(extension.isActive, false, 'Target activated before its command');

  const result = await vscode.commands.executeCommand(commandId);
  assert.equal(
    extension.isActive,
    true,
    'Invoking the contributed command did not auto-activate the target',
  );
  assert.equal(result, commandResult);

  console.log('[packaged-host-test] GREEN: installed Dart hover provider');
  const document = await vscode.workspace.openTextDocument({
    language: 'plaintext',
    content: 'hover target',
  });
  const hovers = await vscode.commands.executeCommand(
    'vscode.executeHoverProvider',
    document.uri,
    new vscode.Position(0, 2),
  );

  assert.equal(hovers.length, 1);
  assert.ok(hovers[0] instanceof vscode.Hover);
  assert.equal(hovers[0].contents.length, 1);
  assert.ok(hovers[0].contents[0] instanceof vscode.MarkdownString);
  assert.equal(hovers[0].contents[0].value, 'Hover from Dart at 0:2');
  assert.deepEqual(hovers[0].range, new vscode.Range(0, 0, 0, 5));

  const viewCommandId =
    process.env.FLUTTER_VSCODE_PACKAGED_VIEW_COMMAND_ID;
  if (viewCommandId) {
    console.log('[packaged-host-test] checking packaged Flutter View v1');
    const viewReport = await vscode.commands.executeCommand(viewCommandId);
    assert.equal(viewReport.renderedValue, 'hello from Host Dart');
    assert.equal(viewReport.closed, true);
    assert.equal(viewReport.viewPendingRequests, 0);
    assert.equal(viewReport.viewSubscriptions, 0);
    assert.equal(viewReport.hostPendingRequests, 0);
    assert.equal(viewReport.hostSubscriptions, 0);
    assert.equal(viewReport.hostPendingSends, 0);

    assert.equal(
      await vscode.commands.executeCommand(commandId),
      commandResult,
      'Host command failed after packaged Flutter View cleanup',
    );
    const hoversAfterView = await vscode.commands.executeCommand(
      'vscode.executeHoverProvider',
      document.uri,
      new vscode.Position(0, 2),
    );
    assert.equal(hoversAfterView.length, 1);
    assert.ok(hoversAfterView[0] instanceof vscode.Hover);
  }
}

module.exports = {run};

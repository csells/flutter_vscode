const assert = require('node:assert/strict');
const vscode = require('vscode');

const extensionId = 'flutter-vscode-test.host-extension-fixture';
const commandId = 'flutter-vscode.host-test.ping';
const eventCountCommandId = 'flutter-vscode.host-test.openEventCount';
const unsubscribeCommandId = 'flutter-vscode.host-test.unsubscribeOpenEvent';
const identityCommandId = 'flutter-vscode.host-test.hoverDocumentMatchedEvent';
const failAsyncCommandId = 'flutter-vscode.host-test.failAsync';
const failSyncCommandId = 'flutter-vscode.host-test.failSync';
const jsPromiseSourceCommandId = 'flutter-vscode.host-test.jsPromiseSource';
const jsPromiseRoundTripCommandId =
  'flutter-vscode.host-test.jsPromiseRoundTrip';
const hoverReceivedCancellationTokenCommandId =
  'flutter-vscode.host-test.hoverReceivedCancellationToken';
const openFlutterViewCommandId =
  'flutter-vscode.host-test.openFlutterView';

async function run() {
  console.log('[host-test] RED/GREEN: activation and Dart command');

  const extension = vscode.extensions.getExtension(extensionId);
  assert.ok(extension, `Expected VS Code to discover ${extensionId}`);
  assert.equal(extension.isActive, false, 'Fixture activated before the test');

  await extension.activate();

  assert.equal(extension.isActive, true, 'Fixture did not activate');
  const result = await vscode.commands.executeCommand(commandId);
  assert.equal(result, 'pong from Dart');

  console.log('[host-test] RED/GREEN: JavaScript promise to Dart future');
  const jsPromiseSource = vscode.commands.registerCommand(
    jsPromiseSourceCommandId,
    async () => 'value from JavaScript Promise',
  );
  try {
    const roundTrip = await vscode.commands.executeCommand(
      jsPromiseRoundTripCommandId,
    );
    assert.equal(
      roundTrip,
      'Dart received: value from JavaScript Promise',
    );
  } finally {
    jsPromiseSource.dispose();
  }

  console.log('[host-test] RED/GREEN: Dart async error');
  await assert.rejects(
    vscode.commands.executeCommand(failAsyncCommandId),
    (error) => {
      assert.match(error.message, /Dart command failed intentionally/);
      assert.match(error.stack, /extension\.dart/);
      return true;
    },
  );

  console.log('[host-test] RED/GREEN: Dart synchronous error');
  await assert.rejects(
    vscode.commands.executeCommand(failSyncCommandId),
    (error) => {
      assert.match(error.message, /Dart synchronous failure/);
      assert.match(error.stack, /extension\.dart/);
      return true;
    },
  );

  console.log('[host-test] RED/GREEN: Dart hover provider');
  const document = await vscode.workspace.openTextDocument({
    language: 'plaintext',
    content: 'hover target',
  });
  const position = new vscode.Position(0, 2);
  const hovers = await vscode.commands.executeCommand(
    'vscode.executeHoverProvider',
    document.uri,
    position,
  );

  assert.equal(hovers.length, 1);
  assert.ok(hovers[0] instanceof vscode.Hover);
  assert.equal(hovers[0].contents.length, 1);
  assert.ok(hovers[0].contents[0] instanceof vscode.MarkdownString);
  assert.equal(hovers[0].contents[0].value, 'Hover from Dart at 0:2');
  assert.deepEqual(hovers[0].range, new vscode.Range(0, 0, 0, 5));
  assert.equal(
    await vscode.commands.executeCommand(
      hoverReceivedCancellationTokenCommandId,
    ),
    true,
  );

  console.log('[host-test] RED/GREEN: native document identity');
  assert.equal(
    await vscode.commands.executeCommand(identityCommandId),
    true,
  );

  console.log('[host-test] RED/GREEN: Dart event unsubscribe');
  assert.equal(
    await vscode.commands.executeCommand(eventCountCommandId),
    1,
  );
  await vscode.commands.executeCommand(unsubscribeCommandId);
  await vscode.workspace.openTextDocument({
    language: 'plaintext',
    content: 'event after unsubscribe',
  });
  assert.equal(
    await vscode.commands.executeCommand(eventCountCommandId),
    1,
  );

  console.log('[host-test] RED/GREEN: optional Flutter View protocol v1');
  const viewReport = await vscode.commands.executeCommand(
    openFlutterViewCommandId,
  );
  assert.equal(viewReport.renderedValue, 'hello from Host Dart');
  assert.equal(viewReport.closed, true);
  assert.equal(viewReport.viewPendingRequests, 0);
  assert.equal(viewReport.viewSubscriptions, 0);
  assert.equal(viewReport.hostPendingRequests, 0);
  assert.equal(viewReport.hostSubscriptions, 0);
  assert.equal(viewReport.hostPendingSends, 0);

  console.log('[host-test] RED/GREEN: host behavior after view cleanup');
  assert.equal(
    await vscode.commands.executeCommand(commandId),
    'pong from Dart',
  );
  const hoversAfterView = await vscode.commands.executeCommand(
    'vscode.executeHoverProvider',
    document.uri,
    position,
  );
  assert.equal(hoversAfterView.length, 1);
  assert.ok(hoversAfterView[0] instanceof vscode.Hover);
}

module.exports = {run};

import * as vscode from 'vscode';

/* eslint-disable @typescript-eslint/no-explicit-any */

/**
 * Resolves a dotted VS Code API path to a callable function.
 *
 * Examples:
 * - `window.showInformationMessage` -> `vscode.window.showInformationMessage`
 * - `workspace.getConfiguration` -> `vscode.workspace.getConfiguration`
 */
function resolveVscodeFn(
  commandId: string,
): ((...args: any[]) => any) | undefined {
  if (commandId.includes('.')) {
    const parts = commandId.split('.');
    let cur: any = vscode as any;
    let parent: any = undefined;
    for (const part of parts) {
      parent = cur;
      cur = cur?.[part];
    }
    if (typeof cur === 'function') {
      return cur.bind(parent);
    }
    return undefined;
  }

  const fn = (vscode.window as any)?.[commandId];
  return typeof fn === 'function' ? fn.bind(vscode.window) : undefined;
}

/**
 * Returns true when [message] should be routed through generic invoke handling.
 */
export function shouldUseInvokeRouting(message: unknown): boolean {
  const command = (message as any)?.command;
  return typeof command === 'string' && command.includes('.');
}

/**
 * Dynamically invokes a VS Code API from a webview message.
 *
 * Expects `{ command, params, requestId? }` where `command` is a dotted API
 * path such as `window.showInputBox`.
 */
export async function handleInvoke(
  message: any,
  webview: vscode.Webview,
): Promise<void> {
  const command = message?.command as string | undefined;
  if (!command) {
    return;
  }

  const params: any[] = message?.params ?? [];
  const requestId: string | undefined = message?.requestId;
  const fn = resolveVscodeFn(command);

  if (!fn) {
    if (requestId) {
      void webview.postMessage({
        requestId,
        error: `Unknown VS Code API: ${command}`,
      });
    }
    return;
  }

  try {
    const result = await fn(...params);
    if (requestId) {
      void webview.postMessage({ requestId, result });
    }
  } catch (error) {
    if (requestId) {
      void webview.postMessage({ requestId, error: String(error) });
    }
  }
}

/**
 * Routes a webview message to generic invoke or generated handlers.
 *
 * Dotted `command` ids use [handleInvoke]. Other ids delegate to the generated
 * `handleCommand` from annotated controllers (legacy undotted commands).
 */
export async function routeWebviewMessage(
  message: unknown,
  webview: vscode.Webview,
  handleCommand: (message: any, webview: vscode.Webview) => Promise<void>,
): Promise<void> {
  if (shouldUseInvokeRouting(message)) {
    await handleInvoke(message, webview);
    return;
  }

  await handleCommand(message, webview);
}

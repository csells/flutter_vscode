import * as vscode from 'vscode';

/* eslint-disable @typescript-eslint/no-explicit-any */

function resolveVscodeFn(commandId: string): ((...args: any[]) => any) | undefined {
  if (commandId.includes('.')) {
    const parts = commandId.split('.');
    let cur: any = vscode as any;
    let parent: any = undefined;
    for (const part of parts) {
      parent = cur;
      cur = cur?.[part];
    }
    if (typeof cur === 'function') return cur.bind(parent);
    return undefined;
  }

  const fn = (vscode.window as any)?.[commandId];
  return typeof fn === 'function' ? fn.bind(vscode.window) : undefined;
}

export async function handleCommand(message: any, webview: vscode.Webview) {
  const command = message?.command;
  const params: any[] = message?.params ?? [];
  const requestId: string | undefined = message?.requestId;

  try {
    switch (command) {
      case 'showInformationMessage': {
        const fn = resolveVscodeFn('showInformationMessage');
        if (!fn) return;
        void fn(params[0]);
        return;
      }

      case 'showInputBox': {
        const fn = resolveVscodeFn('showInputBox');
        if (!fn) return;
        const result = await fn(params[0]);
        if (requestId) {
          void webview.postMessage({ requestId, result });
        }
        return;
      }

      case 'showErrorMessage': {
        const fn = resolveVscodeFn('showErrorMessage');
        if (!fn) return;
        void fn(params[0]);
        return;
      }

      default:
        return;
    }
  } catch (error) {
    if (requestId) {
      void webview.postMessage({ requestId, error: String(error) });
    }
  }
}

import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

import { handleCommand } from '../lib/api_controller.handlers';

export function activate(context: vscode.ExtensionContext) {
    const provider = new FlutterWebviewProvider(context.extensionUri);

    context.subscriptions.push(
        vscode.window.registerWebviewViewProvider(FlutterWebviewProvider.viewType, provider)
    );

    context.subscriptions.push(provider.statusBarItem);
}

class FlutterWebviewProvider implements vscode.WebviewViewProvider {
    public static readonly viewType = 'flutterVSCodeExample.counter';

    public view?: vscode.WebviewView;
    private _statusBarItem: vscode.StatusBarItem;

    constructor(
        private readonly _extensionUri: vscode.Uri,
    ) {
        this._statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
        this._statusBarItem.text = "$(symbol-number) Counter: 0";
        this._statusBarItem.tooltip = "Flutter Counter Value";
        this._statusBarItem.show();
    }

    public get statusBarItem(): vscode.StatusBarItem {
        return this._statusBarItem;
    }

    public resolveWebviewView(
        webviewView: vscode.WebviewView,
        context: vscode.WebviewViewResolveContext,
        _token: vscode.CancellationToken,
    ) {
        this.view = webviewView;

        webviewView.webview.options = {
            enableScripts: true,
            localResourceRoots: [
                vscode.Uri.joinPath(this._extensionUri, 'build', 'web')
            ]
        };

        webviewView.webview.html = this._getHtml(webviewView.webview);

        webviewView.webview.onDidReceiveMessage(async (message) => {
            await handleCommand(message, webviewView.webview);
        });
    }

    private _updateStatusBar(value: number): void {
        this._statusBarItem.text = `$(symbol-number) Counter: ${value}`;
        this._statusBarItem.tooltip = `Flutter Counter Value: ${value}`;
    }

    _getHtml(webview: vscode.Webview): string {
        const webviewUri = webview.asWebviewUri(vscode.Uri.joinPath(this._extensionUri, "build", "web"));
        console.log('webviewUri', webviewUri);

        const indexHtmlPath = path.join(this._extensionUri.fsPath, "build", "web", "index.html");
        let indexHtml = '';
        try {
            indexHtml = fs.readFileSync(indexHtmlPath, 'utf8');
            console.log('Successfully read index.html');
        } catch (error) {
            console.error('Could not read build/web/index.html:', error);
            return `<html><body><h1>Error: Could not load Flutter app</h1><p>build/web/index.html not found</p></body></html>`;
        }

        indexHtml = indexHtml.replace('<base href="/">', `<base href="${webviewUri}/">`);
        console.log('Modified index.html for webview');
        return indexHtml;
    }
}

export function deactivate() {}


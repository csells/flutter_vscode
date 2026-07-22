// GENERATED CODE - DO NOT MODIFY BY HAND.
// VS Code 1.129.1 mechanically reviewed API slice.

import 'dart:js_interop';

/// Selected root namespaces from the native VS Code API object.
extension type VSCode.fromJS(JSObject _) implements JSObject {
  /// Command registration and execution APIs.
  external Commands get commands;

  /// Language feature registration APIs.
  external Languages get languages;

  /// Window and Flutter View panel APIs.
  external Window get window;

  /// Workspace state and event APIs.
  external Workspace get workspace;
}

/// Selected `vscode.commands` operations.
extension type Commands.fromJS(JSObject _) implements JSObject {
  /// Registers [callback] for [command].
  external Disposable registerCommand(
    JSString command,
    JSFunction callback, [
    JSAny? thisArg,
  ]);

  /// Executes [command] and returns its host thenable.
  external Thenable<T> executeCommand<T extends JSAny?>(
    JSString command,
  );
}

/// A host thenable represented by a native JavaScript promise contract.
extension type Thenable<T extends JSAny?>.fromJS(JSPromise<T> _)
    implements JSPromise<T> {}

/// Structural host object that can release its resource.
extension type DisposableLike.fromJS(JSObject _) implements JSObject {
  /// Releases the resource.
  external JSAny? dispose();
}

/// Native VS Code disposable registration.
extension type Disposable.fromJS(JSObject _)
    implements JSObject, DisposableLike {
  /// Releases the registration.
  external JSAny? dispose();
}

/// Native VS Code extension activation context.
extension type ExtensionContext.fromJS(JSObject _) implements JSObject {
  /// Root URI of the installed extension.
  external Uri get extensionUri;

  /// Registrations VS Code disposes with the extension.
  external JSArray<DisposableLike> get subscriptions;
}

/// Selected `vscode.languages` operations.
extension type Languages.fromJS(JSObject _) implements JSObject {
  /// Registers [provider] for the selected documents.
  external Disposable registerHoverProvider(
    JSAny selector,
    HoverProvider provider,
  );
}

/// Native hover provider callback object.
@JS()
extension type HoverProvider._(JSObject _) implements JSObject {
  /// Creates a provider backed by [provideHover].
  external factory HoverProvider({JSFunction provideHover});
}

/// Native VS Code text document whose identity is preserved.
extension type TextDocument.fromJS(JSObject _) implements JSObject {}

/// Native cancellation token supplied to provider callbacks.
extension type CancellationToken.fromJS(JSObject _) implements JSObject {
  /// Whether the host requested cancellation.
  external bool get isCancellationRequested;
}

/// Selected `vscode.workspace` events.
extension type Workspace.fromJS(JSObject _) implements JSObject {
  /// Fires when a text document opens.
  external Event<TextDocument> get onDidOpenTextDocument;
}

/// Selected `vscode.window` operations.
extension type Window.fromJS(JSObject _) implements JSObject {
  /// Creates a native VS Code panel that hosts one Flutter View.
  external WebviewPanel createWebviewPanel(
    JSString viewType,
    JSString title,
    int showOptions, [
    WebviewOptions options,
  ]);
}

/// Reviewed numeric values from VS Code's `ViewColumn` enum.
abstract final class ViewColumn {
  /// The first editor column.
  static const int one = 1;
}

/// Native options passed when a Flutter View panel is created.
@JS()
extension type WebviewOptions._(JSObject _) implements JSObject {
  /// Creates the reviewed options shape used by Flutter Views.
  external factory WebviewOptions({
    bool enableScripts,
    JSArray<Uri> localResourceRoots,
  });
}

/// Callable native VS Code event.
extension type Event<T extends JSAny?>.fromJS(JSFunction _)
    implements JSFunction {
  /// Subscribes [listener] and returns its native disposable.
  Disposable call(
    JSFunction listener, [
    JSAny? thisArgs,
    JSArray<Disposable>? disposables,
  ]) {
    final JSAny? result;
    if (disposables != null) {
      result = _.callAsFunction(null, listener, thisArgs, disposables);
    } else if (thisArgs != null) {
      result = _.callAsFunction(null, listener, thisArgs);
    } else {
      result = _.callAsFunction(null, listener);
    }
    return Disposable.fromJS(result! as JSObject);
  }
}

/// Callable native VS Code event that carries no value.
extension type VoidEvent.fromJS(JSFunction _) implements JSFunction {
  /// Subscribes [listener] and returns its native disposable.
  Disposable call(
    JSFunction listener, [
    JSAny? thisArgs,
    JSArray<Disposable>? disposables,
  ]) {
    final JSAny? result;
    if (disposables != null) {
      result = _.callAsFunction(null, listener, thisArgs, disposables);
    } else if (thisArgs != null) {
      result = _.callAsFunction(null, listener, thisArgs);
    } else {
      result = _.callAsFunction(null, listener);
    }
    return Disposable.fromJS(result! as JSObject);
  }
}

/// Native VS Code zero-based document position.
extension type Position.fromJS(JSObject _) implements JSObject {
  /// Projected numeric host property.
  external int get character;

  /// Projected numeric host property.
  external int get line;


}

/// Native VS Code URI with the reviewed Flutter View operations.
@JS(
  '__flutterVscode.apis.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6.Uri',
)
extension type Uri._(JSObject _) implements JSObject {
  /// Joins one path segment onto [base].
  @JS('joinPath')
  external static Uri joinPath(
    Uri base,
    JSString pathSegment,
  );

  /// Serializes this URI using VS Code's URI implementation.
  @JS('toString')
  // VS Code defines this as a positional boolean parameter.
  // ignore: avoid_positional_boolean_parameters
  external JSString toUriString([bool skipEncoding]);
}

/// Native VS Code panel that hosts one Flutter View.
extension type WebviewPanel.fromJS(JSObject _)
    implements JSObject, DisposableLike {
  /// The panel's web content surface.
  external Webview get webview;

  /// Fires once when the panel is disposed.
  external VoidEvent get onDidDispose;

  /// Closes the panel and releases its resources.
  external JSAny? dispose();
}

/// Native VS Code web content surface for a Flutter View.
extension type Webview.fromJS(JSObject _) implements JSObject {
  /// Current HTML document source.
  external JSString get html;

  /// Replaces the HTML document source.
  external set html(JSString value);

  /// Source allowed by VS Code's content security policy.
  external JSString get cspSource;

  /// Converts an extension resource URI into a panel-safe URI.
  external Uri asWebviewUri(Uri localResource);

  /// Posts [message] to the Flutter View runtime.
  external Thenable<JSBoolean> postMessage(JSAny? message);

  /// Fires when the Flutter View posts a message to Host Dart.
  external Event<JSAny?> get onDidReceiveMessage;
}

/// Native VS Code markdown content.
@JS(
  '__flutterVscode.apis.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6.MarkdownString',
)
extension type MarkdownString._(JSObject _) implements JSObject {
  /// Creates markdown initialized with [value].
  external factory MarkdownString([JSString value]);
}

/// Native VS Code range between two numeric coordinates.
@JS(
  '__flutterVscode.apis.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6.Range',
)
extension type Range._(JSObject _) implements JSObject {
  /// Creates a range from zero-based start and end coordinates.
  external factory Range(
    int startLine,
    int startCharacter,
    int endLine,
    int endCharacter,
  );
}

/// Native VS Code hover result.
@JS(
  '__flutterVscode.apis.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6.Hover',
)
extension type Hover._(JSObject _) implements JSObject {
  /// Creates a hover with [contents] and an optional [range].
  external factory Hover(MarkdownString contents, [Range range]);
}

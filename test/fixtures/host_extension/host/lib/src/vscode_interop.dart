// The Checkpoint 1 interop kernel is private fixture scaffolding even though
// cross-library Dart names must remain public until generated code replaces it.
// ignore_for_file: public_member_api_docs

import 'dart:js_interop';

extension type VSCode.fromJS(JSObject _) implements JSObject {
  external Commands get commands;
  external Languages get languages;
  external Workspace get workspace;
}

extension type Commands.fromJS(JSObject _) implements JSObject {
  external Disposable registerCommand(JSString command, JSFunction callback);
  external JSPromise<JSAny?> executeCommand(JSString command);
}

extension type Disposable.fromJS(JSObject _) implements JSObject {
  external void dispose();
}

extension type ExtensionContext.fromJS(JSObject _) implements JSObject {
  external JSArray<Disposable> get subscriptions;
}

extension type Languages.fromJS(JSObject _) implements JSObject {
  external Disposable registerHoverProvider(
    JSString selector,
    HoverProvider provider,
  );
}

@JS()
extension type HoverProvider._(JSObject _) implements JSObject {
  external factory HoverProvider({JSFunction provideHover});
}

extension type TextDocument.fromJS(JSObject _) implements JSObject {}

extension type CancellationToken.fromJS(JSObject _) implements JSObject {
  external bool get isCancellationRequested;
}

extension type Workspace.fromJS(JSObject _) implements JSObject {
  external Disposable onDidOpenTextDocument(JSFunction listener);
}

extension type Position.fromJS(JSObject _) implements JSObject {
  external int get line;
  external int get character;
}

@JS(
  '__flutterVscode.apis.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6.MarkdownString',
)
extension type MarkdownString._(JSObject _) implements JSObject {
  external factory MarkdownString([JSString value]);
}

@JS(
  '__flutterVscode.apis.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6.Range',
)
extension type Range._(JSObject _) implements JSObject {
  external factory Range(
    int startLine,
    int startCharacter,
    int endLine,
    int endCharacter,
  );
}

@JS(
  '__flutterVscode.apis.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6.Hover',
)
extension type Hover._(JSObject _) implements JSObject {
  external factory Hover(MarkdownString contents, [Range range]);
}

@JS('Error')
extension type JavaScriptError._(JSObject _) implements JSObject {
  external factory JavaScriptError(JSString message);

  external JSString get stack;
  external set stack(JSString value);
}

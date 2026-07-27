import 'dart:js_interop';

import 'package:pubspec_lens_host/generated/host_exports.g.dart';
// The complete typed VS Code API generated into this project. Wrap the
// raw activation module with VscodeApi(rawVscode), or enter the
// Dart-first ergonomics layer over it with VscodeApi(rawVscode).dart.
import 'package:pubspec_lens_host/generated/vscode_dart_layer.g.dart';
// Runtime helpers: toHostPromise, toHostCallback, hostFetch.
import 'package:pubspec_lens_host/generated/vscode_runtime.g.dart';
import 'package:pubspec_lens_shared/shared.dart';

const _helloCommand = 'pubspec-lens.hello';

@JSExport()
class _Extension {
  JSPromise<JSAny?> activate(
    JSObject rawContext,
    JSObject rawVscode,
  ) {
    final context = ExtensionContext(rawContext);
    final vscode = VscodeApi(rawVscode);

    final hello = (() => helloMessage.toJS).toJS;
    context.subscriptions.toDart.add(
      JSAnon_ffa2e03c40a2(
        vscode.commands.registerCommand(_helloCommand, toHostCallback(hello)),
      ),
    );

    final provideHover =
        (
              TextDocument document,
              Position position,
              CancellationToken token,
            ) {
              final contents = vscode.MarkdownString.new$(
                'Hover from Dart at '
                        '${position.line.toInt()}:'
                        '${position.character.toInt()}'
                    .toJS,
              );
              final range =
                  vscode.Range.new$$2(0.toJS, 0.toJS, 0.toJS, 5.toJS);
              return vscode.Hover.new$(contents, range);
            }
            .toJS;
    final provider = HoverProvider.lit$(
      provideHover: toHostCallback(provideHover),
    );
    context.subscriptions.toDart.add(
      JSAnon_ffa2e03c40a2(
        vscode.languages.registerHoverProvider('json'.toJS, provider),
      ),
    );
    return Future<JSAny?>.value(null).toJS;
  }

  JSPromise<JSAny?> deactivate() => Future<JSAny?>.value(null).toJS;
}

void main() {
  registerHostExports(createJSInteropWrapper(_Extension()));
}

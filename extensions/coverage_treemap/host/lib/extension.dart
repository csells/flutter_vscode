import 'dart:js_interop';

import 'package:coverage_treemap_host/generated/vscode_facade.g.dart';
// The complete typed VS Code API is also generated into this project:
//   import 'package:coverage_treemap_host/generated/vscode_parity_layer.g.dart';
// Wrap the raw activation module with VscodeApi(rawVscode) to use it.
import 'package:coverage_treemap_shared/shared.dart';

const _helloCommand = 'coverage-treemap.hello';

@JSExport()
class _Extension {
  JSPromise<JSAny?> activate(
    JSObject rawContext,
    JSObject rawVscode,
  ) {
    final context = ExtensionContext.fromJS(rawContext);
    final vscode = VSCode.fromJS(rawVscode);

    final hello = (() => helloMessage.toJS).toJS;
    context.subscriptions.toDart.add(
      vscode.commands.registerCommandCallback(_helloCommand.toJS, hello),
    );

    final provideHover =
        (
              TextDocument document,
              Position position,
              CancellationToken token,
            ) {
              final contents = MarkdownString(
                'Hover from Dart at ${position.line}:${position.character}'
                    .toJS,
              );
              return Hover(contents, Range(0, 0, 0, 5));
            }
            .toJS;
    final provider = HoverProvider(provideHover: provideHover);
    context.subscriptions.toDart.add(
      vscode.languages.registerHoverProvider('json'.toJS, provider),
    );
    return Future<JSAny?>.value(null).toJS;
  }

  JSPromise<JSAny?> deactivate() => Future<JSAny?>.value(null).toJS;
}

void main() {
  registerHostExports(createJSInteropWrapper(_Extension()));
}

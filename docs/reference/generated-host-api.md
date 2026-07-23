# Generated Host API

New Extension Projects use direct generated Dart bindings inside VS Code's
Extension Host. Start in `host/lib/extension.dart` and import the idiomatic
facade generated for that project:

```dart
import 'dart:js_interop';

import 'package:my_extension_host/generated/vscode_facade.g.dart';
```

The scaffold demonstrates the supported lifecycle shape. `activate` receives
native extension context and VS Code objects, converts them with `fromJS`, and
places registrations in `context.subscriptions`:

```dart
@JSExport()
class _Extension {
  JSPromise<JSAny?> activate(JSObject rawContext, JSObject rawVscode) {
    final context = ExtensionContext.fromJS(rawContext);
    final vscode = VSCode.fromJS(rawVscode);
    final hello = (() => 'Hello from Dart'.toJS).toJS;
    context.subscriptions.toDart.add(
      vscode.commands.registerCommandCallback(
        'my-extension.hello'.toJS,
        hello,
      ),
    );
    return Future<JSAny?>.value(null).toJS;
  }

  JSPromise<JSAny?> deactivate() => Future<JSAny?>.value(null).toJS;
}

void main() => registerHostExports(createJSInteropWrapper(_Extension()));
```

Prefer symbols exported by `vscode_facade.g.dart`; it re-exports the parity and
runtime layers when a lower-level shape is necessary. Keep native VS Code
objects in Host Dart. Only value snapshots and typed operations cross into a
Flutter View.

After `flutter_vscode build`, inspect `coverage.json` for the exact pinned API
slice. A symbol must be marked emitted before an Extension Author uses it. Each
host-attributed entry cites a Host Contract artifact shipped with the framework.
For this slice, one real Extension Host Contract exercises 53 generated binding
IDs after its native behavior checks pass. That means each generated probe ran;
it does not mean the package has 53 independent behavioral contracts. The
artifact keeps the exact IDs and hashes of the executable repository test
sources. If a capability is pending or excluded, extend the framework's pinned
inputs and reviewed Semantic Overrides. Do not add `dynamic`, handwritten
interop, or an inferred binding to an Extension Project.

The older annotation and TypeScript bridge is documented separately in the
[legacy mapping](vscode-api-mapping.md) and does not describe new projects.

## The complete typed Parity Layer

Beside the facade, `flutter_vscode build` generates
`host/lib/generated/vscode_parity_layer.g.dart` (also exported from the
package as `package:flutter_vscode/vscode_parity.dart`): a mechanically
complete typed mapping of every public declaration in the pinned VS Code
API (ADR 0012), produced only by Total Mapping Rules and proven against a
live Extension Host by the repository gates.

Use it by wrapping the raw module object your extension receives at
activation:

```dart
final api = parity.VscodeApi(rawVscode);
final uri = api.Uri.file('/tmp/notes.md');
final position = api.Position.new$(0.toJS, 0.toJS);
final registration = api.languages.registerHoverProvider(
  parity.DocumentFilter.lit$(language: 'markdown'.toJS),
  parity.HoverProvider.lit$(provideHover: myProvider.toJS),
);
```

Conventions: classes construct through module-rooted `new$` (statics live
on the same `XCtor` object); enums are `int` typedefs with values on
`api.<EnumName>`; interfaces and anonymous shapes are created with `lit$`
object-literal factories; JS `undefined` and `null` both surface as Dart
`null`; unions are erased to their least upper bound. The facade above
remains the ergonomic path for the reviewed slice; the Parity Layer is
the total one. Coverage accounting: [parity report](parity.md).

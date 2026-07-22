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

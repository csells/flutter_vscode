/// The embedded source templates rendered by the binding generator.
///
/// Each function renders one generated runtime artifact from the
/// values the generator resolves out of the reviewed inventory
/// selection. The generated API surface itself is the single
/// dart-layer artifact emitted by `dart_layer.dart`.
library;

/// Renders the generated `host_exports.g.dart` module.
String hostExportsTemplate({
  required String dartExtensionId,
  required String extensionKey,
}) {
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:js_interop';

/// Fully qualified extension identifier used by the generated host.
// The JSON encoder deliberately emits a double-quoted, escaped Dart literal.
// ignore: prefer_single_quotes
const generatedExtensionId = $dartExtensionId;

/// Collision-resistant key used for this extension's JavaScript globals.
const generatedExtensionKey =
    '$extensionKey';

@JS(
  '__flutterVscode.hosts.$extensionKey',
)
external set _hostExports(JSObject value);

/// Publishes the Dart lifecycle object for the CommonJS bootstrap.
void registerHostExports(JSObject value) {
  _hostExports = value;
}
''';
}

/// Renders the generated CommonJS bootstrap, `host/bootstrap.cjs`.
String bootstrapTemplate({
  required String javaScriptExtensionKey,
}) {
  return '''
'use strict';

const crypto = require('node:crypto');
const fs = require('node:fs');
const manifest = require('../package.json');
const moduleApi = require('node:module');
const path = require('node:path');
const vscode = require('vscode');

process.setSourceMapsEnabled?.(true);
globalThis.self ??= globalThis;
const namespace = (globalThis.__flutterVscode ??= Object.create(null));
namespace.hosts ??= Object.create(null);
namespace.apis ??= Object.create(null);
namespace.callbackWrappers ??= Object.create(null);
namespace.stackMappers ??= Object.create(null);
const extensionId = `\${manifest.publisher}.\${manifest.name}`;
const extensionKey = `e_\${crypto
  .createHash('sha256')
  .update(extensionId)
  .digest('hex')}`;
const emittedExtensionKey = $javaScriptExtensionKey;
if (extensionKey !== emittedExtensionKey) {
  throw new Error('Generated Dart and manifest extension identities differ.');
}
namespace.apis[extensionKey] = vscode;

const hostBundlePath = path.resolve(__dirname, '../out/extension.dart.js');
const hostSourceMap = new moduleApi.SourceMap(
  JSON.parse(fs.readFileSync(`\${hostBundlePath}.map`, 'utf8')),
);
const mapHostStack = (stack) => stack.replace(
  /[^\\s()]*extension\\.dart\\.js:(\\d+):(\\d+)/g,
  (location, line, column) => {
    const entry = hostSourceMap.findEntry(
      Number(line) - 1,
      Number(column) - 1,
    );
    if (entry.originalSource === undefined) {
      return location;
    }
    const source = entry.originalSource.replace(/^(\\.\\.\\/)+/, '');
    return `\${source}:\${entry.originalLine + 1}:\${entry.originalColumn + 1}`;
  },
);
namespace.stackMappers[extensionKey] = mapHostStack;
namespace.callbackWrappers[extensionKey] = (callback) => function (...args) {
  try {
    return Reflect.apply(callback, this, args);
  } catch (error) {
    if (error && typeof error.stack === 'string') {
      error.stack = mapHostStack(error.stack);
    }
    throw error;
  }
};

require('../out/extension.dart.js');

const host = namespace.hosts[extensionKey];
if (!host) {
  throw new Error('Dart host did not register its lifecycle exports.');
}

let devReloadWatcher;
const startDevReload = (context) => {
  if (devReloadWatcher) {
    return;
  }
  const bundlePath = path.join(__dirname, '..', 'out', 'extension.dart.js');
  let debounce;
  devReloadWatcher = fs.watch(path.dirname(bundlePath), (_event, filename) => {
    if (filename !== path.basename(bundlePath)) {
      return;
    }
    clearTimeout(debounce);
    debounce = setTimeout(() => {
      vscode.commands.executeCommand('workbench.action.reloadWindow');
    }, 150);
  });
  context.subscriptions.push({
    dispose() {
      clearTimeout(debounce);
      try {
        devReloadWatcher.close();
      } catch {
        // The watcher may already be gone during host shutdown.
      }
      devReloadWatcher = undefined;
    },
  });
};

exports.activate = async (context) => {
  if (
    vscode.ExtensionMode &&
    context.extensionMode === vscode.ExtensionMode.Development
  ) {
    startDevReload(context);
  }
  const firstActivationSubscription = context.subscriptions.length;
  try {
    return await host.activate(context, vscode);
  } catch (error) {
    const registrations = context.subscriptions.splice(
      firstActivationSubscription,
    );
    for (const registration of registrations.reverse()) {
      try {
        await registration.dispose();
      } catch {
        // Preserve the activation failure after attempting every rollback.
      }
    }
    throw error;
  }
};
exports.deactivate = () => host.deactivate();
''';
}

/// Renders the generated runtime module, `vscode_runtime.g.dart`.
String runtimeTemplate(String extensionKey) {
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('__flutterVscode.stackMappers.$extensionKey')
external JSString _mapHostStack(JSString stack);

@JS('__flutterVscode.callbackWrappers.$extensionKey')
external JSFunction _wrapHostCallback(JSFunction callback);
'''
      r'''

/// Native JavaScript error used to preserve Dart failure details.
@JS('Error')
extension type JavaScriptError._(JSObject _) implements JSObject {
  /// Creates an error with [message].
  external factory JavaScriptError(JSString message);

  /// Host-visible stack trace.
  external JSString get stack;

  /// Replaces the host-visible stack trace.
  external set stack(JSString value);
}

/// Creates a native host error whose stack retains mapped Dart source frames.
JavaScriptError toHostError(Object error, StackTrace stackTrace) {
  final hostError = JavaScriptError(error.toString().toJS);
  final stack = '${hostError.stack.toDart}\n$stackTrace';
  hostError.stack = _mapHostStack(stack.toJS);
  return hostError;
}

/// Wraps [callback] so synchronous throws retain mapped Dart source frames.
JSFunction toHostCallback(JSFunction callback) => _wrapHostCallback(callback);

/// One HTTP response snapshot from the Extension Host's global `fetch`.
final class HostFetchResponse {
  /// Creates a response snapshot.
  const HostFetchResponse({required this.status, required this.body});

  /// HTTP status code.
  final int status;

  /// Response body decoded as text.
  final String body;

  /// Whether [status] is in the 2xx range.
  bool get ok => status >= 200 && status < 300;
}

@JS('fetch')
external JSPromise<JSObject> _hostGlobalFetch(JSString url, JSObject init);

/// Performs an HTTP request with the Extension Host's global `fetch`.
///
/// The supported host network path: Node's WHATWG `fetch`, bound by the
/// generated runtime and returned as a protocol-safe snapshot.
Future<HostFetchResponse> hostFetch(
  String url, {
  String method = 'GET',
  Map<String, String> headers = const {},
  String? body,
}) async {
  final init = JSObject()..setProperty('method'.toJS, method.toJS);
  if (headers.isNotEmpty) {
    final headerBag = JSObject();
    for (final entry in headers.entries) {
      headerBag.setProperty(entry.key.toJS, entry.value.toJS);
    }
    init.setProperty('headers'.toJS, headerBag);
  }
  if (body != null) {
    init.setProperty('body'.toJS, body.toJS);
  }
  final response = await _hostGlobalFetch(url.toJS, init).toDart;
  final status =
      (response.getProperty('status'.toJS)! as JSNumber).toDartInt;
  final text =
      await (response.callMethod('text'.toJS)! as JSPromise<JSString>)
          .toDart;
  return HostFetchResponse(status: status, body: text.toDart);
}

/// Converts [future] to a host promise while retaining Dart stack frames.
JSPromise<T> toHostPromise<T extends JSAny?>(Future<T> future) {
  return JSPromise<T>(
    (JSFunction resolve, JSFunction reject) {
      unawaited(
        future.then<void>(
          (value) {
            resolve.callAsFunction(resolve, value);
          },
          onError: (Object error, StackTrace stackTrace) {
            reject.callAsFunction(
              reject,
              toHostError(error, stackTrace),
            );
          },
        ),
      );
    }.toJS,
  );
}
''';
}

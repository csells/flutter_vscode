// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('__flutterVscode.stackMappers.e_fd2880b059dc6684df43c2921c1e75f9b7b263154503300a7223562915d8051f')
external JSString _mapHostStack(JSString stack);

@JS('__flutterVscode.callbackWrappers.e_fd2880b059dc6684df43c2921c1e75f9b7b263154503300a7223562915d8051f')
external JSFunction _wrapHostCallback(JSFunction callback);

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

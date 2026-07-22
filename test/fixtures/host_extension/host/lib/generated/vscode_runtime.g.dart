// GENERATED CODE - DO NOT MODIFY BY HAND.

import 'dart:async';
import 'dart:js_interop';

@JS('__flutterVscode.stackMappers.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6')
external JSString _mapHostStack(JSString stack);

@JS('__flutterVscode.callbackWrappers.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6')
external JSFunction _wrapHostCallback(JSFunction callback);

@JS('__flutterVscode.bindingObservers.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6')
external void _observeHostBinding(JSString bindingId);

@JS('__flutterVscode.bindingCallbackWrappers.e_ded70adb722dcc045c085661384a28efd7439f252df0117d72ecce65644f64f6')
external JSFunction _wrapObservedHostCallback(
  JSFunction callback,
  JSArray<JSString> bindingIds,
);

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

/// Records binding IDs reached through an actual generated host operation.
void observeHostBindings(Iterable<String> bindingIds) {
  for (final bindingId in bindingIds) {
    _observeHostBinding(bindingId.toJS);
  }
}

/// Records [bindingIds] only when the native host invokes [callback].
JSFunction observeHostCallback(
  JSFunction callback,
  List<String> bindingIds,
) =>
    _wrapObservedHostCallback(
      callback,
      bindingIds.map((bindingId) => bindingId.toJS).toList().toJS,
    );

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

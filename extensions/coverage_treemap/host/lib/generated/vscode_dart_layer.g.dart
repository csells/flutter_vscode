// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// The mechanical Dart-ergonomics layer over the VS Code
// Parity Layer (developer-experience D-2), produced only
// by total, judgment-free rules: helper boundaries take
// ordinary String/num/bool, JSPromise returns become
// Futures, Event members gain broadcast Stream accessors
// (onDidX gains onDidXStream), and lit$ factories
// flatten inherited interface members.
// Regenerate with:
//   dart tool/binding_generator/generate.dart --dart-layer .
//
// Enter the layer with VscodeApi(rawVscode).dart; every
// XDart type wraps and implements its parity type X, so
// dart-layer values flow anywhere the parity surface is
// expected. Trailing optional arguments that are null are
// not forwarded (the parity trimming semantics).
// ignore_for_file: type=lint
import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'vscode_parity_layer.g.dart';

extension type JSTuple_171b5687ecdcDart(JSTuple_171b5687ecdc $js) implements JSTuple_171b5687ecdc {
  String get $1 => $js.$1.toDart;
  num get $2 => $js.$2.toDartDouble;
}

extension JSTuple_171b5687ecdcToDart on JSTuple_171b5687ecdc {
  JSTuple_171b5687ecdcDart get dart => JSTuple_171b5687ecdcDart(this);
}

extension type JSTuple_58c6c79a4e36Dart(JSTuple_58c6c79a4e36 $js) implements JSTuple_58c6c79a4e36 {
  String get $1 => $js.$1.toDart;
  String get $2 => $js.$2.toDart;
}

extension JSTuple_58c6c79a4e36ToDart on JSTuple_58c6c79a4e36 {
  JSTuple_58c6c79a4e36Dart get dart => JSTuple_58c6c79a4e36Dart(this);
}

extension type JSTuple_87f74e97d0daDart(JSTuple_87f74e97d0da $js) implements JSTuple_87f74e97d0da {
  num get $2 => $js.$2.toDartDouble;
}

extension JSTuple_87f74e97d0daToDart on JSTuple_87f74e97d0da {
  JSTuple_87f74e97d0daDart get dart => JSTuple_87f74e97d0daDart(this);
}

extension type JSTuple_9b5999d5c048Dart(JSTuple_9b5999d5c048 $js) implements JSTuple_9b5999d5c048 {
  num get $1 => $js.$1.toDartDouble;
  num get $2 => $js.$2.toDartDouble;
}

extension JSTuple_9b5999d5c048ToDart on JSTuple_9b5999d5c048 {
  JSTuple_9b5999d5c048Dart get dart => JSTuple_9b5999d5c048Dart(this);
}

extension type JSAnon_af97be86c0c7Dart(JSAnon_af97be86c0c7 $js) implements JSAnon_af97be86c0c7 {
  factory JSAnon_af97be86c0c7Dart.lit$({JSAny? createIfNone}) {
    final object$ = JSObject();
    if (createIfNone != null) {
      object$.setProperty('createIfNone'.toJS, createIfNone);
    }
    return JSAnon_af97be86c0c7Dart(JSAnon_af97be86c0c7(object$));
  }
}

extension JSAnon_af97be86c0c7ToDart on JSAnon_af97be86c0c7 {
  JSAnon_af97be86c0c7Dart get dart => JSAnon_af97be86c0c7Dart(this);
}

extension type JSAnon_cdd103013c05Dart(JSAnon_cdd103013c05 $js) implements JSAnon_cdd103013c05 {
  factory JSAnon_cdd103013c05Dart.lit$({JSAny? forceNewSession}) {
    final object$ = JSObject();
    if (forceNewSession != null) {
      object$.setProperty('forceNewSession'.toJS, forceNewSession);
    }
    return JSAnon_cdd103013c05Dart(JSAnon_cdd103013c05(object$));
  }
}

extension JSAnon_cdd103013c05ToDart on JSAnon_cdd103013c05 {
  JSAnon_cdd103013c05Dart get dart => JSAnon_cdd103013c05Dart(this);
}

extension type JSAnon_190a3fc62b24Dart(JSAnon_190a3fc62b24 $js) implements JSAnon_190a3fc62b24 {
  factory JSAnon_190a3fc62b24Dart.lit$({JSObject? args, JSAny? comment, String? message}) {
    final object$ = JSObject();
    if (args != null) {
      object$.setProperty('args'.toJS, args);
    }
    if (comment != null) {
      object$.setProperty('comment'.toJS, comment);
    }
    if (message != null) {
      object$.setProperty('message'.toJS, message.toJS);
    }
    return JSAnon_190a3fc62b24Dart(JSAnon_190a3fc62b24(object$));
  }
}

extension JSAnon_190a3fc62b24ToDart on JSAnon_190a3fc62b24 {
  JSAnon_190a3fc62b24Dart get dart => JSAnon_190a3fc62b24Dart(this);
}

extension type JSAnon_0937a16a6355Dart(JSAnon_0937a16a6355 $js) implements JSAnon_0937a16a6355 {
  factory JSAnon_0937a16a6355Dart.lit$({bool? log}) {
    final object$ = JSObject();
    if (log != null) {
      object$.setProperty('log'.toJS, log.toJS);
    }
    return JSAnon_0937a16a6355Dart(JSAnon_0937a16a6355(object$));
  }
}

extension JSAnon_0937a16a6355ToDart on JSAnon_0937a16a6355 {
  JSAnon_0937a16a6355Dart get dart => JSAnon_0937a16a6355Dart(this);
}

extension type JSAnon_fc85cbbeff88Dart(JSAnon_fc85cbbeff88 $js) implements JSAnon_fc85cbbeff88 {
  factory JSAnon_fc85cbbeff88Dart.lit$({bool? preserveFocus, num? viewColumn}) {
    final object$ = JSObject();
    if (preserveFocus != null) {
      object$.setProperty('preserveFocus'.toJS, preserveFocus.toJS);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    return JSAnon_fc85cbbeff88Dart(JSAnon_fc85cbbeff88(object$));
  }
}

extension JSAnon_fc85cbbeff88ToDart on JSAnon_fc85cbbeff88 {
  JSAnon_fc85cbbeff88Dart get dart => JSAnon_fc85cbbeff88Dart(this);
}

extension type JSAnon_544a305acd79Dart(JSAnon_544a305acd79 $js) implements JSAnon_544a305acd79 {
  factory JSAnon_544a305acd79Dart.lit$({bool? supportsMultipleEditorsPerDocument, WebviewPanelOptions? webviewOptions}) {
    final object$ = JSObject();
    if (supportsMultipleEditorsPerDocument != null) {
      object$.setProperty('supportsMultipleEditorsPerDocument'.toJS, supportsMultipleEditorsPerDocument.toJS);
    }
    if (webviewOptions != null) {
      object$.setProperty('webviewOptions'.toJS, webviewOptions);
    }
    return JSAnon_544a305acd79Dart(JSAnon_544a305acd79(object$));
  }
}

extension JSAnon_544a305acd79ToDart on JSAnon_544a305acd79 {
  JSAnon_544a305acd79Dart get dart => JSAnon_544a305acd79Dart(this);
}

extension type JSAnon_202de06b6facDart(JSAnon_202de06b6fac $js) implements JSAnon_202de06b6fac {
  factory JSAnon_202de06b6facDart.lit$({JSAnon_337f2402bc9d? webviewOptions}) {
    final object$ = JSObject();
    if (webviewOptions != null) {
      object$.setProperty('webviewOptions'.toJS, webviewOptions);
    }
    return JSAnon_202de06b6facDart(JSAnon_202de06b6fac(object$));
  }
}

extension JSAnon_202de06b6facToDart on JSAnon_202de06b6fac {
  JSAnon_202de06b6facDart get dart => JSAnon_202de06b6facDart(this);
}

extension type JSAnon_997f9ce7b5dbDart(JSAnon_997f9ce7b5db $js) implements JSAnon_997f9ce7b5db {
  factory JSAnon_997f9ce7b5dbDart.lit$({bool? canPickMany}) {
    final object$ = JSObject();
    if (canPickMany != null) {
      object$.setProperty('canPickMany'.toJS, canPickMany.toJS);
    }
    return JSAnon_997f9ce7b5dbDart(JSAnon_997f9ce7b5db(object$));
  }
}

extension JSAnon_997f9ce7b5dbToDart on JSAnon_997f9ce7b5db {
  JSAnon_997f9ce7b5dbDart get dart => JSAnon_997f9ce7b5dbDart(this);
}

extension type JSAnon_879fda8037dfDart(JSAnon_879fda8037df $js) implements JSAnon_879fda8037df {
  factory JSAnon_879fda8037dfDart.lit$({num? increment, String? message}) {
    final object$ = JSObject();
    if (increment != null) {
      object$.setProperty('increment'.toJS, increment.toJS);
    }
    if (message != null) {
      object$.setProperty('message'.toJS, message.toJS);
    }
    return JSAnon_879fda8037dfDart(JSAnon_879fda8037df(object$));
  }
}

extension JSAnon_879fda8037dfToDart on JSAnon_879fda8037df {
  JSAnon_879fda8037dfDart get dart => JSAnon_879fda8037dfDart(this);
}

extension type JSAnon_bce51fc74910Dart(JSAnon_bce51fc74910 $js) implements JSAnon_bce51fc74910 {
  factory JSAnon_bce51fc74910Dart.lit$({String? encoding}) {
    final object$ = JSObject();
    if (encoding != null) {
      object$.setProperty('encoding'.toJS, encoding.toJS);
    }
    return JSAnon_bce51fc74910Dart(JSAnon_bce51fc74910(object$));
  }
}

extension JSAnon_bce51fc74910ToDart on JSAnon_bce51fc74910 {
  JSAnon_bce51fc74910Dart get dart => JSAnon_bce51fc74910Dart(this);
}

extension type JSAnon_5f13b3458117Dart(JSAnon_5f13b3458117 $js) implements JSAnon_5f13b3458117 {
  factory JSAnon_5f13b3458117Dart.lit$({Uri? uri}) {
    final object$ = JSObject();
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return JSAnon_5f13b3458117Dart(JSAnon_5f13b3458117(object$));
  }
}

extension JSAnon_5f13b3458117ToDart on JSAnon_5f13b3458117 {
  JSAnon_5f13b3458117Dart get dart => JSAnon_5f13b3458117Dart(this);
}

extension type JSAnon_d8666bad7f07Dart(JSAnon_d8666bad7f07 $js) implements JSAnon_d8666bad7f07 {
  factory JSAnon_d8666bad7f07Dart.lit$({String? encoding}) {
    final object$ = JSObject();
    if (encoding != null) {
      object$.setProperty('encoding'.toJS, encoding.toJS);
    }
    return JSAnon_d8666bad7f07Dart(JSAnon_d8666bad7f07(object$));
  }
}

extension JSAnon_d8666bad7f07ToDart on JSAnon_d8666bad7f07 {
  JSAnon_d8666bad7f07Dart get dart => JSAnon_d8666bad7f07Dart(this);
}

extension type JSAnon_46c65550b867Dart(JSAnon_46c65550b867 $js) implements JSAnon_46c65550b867 {
  factory JSAnon_46c65550b867Dart.lit$({String? content, String? encoding, String? language}) {
    final object$ = JSObject();
    if (content != null) {
      object$.setProperty('content'.toJS, content.toJS);
    }
    if (encoding != null) {
      object$.setProperty('encoding'.toJS, encoding.toJS);
    }
    if (language != null) {
      object$.setProperty('language'.toJS, language.toJS);
    }
    return JSAnon_46c65550b867Dart(JSAnon_46c65550b867(object$));
  }
}

extension JSAnon_46c65550b867ToDart on JSAnon_46c65550b867 {
  JSAnon_46c65550b867Dart get dart => JSAnon_46c65550b867Dart(this);
}

extension type JSAnon_3b8881df895eDart(JSAnon_3b8881df895e $js) implements JSAnon_3b8881df895e {
  factory JSAnon_3b8881df895eDart.lit$({bool? isCaseSensitive, JSAny? isReadonly}) {
    final object$ = JSObject();
    if (isCaseSensitive != null) {
      object$.setProperty('isCaseSensitive'.toJS, isCaseSensitive.toJS);
    }
    if (isReadonly != null) {
      object$.setProperty('isReadonly'.toJS, isReadonly);
    }
    return JSAnon_3b8881df895eDart(JSAnon_3b8881df895e(object$));
  }
}

extension JSAnon_3b8881df895eToDart on JSAnon_3b8881df895e {
  JSAnon_3b8881df895eDart get dart => JSAnon_3b8881df895eDart(this);
}

extension type JSAnon_ca4121a2aaf6Dart(JSAnon_ca4121a2aaf6 $js) implements JSAnon_ca4121a2aaf6 {
  factory JSAnon_ca4121a2aaf6Dart.lit$({String? name, Uri? uri}) {
    final object$ = JSObject();
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return JSAnon_ca4121a2aaf6Dart(JSAnon_ca4121a2aaf6(object$));
  }
}

extension JSAnon_ca4121a2aaf6ToDart on JSAnon_ca4121a2aaf6 {
  JSAnon_ca4121a2aaf6Dart get dart => JSAnon_ca4121a2aaf6Dart(this);
}

extension type JSAnon_0a93578cd4a3Dart(JSAnon_0a93578cd4a3 $js) implements JSAnon_0a93578cd4a3 {
  factory JSAnon_0a93578cd4a3Dart.lit$({JSFunction? dispose}) {
    final object$ = JSObject();
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    return JSAnon_0a93578cd4a3Dart(JSAnon_0a93578cd4a3(object$));
  }
}

extension JSAnon_0a93578cd4a3ToDart on JSAnon_0a93578cd4a3 {
  JSAnon_0a93578cd4a3Dart get dart => JSAnon_0a93578cd4a3Dart(this);
}

extension type JSAnon_e0c29a989921Dart(JSAnon_e0c29a989921 $js) implements JSAnon_e0c29a989921 {
  factory JSAnon_e0c29a989921Dart.lit$({TextDocument? document, Range? range}) {
    final object$ = JSObject();
    if (document != null) {
      object$.setProperty('document'.toJS, document);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    return JSAnon_e0c29a989921Dart(JSAnon_e0c29a989921(object$));
  }
}

extension JSAnon_e0c29a989921ToDart on JSAnon_e0c29a989921 {
  JSAnon_e0c29a989921Dart get dart => JSAnon_e0c29a989921Dart(this);
}

extension type JSAnon_b2623fd46fdeDart(JSAnon_b2623fd46fde $js) implements JSAnon_b2623fd46fde {
  factory JSAnon_b2623fd46fdeDart.lit$({bool? overwrite}) {
    final object$ = JSObject();
    if (overwrite != null) {
      object$.setProperty('overwrite'.toJS, overwrite.toJS);
    }
    return JSAnon_b2623fd46fdeDart(JSAnon_b2623fd46fde(object$));
  }
}

extension JSAnon_b2623fd46fdeToDart on JSAnon_b2623fd46fde {
  JSAnon_b2623fd46fdeDart get dart => JSAnon_b2623fd46fdeDart(this);
}

extension type JSAnon_576b1a88ebc3Dart(JSAnon_576b1a88ebc3 $js) implements JSAnon_576b1a88ebc3 {
  factory JSAnon_576b1a88ebc3Dart.lit$({bool? recursive, bool? useTrash}) {
    final object$ = JSObject();
    if (recursive != null) {
      object$.setProperty('recursive'.toJS, recursive.toJS);
    }
    if (useTrash != null) {
      object$.setProperty('useTrash'.toJS, useTrash.toJS);
    }
    return JSAnon_576b1a88ebc3Dart(JSAnon_576b1a88ebc3(object$));
  }
}

extension JSAnon_576b1a88ebc3ToDart on JSAnon_576b1a88ebc3 {
  JSAnon_576b1a88ebc3Dart get dart => JSAnon_576b1a88ebc3Dart(this);
}

extension type JSAnon_f4ceea3f5f6fDart(JSAnon_f4ceea3f5f6f $js) implements JSAnon_f4ceea3f5f6f {
  factory JSAnon_f4ceea3f5f6fDart.lit$({bool? overwrite}) {
    final object$ = JSObject();
    if (overwrite != null) {
      object$.setProperty('overwrite'.toJS, overwrite.toJS);
    }
    return JSAnon_f4ceea3f5f6fDart(JSAnon_f4ceea3f5f6f(object$));
  }
}

extension JSAnon_f4ceea3f5f6fToDart on JSAnon_f4ceea3f5f6f {
  JSAnon_f4ceea3f5f6fDart get dart => JSAnon_f4ceea3f5f6fDart(this);
}

extension type JSAnon_4ae6d0aa1bdfDart(JSAnon_4ae6d0aa1bdf $js) implements JSAnon_4ae6d0aa1bdf {
  factory JSAnon_4ae6d0aa1bdfDart.lit$({bool? recursive}) {
    final object$ = JSObject();
    if (recursive != null) {
      object$.setProperty('recursive'.toJS, recursive.toJS);
    }
    return JSAnon_4ae6d0aa1bdfDart(JSAnon_4ae6d0aa1bdf(object$));
  }
}

extension JSAnon_4ae6d0aa1bdfToDart on JSAnon_4ae6d0aa1bdf {
  JSAnon_4ae6d0aa1bdfDart get dart => JSAnon_4ae6d0aa1bdfDart(this);
}

extension type JSAnon_ce282821cb2aDart(JSAnon_ce282821cb2a $js) implements JSAnon_ce282821cb2a {
  factory JSAnon_ce282821cb2aDart.lit$({JSArray<JSString>? excludes, bool? recursive}) {
    final object$ = JSObject();
    if (excludes != null) {
      object$.setProperty('excludes'.toJS, excludes);
    }
    if (recursive != null) {
      object$.setProperty('recursive'.toJS, recursive.toJS);
    }
    return JSAnon_ce282821cb2aDart(JSAnon_ce282821cb2a(object$));
  }
}

extension JSAnon_ce282821cb2aToDart on JSAnon_ce282821cb2a {
  JSAnon_ce282821cb2aDart get dart => JSAnon_ce282821cb2aDart(this);
}

extension type JSAnon_95947812f514Dart(JSAnon_95947812f514 $js) implements JSAnon_95947812f514 {
  factory JSAnon_95947812f514Dart.lit$({bool? create, bool? overwrite}) {
    final object$ = JSObject();
    if (create != null) {
      object$.setProperty('create'.toJS, create.toJS);
    }
    if (overwrite != null) {
      object$.setProperty('overwrite'.toJS, overwrite.toJS);
    }
    return JSAnon_95947812f514Dart(JSAnon_95947812f514(object$));
  }
}

extension JSAnon_95947812f514ToDart on JSAnon_95947812f514 {
  JSAnon_95947812f514Dart get dart => JSAnon_95947812f514Dart(this);
}

extension type JSAnon_d702e8e12ae8Dart(JSAnon_d702e8e12ae8 $js) implements JSAnon_d702e8e12ae8 {
  factory JSAnon_d702e8e12ae8Dart.lit$({num? end, num? start}) {
    final object$ = JSObject();
    if (end != null) {
      object$.setProperty('end'.toJS, end.toJS);
    }
    if (start != null) {
      object$.setProperty('start'.toJS, start.toJS);
    }
    return JSAnon_d702e8e12ae8Dart(JSAnon_d702e8e12ae8(object$));
  }
}

extension JSAnon_d702e8e12ae8ToDart on JSAnon_d702e8e12ae8 {
  JSAnon_d702e8e12ae8Dart get dart => JSAnon_d702e8e12ae8Dart(this);
}

extension type JSAnon_5687bad38499Dart(JSAnon_5687bad38499 $js) implements JSAnon_5687bad38499 {
  factory JSAnon_5687bad38499Dart.lit$({num? characterDelta, num? lineDelta}) {
    final object$ = JSObject();
    if (characterDelta != null) {
      object$.setProperty('characterDelta'.toJS, characterDelta.toJS);
    }
    if (lineDelta != null) {
      object$.setProperty('lineDelta'.toJS, lineDelta.toJS);
    }
    return JSAnon_5687bad38499Dart(JSAnon_5687bad38499(object$));
  }
}

extension JSAnon_5687bad38499ToDart on JSAnon_5687bad38499 {
  JSAnon_5687bad38499Dart get dart => JSAnon_5687bad38499Dart(this);
}

extension type JSAnon_91ec0d04130cDart(JSAnon_91ec0d04130c $js) implements JSAnon_91ec0d04130c {
  factory JSAnon_91ec0d04130cDart.lit$({num? character, num? line}) {
    final object$ = JSObject();
    if (character != null) {
      object$.setProperty('character'.toJS, character.toJS);
    }
    if (line != null) {
      object$.setProperty('line'.toJS, line.toJS);
    }
    return JSAnon_91ec0d04130cDart(JSAnon_91ec0d04130c(object$));
  }
}

extension JSAnon_91ec0d04130cToDart on JSAnon_91ec0d04130c {
  JSAnon_91ec0d04130cDart get dart => JSAnon_91ec0d04130cDart(this);
}

extension type JSAnon_471b06108965Dart(JSAnon_471b06108965 $js) implements JSAnon_471b06108965 {
  factory JSAnon_471b06108965Dart.lit$({Position? end, Position? start}) {
    final object$ = JSObject();
    if (end != null) {
      object$.setProperty('end'.toJS, end);
    }
    if (start != null) {
      object$.setProperty('start'.toJS, start);
    }
    return JSAnon_471b06108965Dart(JSAnon_471b06108965(object$));
  }
}

extension JSAnon_471b06108965ToDart on JSAnon_471b06108965 {
  JSAnon_471b06108965Dart get dart => JSAnon_471b06108965Dart(this);
}

extension type JSAnon_834452ade499Dart(JSAnon_834452ade499 $js) implements JSAnon_834452ade499 {
  factory JSAnon_834452ade499Dart.lit$({String? placeholder, Range? range}) {
    final object$ = JSObject();
    if (placeholder != null) {
      object$.setProperty('placeholder'.toJS, placeholder.toJS);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    return JSAnon_834452ade499Dart(JSAnon_834452ade499(object$));
  }
}

extension JSAnon_834452ade499ToDart on JSAnon_834452ade499 {
  JSAnon_834452ade499Dart get dart => JSAnon_834452ade499Dart(this);
}

extension type JSAnon_c32f2c0618c1Dart(JSAnon_c32f2c0618c1 $js) implements JSAnon_c32f2c0618c1 {
  factory JSAnon_c32f2c0618c1Dart.lit$({bool? undoStopAfter, bool? undoStopBefore}) {
    final object$ = JSObject();
    if (undoStopAfter != null) {
      object$.setProperty('undoStopAfter'.toJS, undoStopAfter.toJS);
    }
    if (undoStopBefore != null) {
      object$.setProperty('undoStopBefore'.toJS, undoStopBefore.toJS);
    }
    return JSAnon_c32f2c0618c1Dart(JSAnon_c32f2c0618c1(object$));
  }
}

extension JSAnon_c32f2c0618c1ToDart on JSAnon_c32f2c0618c1 {
  JSAnon_c32f2c0618c1Dart get dart => JSAnon_c32f2c0618c1Dart(this);
}

extension type JSAnon_d6158a9f7600Dart(JSAnon_d6158a9f7600 $js) implements JSAnon_d6158a9f7600 {
  factory JSAnon_d6158a9f7600Dart.lit$({bool? keepWhitespace, bool? undoStopAfter, bool? undoStopBefore}) {
    final object$ = JSObject();
    if (keepWhitespace != null) {
      object$.setProperty('keepWhitespace'.toJS, keepWhitespace.toJS);
    }
    if (undoStopAfter != null) {
      object$.setProperty('undoStopAfter'.toJS, undoStopAfter.toJS);
    }
    if (undoStopBefore != null) {
      object$.setProperty('undoStopBefore'.toJS, undoStopBefore.toJS);
    }
    return JSAnon_d6158a9f7600Dart(JSAnon_d6158a9f7600(object$));
  }
}

extension JSAnon_d6158a9f7600ToDart on JSAnon_d6158a9f7600 {
  JSAnon_d6158a9f7600Dart get dart => JSAnon_d6158a9f7600Dart(this);
}

extension type JSAnon_49025246bc6fDart(JSAnon_49025246bc6f $js) implements JSAnon_49025246bc6f {
  factory JSAnon_49025246bc6fDart.lit$({JSAny? expand, bool? focus, bool? select}) {
    final object$ = JSObject();
    if (expand != null) {
      object$.setProperty('expand'.toJS, expand);
    }
    if (focus != null) {
      object$.setProperty('focus'.toJS, focus.toJS);
    }
    if (select != null) {
      object$.setProperty('select'.toJS, select.toJS);
    }
    return JSAnon_49025246bc6fDart(JSAnon_49025246bc6f(object$));
  }
}

extension JSAnon_49025246bc6fToDart on JSAnon_49025246bc6f {
  JSAnon_49025246bc6fDart get dart => JSAnon_49025246bc6fDart(this);
}

extension type JSAnon_5503263f5517Dart(JSAnon_5503263f5517 $js) implements JSAnon_5503263f5517 {
  factory JSAnon_5503263f5517Dart.lit$({String? authority, String? fragment, String? path, String? query, String? scheme}) {
    final object$ = JSObject();
    if (authority != null) {
      object$.setProperty('authority'.toJS, authority.toJS);
    }
    if (fragment != null) {
      object$.setProperty('fragment'.toJS, fragment.toJS);
    }
    if (path != null) {
      object$.setProperty('path'.toJS, path.toJS);
    }
    if (query != null) {
      object$.setProperty('query'.toJS, query.toJS);
    }
    if (scheme != null) {
      object$.setProperty('scheme'.toJS, scheme.toJS);
    }
    return JSAnon_5503263f5517Dart(JSAnon_5503263f5517(object$));
  }
}

extension JSAnon_5503263f5517ToDart on JSAnon_5503263f5517 {
  JSAnon_5503263f5517Dart get dart => JSAnon_5503263f5517Dart(this);
}

extension type JSAnon_67772e4ecc2bDart(JSAnon_67772e4ecc2b $js) implements JSAnon_67772e4ecc2b {
  factory JSAnon_67772e4ecc2bDart.lit$({String? authority, String? fragment, String? path, String? query, String? scheme}) {
    final object$ = JSObject();
    if (authority != null) {
      object$.setProperty('authority'.toJS, authority.toJS);
    }
    if (fragment != null) {
      object$.setProperty('fragment'.toJS, fragment.toJS);
    }
    if (path != null) {
      object$.setProperty('path'.toJS, path.toJS);
    }
    if (query != null) {
      object$.setProperty('query'.toJS, query.toJS);
    }
    if (scheme != null) {
      object$.setProperty('scheme'.toJS, scheme.toJS);
    }
    return JSAnon_67772e4ecc2bDart(JSAnon_67772e4ecc2b(object$));
  }
}

extension JSAnon_67772e4ecc2bToDart on JSAnon_67772e4ecc2b {
  JSAnon_67772e4ecc2bDart get dart => JSAnon_67772e4ecc2bDart(this);
}

extension type JSAnon_406956b7ed59Dart(JSAnon_406956b7ed59 $js) implements JSAnon_406956b7ed59 {
  factory JSAnon_406956b7ed59Dart.lit$({JSAny? defaultLanguageValue, JSAny? defaultValue, JSAny? globalLanguageValue, JSAny? globalValue, String? key, JSArray<JSString>? languageIds, JSAny? workspaceFolderLanguageValue, JSAny? workspaceFolderValue, JSAny? workspaceLanguageValue, JSAny? workspaceValue}) {
    final object$ = JSObject();
    if (defaultLanguageValue != null) {
      object$.setProperty('defaultLanguageValue'.toJS, defaultLanguageValue);
    }
    if (defaultValue != null) {
      object$.setProperty('defaultValue'.toJS, defaultValue);
    }
    if (globalLanguageValue != null) {
      object$.setProperty('globalLanguageValue'.toJS, globalLanguageValue);
    }
    if (globalValue != null) {
      object$.setProperty('globalValue'.toJS, globalValue);
    }
    if (key != null) {
      object$.setProperty('key'.toJS, key.toJS);
    }
    if (languageIds != null) {
      object$.setProperty('languageIds'.toJS, languageIds);
    }
    if (workspaceFolderLanguageValue != null) {
      object$.setProperty('workspaceFolderLanguageValue'.toJS, workspaceFolderLanguageValue);
    }
    if (workspaceFolderValue != null) {
      object$.setProperty('workspaceFolderValue'.toJS, workspaceFolderValue);
    }
    if (workspaceLanguageValue != null) {
      object$.setProperty('workspaceLanguageValue'.toJS, workspaceLanguageValue);
    }
    if (workspaceValue != null) {
      object$.setProperty('workspaceValue'.toJS, workspaceValue);
    }
    return JSAnon_406956b7ed59Dart(JSAnon_406956b7ed59(object$));
  }
}

extension JSAnon_406956b7ed59ToDart on JSAnon_406956b7ed59 {
  JSAnon_406956b7ed59Dart get dart => JSAnon_406956b7ed59Dart(this);
}

extension type JSAnon_05617a7b4547Dart(JSAnon_05617a7b4547 $js) implements JSAnon_05617a7b4547 {
  factory JSAnon_05617a7b4547Dart.lit$({JSObject? contents, bool? ignoreIfExists, bool? overwrite}) {
    final object$ = JSObject();
    if (contents != null) {
      object$.setProperty('contents'.toJS, contents);
    }
    if (ignoreIfExists != null) {
      object$.setProperty('ignoreIfExists'.toJS, ignoreIfExists.toJS);
    }
    if (overwrite != null) {
      object$.setProperty('overwrite'.toJS, overwrite.toJS);
    }
    return JSAnon_05617a7b4547Dart(JSAnon_05617a7b4547(object$));
  }
}

extension JSAnon_05617a7b4547ToDart on JSAnon_05617a7b4547 {
  JSAnon_05617a7b4547Dart get dart => JSAnon_05617a7b4547Dart(this);
}

extension type JSAnon_6f600fe6d695Dart(JSAnon_6f600fe6d695 $js) implements JSAnon_6f600fe6d695 {
  factory JSAnon_6f600fe6d695Dart.lit$({bool? ignoreIfNotExists, bool? recursive}) {
    final object$ = JSObject();
    if (ignoreIfNotExists != null) {
      object$.setProperty('ignoreIfNotExists'.toJS, ignoreIfNotExists.toJS);
    }
    if (recursive != null) {
      object$.setProperty('recursive'.toJS, recursive.toJS);
    }
    return JSAnon_6f600fe6d695Dart(JSAnon_6f600fe6d695(object$));
  }
}

extension JSAnon_6f600fe6d695ToDart on JSAnon_6f600fe6d695 {
  JSAnon_6f600fe6d695Dart get dart => JSAnon_6f600fe6d695Dart(this);
}

extension type JSAnon_ed2698223f98Dart(JSAnon_ed2698223f98 $js) implements JSAnon_ed2698223f98 {
  factory JSAnon_ed2698223f98Dart.lit$({bool? ignoreIfExists, bool? overwrite}) {
    final object$ = JSObject();
    if (ignoreIfExists != null) {
      object$.setProperty('ignoreIfExists'.toJS, ignoreIfExists.toJS);
    }
    if (overwrite != null) {
      object$.setProperty('overwrite'.toJS, overwrite.toJS);
    }
    return JSAnon_ed2698223f98Dart(JSAnon_ed2698223f98(object$));
  }
}

extension JSAnon_ed2698223f98ToDart on JSAnon_ed2698223f98 {
  JSAnon_ed2698223f98Dart get dart => JSAnon_ed2698223f98Dart(this);
}

extension type JSAnon_4caec6211e15Dart(JSAnon_4caec6211e15 $js) implements JSAnon_4caec6211e15 {
  factory JSAnon_4caec6211e15Dart.lit$({String? reason}) {
    final object$ = JSObject();
    if (reason != null) {
      object$.setProperty('reason'.toJS, reason.toJS);
    }
    return JSAnon_4caec6211e15Dart(JSAnon_4caec6211e15(object$));
  }
}

extension JSAnon_4caec6211e15ToDart on JSAnon_4caec6211e15 {
  JSAnon_4caec6211e15Dart get dart => JSAnon_4caec6211e15Dart(this);
}

extension type JSAnon_f7c793236ebaDart(JSAnon_f7c793236eba $js) implements JSAnon_f7c793236eba {
  factory JSAnon_f7c793236ebaDart.lit$({Range? inserting, Range? replacing}) {
    final object$ = JSObject();
    if (inserting != null) {
      object$.setProperty('inserting'.toJS, inserting);
    }
    if (replacing != null) {
      object$.setProperty('replacing'.toJS, replacing);
    }
    return JSAnon_f7c793236ebaDart(JSAnon_f7c793236eba(object$));
  }
}

extension JSAnon_f7c793236ebaToDart on JSAnon_f7c793236eba {
  JSAnon_f7c793236ebaDart get dart => JSAnon_f7c793236ebaDart(this);
}

extension type JSAnon_588b120e4aaeDart(JSAnon_588b120e4aae $js) implements JSAnon_588b120e4aae {
  factory JSAnon_588b120e4aaeDart.lit$({Uri? target, JSAny? value}) {
    final object$ = JSObject();
    if (target != null) {
      object$.setProperty('target'.toJS, target);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value);
    }
    return JSAnon_588b120e4aaeDart(JSAnon_588b120e4aae(object$));
  }
}

extension JSAnon_588b120e4aaeToDart on JSAnon_588b120e4aae {
  JSAnon_588b120e4aaeDart get dart => JSAnon_588b120e4aaeDart(this);
}

extension type JSAnon_8ecf0c868e89Dart(JSAnon_8ecf0c868e89 $js) implements JSAnon_8ecf0c868e89 {
  factory JSAnon_8ecf0c868e89Dart.lit$({JSArray<JSString>? enabledCommands}) {
    final object$ = JSObject();
    if (enabledCommands != null) {
      object$.setProperty('enabledCommands'.toJS, enabledCommands);
    }
    return JSAnon_8ecf0c868e89Dart(JSAnon_8ecf0c868e89(object$));
  }
}

extension JSAnon_8ecf0c868e89ToDart on JSAnon_8ecf0c868e89 {
  JSAnon_8ecf0c868e89Dart get dart => JSAnon_8ecf0c868e89Dart(this);
}

extension type JSAnon_ef7f0ac74d5cDart(JSAnon_ef7f0ac74d5c $js) implements JSAnon_ef7f0ac74d5c {
  factory JSAnon_ef7f0ac74d5cDart.lit$({AccessibilityInformation? accessibilityInformation, num? state, String? tooltip}) {
    final object$ = JSObject();
    if (accessibilityInformation != null) {
      object$.setProperty('accessibilityInformation'.toJS, accessibilityInformation);
    }
    if (state != null) {
      object$.setProperty('state'.toJS, state.toJS);
    }
    if (tooltip != null) {
      object$.setProperty('tooltip'.toJS, tooltip.toJS);
    }
    return JSAnon_ef7f0ac74d5cDart(JSAnon_ef7f0ac74d5c(object$));
  }
}

extension JSAnon_ef7f0ac74d5cToDart on JSAnon_ef7f0ac74d5c {
  JSAnon_ef7f0ac74d5cDart get dart => JSAnon_ef7f0ac74d5cDart(this);
}

extension type JSAnon_f698f56281f5Dart(JSAnon_f698f56281f5 $js) implements JSAnon_f698f56281f5 {
  factory JSAnon_f698f56281f5Dart.lit$({Command? command, CodeActionKind? kind}) {
    final object$ = JSObject();
    if (command != null) {
      object$.setProperty('command'.toJS, command);
    }
    if (kind != null) {
      object$.setProperty('kind'.toJS, kind);
    }
    return JSAnon_f698f56281f5Dart(JSAnon_f698f56281f5(object$));
  }
}

extension JSAnon_f698f56281f5ToDart on JSAnon_f698f56281f5 {
  JSAnon_f698f56281f5Dart get dart => JSAnon_f698f56281f5Dart(this);
}

extension type JSAnon_185648dab94dDart(JSAnon_185648dab94d $js) implements JSAnon_185648dab94d {
  factory JSAnon_185648dab94dDart.lit$({JSFunction? setKeysForSync}) {
    final object$ = JSObject();
    if (setKeysForSync != null) {
      object$.setProperty('setKeysForSync'.toJS, setKeysForSync);
    }
    return JSAnon_185648dab94dDart(JSAnon_185648dab94d(object$));
  }
}

extension JSAnon_185648dab94dToDart on JSAnon_185648dab94d {
  JSAnon_185648dab94dDart get dart => JSAnon_185648dab94dDart(this);
}

extension type JSAnon_ffa2e03c40a2Dart(JSAnon_ffa2e03c40a2 $js) implements JSAnon_ffa2e03c40a2 {
  factory JSAnon_ffa2e03c40a2Dart.lit$({JSFunction? dispose}) {
    final object$ = JSObject();
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    return JSAnon_ffa2e03c40a2Dart(JSAnon_ffa2e03c40a2(object$));
  }
}

extension JSAnon_ffa2e03c40a2ToDart on JSAnon_ffa2e03c40a2 {
  JSAnon_ffa2e03c40a2Dart get dart => JSAnon_ffa2e03c40a2Dart(this);
}

extension type JSAnon_7c30c4713d83Dart(JSAnon_7c30c4713d83 $js) implements JSAnon_7c30c4713d83 {
  factory JSAnon_7c30c4713d83Dart.lit$({Uri? newUri, Uri? oldUri}) {
    final object$ = JSObject();
    if (newUri != null) {
      object$.setProperty('newUri'.toJS, newUri);
    }
    if (oldUri != null) {
      object$.setProperty('oldUri'.toJS, oldUri);
    }
    return JSAnon_7c30c4713d83Dart(JSAnon_7c30c4713d83(object$));
  }
}

extension JSAnon_7c30c4713d83ToDart on JSAnon_7c30c4713d83 {
  JSAnon_7c30c4713d83Dart get dart => JSAnon_7c30c4713d83Dart(this);
}

extension type JSAnon_3800d8dfe13aDart(JSAnon_3800d8dfe13a $js) implements JSAnon_3800d8dfe13a {
  factory JSAnon_3800d8dfe13aDart.lit$({JSArray<JSAnon_393d84ef6035>? autoClosingPairs}) {
    final object$ = JSObject();
    if (autoClosingPairs != null) {
      object$.setProperty('autoClosingPairs'.toJS, autoClosingPairs);
    }
    return JSAnon_3800d8dfe13aDart(JSAnon_3800d8dfe13a(object$));
  }
}

extension JSAnon_3800d8dfe13aToDart on JSAnon_3800d8dfe13a {
  JSAnon_3800d8dfe13aDart get dart => JSAnon_3800d8dfe13aDart(this);
}

extension type JSAnon_7e699a4ba0b6Dart(JSAnon_7e699a4ba0b6 $js) implements JSAnon_7e699a4ba0b6 {
  factory JSAnon_7e699a4ba0b6Dart.lit$({JSAny? brackets, JSAnon_e6d00e2e01a5? docComment}) {
    final object$ = JSObject();
    if (brackets != null) {
      object$.setProperty('brackets'.toJS, brackets);
    }
    if (docComment != null) {
      object$.setProperty('docComment'.toJS, docComment);
    }
    return JSAnon_7e699a4ba0b6Dart(JSAnon_7e699a4ba0b6(object$));
  }
}

extension JSAnon_7e699a4ba0b6ToDart on JSAnon_7e699a4ba0b6 {
  JSAnon_7e699a4ba0b6Dart get dart => JSAnon_7e699a4ba0b6Dart(this);
}

extension type JSAnon_2ef6a897fc39Dart(JSAnon_2ef6a897fc39 $js) implements JSAnon_2ef6a897fc39 {
  factory JSAnon_2ef6a897fc39Dart.lit$({num? endTime, num? startTime}) {
    final object$ = JSObject();
    if (endTime != null) {
      object$.setProperty('endTime'.toJS, endTime.toJS);
    }
    if (startTime != null) {
      object$.setProperty('startTime'.toJS, startTime.toJS);
    }
    return JSAnon_2ef6a897fc39Dart(JSAnon_2ef6a897fc39(object$));
  }
}

extension JSAnon_2ef6a897fc39ToDart on JSAnon_2ef6a897fc39 {
  JSAnon_2ef6a897fc39Dart get dart => JSAnon_2ef6a897fc39Dart(this);
}

extension type JSAnon_a6a068851ba0Dart(JSAnon_a6a068851ba0 $js) implements JSAnon_a6a068851ba0 {
  factory JSAnon_a6a068851ba0Dart.lit$({NotebookDocument? notebook, bool? selected}) {
    final object$ = JSObject();
    if (notebook != null) {
      object$.setProperty('notebook'.toJS, notebook);
    }
    if (selected != null) {
      object$.setProperty('selected'.toJS, selected.toJS);
    }
    return JSAnon_a6a068851ba0Dart(JSAnon_a6a068851ba0(object$));
  }
}

extension JSAnon_a6a068851ba0ToDart on JSAnon_a6a068851ba0 {
  JSAnon_a6a068851ba0Dart get dart => JSAnon_a6a068851ba0Dart(this);
}

extension type JSAnon_68b4d8c85bbaDart(JSAnon_68b4d8c85bba $js) implements JSAnon_68b4d8c85bba {
  factory JSAnon_68b4d8c85bbaDart.lit$({NotebookEditor? editor, JSAny? message}) {
    final object$ = JSObject();
    if (editor != null) {
      object$.setProperty('editor'.toJS, editor);
    }
    if (message != null) {
      object$.setProperty('message'.toJS, message);
    }
    return JSAnon_68b4d8c85bbaDart(JSAnon_68b4d8c85bba(object$));
  }
}

extension JSAnon_68b4d8c85bbaToDart on JSAnon_68b4d8c85bba {
  JSAnon_68b4d8c85bbaDart get dart => JSAnon_68b4d8c85bbaDart(this);
}

extension type JSAnon_d424d3df46f9Dart(JSAnon_d424d3df46f9 $js) implements JSAnon_d424d3df46f9 {
  factory JSAnon_d424d3df46f9Dart.lit$({String? viewId}) {
    final object$ = JSObject();
    if (viewId != null) {
      object$.setProperty('viewId'.toJS, viewId.toJS);
    }
    return JSAnon_d424d3df46f9Dart(JSAnon_d424d3df46f9(object$));
  }
}

extension JSAnon_d424d3df46f9ToDart on JSAnon_d424d3df46f9 {
  JSAnon_d424d3df46f9Dart get dart => JSAnon_d424d3df46f9Dart(this);
}

extension type JSAnon_dc1f16364c4aDart(JSAnon_dc1f16364c4a $js) implements JSAnon_dc1f16364c4a {
  factory JSAnon_dc1f16364c4aDart.lit$({bool? checked}) {
    final object$ = JSObject();
    if (checked != null) {
      object$.setProperty('checked'.toJS, checked.toJS);
    }
    return JSAnon_dc1f16364c4aDart(JSAnon_dc1f16364c4a(object$));
  }
}

extension JSAnon_dc1f16364c4aToDart on JSAnon_dc1f16364c4a {
  JSAnon_dc1f16364c4aDart get dart => JSAnon_dc1f16364c4aDart(this);
}

extension type JSAnon_1507e616ac62Dart(JSAnon_1507e616ac62 $js) implements JSAnon_1507e616ac62 {
  factory JSAnon_1507e616ac62Dart.lit$({String? charsToEscape, String? escapeChar}) {
    final object$ = JSObject();
    if (charsToEscape != null) {
      object$.setProperty('charsToEscape'.toJS, charsToEscape.toJS);
    }
    if (escapeChar != null) {
      object$.setProperty('escapeChar'.toJS, escapeChar.toJS);
    }
    return JSAnon_1507e616ac62Dart(JSAnon_1507e616ac62(object$));
  }
}

extension JSAnon_1507e616ac62ToDart on JSAnon_1507e616ac62 {
  JSAnon_1507e616ac62Dart get dart => JSAnon_1507e616ac62Dart(this);
}

extension type JSAnon_337f2402bc9dDart(JSAnon_337f2402bc9d $js) implements JSAnon_337f2402bc9d {
  factory JSAnon_337f2402bc9dDart.lit$({bool? retainContextWhenHidden}) {
    final object$ = JSObject();
    if (retainContextWhenHidden != null) {
      object$.setProperty('retainContextWhenHidden'.toJS, retainContextWhenHidden.toJS);
    }
    return JSAnon_337f2402bc9dDart(JSAnon_337f2402bc9d(object$));
  }
}

extension JSAnon_337f2402bc9dToDart on JSAnon_337f2402bc9d {
  JSAnon_337f2402bc9dDart get dart => JSAnon_337f2402bc9dDart(this);
}

extension type JSAnon_393d84ef6035Dart(JSAnon_393d84ef6035 $js) implements JSAnon_393d84ef6035 {
  factory JSAnon_393d84ef6035Dart.lit$({String? close, JSArray<JSString>? notIn, String? open}) {
    final object$ = JSObject();
    if (close != null) {
      object$.setProperty('close'.toJS, close.toJS);
    }
    if (notIn != null) {
      object$.setProperty('notIn'.toJS, notIn);
    }
    if (open != null) {
      object$.setProperty('open'.toJS, open.toJS);
    }
    return JSAnon_393d84ef6035Dart(JSAnon_393d84ef6035(object$));
  }
}

extension JSAnon_393d84ef6035ToDart on JSAnon_393d84ef6035 {
  JSAnon_393d84ef6035Dart get dart => JSAnon_393d84ef6035Dart(this);
}

extension type JSAnon_e6d00e2e01a5Dart(JSAnon_e6d00e2e01a5 $js) implements JSAnon_e6d00e2e01a5 {
  factory JSAnon_e6d00e2e01a5Dart.lit$({String? close, String? lineStart, String? open, String? scope}) {
    final object$ = JSObject();
    if (close != null) {
      object$.setProperty('close'.toJS, close.toJS);
    }
    if (lineStart != null) {
      object$.setProperty('lineStart'.toJS, lineStart.toJS);
    }
    if (open != null) {
      object$.setProperty('open'.toJS, open.toJS);
    }
    if (scope != null) {
      object$.setProperty('scope'.toJS, scope.toJS);
    }
    return JSAnon_e6d00e2e01a5Dart(JSAnon_e6d00e2e01a5(object$));
  }
}

extension JSAnon_e6d00e2e01a5ToDart on JSAnon_e6d00e2e01a5 {
  JSAnon_e6d00e2e01a5Dart get dart => JSAnon_e6d00e2e01a5Dart(this);
}

extension type JSAnon_61f1b291a4f5Dart(JSAnon_61f1b291a4f5 $js) implements JSAnon_61f1b291a4f5 {
  factory JSAnon_61f1b291a4f5Dart.lit$({String? languageId, Uri? uri}) {
    final object$ = JSObject();
    if (languageId != null) {
      object$.setProperty('languageId'.toJS, languageId.toJS);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return JSAnon_61f1b291a4f5Dart(JSAnon_61f1b291a4f5(object$));
  }
}

extension JSAnon_61f1b291a4f5ToDart on JSAnon_61f1b291a4f5 {
  JSAnon_61f1b291a4f5Dart get dart => JSAnon_61f1b291a4f5Dart(this);
}

extension type JSAnon_a5a3481054d2Dart(JSAnon_a5a3481054d2 $js) implements JSAnon_a5a3481054d2 {
  factory JSAnon_a5a3481054d2Dart.lit$({Uri? dark, Uri? light}) {
    final object$ = JSObject();
    if (dark != null) {
      object$.setProperty('dark'.toJS, dark);
    }
    if (light != null) {
      object$.setProperty('light'.toJS, light);
    }
    return JSAnon_a5a3481054d2Dart(JSAnon_a5a3481054d2(object$));
  }
}

extension JSAnon_a5a3481054d2ToDart on JSAnon_a5a3481054d2 {
  JSAnon_a5a3481054d2Dart get dart => JSAnon_a5a3481054d2Dart(this);
}

extension type JSAnon_a905fa8af122Dart(JSAnon_a905fa8af122 $js) implements JSAnon_a905fa8af122 {
  factory JSAnon_a905fa8af122Dart.lit$({String? language, String? value}) {
    final object$ = JSObject();
    if (language != null) {
      object$.setProperty('language'.toJS, language.toJS);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    return JSAnon_a905fa8af122Dart(JSAnon_a905fa8af122(object$));
  }
}

extension JSAnon_a905fa8af122ToDart on JSAnon_a905fa8af122 {
  JSAnon_a905fa8af122Dart get dart => JSAnon_a905fa8af122Dart(this);
}

extension type AuthenticationNsDart(AuthenticationNs $js) implements AuthenticationNs {
  Future<JSArray<AuthenticationSessionAccountInformation>> getAccounts(String providerId) => $js.getAccounts(providerId).toDart;
  Future<AuthenticationSession> getSession(String providerId, JSObject scopeListOrRequest, JSIntersection_36a7d28cc578 options) => $js.getSession(providerId, scopeListOrRequest, options).toDart;
  Future<AuthenticationSession> getSession$2(String providerId, JSObject scopeListOrRequest, JSIntersection_559b79086707 options) => $js.getSession$2(providerId, scopeListOrRequest, options).toDart;
  Future<AuthenticationSession?> getSession$3(String providerId, JSObject scopeListOrRequest, [AuthenticationGetSessionOptions? options]) => (options != null ? $js.getSession$3(providerId, scopeListOrRequest, options) : $js.getSession$3(providerId, scopeListOrRequest)).toDart;
  Stream<AuthenticationSessionsChangeEvent> get onDidChangeSessionsStream => _eventStream$(
        (listener) => $js.onDidChangeSessions.call(listener),
        (raw) => raw as AuthenticationSessionsChangeEvent,
      );
}

extension AuthenticationNsToDart on AuthenticationNs {
  AuthenticationNsDart get dart => AuthenticationNsDart(this);
}

extension type CommandsNsDart(CommandsNs $js) implements CommandsNs {
  Future<T> executeCommand<T extends JSAny?>(String command, [List<JSAny?> rest = const []]) => $js.executeCommand<T>(command.toJS, rest).toDart;
  Future<JSArray<JSString>> getCommands([bool? filterInternal]) => (filterInternal != null ? $js.getCommands(filterInternal) : $js.getCommands()).toDart;
}

extension CommandsNsToDart on CommandsNs {
  CommandsNsDart get dart => CommandsNsDart(this);
}

extension type DebugNsDart(DebugNs $js) implements DebugNs {
  Stream<DebugSession?> get onDidChangeActiveDebugSessionStream => _eventStream$(
        (listener) => $js.onDidChangeActiveDebugSession.call(listener),
        (raw) => raw as DebugSession?,
      );
  Stream<JSObject?> get onDidChangeActiveStackItemStream => _eventStream$(
        (listener) => $js.onDidChangeActiveStackItem.call(listener),
        (raw) => raw as JSObject?,
      );
  Stream<BreakpointsChangeEvent> get onDidChangeBreakpointsStream => _eventStream$(
        (listener) => $js.onDidChangeBreakpoints.call(listener),
        (raw) => raw as BreakpointsChangeEvent,
      );
  Stream<DebugSessionCustomEvent> get onDidReceiveDebugSessionCustomEventStream => _eventStream$(
        (listener) => $js.onDidReceiveDebugSessionCustomEvent.call(listener),
        (raw) => raw as DebugSessionCustomEvent,
      );
  Stream<DebugSession> get onDidStartDebugSessionStream => _eventStream$(
        (listener) => $js.onDidStartDebugSession.call(listener),
        (raw) => raw as DebugSession,
      );
  Stream<DebugSession> get onDidTerminateDebugSessionStream => _eventStream$(
        (listener) => $js.onDidTerminateDebugSession.call(listener),
        (raw) => raw as DebugSession,
      );
  Future<bool> startDebugging(WorkspaceFolder? folder, JSAny nameOrConfiguration, [JSObject? parentSessionOrOptions]) => (parentSessionOrOptions != null ? $js.startDebugging(folder, nameOrConfiguration, parentSessionOrOptions) : $js.startDebugging(folder, nameOrConfiguration)).toDart.then((value) => value.toDart);
  Future<JSAny?> stopDebugging([DebugSession? session]) => (session != null ? $js.stopDebugging(session) : $js.stopDebugging()).toDart;
}

extension DebugNsToDart on DebugNs {
  DebugNsDart get dart => DebugNsDart(this);
}

extension type EnvNsDart(EnvNs $js) implements EnvNs {
  Future<Uri> asExternalUri(Uri target) => $js.asExternalUri(target).toDart;
  Stream<num> get onDidChangeLogLevelStream => _eventStream$(
        (listener) => $js.onDidChangeLogLevel.call(listener),
        (raw) => (raw! as JSNumber).toDartDouble,
      );
  Stream<String> get onDidChangeShellStream => _eventStream$(
        (listener) => $js.onDidChangeShell.call(listener),
        (raw) => (raw! as JSString).toDart,
      );
  Stream<bool> get onDidChangeTelemetryEnabledStream => _eventStream$(
        (listener) => $js.onDidChangeTelemetryEnabled.call(listener),
        (raw) => (raw! as JSBoolean).toDart,
      );
  Future<bool> openExternal(Uri target) => $js.openExternal(target).toDart.then((value) => value.toDart);
}

extension EnvNsToDart on EnvNs {
  EnvNsDart get dart => EnvNsDart(this);
}

extension type ExtensionsNsDart(ExtensionsNs $js) implements ExtensionsNs {
  Stream<JSAny?> get onDidChangeStream => _eventStream$(
        (listener) => $js.onDidChange.call(listener),
        (raw) => raw,
      );
}

extension ExtensionsNsToDart on ExtensionsNs {
  ExtensionsNsDart get dart => ExtensionsNsDart(this);
}

extension type L10nNsDart(L10nNs $js) implements L10nNs {
  String t(String message, [List<JSAny?> args = const []]) => $js.t(message.toJS, args).toDart;
}

extension L10nNsToDart on L10nNs {
  L10nNsDart get dart => L10nNsDart(this);
}

extension type LanguagesNsDart(LanguagesNs $js) implements LanguagesNs {
  Future<JSArray<JSString>> getLanguages() => $js.getLanguages().toDart;
  Stream<DiagnosticChangeEvent> get onDidChangeDiagnosticsStream => _eventStream$(
        (listener) => $js.onDidChangeDiagnostics.call(listener),
        (raw) => raw as DiagnosticChangeEvent,
      );
  Disposable registerOnTypeFormattingEditProvider(JSAny selector, OnTypeFormattingEditProvider provider, String firstTriggerCharacter, [List<JSAny?> moreTriggerCharacter = const []]) => $js.registerOnTypeFormattingEditProvider(selector, provider, firstTriggerCharacter.toJS, moreTriggerCharacter);
  Future<TextDocument> setTextDocumentLanguage(TextDocument document, String languageId) => $js.setTextDocumentLanguage(document, languageId).toDart;
}

extension LanguagesNsToDart on LanguagesNs {
  LanguagesNsDart get dart => LanguagesNsDart(this);
}

extension type LmNsDart(LmNs $js) implements LmNs {
  Future<LanguageModelToolResult> invokeTool(String name, LanguageModelToolInvocationOptions<JSObject> options, [CancellationToken? token]) => (token != null ? $js.invokeTool(name, options, token) : $js.invokeTool(name, options)).toDart;
  Stream<JSAny?> get onDidChangeChatModelsStream => _eventStream$(
        (listener) => $js.onDidChangeChatModels.call(listener),
        (raw) => raw,
      );
  Future<JSArray<LanguageModelChat>> selectChatModels([LanguageModelChatSelector? selector]) => (selector != null ? $js.selectChatModels(selector) : $js.selectChatModels()).toDart;
}

extension LmNsToDart on LmNs {
  LmNsDart get dart => LmNsDart(this);
}

extension type TasksNsDart(TasksNs $js) implements TasksNs {
  Future<TaskExecution> executeTask(Task task) => $js.executeTask(task).toDart;
  Future<JSArray<Task>> fetchTasks([TaskFilter? filter]) => (filter != null ? $js.fetchTasks(filter) : $js.fetchTasks()).toDart;
  Stream<TaskEndEvent> get onDidEndTaskStream => _eventStream$(
        (listener) => $js.onDidEndTask.call(listener),
        (raw) => raw as TaskEndEvent,
      );
  Stream<TaskProcessEndEvent> get onDidEndTaskProcessStream => _eventStream$(
        (listener) => $js.onDidEndTaskProcess.call(listener),
        (raw) => raw as TaskProcessEndEvent,
      );
  Stream<TaskStartEvent> get onDidStartTaskStream => _eventStream$(
        (listener) => $js.onDidStartTask.call(listener),
        (raw) => raw as TaskStartEvent,
      );
  Stream<TaskProcessStartEvent> get onDidStartTaskProcessStream => _eventStream$(
        (listener) => $js.onDidStartTaskProcess.call(listener),
        (raw) => raw as TaskProcessStartEvent,
      );
}

extension TasksNsToDart on TasksNs {
  TasksNsDart get dart => TasksNsDart(this);
}

extension type WindowNsDart(WindowNs $js) implements WindowNs {
  Stream<ColorTheme> get onDidChangeActiveColorThemeStream => _eventStream$(
        (listener) => $js.onDidChangeActiveColorTheme.call(listener),
        (raw) => raw as ColorTheme,
      );
  Stream<NotebookEditor?> get onDidChangeActiveNotebookEditorStream => _eventStream$(
        (listener) => $js.onDidChangeActiveNotebookEditor.call(listener),
        (raw) => raw as NotebookEditor?,
      );
  Stream<Terminal?> get onDidChangeActiveTerminalStream => _eventStream$(
        (listener) => $js.onDidChangeActiveTerminal.call(listener),
        (raw) => raw as Terminal?,
      );
  Stream<TextEditor?> get onDidChangeActiveTextEditorStream => _eventStream$(
        (listener) => $js.onDidChangeActiveTextEditor.call(listener),
        (raw) => raw as TextEditor?,
      );
  Stream<NotebookEditorSelectionChangeEvent> get onDidChangeNotebookEditorSelectionStream => _eventStream$(
        (listener) => $js.onDidChangeNotebookEditorSelection.call(listener),
        (raw) => raw as NotebookEditorSelectionChangeEvent,
      );
  Stream<NotebookEditorVisibleRangesChangeEvent> get onDidChangeNotebookEditorVisibleRangesStream => _eventStream$(
        (listener) => $js.onDidChangeNotebookEditorVisibleRanges.call(listener),
        (raw) => raw as NotebookEditorVisibleRangesChangeEvent,
      );
  Stream<TerminalShellIntegrationChangeEvent> get onDidChangeTerminalShellIntegrationStream => _eventStream$(
        (listener) => $js.onDidChangeTerminalShellIntegration.call(listener),
        (raw) => raw as TerminalShellIntegrationChangeEvent,
      );
  Stream<Terminal> get onDidChangeTerminalStateStream => _eventStream$(
        (listener) => $js.onDidChangeTerminalState.call(listener),
        (raw) => raw as Terminal,
      );
  Stream<TextEditorOptionsChangeEvent> get onDidChangeTextEditorOptionsStream => _eventStream$(
        (listener) => $js.onDidChangeTextEditorOptions.call(listener),
        (raw) => raw as TextEditorOptionsChangeEvent,
      );
  Stream<TextEditorSelectionChangeEvent> get onDidChangeTextEditorSelectionStream => _eventStream$(
        (listener) => $js.onDidChangeTextEditorSelection.call(listener),
        (raw) => raw as TextEditorSelectionChangeEvent,
      );
  Stream<TextEditorViewColumnChangeEvent> get onDidChangeTextEditorViewColumnStream => _eventStream$(
        (listener) => $js.onDidChangeTextEditorViewColumn.call(listener),
        (raw) => raw as TextEditorViewColumnChangeEvent,
      );
  Stream<TextEditorVisibleRangesChangeEvent> get onDidChangeTextEditorVisibleRangesStream => _eventStream$(
        (listener) => $js.onDidChangeTextEditorVisibleRanges.call(listener),
        (raw) => raw as TextEditorVisibleRangesChangeEvent,
      );
  Stream<JSArray<NotebookEditor>> get onDidChangeVisibleNotebookEditorsStream => _eventStream$(
        (listener) => $js.onDidChangeVisibleNotebookEditors.call(listener),
        (raw) => raw as JSArray<NotebookEditor>,
      );
  Stream<JSArray<TextEditor>> get onDidChangeVisibleTextEditorsStream => _eventStream$(
        (listener) => $js.onDidChangeVisibleTextEditors.call(listener),
        (raw) => raw as JSArray<TextEditor>,
      );
  Stream<WindowState> get onDidChangeWindowStateStream => _eventStream$(
        (listener) => $js.onDidChangeWindowState.call(listener),
        (raw) => raw as WindowState,
      );
  Stream<Terminal> get onDidCloseTerminalStream => _eventStream$(
        (listener) => $js.onDidCloseTerminal.call(listener),
        (raw) => raw as Terminal,
      );
  Stream<TerminalShellExecutionEndEvent> get onDidEndTerminalShellExecutionStream => _eventStream$(
        (listener) => $js.onDidEndTerminalShellExecution.call(listener),
        (raw) => raw as TerminalShellExecutionEndEvent,
      );
  Stream<Terminal> get onDidOpenTerminalStream => _eventStream$(
        (listener) => $js.onDidOpenTerminal.call(listener),
        (raw) => raw as Terminal,
      );
  Stream<TerminalShellExecutionStartEvent> get onDidStartTerminalShellExecutionStream => _eventStream$(
        (listener) => $js.onDidStartTerminalShellExecution.call(listener),
        (raw) => raw as TerminalShellExecutionStartEvent,
      );
  Future<T?> showErrorMessage<T extends JSAny?>(String message, [List<JSAny?> items = const []]) => $js.showErrorMessage<T>(message.toJS, items).toDart;
  Future<T?> showErrorMessage$2<T extends JSAny?>(String message, MessageOptions options, [List<JSAny?> items = const []]) => $js.showErrorMessage$2<T>(message.toJS, options, items).toDart;
  Future<T?> showErrorMessage$3<T extends JSAny?>(String message, [List<JSAny?> items = const []]) => $js.showErrorMessage$3<T>(message.toJS, items).toDart;
  Future<T?> showErrorMessage$4<T extends JSAny?>(String message, MessageOptions options, [List<JSAny?> items = const []]) => $js.showErrorMessage$4<T>(message.toJS, options, items).toDart;
  Future<T?> showInformationMessage<T extends JSAny?>(String message, [List<JSAny?> items = const []]) => $js.showInformationMessage<T>(message.toJS, items).toDart;
  Future<T?> showInformationMessage$2<T extends JSAny?>(String message, MessageOptions options, [List<JSAny?> items = const []]) => $js.showInformationMessage$2<T>(message.toJS, options, items).toDart;
  Future<T?> showInformationMessage$3<T extends JSAny?>(String message, [List<JSAny?> items = const []]) => $js.showInformationMessage$3<T>(message.toJS, items).toDart;
  Future<T?> showInformationMessage$4<T extends JSAny?>(String message, MessageOptions options, [List<JSAny?> items = const []]) => $js.showInformationMessage$4<T>(message.toJS, options, items).toDart;
  Future<String?> showInputBox([InputBoxOptions? options, CancellationToken? token]) => (token != null ? $js.showInputBox(options, token) : options != null ? $js.showInputBox(options) : $js.showInputBox()).toDart.then((value) => value?.toDart);
  Future<NotebookEditor> showNotebookDocument(NotebookDocument document, [NotebookDocumentShowOptions? options]) => (options != null ? $js.showNotebookDocument(document, options) : $js.showNotebookDocument(document)).toDart;
  Future<JSArray<Uri>?> showOpenDialog([OpenDialogOptions? options]) => (options != null ? $js.showOpenDialog(options) : $js.showOpenDialog()).toDart;
  Future<JSArray<JSString>?> showQuickPick(JSObject items, JSIntersection_18ddc81c2d41 options, [CancellationToken? token]) => (token != null ? $js.showQuickPick(items, options, token) : $js.showQuickPick(items, options)).toDart;
  Future<String?> showQuickPick$2(JSObject items, [QuickPickOptions? options, CancellationToken? token]) => (token != null ? $js.showQuickPick$2(items, options, token) : options != null ? $js.showQuickPick$2(items, options) : $js.showQuickPick$2(items)).toDart.then((value) => value?.toDart);
  Future<JSArray<T>?> showQuickPick$3<T extends JSAny?>(JSObject items, JSIntersection_18ddc81c2d41 options, [CancellationToken? token]) => (token != null ? $js.showQuickPick$3<T>(items, options, token) : $js.showQuickPick$3<T>(items, options)).toDart;
  Future<T?> showQuickPick$4<T extends JSAny?>(JSObject items, [QuickPickOptions? options, CancellationToken? token]) => (token != null ? $js.showQuickPick$4<T>(items, options, token) : options != null ? $js.showQuickPick$4<T>(items, options) : $js.showQuickPick$4<T>(items)).toDart;
  Future<Uri?> showSaveDialog([SaveDialogOptions? options]) => (options != null ? $js.showSaveDialog(options) : $js.showSaveDialog()).toDart;
  Future<TextEditor> showTextDocument(TextDocument document, [int? column, bool? preserveFocus]) => (preserveFocus != null ? $js.showTextDocument(document, column, preserveFocus) : column != null ? $js.showTextDocument(document, column) : $js.showTextDocument(document)).toDart;
  Future<TextEditor> showTextDocument$2(TextDocument document, [TextDocumentShowOptions? options]) => (options != null ? $js.showTextDocument$2(document, options) : $js.showTextDocument$2(document)).toDart;
  Future<TextEditor> showTextDocument$3(Uri uri, [TextDocumentShowOptions? options]) => (options != null ? $js.showTextDocument$3(uri, options) : $js.showTextDocument$3(uri)).toDart;
  Future<T?> showWarningMessage<T extends JSAny?>(String message, [List<JSAny?> items = const []]) => $js.showWarningMessage<T>(message.toJS, items).toDart;
  Future<T?> showWarningMessage$2<T extends JSAny?>(String message, MessageOptions options, [List<JSAny?> items = const []]) => $js.showWarningMessage$2<T>(message.toJS, options, items).toDart;
  Future<T?> showWarningMessage$3<T extends JSAny?>(String message, [List<JSAny?> items = const []]) => $js.showWarningMessage$3<T>(message.toJS, items).toDart;
  Future<T?> showWarningMessage$4<T extends JSAny?>(String message, MessageOptions options, [List<JSAny?> items = const []]) => $js.showWarningMessage$4<T>(message.toJS, options, items).toDart;
  Future<WorkspaceFolder?> showWorkspaceFolderPick([WorkspaceFolderPickOptions? options]) => (options != null ? $js.showWorkspaceFolderPick(options) : $js.showWorkspaceFolderPick()).toDart;
  Future<R> withProgress<R extends JSAny?>(ProgressOptions options, JSFunction task) => $js.withProgress<R>(options, task).toDart;
  Future<R> withScmProgress<R extends JSAny?>(JSFunction task) => $js.withScmProgress<R>(task).toDart;
}

extension WindowNsToDart on WindowNs {
  WindowNsDart get dart => WindowNsDart(this);
}

extension type WorkspaceNsDart(WorkspaceNs $js) implements WorkspaceNs {
  Future<bool> applyEdit(WorkspaceEdit edit, [WorkspaceEditMetadata? metadata]) => (metadata != null ? $js.applyEdit(edit, metadata) : $js.applyEdit(edit)).toDart.then((value) => value.toDart);
  Future<String> decode(JSUint8Array content) => $js.decode(content).toDart.then((value) => value.toDart);
  Future<String> decode$2(JSUint8Array content, JSAnon_bce51fc74910 options) => $js.decode$2(content, options).toDart.then((value) => value.toDart);
  Future<String> decode$3(JSUint8Array content, JSAnon_5f13b3458117 options) => $js.decode$3(content, options).toDart.then((value) => value.toDart);
  Future<JSUint8Array> encode(String content) => $js.encode(content).toDart;
  Future<JSUint8Array> encode$2(String content, JSAnon_bce51fc74910 options) => $js.encode$2(content, options).toDart;
  Future<JSUint8Array> encode$3(String content, JSAnon_5f13b3458117 options) => $js.encode$3(content, options).toDart;
  Future<JSArray<Uri>> findFiles(JSAny include, [JSAny? exclude, num? maxResults, CancellationToken? token]) => (token != null ? $js.findFiles(include, exclude, maxResults, token) : maxResults != null ? $js.findFiles(include, exclude, maxResults) : exclude != null ? $js.findFiles(include, exclude) : $js.findFiles(include)).toDart;
  Stream<ConfigurationChangeEvent> get onDidChangeConfigurationStream => _eventStream$(
        (listener) => $js.onDidChangeConfiguration.call(listener),
        (raw) => raw as ConfigurationChangeEvent,
      );
  Stream<NotebookDocumentChangeEvent> get onDidChangeNotebookDocumentStream => _eventStream$(
        (listener) => $js.onDidChangeNotebookDocument.call(listener),
        (raw) => raw as NotebookDocumentChangeEvent,
      );
  Stream<TextDocumentChangeEvent> get onDidChangeTextDocumentStream => _eventStream$(
        (listener) => $js.onDidChangeTextDocument.call(listener),
        (raw) => raw as TextDocumentChangeEvent,
      );
  Stream<WorkspaceFoldersChangeEvent> get onDidChangeWorkspaceFoldersStream => _eventStream$(
        (listener) => $js.onDidChangeWorkspaceFolders.call(listener),
        (raw) => raw as WorkspaceFoldersChangeEvent,
      );
  Stream<NotebookDocument> get onDidCloseNotebookDocumentStream => _eventStream$(
        (listener) => $js.onDidCloseNotebookDocument.call(listener),
        (raw) => raw as NotebookDocument,
      );
  Stream<TextDocument> get onDidCloseTextDocumentStream => _eventStream$(
        (listener) => $js.onDidCloseTextDocument.call(listener),
        (raw) => raw as TextDocument,
      );
  Stream<FileCreateEvent> get onDidCreateFilesStream => _eventStream$(
        (listener) => $js.onDidCreateFiles.call(listener),
        (raw) => raw as FileCreateEvent,
      );
  Stream<FileDeleteEvent> get onDidDeleteFilesStream => _eventStream$(
        (listener) => $js.onDidDeleteFiles.call(listener),
        (raw) => raw as FileDeleteEvent,
      );
  Stream<JSAny?> get onDidGrantWorkspaceTrustStream => _eventStream$(
        (listener) => $js.onDidGrantWorkspaceTrust.call(listener),
        (raw) => raw,
      );
  Stream<NotebookDocument> get onDidOpenNotebookDocumentStream => _eventStream$(
        (listener) => $js.onDidOpenNotebookDocument.call(listener),
        (raw) => raw as NotebookDocument,
      );
  Stream<TextDocument> get onDidOpenTextDocumentStream => _eventStream$(
        (listener) => $js.onDidOpenTextDocument.call(listener),
        (raw) => raw as TextDocument,
      );
  Stream<FileRenameEvent> get onDidRenameFilesStream => _eventStream$(
        (listener) => $js.onDidRenameFiles.call(listener),
        (raw) => raw as FileRenameEvent,
      );
  Stream<NotebookDocument> get onDidSaveNotebookDocumentStream => _eventStream$(
        (listener) => $js.onDidSaveNotebookDocument.call(listener),
        (raw) => raw as NotebookDocument,
      );
  Stream<TextDocument> get onDidSaveTextDocumentStream => _eventStream$(
        (listener) => $js.onDidSaveTextDocument.call(listener),
        (raw) => raw as TextDocument,
      );
  Stream<FileWillCreateEvent> get onWillCreateFilesStream => _eventStream$(
        (listener) => $js.onWillCreateFiles.call(listener),
        (raw) => raw as FileWillCreateEvent,
      );
  Stream<FileWillDeleteEvent> get onWillDeleteFilesStream => _eventStream$(
        (listener) => $js.onWillDeleteFiles.call(listener),
        (raw) => raw as FileWillDeleteEvent,
      );
  Stream<FileWillRenameEvent> get onWillRenameFilesStream => _eventStream$(
        (listener) => $js.onWillRenameFiles.call(listener),
        (raw) => raw as FileWillRenameEvent,
      );
  Stream<NotebookDocumentWillSaveEvent> get onWillSaveNotebookDocumentStream => _eventStream$(
        (listener) => $js.onWillSaveNotebookDocument.call(listener),
        (raw) => raw as NotebookDocumentWillSaveEvent,
      );
  Stream<TextDocumentWillSaveEvent> get onWillSaveTextDocumentStream => _eventStream$(
        (listener) => $js.onWillSaveTextDocument.call(listener),
        (raw) => raw as TextDocumentWillSaveEvent,
      );
  Future<NotebookDocument> openNotebookDocument(Uri uri) => $js.openNotebookDocument(uri).toDart;
  Future<NotebookDocument> openNotebookDocument$2(String notebookType, [NotebookData? content]) => (content != null ? $js.openNotebookDocument$2(notebookType, content) : $js.openNotebookDocument$2(notebookType)).toDart;
  Future<TextDocument> openTextDocument(Uri uri, [JSAnon_d8666bad7f07? options]) => (options != null ? $js.openTextDocument(uri, options) : $js.openTextDocument(uri)).toDart;
  Future<TextDocument> openTextDocument$2(String path, [JSAnon_d8666bad7f07? options]) => (options != null ? $js.openTextDocument$2(path, options) : $js.openTextDocument$2(path)).toDart;
  Future<TextDocument> openTextDocument$3([JSAnon_46c65550b867? options]) => (options != null ? $js.openTextDocument$3(options) : $js.openTextDocument$3()).toDart;
  Future<Uri?> save(Uri uri) => $js.save(uri).toDart;
  Future<bool> saveAll([bool? includeUntitled]) => (includeUntitled != null ? $js.saveAll(includeUntitled) : $js.saveAll()).toDart.then((value) => value.toDart);
  Future<Uri?> saveAs(Uri uri) => $js.saveAs(uri).toDart;
  bool updateWorkspaceFolders(num start, JSAny? deleteCount, [List<JSAny?> workspaceFoldersToAdd = const []]) => $js.updateWorkspaceFolders(start.toJS, deleteCount, workspaceFoldersToAdd).toDart;
}

extension WorkspaceNsToDart on WorkspaceNs {
  WorkspaceNsDart get dart => WorkspaceNsDart(this);
}

extension type AccessibilityInformationDart(AccessibilityInformation $js) implements AccessibilityInformation {
  factory AccessibilityInformationDart.lit$({String? label, String? role}) {
    final object$ = JSObject();
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (role != null) {
      object$.setProperty('role'.toJS, role.toJS);
    }
    return AccessibilityInformationDart(AccessibilityInformation(object$));
  }
}

extension AccessibilityInformationToDart on AccessibilityInformation {
  AccessibilityInformationDart get dart => AccessibilityInformationDart(this);
}

extension type AuthenticationGetSessionOptionsDart(AuthenticationGetSessionOptions $js) implements AuthenticationGetSessionOptions {
  factory AuthenticationGetSessionOptionsDart.lit$({AuthenticationSessionAccountInformation? account, bool? clearSessionPreference, JSAny? createIfNone, JSAny? forceNewSession, bool? silent}) {
    final object$ = JSObject();
    if (account != null) {
      object$.setProperty('account'.toJS, account);
    }
    if (clearSessionPreference != null) {
      object$.setProperty('clearSessionPreference'.toJS, clearSessionPreference.toJS);
    }
    if (createIfNone != null) {
      object$.setProperty('createIfNone'.toJS, createIfNone);
    }
    if (forceNewSession != null) {
      object$.setProperty('forceNewSession'.toJS, forceNewSession);
    }
    if (silent != null) {
      object$.setProperty('silent'.toJS, silent.toJS);
    }
    return AuthenticationGetSessionOptionsDart(AuthenticationGetSessionOptions(object$));
  }
}

extension AuthenticationGetSessionOptionsToDart on AuthenticationGetSessionOptions {
  AuthenticationGetSessionOptionsDart get dart => AuthenticationGetSessionOptionsDart(this);
}

extension type AuthenticationGetSessionPresentationOptionsDart(AuthenticationGetSessionPresentationOptions $js) implements AuthenticationGetSessionPresentationOptions {
  factory AuthenticationGetSessionPresentationOptionsDart.lit$({String? detail}) {
    final object$ = JSObject();
    if (detail != null) {
      object$.setProperty('detail'.toJS, detail.toJS);
    }
    return AuthenticationGetSessionPresentationOptionsDart(AuthenticationGetSessionPresentationOptions(object$));
  }
}

extension AuthenticationGetSessionPresentationOptionsToDart on AuthenticationGetSessionPresentationOptions {
  AuthenticationGetSessionPresentationOptionsDart get dart => AuthenticationGetSessionPresentationOptionsDart(this);
}

extension type AuthenticationProviderDart(AuthenticationProvider $js) implements AuthenticationProvider {
  factory AuthenticationProviderDart.lit$({JSFunction? createSession, JSFunction? getSessions, Event<AuthenticationProviderAuthenticationSessionsChangeEvent>? onDidChangeSessions, JSFunction? removeSession}) {
    final object$ = JSObject();
    if (createSession != null) {
      object$.setProperty('createSession'.toJS, createSession);
    }
    if (getSessions != null) {
      object$.setProperty('getSessions'.toJS, getSessions);
    }
    if (onDidChangeSessions != null) {
      object$.setProperty('onDidChangeSessions'.toJS, onDidChangeSessions);
    }
    if (removeSession != null) {
      object$.setProperty('removeSession'.toJS, removeSession);
    }
    return AuthenticationProviderDart(AuthenticationProvider(object$));
  }
  Future<AuthenticationSession> createSession(JSArray<JSString> scopes, AuthenticationProviderSessionOptions options) => $js.createSession(scopes, options).toDart;
  Future<JSArray<AuthenticationSession>> getSessions(JSArray<JSString>? scopes, AuthenticationProviderSessionOptions options) => $js.getSessions(scopes, options).toDart;
  Stream<AuthenticationProviderAuthenticationSessionsChangeEvent> get onDidChangeSessionsStream => _eventStream$(
        (listener) => $js.onDidChangeSessions.call(listener),
        (raw) => raw as AuthenticationProviderAuthenticationSessionsChangeEvent,
      );
  Future<JSAny?> removeSession(String sessionId) => $js.removeSession(sessionId).toDart;
}

extension AuthenticationProviderToDart on AuthenticationProvider {
  AuthenticationProviderDart get dart => AuthenticationProviderDart(this);
}

extension type AuthenticationProviderAuthenticationSessionsChangeEventDart(AuthenticationProviderAuthenticationSessionsChangeEvent $js) implements AuthenticationProviderAuthenticationSessionsChangeEvent {
  factory AuthenticationProviderAuthenticationSessionsChangeEventDart.lit$({JSArray<AuthenticationSession>? added, JSArray<AuthenticationSession>? changed, JSArray<AuthenticationSession>? removed}) {
    final object$ = JSObject();
    if (added != null) {
      object$.setProperty('added'.toJS, added);
    }
    if (changed != null) {
      object$.setProperty('changed'.toJS, changed);
    }
    if (removed != null) {
      object$.setProperty('removed'.toJS, removed);
    }
    return AuthenticationProviderAuthenticationSessionsChangeEventDart(AuthenticationProviderAuthenticationSessionsChangeEvent(object$));
  }
}

extension AuthenticationProviderAuthenticationSessionsChangeEventToDart on AuthenticationProviderAuthenticationSessionsChangeEvent {
  AuthenticationProviderAuthenticationSessionsChangeEventDart get dart => AuthenticationProviderAuthenticationSessionsChangeEventDart(this);
}

extension type AuthenticationProviderInformationDart(AuthenticationProviderInformation $js) implements AuthenticationProviderInformation {
  factory AuthenticationProviderInformationDart.lit$({String? id, String? label}) {
    final object$ = JSObject();
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    return AuthenticationProviderInformationDart(AuthenticationProviderInformation(object$));
  }
}

extension AuthenticationProviderInformationToDart on AuthenticationProviderInformation {
  AuthenticationProviderInformationDart get dart => AuthenticationProviderInformationDart(this);
}

extension type AuthenticationProviderOptionsDart(AuthenticationProviderOptions $js) implements AuthenticationProviderOptions {
  factory AuthenticationProviderOptionsDart.lit$({bool? supportsMultipleAccounts}) {
    final object$ = JSObject();
    if (supportsMultipleAccounts != null) {
      object$.setProperty('supportsMultipleAccounts'.toJS, supportsMultipleAccounts.toJS);
    }
    return AuthenticationProviderOptionsDart(AuthenticationProviderOptions(object$));
  }
}

extension AuthenticationProviderOptionsToDart on AuthenticationProviderOptions {
  AuthenticationProviderOptionsDart get dart => AuthenticationProviderOptionsDart(this);
}

extension type AuthenticationProviderSessionOptionsDart(AuthenticationProviderSessionOptions $js) implements AuthenticationProviderSessionOptions {
  factory AuthenticationProviderSessionOptionsDart.lit$({AuthenticationSessionAccountInformation? account}) {
    final object$ = JSObject();
    if (account != null) {
      object$.setProperty('account'.toJS, account);
    }
    return AuthenticationProviderSessionOptionsDart(AuthenticationProviderSessionOptions(object$));
  }
}

extension AuthenticationProviderSessionOptionsToDart on AuthenticationProviderSessionOptions {
  AuthenticationProviderSessionOptionsDart get dart => AuthenticationProviderSessionOptionsDart(this);
}

extension type AuthenticationSessionDart(AuthenticationSession $js) implements AuthenticationSession {
  factory AuthenticationSessionDart.lit$({String? accessToken, AuthenticationSessionAccountInformation? account, String? id, String? idToken, JSArray<JSString>? scopes}) {
    final object$ = JSObject();
    if (accessToken != null) {
      object$.setProperty('accessToken'.toJS, accessToken.toJS);
    }
    if (account != null) {
      object$.setProperty('account'.toJS, account);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (idToken != null) {
      object$.setProperty('idToken'.toJS, idToken.toJS);
    }
    if (scopes != null) {
      object$.setProperty('scopes'.toJS, scopes);
    }
    return AuthenticationSessionDart(AuthenticationSession(object$));
  }
}

extension AuthenticationSessionToDart on AuthenticationSession {
  AuthenticationSessionDart get dart => AuthenticationSessionDart(this);
}

extension type AuthenticationSessionAccountInformationDart(AuthenticationSessionAccountInformation $js) implements AuthenticationSessionAccountInformation {
  factory AuthenticationSessionAccountInformationDart.lit$({String? id, String? label}) {
    final object$ = JSObject();
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    return AuthenticationSessionAccountInformationDart(AuthenticationSessionAccountInformation(object$));
  }
}

extension AuthenticationSessionAccountInformationToDart on AuthenticationSessionAccountInformation {
  AuthenticationSessionAccountInformationDart get dart => AuthenticationSessionAccountInformationDart(this);
}

extension type AuthenticationSessionsChangeEventDart(AuthenticationSessionsChangeEvent $js) implements AuthenticationSessionsChangeEvent {
  factory AuthenticationSessionsChangeEventDart.lit$({AuthenticationProviderInformation? provider}) {
    final object$ = JSObject();
    if (provider != null) {
      object$.setProperty('provider'.toJS, provider);
    }
    return AuthenticationSessionsChangeEventDart(AuthenticationSessionsChangeEvent(object$));
  }
}

extension AuthenticationSessionsChangeEventToDart on AuthenticationSessionsChangeEvent {
  AuthenticationSessionsChangeEventDart get dart => AuthenticationSessionsChangeEventDart(this);
}

extension type AuthenticationWwwAuthenticateRequestDart(AuthenticationWwwAuthenticateRequest $js) implements AuthenticationWwwAuthenticateRequest {
  factory AuthenticationWwwAuthenticateRequestDart.lit$({JSArray<JSString>? fallbackScopes, String? wwwAuthenticate}) {
    final object$ = JSObject();
    if (fallbackScopes != null) {
      object$.setProperty('fallbackScopes'.toJS, fallbackScopes);
    }
    if (wwwAuthenticate != null) {
      object$.setProperty('wwwAuthenticate'.toJS, wwwAuthenticate.toJS);
    }
    return AuthenticationWwwAuthenticateRequestDart(AuthenticationWwwAuthenticateRequest(object$));
  }
}

extension AuthenticationWwwAuthenticateRequestToDart on AuthenticationWwwAuthenticateRequest {
  AuthenticationWwwAuthenticateRequestDart get dart => AuthenticationWwwAuthenticateRequestDart(this);
}

extension type AutoClosingPairDart(AutoClosingPair $js) implements AutoClosingPair {
  factory AutoClosingPairDart.lit$({String? close, JSArray<JSNumber>? notIn, String? open}) {
    final object$ = JSObject();
    if (close != null) {
      object$.setProperty('close'.toJS, close.toJS);
    }
    if (notIn != null) {
      object$.setProperty('notIn'.toJS, notIn);
    }
    if (open != null) {
      object$.setProperty('open'.toJS, open.toJS);
    }
    return AutoClosingPairDart(AutoClosingPair(object$));
  }
}

extension AutoClosingPairToDart on AutoClosingPair {
  AutoClosingPairDart get dart => AutoClosingPairDart(this);
}

extension type BreakpointsChangeEventDart(BreakpointsChangeEvent $js) implements BreakpointsChangeEvent {
  factory BreakpointsChangeEventDart.lit$({JSArray<Breakpoint>? added, JSArray<Breakpoint>? changed, JSArray<Breakpoint>? removed}) {
    final object$ = JSObject();
    if (added != null) {
      object$.setProperty('added'.toJS, added);
    }
    if (changed != null) {
      object$.setProperty('changed'.toJS, changed);
    }
    if (removed != null) {
      object$.setProperty('removed'.toJS, removed);
    }
    return BreakpointsChangeEventDart(BreakpointsChangeEvent(object$));
  }
}

extension BreakpointsChangeEventToDart on BreakpointsChangeEvent {
  BreakpointsChangeEventDart get dart => BreakpointsChangeEventDart(this);
}

extension type CallHierarchyProviderDart(CallHierarchyProvider $js) implements CallHierarchyProvider {
  factory CallHierarchyProviderDart.lit$({JSFunction? prepareCallHierarchy, JSFunction? provideCallHierarchyIncomingCalls, JSFunction? provideCallHierarchyOutgoingCalls}) {
    final object$ = JSObject();
    if (prepareCallHierarchy != null) {
      object$.setProperty('prepareCallHierarchy'.toJS, prepareCallHierarchy);
    }
    if (provideCallHierarchyIncomingCalls != null) {
      object$.setProperty('provideCallHierarchyIncomingCalls'.toJS, provideCallHierarchyIncomingCalls);
    }
    if (provideCallHierarchyOutgoingCalls != null) {
      object$.setProperty('provideCallHierarchyOutgoingCalls'.toJS, provideCallHierarchyOutgoingCalls);
    }
    return CallHierarchyProviderDart(CallHierarchyProvider(object$));
  }
}

extension CallHierarchyProviderToDart on CallHierarchyProvider {
  CallHierarchyProviderDart get dart => CallHierarchyProviderDart(this);
}

extension type CancellationTokenDart(CancellationToken $js) implements CancellationToken {
  factory CancellationTokenDart.lit$({bool? isCancellationRequested, Event<JSAny?>? onCancellationRequested}) {
    final object$ = JSObject();
    if (isCancellationRequested != null) {
      object$.setProperty('isCancellationRequested'.toJS, isCancellationRequested.toJS);
    }
    if (onCancellationRequested != null) {
      object$.setProperty('onCancellationRequested'.toJS, onCancellationRequested);
    }
    return CancellationTokenDart(CancellationToken(object$));
  }
  Stream<JSAny?> get onCancellationRequestedStream => _eventStream$(
        (listener) => $js.onCancellationRequested.call(listener),
        (raw) => raw,
      );
}

extension CancellationTokenToDart on CancellationToken {
  CancellationTokenDart get dart => CancellationTokenDart(this);
}

extension type ChatContextDart(ChatContext $js) implements ChatContext {
  factory ChatContextDart.lit$({JSArray<JSObject>? history}) {
    final object$ = JSObject();
    if (history != null) {
      object$.setProperty('history'.toJS, history);
    }
    return ChatContextDart(ChatContext(object$));
  }
}

extension ChatContextToDart on ChatContext {
  ChatContextDart get dart => ChatContextDart(this);
}

extension type ChatErrorDetailsDart(ChatErrorDetails $js) implements ChatErrorDetails {
  factory ChatErrorDetailsDart.lit$({String? message, bool? responseIsFiltered}) {
    final object$ = JSObject();
    if (message != null) {
      object$.setProperty('message'.toJS, message.toJS);
    }
    if (responseIsFiltered != null) {
      object$.setProperty('responseIsFiltered'.toJS, responseIsFiltered.toJS);
    }
    return ChatErrorDetailsDart(ChatErrorDetails(object$));
  }
}

extension ChatErrorDetailsToDart on ChatErrorDetails {
  ChatErrorDetailsDart get dart => ChatErrorDetailsDart(this);
}

extension type ChatFollowupDart(ChatFollowup $js) implements ChatFollowup {
  factory ChatFollowupDart.lit$({String? command, String? label, String? participant, String? prompt}) {
    final object$ = JSObject();
    if (command != null) {
      object$.setProperty('command'.toJS, command.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (participant != null) {
      object$.setProperty('participant'.toJS, participant.toJS);
    }
    if (prompt != null) {
      object$.setProperty('prompt'.toJS, prompt.toJS);
    }
    return ChatFollowupDart(ChatFollowup(object$));
  }
}

extension ChatFollowupToDart on ChatFollowup {
  ChatFollowupDart get dart => ChatFollowupDart(this);
}

extension type ChatFollowupProviderDart(ChatFollowupProvider $js) implements ChatFollowupProvider {
  factory ChatFollowupProviderDart.lit$({JSFunction? provideFollowups}) {
    final object$ = JSObject();
    if (provideFollowups != null) {
      object$.setProperty('provideFollowups'.toJS, provideFollowups);
    }
    return ChatFollowupProviderDart(ChatFollowupProvider(object$));
  }
}

extension ChatFollowupProviderToDart on ChatFollowupProvider {
  ChatFollowupProviderDart get dart => ChatFollowupProviderDart(this);
}

extension type ChatLanguageModelToolReferenceDart(ChatLanguageModelToolReference $js) implements ChatLanguageModelToolReference {
  factory ChatLanguageModelToolReferenceDart.lit$({String? name, JSTuple_9b5999d5c048? range}) {
    final object$ = JSObject();
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    return ChatLanguageModelToolReferenceDart(ChatLanguageModelToolReference(object$));
  }
}

extension ChatLanguageModelToolReferenceToDart on ChatLanguageModelToolReference {
  ChatLanguageModelToolReferenceDart get dart => ChatLanguageModelToolReferenceDart(this);
}

extension type ChatParticipantDart(ChatParticipant $js) implements ChatParticipant {
  factory ChatParticipantDart.lit$({JSFunction? dispose, ChatFollowupProvider? followupProvider, JSObject? iconPath, String? id, Event<ChatResultFeedback>? onDidReceiveFeedback, JSFunction? requestHandler}) {
    final object$ = JSObject();
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (followupProvider != null) {
      object$.setProperty('followupProvider'.toJS, followupProvider);
    }
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (onDidReceiveFeedback != null) {
      object$.setProperty('onDidReceiveFeedback'.toJS, onDidReceiveFeedback);
    }
    if (requestHandler != null) {
      object$.setProperty('requestHandler'.toJS, requestHandler);
    }
    return ChatParticipantDart(ChatParticipant(object$));
  }
  Stream<ChatResultFeedback> get onDidReceiveFeedbackStream => _eventStream$(
        (listener) => $js.onDidReceiveFeedback.call(listener),
        (raw) => raw as ChatResultFeedback,
      );
}

extension ChatParticipantToDart on ChatParticipant {
  ChatParticipantDart get dart => ChatParticipantDart(this);
}

extension type ChatPromptReferenceDart(ChatPromptReference $js) implements ChatPromptReference {
  factory ChatPromptReferenceDart.lit$({String? id, String? modelDescription, JSTuple_9b5999d5c048? range, JSAny? value}) {
    final object$ = JSObject();
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (modelDescription != null) {
      object$.setProperty('modelDescription'.toJS, modelDescription.toJS);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value);
    }
    return ChatPromptReferenceDart(ChatPromptReference(object$));
  }
}

extension ChatPromptReferenceToDart on ChatPromptReference {
  ChatPromptReferenceDart get dart => ChatPromptReferenceDart(this);
}

extension type ChatRequestDart(ChatRequest $js) implements ChatRequest {
  factory ChatRequestDart.lit$({String? command, LanguageModelChat? model, String? prompt, JSArray<ChatPromptReference>? references, JSAny? toolInvocationToken, JSArray<ChatLanguageModelToolReference>? toolReferences}) {
    final object$ = JSObject();
    if (command != null) {
      object$.setProperty('command'.toJS, command.toJS);
    }
    if (model != null) {
      object$.setProperty('model'.toJS, model);
    }
    if (prompt != null) {
      object$.setProperty('prompt'.toJS, prompt.toJS);
    }
    if (references != null) {
      object$.setProperty('references'.toJS, references);
    }
    if (toolInvocationToken != null) {
      object$.setProperty('toolInvocationToken'.toJS, toolInvocationToken);
    }
    if (toolReferences != null) {
      object$.setProperty('toolReferences'.toJS, toolReferences);
    }
    return ChatRequestDart(ChatRequest(object$));
  }
}

extension ChatRequestToDart on ChatRequest {
  ChatRequestDart get dart => ChatRequestDart(this);
}

extension type ChatResponseFileTreeDart(ChatResponseFileTree $js) implements ChatResponseFileTree {
  factory ChatResponseFileTreeDart.lit$({JSArray<ChatResponseFileTree>? children, String? name}) {
    final object$ = JSObject();
    if (children != null) {
      object$.setProperty('children'.toJS, children);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    return ChatResponseFileTreeDart(ChatResponseFileTree(object$));
  }
}

extension ChatResponseFileTreeToDart on ChatResponseFileTree {
  ChatResponseFileTreeDart get dart => ChatResponseFileTreeDart(this);
}

extension type ChatResponseStreamDart(ChatResponseStream $js) implements ChatResponseStream {
  factory ChatResponseStreamDart.lit$({JSFunction? anchor, JSFunction? button, JSFunction? filetree, JSFunction? markdown, JSFunction? progress, JSFunction? push, JSFunction? reference}) {
    final object$ = JSObject();
    if (anchor != null) {
      object$.setProperty('anchor'.toJS, anchor);
    }
    if (button != null) {
      object$.setProperty('button'.toJS, button);
    }
    if (filetree != null) {
      object$.setProperty('filetree'.toJS, filetree);
    }
    if (markdown != null) {
      object$.setProperty('markdown'.toJS, markdown);
    }
    if (progress != null) {
      object$.setProperty('progress'.toJS, progress);
    }
    if (push != null) {
      object$.setProperty('push'.toJS, push);
    }
    if (reference != null) {
      object$.setProperty('reference'.toJS, reference);
    }
    return ChatResponseStreamDart(ChatResponseStream(object$));
  }
}

extension ChatResponseStreamToDart on ChatResponseStream {
  ChatResponseStreamDart get dart => ChatResponseStreamDart(this);
}

extension type ChatResultDart(ChatResult $js) implements ChatResult {
  factory ChatResultDart.lit$({ChatErrorDetails? errorDetails, JSAnon_cd1da709a211? metadata}) {
    final object$ = JSObject();
    if (errorDetails != null) {
      object$.setProperty('errorDetails'.toJS, errorDetails);
    }
    if (metadata != null) {
      object$.setProperty('metadata'.toJS, metadata);
    }
    return ChatResultDart(ChatResult(object$));
  }
}

extension ChatResultToDart on ChatResult {
  ChatResultDart get dart => ChatResultDart(this);
}

extension type ChatResultFeedbackDart(ChatResultFeedback $js) implements ChatResultFeedback {
  factory ChatResultFeedbackDart.lit$({num? kind, ChatResult? result}) {
    final object$ = JSObject();
    if (kind != null) {
      object$.setProperty('kind'.toJS, kind.toJS);
    }
    if (result != null) {
      object$.setProperty('result'.toJS, result);
    }
    return ChatResultFeedbackDart(ChatResultFeedback(object$));
  }
}

extension ChatResultFeedbackToDart on ChatResultFeedback {
  ChatResultFeedbackDart get dart => ChatResultFeedbackDart(this);
}

extension type ClipboardDart(Clipboard $js) implements Clipboard {
  factory ClipboardDart.lit$({JSFunction? readText, JSFunction? writeText}) {
    final object$ = JSObject();
    if (readText != null) {
      object$.setProperty('readText'.toJS, readText);
    }
    if (writeText != null) {
      object$.setProperty('writeText'.toJS, writeText);
    }
    return ClipboardDart(Clipboard(object$));
  }
  Future<String> readText() => $js.readText().toDart.then((value) => value.toDart);
  Future<JSAny?> writeText(String value) => $js.writeText(value).toDart;
}

extension ClipboardToDart on Clipboard {
  ClipboardDart get dart => ClipboardDart(this);
}

extension type CodeActionContextDart(CodeActionContext $js) implements CodeActionContext {
  factory CodeActionContextDart.lit$({JSArray<Diagnostic>? diagnostics, CodeActionKind? only, num? triggerKind}) {
    final object$ = JSObject();
    if (diagnostics != null) {
      object$.setProperty('diagnostics'.toJS, diagnostics);
    }
    if (only != null) {
      object$.setProperty('only'.toJS, only);
    }
    if (triggerKind != null) {
      object$.setProperty('triggerKind'.toJS, triggerKind.toJS);
    }
    return CodeActionContextDart(CodeActionContext(object$));
  }
}

extension CodeActionContextToDart on CodeActionContext {
  CodeActionContextDart get dart => CodeActionContextDart(this);
}

extension type CodeActionProviderDart<T extends JSAny?>(CodeActionProvider<T> $js) implements CodeActionProvider<T> {
  factory CodeActionProviderDart.lit$({JSFunction? provideCodeActions, JSFunction? resolveCodeAction}) {
    final object$ = JSObject();
    if (provideCodeActions != null) {
      object$.setProperty('provideCodeActions'.toJS, provideCodeActions);
    }
    if (resolveCodeAction != null) {
      object$.setProperty('resolveCodeAction'.toJS, resolveCodeAction);
    }
    return CodeActionProviderDart<T>(CodeActionProvider<T>(object$));
  }
}

extension CodeActionProviderToDart<T extends JSAny?> on CodeActionProvider<T> {
  CodeActionProviderDart<T> get dart => CodeActionProviderDart<T>(this);
}

extension type CodeActionProviderMetadataDart(CodeActionProviderMetadata $js) implements CodeActionProviderMetadata {
  factory CodeActionProviderMetadataDart.lit$({JSArray<JSAnon_f698f56281f5>? documentation, JSArray<CodeActionKind>? providedCodeActionKinds}) {
    final object$ = JSObject();
    if (documentation != null) {
      object$.setProperty('documentation'.toJS, documentation);
    }
    if (providedCodeActionKinds != null) {
      object$.setProperty('providedCodeActionKinds'.toJS, providedCodeActionKinds);
    }
    return CodeActionProviderMetadataDart(CodeActionProviderMetadata(object$));
  }
}

extension CodeActionProviderMetadataToDart on CodeActionProviderMetadata {
  CodeActionProviderMetadataDart get dart => CodeActionProviderMetadataDart(this);
}

extension type CodeLensProviderDart<T extends JSAny?>(CodeLensProvider<T> $js) implements CodeLensProvider<T> {
  factory CodeLensProviderDart.lit$({Event<JSAny?>? onDidChangeCodeLenses, JSFunction? provideCodeLenses, JSFunction? resolveCodeLens}) {
    final object$ = JSObject();
    if (onDidChangeCodeLenses != null) {
      object$.setProperty('onDidChangeCodeLenses'.toJS, onDidChangeCodeLenses);
    }
    if (provideCodeLenses != null) {
      object$.setProperty('provideCodeLenses'.toJS, provideCodeLenses);
    }
    if (resolveCodeLens != null) {
      object$.setProperty('resolveCodeLens'.toJS, resolveCodeLens);
    }
    return CodeLensProviderDart<T>(CodeLensProvider<T>(object$));
  }
  Stream<JSAny?>? get onDidChangeCodeLensesStream {
    final event$ = $js.onDidChangeCodeLenses;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension CodeLensProviderToDart<T extends JSAny?> on CodeLensProvider<T> {
  CodeLensProviderDart<T> get dart => CodeLensProviderDart<T>(this);
}

extension type ColorThemeDart(ColorTheme $js) implements ColorTheme {
  factory ColorThemeDart.lit$({num? kind}) {
    final object$ = JSObject();
    if (kind != null) {
      object$.setProperty('kind'.toJS, kind.toJS);
    }
    return ColorThemeDart(ColorTheme(object$));
  }
}

extension ColorThemeToDart on ColorTheme {
  ColorThemeDart get dart => ColorThemeDart(this);
}

extension type CommandDart(Command $js) implements Command {
  factory CommandDart.lit$({JSArray<JSAny?>? arguments, String? command, String? title, String? tooltip}) {
    final object$ = JSObject();
    if (arguments != null) {
      object$.setProperty('arguments'.toJS, arguments);
    }
    if (command != null) {
      object$.setProperty('command'.toJS, command.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    if (tooltip != null) {
      object$.setProperty('tooltip'.toJS, tooltip.toJS);
    }
    return CommandDart(Command(object$));
  }
}

extension CommandToDart on Command {
  CommandDart get dart => CommandDart(this);
}

extension type CommentDart(Comment $js) implements Comment {
  factory CommentDart.lit$({CommentAuthorInformation? author, JSAny? body, String? contextValue, String? label, num? mode, JSArray<CommentReaction>? reactions, JSObject? timestamp}) {
    final object$ = JSObject();
    if (author != null) {
      object$.setProperty('author'.toJS, author);
    }
    if (body != null) {
      object$.setProperty('body'.toJS, body);
    }
    if (contextValue != null) {
      object$.setProperty('contextValue'.toJS, contextValue.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (mode != null) {
      object$.setProperty('mode'.toJS, mode.toJS);
    }
    if (reactions != null) {
      object$.setProperty('reactions'.toJS, reactions);
    }
    if (timestamp != null) {
      object$.setProperty('timestamp'.toJS, timestamp);
    }
    return CommentDart(Comment(object$));
  }
}

extension CommentToDart on Comment {
  CommentDart get dart => CommentDart(this);
}

extension type CommentAuthorInformationDart(CommentAuthorInformation $js) implements CommentAuthorInformation {
  factory CommentAuthorInformationDart.lit$({Uri? iconPath, String? name}) {
    final object$ = JSObject();
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    return CommentAuthorInformationDart(CommentAuthorInformation(object$));
  }
}

extension CommentAuthorInformationToDart on CommentAuthorInformation {
  CommentAuthorInformationDart get dart => CommentAuthorInformationDart(this);
}

extension type CommentControllerDart(CommentController $js) implements CommentController {
  factory CommentControllerDart.lit$({CommentingRangeProvider? commentingRangeProvider, JSFunction? createCommentThread, JSFunction? dispose, String? id, String? label, CommentOptions? options, JSFunction? reactionHandler}) {
    final object$ = JSObject();
    if (commentingRangeProvider != null) {
      object$.setProperty('commentingRangeProvider'.toJS, commentingRangeProvider);
    }
    if (createCommentThread != null) {
      object$.setProperty('createCommentThread'.toJS, createCommentThread);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (options != null) {
      object$.setProperty('options'.toJS, options);
    }
    if (reactionHandler != null) {
      object$.setProperty('reactionHandler'.toJS, reactionHandler);
    }
    return CommentControllerDart(CommentController(object$));
  }
}

extension CommentControllerToDart on CommentController {
  CommentControllerDart get dart => CommentControllerDart(this);
}

extension type CommentOptionsDart(CommentOptions $js) implements CommentOptions {
  factory CommentOptionsDart.lit$({String? placeHolder, String? prompt}) {
    final object$ = JSObject();
    if (placeHolder != null) {
      object$.setProperty('placeHolder'.toJS, placeHolder.toJS);
    }
    if (prompt != null) {
      object$.setProperty('prompt'.toJS, prompt.toJS);
    }
    return CommentOptionsDart(CommentOptions(object$));
  }
}

extension CommentOptionsToDart on CommentOptions {
  CommentOptionsDart get dart => CommentOptionsDart(this);
}

extension type CommentReactionDart(CommentReaction $js) implements CommentReaction {
  factory CommentReactionDart.lit$({bool? authorHasReacted, num? count, JSAny? iconPath, String? label}) {
    final object$ = JSObject();
    if (authorHasReacted != null) {
      object$.setProperty('authorHasReacted'.toJS, authorHasReacted.toJS);
    }
    if (count != null) {
      object$.setProperty('count'.toJS, count.toJS);
    }
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    return CommentReactionDart(CommentReaction(object$));
  }
}

extension CommentReactionToDart on CommentReaction {
  CommentReactionDart get dart => CommentReactionDart(this);
}

extension type CommentReplyDart(CommentReply $js) implements CommentReply {
  factory CommentReplyDart.lit$({String? text, CommentThread? thread}) {
    final object$ = JSObject();
    if (text != null) {
      object$.setProperty('text'.toJS, text.toJS);
    }
    if (thread != null) {
      object$.setProperty('thread'.toJS, thread);
    }
    return CommentReplyDart(CommentReply(object$));
  }
}

extension CommentReplyToDart on CommentReply {
  CommentReplyDart get dart => CommentReplyDart(this);
}

extension type CommentRuleDart(CommentRule $js) implements CommentRule {
  factory CommentRuleDart.lit$({JSTuple_58c6c79a4e36? blockComment, JSAny? lineComment}) {
    final object$ = JSObject();
    if (blockComment != null) {
      object$.setProperty('blockComment'.toJS, blockComment);
    }
    if (lineComment != null) {
      object$.setProperty('lineComment'.toJS, lineComment);
    }
    return CommentRuleDart(CommentRule(object$));
  }
}

extension CommentRuleToDart on CommentRule {
  CommentRuleDart get dart => CommentRuleDart(this);
}

extension type CommentThreadDart(CommentThread $js) implements CommentThread {
  factory CommentThreadDart.lit$({JSAny? canReply, num? collapsibleState, JSArray<Comment>? comments, String? contextValue, JSFunction? dispose, String? label, Range? range, num? state, Uri? uri}) {
    final object$ = JSObject();
    if (canReply != null) {
      object$.setProperty('canReply'.toJS, canReply);
    }
    if (collapsibleState != null) {
      object$.setProperty('collapsibleState'.toJS, collapsibleState.toJS);
    }
    if (comments != null) {
      object$.setProperty('comments'.toJS, comments);
    }
    if (contextValue != null) {
      object$.setProperty('contextValue'.toJS, contextValue.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    if (state != null) {
      object$.setProperty('state'.toJS, state.toJS);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return CommentThreadDart(CommentThread(object$));
  }
}

extension CommentThreadToDart on CommentThread {
  CommentThreadDart get dart => CommentThreadDart(this);
}

extension type CommentingRangeProviderDart(CommentingRangeProvider $js) implements CommentingRangeProvider {
  factory CommentingRangeProviderDart.lit$({JSFunction? provideCommentingRanges}) {
    final object$ = JSObject();
    if (provideCommentingRanges != null) {
      object$.setProperty('provideCommentingRanges'.toJS, provideCommentingRanges);
    }
    return CommentingRangeProviderDart(CommentingRangeProvider(object$));
  }
}

extension CommentingRangeProviderToDart on CommentingRangeProvider {
  CommentingRangeProviderDart get dart => CommentingRangeProviderDart(this);
}

extension type CommentingRangesDart(CommentingRanges $js) implements CommentingRanges {
  factory CommentingRangesDart.lit$({bool? enableFileComments, JSArray<Range>? ranges}) {
    final object$ = JSObject();
    if (enableFileComments != null) {
      object$.setProperty('enableFileComments'.toJS, enableFileComments.toJS);
    }
    if (ranges != null) {
      object$.setProperty('ranges'.toJS, ranges);
    }
    return CommentingRangesDart(CommentingRanges(object$));
  }
}

extension CommentingRangesToDart on CommentingRanges {
  CommentingRangesDart get dart => CommentingRangesDart(this);
}

extension type CompletionContextDart(CompletionContext $js) implements CompletionContext {
  factory CompletionContextDart.lit$({String? triggerCharacter, num? triggerKind}) {
    final object$ = JSObject();
    if (triggerCharacter != null) {
      object$.setProperty('triggerCharacter'.toJS, triggerCharacter.toJS);
    }
    if (triggerKind != null) {
      object$.setProperty('triggerKind'.toJS, triggerKind.toJS);
    }
    return CompletionContextDart(CompletionContext(object$));
  }
}

extension CompletionContextToDart on CompletionContext {
  CompletionContextDart get dart => CompletionContextDart(this);
}

extension type CompletionItemLabelDart(CompletionItemLabel $js) implements CompletionItemLabel {
  factory CompletionItemLabelDart.lit$({String? description, String? detail, String? label}) {
    final object$ = JSObject();
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (detail != null) {
      object$.setProperty('detail'.toJS, detail.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    return CompletionItemLabelDart(CompletionItemLabel(object$));
  }
}

extension CompletionItemLabelToDart on CompletionItemLabel {
  CompletionItemLabelDart get dart => CompletionItemLabelDart(this);
}

extension type CompletionItemProviderDart<T extends JSAny?>(CompletionItemProvider<T> $js) implements CompletionItemProvider<T> {
  factory CompletionItemProviderDart.lit$({JSFunction? provideCompletionItems, JSFunction? resolveCompletionItem}) {
    final object$ = JSObject();
    if (provideCompletionItems != null) {
      object$.setProperty('provideCompletionItems'.toJS, provideCompletionItems);
    }
    if (resolveCompletionItem != null) {
      object$.setProperty('resolveCompletionItem'.toJS, resolveCompletionItem);
    }
    return CompletionItemProviderDart<T>(CompletionItemProvider<T>(object$));
  }
}

extension CompletionItemProviderToDart<T extends JSAny?> on CompletionItemProvider<T> {
  CompletionItemProviderDart<T> get dart => CompletionItemProviderDart<T>(this);
}

extension type ConfigurationChangeEventDart(ConfigurationChangeEvent $js) implements ConfigurationChangeEvent {
  factory ConfigurationChangeEventDart.lit$({JSFunction? affectsConfiguration}) {
    final object$ = JSObject();
    if (affectsConfiguration != null) {
      object$.setProperty('affectsConfiguration'.toJS, affectsConfiguration);
    }
    return ConfigurationChangeEventDart(ConfigurationChangeEvent(object$));
  }
}

extension ConfigurationChangeEventToDart on ConfigurationChangeEvent {
  ConfigurationChangeEventDart get dart => ConfigurationChangeEventDart(this);
}

extension type CustomDocumentDart(CustomDocument $js) implements CustomDocument {
  factory CustomDocumentDart.lit$({JSFunction? dispose, Uri? uri}) {
    final object$ = JSObject();
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return CustomDocumentDart(CustomDocument(object$));
  }
}

extension CustomDocumentToDart on CustomDocument {
  CustomDocumentDart get dart => CustomDocumentDart(this);
}

extension type CustomDocumentBackupDart(CustomDocumentBackup $js) implements CustomDocumentBackup {
  factory CustomDocumentBackupDart.lit$({JSFunction? delete, String? id}) {
    final object$ = JSObject();
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    return CustomDocumentBackupDart(CustomDocumentBackup(object$));
  }
}

extension CustomDocumentBackupToDart on CustomDocumentBackup {
  CustomDocumentBackupDart get dart => CustomDocumentBackupDart(this);
}

extension type CustomDocumentBackupContextDart(CustomDocumentBackupContext $js) implements CustomDocumentBackupContext {
  factory CustomDocumentBackupContextDart.lit$({Uri? destination}) {
    final object$ = JSObject();
    if (destination != null) {
      object$.setProperty('destination'.toJS, destination);
    }
    return CustomDocumentBackupContextDart(CustomDocumentBackupContext(object$));
  }
}

extension CustomDocumentBackupContextToDart on CustomDocumentBackupContext {
  CustomDocumentBackupContextDart get dart => CustomDocumentBackupContextDart(this);
}

extension type CustomDocumentContentChangeEventDart<T extends JSAny?>(CustomDocumentContentChangeEvent<T> $js) implements CustomDocumentContentChangeEvent<T> {
  factory CustomDocumentContentChangeEventDart.lit$({T? document}) {
    final object$ = JSObject();
    if (document != null) {
      object$.setProperty('document'.toJS, document);
    }
    return CustomDocumentContentChangeEventDart<T>(CustomDocumentContentChangeEvent<T>(object$));
  }
}

extension CustomDocumentContentChangeEventToDart<T extends JSAny?> on CustomDocumentContentChangeEvent<T> {
  CustomDocumentContentChangeEventDart<T> get dart => CustomDocumentContentChangeEventDart<T>(this);
}

extension type CustomDocumentEditEventDart<T extends JSAny?>(CustomDocumentEditEvent<T> $js) implements CustomDocumentEditEvent<T> {
  factory CustomDocumentEditEventDart.lit$({T? document, String? label, JSFunction? redo, JSFunction? undo}) {
    final object$ = JSObject();
    if (document != null) {
      object$.setProperty('document'.toJS, document);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (redo != null) {
      object$.setProperty('redo'.toJS, redo);
    }
    if (undo != null) {
      object$.setProperty('undo'.toJS, undo);
    }
    return CustomDocumentEditEventDart<T>(CustomDocumentEditEvent<T>(object$));
  }
}

extension CustomDocumentEditEventToDart<T extends JSAny?> on CustomDocumentEditEvent<T> {
  CustomDocumentEditEventDart<T> get dart => CustomDocumentEditEventDart<T>(this);
}

extension type CustomDocumentOpenContextDart(CustomDocumentOpenContext $js) implements CustomDocumentOpenContext {
  factory CustomDocumentOpenContextDart.lit$({String? backupId, JSUint8Array? untitledDocumentData}) {
    final object$ = JSObject();
    if (backupId != null) {
      object$.setProperty('backupId'.toJS, backupId.toJS);
    }
    if (untitledDocumentData != null) {
      object$.setProperty('untitledDocumentData'.toJS, untitledDocumentData);
    }
    return CustomDocumentOpenContextDart(CustomDocumentOpenContext(object$));
  }
}

extension CustomDocumentOpenContextToDart on CustomDocumentOpenContext {
  CustomDocumentOpenContextDart get dart => CustomDocumentOpenContextDart(this);
}

extension type CustomEditorProviderDart<T extends JSAny?>(CustomEditorProvider<T> $js) implements CustomEditorProvider<T> {
  factory CustomEditorProviderDart.lit$({JSFunction? backupCustomDocument, JSObject? onDidChangeCustomDocument, JSFunction? revertCustomDocument, JSFunction? saveCustomDocument, JSFunction? saveCustomDocumentAs, JSFunction? openCustomDocument, JSFunction? resolveCustomEditor}) {
    final object$ = JSObject();
    if (backupCustomDocument != null) {
      object$.setProperty('backupCustomDocument'.toJS, backupCustomDocument);
    }
    if (onDidChangeCustomDocument != null) {
      object$.setProperty('onDidChangeCustomDocument'.toJS, onDidChangeCustomDocument);
    }
    if (revertCustomDocument != null) {
      object$.setProperty('revertCustomDocument'.toJS, revertCustomDocument);
    }
    if (saveCustomDocument != null) {
      object$.setProperty('saveCustomDocument'.toJS, saveCustomDocument);
    }
    if (saveCustomDocumentAs != null) {
      object$.setProperty('saveCustomDocumentAs'.toJS, saveCustomDocumentAs);
    }
    if (openCustomDocument != null) {
      object$.setProperty('openCustomDocument'.toJS, openCustomDocument);
    }
    if (resolveCustomEditor != null) {
      object$.setProperty('resolveCustomEditor'.toJS, resolveCustomEditor);
    }
    return CustomEditorProviderDart<T>(CustomEditorProvider<T>(object$));
  }
  Future<CustomDocumentBackup> backupCustomDocument(T document, CustomDocumentBackupContext context, CancellationToken cancellation) => $js.backupCustomDocument(document, context, cancellation).toDart;
  Future<JSAny?> revertCustomDocument(T document, CancellationToken cancellation) => $js.revertCustomDocument(document, cancellation).toDart;
  Future<JSAny?> saveCustomDocument(T document, CancellationToken cancellation) => $js.saveCustomDocument(document, cancellation).toDart;
  Future<JSAny?> saveCustomDocumentAs(T document, Uri destination, CancellationToken cancellation) => $js.saveCustomDocumentAs(document, destination, cancellation).toDart;
}

extension CustomEditorProviderToDart<T extends JSAny?> on CustomEditorProvider<T> {
  CustomEditorProviderDart<T> get dart => CustomEditorProviderDart<T>(this);
}

extension type CustomReadonlyEditorProviderDart<T extends JSAny?>(CustomReadonlyEditorProvider<T> $js) implements CustomReadonlyEditorProvider<T> {
  factory CustomReadonlyEditorProviderDart.lit$({JSFunction? openCustomDocument, JSFunction? resolveCustomEditor}) {
    final object$ = JSObject();
    if (openCustomDocument != null) {
      object$.setProperty('openCustomDocument'.toJS, openCustomDocument);
    }
    if (resolveCustomEditor != null) {
      object$.setProperty('resolveCustomEditor'.toJS, resolveCustomEditor);
    }
    return CustomReadonlyEditorProviderDart<T>(CustomReadonlyEditorProvider<T>(object$));
  }
}

extension CustomReadonlyEditorProviderToDart<T extends JSAny?> on CustomReadonlyEditorProvider<T> {
  CustomReadonlyEditorProviderDart<T> get dart => CustomReadonlyEditorProviderDart<T>(this);
}

extension type CustomTextEditorProviderDart(CustomTextEditorProvider $js) implements CustomTextEditorProvider {
  factory CustomTextEditorProviderDart.lit$({JSFunction? resolveCustomTextEditor}) {
    final object$ = JSObject();
    if (resolveCustomTextEditor != null) {
      object$.setProperty('resolveCustomTextEditor'.toJS, resolveCustomTextEditor);
    }
    return CustomTextEditorProviderDart(CustomTextEditorProvider(object$));
  }
}

extension CustomTextEditorProviderToDart on CustomTextEditorProvider {
  CustomTextEditorProviderDart get dart => CustomTextEditorProviderDart(this);
}

extension type DataTransferFileDart(DataTransferFile $js) implements DataTransferFile {
  factory DataTransferFileDart.lit$({JSFunction? data, String? name, Uri? uri}) {
    final object$ = JSObject();
    if (data != null) {
      object$.setProperty('data'.toJS, data);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return DataTransferFileDart(DataTransferFile(object$));
  }
  Future<JSUint8Array> data() => $js.data().toDart;
}

extension DataTransferFileToDart on DataTransferFile {
  DataTransferFileDart get dart => DataTransferFileDart(this);
}

extension type DebugAdapterDart(DebugAdapter $js) implements DebugAdapter {
  factory DebugAdapterDart.lit$({JSFunction? handleMessage, Event<DebugProtocolMessage>? onDidSendMessage, JSFunction? dispose}) {
    final object$ = JSObject();
    if (handleMessage != null) {
      object$.setProperty('handleMessage'.toJS, handleMessage);
    }
    if (onDidSendMessage != null) {
      object$.setProperty('onDidSendMessage'.toJS, onDidSendMessage);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    return DebugAdapterDart(DebugAdapter(object$));
  }
  Stream<DebugProtocolMessage> get onDidSendMessageStream => _eventStream$(
        (listener) => $js.onDidSendMessage.call(listener),
        (raw) => raw as DebugProtocolMessage,
      );
}

extension DebugAdapterToDart on DebugAdapter {
  DebugAdapterDart get dart => DebugAdapterDart(this);
}

extension type DebugAdapterDescriptorFactoryDart(DebugAdapterDescriptorFactory $js) implements DebugAdapterDescriptorFactory {
  factory DebugAdapterDescriptorFactoryDart.lit$({JSFunction? createDebugAdapterDescriptor}) {
    final object$ = JSObject();
    if (createDebugAdapterDescriptor != null) {
      object$.setProperty('createDebugAdapterDescriptor'.toJS, createDebugAdapterDescriptor);
    }
    return DebugAdapterDescriptorFactoryDart(DebugAdapterDescriptorFactory(object$));
  }
}

extension DebugAdapterDescriptorFactoryToDart on DebugAdapterDescriptorFactory {
  DebugAdapterDescriptorFactoryDart get dart => DebugAdapterDescriptorFactoryDart(this);
}

extension type DebugAdapterExecutableOptionsDart(DebugAdapterExecutableOptions $js) implements DebugAdapterExecutableOptions {
  factory DebugAdapterExecutableOptionsDart.lit$({String? cwd, JSAnon_c77c8585355a? env}) {
    final object$ = JSObject();
    if (cwd != null) {
      object$.setProperty('cwd'.toJS, cwd.toJS);
    }
    if (env != null) {
      object$.setProperty('env'.toJS, env);
    }
    return DebugAdapterExecutableOptionsDart(DebugAdapterExecutableOptions(object$));
  }
}

extension DebugAdapterExecutableOptionsToDart on DebugAdapterExecutableOptions {
  DebugAdapterExecutableOptionsDart get dart => DebugAdapterExecutableOptionsDart(this);
}

extension type DebugAdapterTrackerDart(DebugAdapterTracker $js) implements DebugAdapterTracker {
  factory DebugAdapterTrackerDart.lit$({JSFunction? onDidSendMessage, JSFunction? onError, JSFunction? onExit, JSFunction? onWillReceiveMessage, JSFunction? onWillStartSession, JSFunction? onWillStopSession}) {
    final object$ = JSObject();
    if (onDidSendMessage != null) {
      object$.setProperty('onDidSendMessage'.toJS, onDidSendMessage);
    }
    if (onError != null) {
      object$.setProperty('onError'.toJS, onError);
    }
    if (onExit != null) {
      object$.setProperty('onExit'.toJS, onExit);
    }
    if (onWillReceiveMessage != null) {
      object$.setProperty('onWillReceiveMessage'.toJS, onWillReceiveMessage);
    }
    if (onWillStartSession != null) {
      object$.setProperty('onWillStartSession'.toJS, onWillStartSession);
    }
    if (onWillStopSession != null) {
      object$.setProperty('onWillStopSession'.toJS, onWillStopSession);
    }
    return DebugAdapterTrackerDart(DebugAdapterTracker(object$));
  }
}

extension DebugAdapterTrackerToDart on DebugAdapterTracker {
  DebugAdapterTrackerDart get dart => DebugAdapterTrackerDart(this);
}

extension type DebugAdapterTrackerFactoryDart(DebugAdapterTrackerFactory $js) implements DebugAdapterTrackerFactory {
  factory DebugAdapterTrackerFactoryDart.lit$({JSFunction? createDebugAdapterTracker}) {
    final object$ = JSObject();
    if (createDebugAdapterTracker != null) {
      object$.setProperty('createDebugAdapterTracker'.toJS, createDebugAdapterTracker);
    }
    return DebugAdapterTrackerFactoryDart(DebugAdapterTrackerFactory(object$));
  }
}

extension DebugAdapterTrackerFactoryToDart on DebugAdapterTrackerFactory {
  DebugAdapterTrackerFactoryDart get dart => DebugAdapterTrackerFactoryDart(this);
}

extension type DebugConfigurationDart(DebugConfiguration $js) implements DebugConfiguration {
  factory DebugConfigurationDart.lit$({String? name, String? request, String? type}) {
    final object$ = JSObject();
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (request != null) {
      object$.setProperty('request'.toJS, request.toJS);
    }
    if (type != null) {
      object$.setProperty('type'.toJS, type.toJS);
    }
    return DebugConfigurationDart(DebugConfiguration(object$));
  }
}

extension DebugConfigurationToDart on DebugConfiguration {
  DebugConfigurationDart get dart => DebugConfigurationDart(this);
}

extension type DebugConfigurationProviderDart(DebugConfigurationProvider $js) implements DebugConfigurationProvider {
  factory DebugConfigurationProviderDart.lit$({JSFunction? provideDebugConfigurations, JSFunction? resolveDebugConfiguration, JSFunction? resolveDebugConfigurationWithSubstitutedVariables}) {
    final object$ = JSObject();
    if (provideDebugConfigurations != null) {
      object$.setProperty('provideDebugConfigurations'.toJS, provideDebugConfigurations);
    }
    if (resolveDebugConfiguration != null) {
      object$.setProperty('resolveDebugConfiguration'.toJS, resolveDebugConfiguration);
    }
    if (resolveDebugConfigurationWithSubstitutedVariables != null) {
      object$.setProperty('resolveDebugConfigurationWithSubstitutedVariables'.toJS, resolveDebugConfigurationWithSubstitutedVariables);
    }
    return DebugConfigurationProviderDart(DebugConfigurationProvider(object$));
  }
}

extension DebugConfigurationProviderToDart on DebugConfigurationProvider {
  DebugConfigurationProviderDart get dart => DebugConfigurationProviderDart(this);
}

extension type DebugConsoleDart(DebugConsole $js) implements DebugConsole {
  factory DebugConsoleDart.lit$({JSFunction? append, JSFunction? appendLine}) {
    final object$ = JSObject();
    if (append != null) {
      object$.setProperty('append'.toJS, append);
    }
    if (appendLine != null) {
      object$.setProperty('appendLine'.toJS, appendLine);
    }
    return DebugConsoleDart(DebugConsole(object$));
  }
}

extension DebugConsoleToDart on DebugConsole {
  DebugConsoleDart get dart => DebugConsoleDart(this);
}

extension type DebugSessionDart(DebugSession $js) implements DebugSession {
  factory DebugSessionDart.lit$({DebugConfiguration? configuration, JSFunction? customRequest, JSFunction? getDebugProtocolBreakpoint, String? id, String? name, DebugSession? parentSession, String? type, WorkspaceFolder? workspaceFolder}) {
    final object$ = JSObject();
    if (configuration != null) {
      object$.setProperty('configuration'.toJS, configuration);
    }
    if (customRequest != null) {
      object$.setProperty('customRequest'.toJS, customRequest);
    }
    if (getDebugProtocolBreakpoint != null) {
      object$.setProperty('getDebugProtocolBreakpoint'.toJS, getDebugProtocolBreakpoint);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (parentSession != null) {
      object$.setProperty('parentSession'.toJS, parentSession);
    }
    if (type != null) {
      object$.setProperty('type'.toJS, type.toJS);
    }
    if (workspaceFolder != null) {
      object$.setProperty('workspaceFolder'.toJS, workspaceFolder);
    }
    return DebugSessionDart(DebugSession(object$));
  }
  Future<JSAny?> customRequest(String command, [JSAny? args]) => (args != null ? $js.customRequest(command, args) : $js.customRequest(command)).toDart;
  Future<DebugProtocolBreakpoint?> getDebugProtocolBreakpoint(Breakpoint breakpoint) => $js.getDebugProtocolBreakpoint(breakpoint).toDart;
}

extension DebugSessionToDart on DebugSession {
  DebugSessionDart get dart => DebugSessionDart(this);
}

extension type DebugSessionCustomEventDart(DebugSessionCustomEvent $js) implements DebugSessionCustomEvent {
  factory DebugSessionCustomEventDart.lit$({JSAny? body, String? event, DebugSession? session}) {
    final object$ = JSObject();
    if (body != null) {
      object$.setProperty('body'.toJS, body);
    }
    if (event != null) {
      object$.setProperty('event'.toJS, event.toJS);
    }
    if (session != null) {
      object$.setProperty('session'.toJS, session);
    }
    return DebugSessionCustomEventDart(DebugSessionCustomEvent(object$));
  }
}

extension DebugSessionCustomEventToDart on DebugSessionCustomEvent {
  DebugSessionCustomEventDart get dart => DebugSessionCustomEventDart(this);
}

extension type DebugSessionOptionsDart(DebugSessionOptions $js) implements DebugSessionOptions {
  factory DebugSessionOptionsDart.lit$({bool? compact, num? consoleMode, bool? lifecycleManagedByParent, bool? noDebug, DebugSession? parentSession, bool? suppressDebugStatusbar, bool? suppressDebugToolbar, bool? suppressDebugView, bool? suppressSaveBeforeStart, TestRun? testRun}) {
    final object$ = JSObject();
    if (compact != null) {
      object$.setProperty('compact'.toJS, compact.toJS);
    }
    if (consoleMode != null) {
      object$.setProperty('consoleMode'.toJS, consoleMode.toJS);
    }
    if (lifecycleManagedByParent != null) {
      object$.setProperty('lifecycleManagedByParent'.toJS, lifecycleManagedByParent.toJS);
    }
    if (noDebug != null) {
      object$.setProperty('noDebug'.toJS, noDebug.toJS);
    }
    if (parentSession != null) {
      object$.setProperty('parentSession'.toJS, parentSession);
    }
    if (suppressDebugStatusbar != null) {
      object$.setProperty('suppressDebugStatusbar'.toJS, suppressDebugStatusbar.toJS);
    }
    if (suppressDebugToolbar != null) {
      object$.setProperty('suppressDebugToolbar'.toJS, suppressDebugToolbar.toJS);
    }
    if (suppressDebugView != null) {
      object$.setProperty('suppressDebugView'.toJS, suppressDebugView.toJS);
    }
    if (suppressSaveBeforeStart != null) {
      object$.setProperty('suppressSaveBeforeStart'.toJS, suppressSaveBeforeStart.toJS);
    }
    if (testRun != null) {
      object$.setProperty('testRun'.toJS, testRun);
    }
    return DebugSessionOptionsDart(DebugSessionOptions(object$));
  }
}

extension DebugSessionOptionsToDart on DebugSessionOptions {
  DebugSessionOptionsDart get dart => DebugSessionOptionsDart(this);
}

extension type DeclarationProviderDart(DeclarationProvider $js) implements DeclarationProvider {
  factory DeclarationProviderDart.lit$({JSFunction? provideDeclaration}) {
    final object$ = JSObject();
    if (provideDeclaration != null) {
      object$.setProperty('provideDeclaration'.toJS, provideDeclaration);
    }
    return DeclarationProviderDart(DeclarationProvider(object$));
  }
}

extension DeclarationProviderToDart on DeclarationProvider {
  DeclarationProviderDart get dart => DeclarationProviderDart(this);
}

extension type DecorationInstanceRenderOptionsDart(DecorationInstanceRenderOptions $js) implements DecorationInstanceRenderOptions {
  factory DecorationInstanceRenderOptionsDart.lit$({ThemableDecorationInstanceRenderOptions? dark, ThemableDecorationInstanceRenderOptions? light, ThemableDecorationAttachmentRenderOptions? after, ThemableDecorationAttachmentRenderOptions? before}) {
    final object$ = JSObject();
    if (dark != null) {
      object$.setProperty('dark'.toJS, dark);
    }
    if (light != null) {
      object$.setProperty('light'.toJS, light);
    }
    if (after != null) {
      object$.setProperty('after'.toJS, after);
    }
    if (before != null) {
      object$.setProperty('before'.toJS, before);
    }
    return DecorationInstanceRenderOptionsDart(DecorationInstanceRenderOptions(object$));
  }
}

extension DecorationInstanceRenderOptionsToDart on DecorationInstanceRenderOptions {
  DecorationInstanceRenderOptionsDart get dart => DecorationInstanceRenderOptionsDart(this);
}

extension type DecorationOptionsDart(DecorationOptions $js) implements DecorationOptions {
  factory DecorationOptionsDart.lit$({JSAny? hoverMessage, Range? range, DecorationInstanceRenderOptions? renderOptions}) {
    final object$ = JSObject();
    if (hoverMessage != null) {
      object$.setProperty('hoverMessage'.toJS, hoverMessage);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    if (renderOptions != null) {
      object$.setProperty('renderOptions'.toJS, renderOptions);
    }
    return DecorationOptionsDart(DecorationOptions(object$));
  }
}

extension DecorationOptionsToDart on DecorationOptions {
  DecorationOptionsDart get dart => DecorationOptionsDart(this);
}

extension type DecorationRenderOptionsDart(DecorationRenderOptions $js) implements DecorationRenderOptions {
  factory DecorationRenderOptionsDart.lit$({ThemableDecorationRenderOptions? dark, bool? isWholeLine, ThemableDecorationRenderOptions? light, num? overviewRulerLane, num? rangeBehavior, ThemableDecorationAttachmentRenderOptions? after, JSAny? backgroundColor, ThemableDecorationAttachmentRenderOptions? before, String? border, JSAny? borderColor, String? borderRadius, String? borderSpacing, String? borderStyle, String? borderWidth, JSAny? color, String? cursor, String? fontStyle, String? fontWeight, JSAny? gutterIconPath, String? gutterIconSize, String? letterSpacing, String? opacity, String? outline, JSAny? outlineColor, String? outlineStyle, String? outlineWidth, JSAny? overviewRulerColor, String? textDecoration}) {
    final object$ = JSObject();
    if (dark != null) {
      object$.setProperty('dark'.toJS, dark);
    }
    if (isWholeLine != null) {
      object$.setProperty('isWholeLine'.toJS, isWholeLine.toJS);
    }
    if (light != null) {
      object$.setProperty('light'.toJS, light);
    }
    if (overviewRulerLane != null) {
      object$.setProperty('overviewRulerLane'.toJS, overviewRulerLane.toJS);
    }
    if (rangeBehavior != null) {
      object$.setProperty('rangeBehavior'.toJS, rangeBehavior.toJS);
    }
    if (after != null) {
      object$.setProperty('after'.toJS, after);
    }
    if (backgroundColor != null) {
      object$.setProperty('backgroundColor'.toJS, backgroundColor);
    }
    if (before != null) {
      object$.setProperty('before'.toJS, before);
    }
    if (border != null) {
      object$.setProperty('border'.toJS, border.toJS);
    }
    if (borderColor != null) {
      object$.setProperty('borderColor'.toJS, borderColor);
    }
    if (borderRadius != null) {
      object$.setProperty('borderRadius'.toJS, borderRadius.toJS);
    }
    if (borderSpacing != null) {
      object$.setProperty('borderSpacing'.toJS, borderSpacing.toJS);
    }
    if (borderStyle != null) {
      object$.setProperty('borderStyle'.toJS, borderStyle.toJS);
    }
    if (borderWidth != null) {
      object$.setProperty('borderWidth'.toJS, borderWidth.toJS);
    }
    if (color != null) {
      object$.setProperty('color'.toJS, color);
    }
    if (cursor != null) {
      object$.setProperty('cursor'.toJS, cursor.toJS);
    }
    if (fontStyle != null) {
      object$.setProperty('fontStyle'.toJS, fontStyle.toJS);
    }
    if (fontWeight != null) {
      object$.setProperty('fontWeight'.toJS, fontWeight.toJS);
    }
    if (gutterIconPath != null) {
      object$.setProperty('gutterIconPath'.toJS, gutterIconPath);
    }
    if (gutterIconSize != null) {
      object$.setProperty('gutterIconSize'.toJS, gutterIconSize.toJS);
    }
    if (letterSpacing != null) {
      object$.setProperty('letterSpacing'.toJS, letterSpacing.toJS);
    }
    if (opacity != null) {
      object$.setProperty('opacity'.toJS, opacity.toJS);
    }
    if (outline != null) {
      object$.setProperty('outline'.toJS, outline.toJS);
    }
    if (outlineColor != null) {
      object$.setProperty('outlineColor'.toJS, outlineColor);
    }
    if (outlineStyle != null) {
      object$.setProperty('outlineStyle'.toJS, outlineStyle.toJS);
    }
    if (outlineWidth != null) {
      object$.setProperty('outlineWidth'.toJS, outlineWidth.toJS);
    }
    if (overviewRulerColor != null) {
      object$.setProperty('overviewRulerColor'.toJS, overviewRulerColor);
    }
    if (textDecoration != null) {
      object$.setProperty('textDecoration'.toJS, textDecoration.toJS);
    }
    return DecorationRenderOptionsDart(DecorationRenderOptions(object$));
  }
}

extension DecorationRenderOptionsToDart on DecorationRenderOptions {
  DecorationRenderOptionsDart get dart => DecorationRenderOptionsDart(this);
}

extension type DefinitionProviderDart(DefinitionProvider $js) implements DefinitionProvider {
  factory DefinitionProviderDart.lit$({JSFunction? provideDefinition}) {
    final object$ = JSObject();
    if (provideDefinition != null) {
      object$.setProperty('provideDefinition'.toJS, provideDefinition);
    }
    return DefinitionProviderDart(DefinitionProvider(object$));
  }
}

extension DefinitionProviderToDart on DefinitionProvider {
  DefinitionProviderDart get dart => DefinitionProviderDart(this);
}

extension type DiagnosticChangeEventDart(DiagnosticChangeEvent $js) implements DiagnosticChangeEvent {
  factory DiagnosticChangeEventDart.lit$({JSArray<Uri>? uris}) {
    final object$ = JSObject();
    if (uris != null) {
      object$.setProperty('uris'.toJS, uris);
    }
    return DiagnosticChangeEventDart(DiagnosticChangeEvent(object$));
  }
}

extension DiagnosticChangeEventToDart on DiagnosticChangeEvent {
  DiagnosticChangeEventDart get dart => DiagnosticChangeEventDart(this);
}

extension type DiagnosticCollectionDart(DiagnosticCollection $js) implements DiagnosticCollection {
  factory DiagnosticCollectionDart.lit$({JSFunction? clear, JSFunction? delete, JSFunction? dispose, JSFunction? forEach, JSFunction? get, JSFunction? has, String? name, JSFunction? set}) {
    final object$ = JSObject();
    if (clear != null) {
      object$.setProperty('clear'.toJS, clear);
    }
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (forEach != null) {
      object$.setProperty('forEach'.toJS, forEach);
    }
    if (get != null) {
      object$.setProperty('get'.toJS, get);
    }
    if (has != null) {
      object$.setProperty('has'.toJS, has);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (set != null) {
      object$.setProperty('set'.toJS, set);
    }
    return DiagnosticCollectionDart(DiagnosticCollection(object$));
  }
}

extension DiagnosticCollectionToDart on DiagnosticCollection {
  DiagnosticCollectionDart get dart => DiagnosticCollectionDart(this);
}

extension type DocumentColorProviderDart(DocumentColorProvider $js) implements DocumentColorProvider {
  factory DocumentColorProviderDart.lit$({JSFunction? provideColorPresentations, JSFunction? provideDocumentColors}) {
    final object$ = JSObject();
    if (provideColorPresentations != null) {
      object$.setProperty('provideColorPresentations'.toJS, provideColorPresentations);
    }
    if (provideDocumentColors != null) {
      object$.setProperty('provideDocumentColors'.toJS, provideDocumentColors);
    }
    return DocumentColorProviderDart(DocumentColorProvider(object$));
  }
}

extension DocumentColorProviderToDart on DocumentColorProvider {
  DocumentColorProviderDart get dart => DocumentColorProviderDart(this);
}

extension type DocumentDropEditProviderDart<T extends JSAny?>(DocumentDropEditProvider<T> $js) implements DocumentDropEditProvider<T> {
  factory DocumentDropEditProviderDart.lit$({JSFunction? provideDocumentDropEdits, JSFunction? resolveDocumentDropEdit}) {
    final object$ = JSObject();
    if (provideDocumentDropEdits != null) {
      object$.setProperty('provideDocumentDropEdits'.toJS, provideDocumentDropEdits);
    }
    if (resolveDocumentDropEdit != null) {
      object$.setProperty('resolveDocumentDropEdit'.toJS, resolveDocumentDropEdit);
    }
    return DocumentDropEditProviderDart<T>(DocumentDropEditProvider<T>(object$));
  }
}

extension DocumentDropEditProviderToDart<T extends JSAny?> on DocumentDropEditProvider<T> {
  DocumentDropEditProviderDart<T> get dart => DocumentDropEditProviderDart<T>(this);
}

extension type DocumentDropEditProviderMetadataDart(DocumentDropEditProviderMetadata $js) implements DocumentDropEditProviderMetadata {
  factory DocumentDropEditProviderMetadataDart.lit$({JSArray<JSString>? dropMimeTypes, JSArray<DocumentDropOrPasteEditKind>? providedDropEditKinds}) {
    final object$ = JSObject();
    if (dropMimeTypes != null) {
      object$.setProperty('dropMimeTypes'.toJS, dropMimeTypes);
    }
    if (providedDropEditKinds != null) {
      object$.setProperty('providedDropEditKinds'.toJS, providedDropEditKinds);
    }
    return DocumentDropEditProviderMetadataDart(DocumentDropEditProviderMetadata(object$));
  }
}

extension DocumentDropEditProviderMetadataToDart on DocumentDropEditProviderMetadata {
  DocumentDropEditProviderMetadataDart get dart => DocumentDropEditProviderMetadataDart(this);
}

extension type DocumentFilterDart(DocumentFilter $js) implements DocumentFilter {
  factory DocumentFilterDart.lit$({String? language, String? notebookType, JSAny? pattern, String? scheme}) {
    final object$ = JSObject();
    if (language != null) {
      object$.setProperty('language'.toJS, language.toJS);
    }
    if (notebookType != null) {
      object$.setProperty('notebookType'.toJS, notebookType.toJS);
    }
    if (pattern != null) {
      object$.setProperty('pattern'.toJS, pattern);
    }
    if (scheme != null) {
      object$.setProperty('scheme'.toJS, scheme.toJS);
    }
    return DocumentFilterDart(DocumentFilter(object$));
  }
}

extension DocumentFilterToDart on DocumentFilter {
  DocumentFilterDart get dart => DocumentFilterDart(this);
}

extension type DocumentFormattingEditProviderDart(DocumentFormattingEditProvider $js) implements DocumentFormattingEditProvider {
  factory DocumentFormattingEditProviderDart.lit$({JSFunction? provideDocumentFormattingEdits}) {
    final object$ = JSObject();
    if (provideDocumentFormattingEdits != null) {
      object$.setProperty('provideDocumentFormattingEdits'.toJS, provideDocumentFormattingEdits);
    }
    return DocumentFormattingEditProviderDart(DocumentFormattingEditProvider(object$));
  }
}

extension DocumentFormattingEditProviderToDart on DocumentFormattingEditProvider {
  DocumentFormattingEditProviderDart get dart => DocumentFormattingEditProviderDart(this);
}

extension type DocumentHighlightProviderDart(DocumentHighlightProvider $js) implements DocumentHighlightProvider {
  factory DocumentHighlightProviderDart.lit$({JSFunction? provideDocumentHighlights}) {
    final object$ = JSObject();
    if (provideDocumentHighlights != null) {
      object$.setProperty('provideDocumentHighlights'.toJS, provideDocumentHighlights);
    }
    return DocumentHighlightProviderDart(DocumentHighlightProvider(object$));
  }
}

extension DocumentHighlightProviderToDart on DocumentHighlightProvider {
  DocumentHighlightProviderDart get dart => DocumentHighlightProviderDart(this);
}

extension type DocumentLinkProviderDart<T extends JSAny?>(DocumentLinkProvider<T> $js) implements DocumentLinkProvider<T> {
  factory DocumentLinkProviderDart.lit$({JSFunction? provideDocumentLinks, JSFunction? resolveDocumentLink}) {
    final object$ = JSObject();
    if (provideDocumentLinks != null) {
      object$.setProperty('provideDocumentLinks'.toJS, provideDocumentLinks);
    }
    if (resolveDocumentLink != null) {
      object$.setProperty('resolveDocumentLink'.toJS, resolveDocumentLink);
    }
    return DocumentLinkProviderDart<T>(DocumentLinkProvider<T>(object$));
  }
}

extension DocumentLinkProviderToDart<T extends JSAny?> on DocumentLinkProvider<T> {
  DocumentLinkProviderDart<T> get dart => DocumentLinkProviderDart<T>(this);
}

extension type DocumentPasteEditContextDart(DocumentPasteEditContext $js) implements DocumentPasteEditContext {
  factory DocumentPasteEditContextDart.lit$({DocumentDropOrPasteEditKind? only, num? triggerKind}) {
    final object$ = JSObject();
    if (only != null) {
      object$.setProperty('only'.toJS, only);
    }
    if (triggerKind != null) {
      object$.setProperty('triggerKind'.toJS, triggerKind.toJS);
    }
    return DocumentPasteEditContextDart(DocumentPasteEditContext(object$));
  }
}

extension DocumentPasteEditContextToDart on DocumentPasteEditContext {
  DocumentPasteEditContextDart get dart => DocumentPasteEditContextDart(this);
}

extension type DocumentPasteEditProviderDart<T extends JSAny?>(DocumentPasteEditProvider<T> $js) implements DocumentPasteEditProvider<T> {
  factory DocumentPasteEditProviderDart.lit$({JSFunction? prepareDocumentPaste, JSFunction? provideDocumentPasteEdits, JSFunction? resolveDocumentPasteEdit}) {
    final object$ = JSObject();
    if (prepareDocumentPaste != null) {
      object$.setProperty('prepareDocumentPaste'.toJS, prepareDocumentPaste);
    }
    if (provideDocumentPasteEdits != null) {
      object$.setProperty('provideDocumentPasteEdits'.toJS, provideDocumentPasteEdits);
    }
    if (resolveDocumentPasteEdit != null) {
      object$.setProperty('resolveDocumentPasteEdit'.toJS, resolveDocumentPasteEdit);
    }
    return DocumentPasteEditProviderDart<T>(DocumentPasteEditProvider<T>(object$));
  }
}

extension DocumentPasteEditProviderToDart<T extends JSAny?> on DocumentPasteEditProvider<T> {
  DocumentPasteEditProviderDart<T> get dart => DocumentPasteEditProviderDart<T>(this);
}

extension type DocumentPasteProviderMetadataDart(DocumentPasteProviderMetadata $js) implements DocumentPasteProviderMetadata {
  factory DocumentPasteProviderMetadataDart.lit$({JSArray<JSString>? copyMimeTypes, JSArray<JSString>? pasteMimeTypes, JSArray<DocumentDropOrPasteEditKind>? providedPasteEditKinds}) {
    final object$ = JSObject();
    if (copyMimeTypes != null) {
      object$.setProperty('copyMimeTypes'.toJS, copyMimeTypes);
    }
    if (pasteMimeTypes != null) {
      object$.setProperty('pasteMimeTypes'.toJS, pasteMimeTypes);
    }
    if (providedPasteEditKinds != null) {
      object$.setProperty('providedPasteEditKinds'.toJS, providedPasteEditKinds);
    }
    return DocumentPasteProviderMetadataDart(DocumentPasteProviderMetadata(object$));
  }
}

extension DocumentPasteProviderMetadataToDart on DocumentPasteProviderMetadata {
  DocumentPasteProviderMetadataDart get dart => DocumentPasteProviderMetadataDart(this);
}

extension type DocumentRangeFormattingEditProviderDart(DocumentRangeFormattingEditProvider $js) implements DocumentRangeFormattingEditProvider {
  factory DocumentRangeFormattingEditProviderDart.lit$({JSFunction? provideDocumentRangeFormattingEdits, JSFunction? provideDocumentRangesFormattingEdits}) {
    final object$ = JSObject();
    if (provideDocumentRangeFormattingEdits != null) {
      object$.setProperty('provideDocumentRangeFormattingEdits'.toJS, provideDocumentRangeFormattingEdits);
    }
    if (provideDocumentRangesFormattingEdits != null) {
      object$.setProperty('provideDocumentRangesFormattingEdits'.toJS, provideDocumentRangesFormattingEdits);
    }
    return DocumentRangeFormattingEditProviderDart(DocumentRangeFormattingEditProvider(object$));
  }
}

extension DocumentRangeFormattingEditProviderToDart on DocumentRangeFormattingEditProvider {
  DocumentRangeFormattingEditProviderDart get dart => DocumentRangeFormattingEditProviderDart(this);
}

extension type DocumentRangeSemanticTokensProviderDart(DocumentRangeSemanticTokensProvider $js) implements DocumentRangeSemanticTokensProvider {
  factory DocumentRangeSemanticTokensProviderDart.lit$({Event<JSAny?>? onDidChangeSemanticTokens, JSFunction? provideDocumentRangeSemanticTokens}) {
    final object$ = JSObject();
    if (onDidChangeSemanticTokens != null) {
      object$.setProperty('onDidChangeSemanticTokens'.toJS, onDidChangeSemanticTokens);
    }
    if (provideDocumentRangeSemanticTokens != null) {
      object$.setProperty('provideDocumentRangeSemanticTokens'.toJS, provideDocumentRangeSemanticTokens);
    }
    return DocumentRangeSemanticTokensProviderDart(DocumentRangeSemanticTokensProvider(object$));
  }
  Stream<JSAny?>? get onDidChangeSemanticTokensStream {
    final event$ = $js.onDidChangeSemanticTokens;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension DocumentRangeSemanticTokensProviderToDart on DocumentRangeSemanticTokensProvider {
  DocumentRangeSemanticTokensProviderDart get dart => DocumentRangeSemanticTokensProviderDart(this);
}

extension type DocumentSemanticTokensProviderDart(DocumentSemanticTokensProvider $js) implements DocumentSemanticTokensProvider {
  factory DocumentSemanticTokensProviderDart.lit$({Event<JSAny?>? onDidChangeSemanticTokens, JSFunction? provideDocumentSemanticTokens, JSFunction? provideDocumentSemanticTokensEdits}) {
    final object$ = JSObject();
    if (onDidChangeSemanticTokens != null) {
      object$.setProperty('onDidChangeSemanticTokens'.toJS, onDidChangeSemanticTokens);
    }
    if (provideDocumentSemanticTokens != null) {
      object$.setProperty('provideDocumentSemanticTokens'.toJS, provideDocumentSemanticTokens);
    }
    if (provideDocumentSemanticTokensEdits != null) {
      object$.setProperty('provideDocumentSemanticTokensEdits'.toJS, provideDocumentSemanticTokensEdits);
    }
    return DocumentSemanticTokensProviderDart(DocumentSemanticTokensProvider(object$));
  }
  Stream<JSAny?>? get onDidChangeSemanticTokensStream {
    final event$ = $js.onDidChangeSemanticTokens;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension DocumentSemanticTokensProviderToDart on DocumentSemanticTokensProvider {
  DocumentSemanticTokensProviderDart get dart => DocumentSemanticTokensProviderDart(this);
}

extension type DocumentSymbolProviderDart(DocumentSymbolProvider $js) implements DocumentSymbolProvider {
  factory DocumentSymbolProviderDart.lit$({JSFunction? provideDocumentSymbols}) {
    final object$ = JSObject();
    if (provideDocumentSymbols != null) {
      object$.setProperty('provideDocumentSymbols'.toJS, provideDocumentSymbols);
    }
    return DocumentSymbolProviderDart(DocumentSymbolProvider(object$));
  }
}

extension DocumentSymbolProviderToDart on DocumentSymbolProvider {
  DocumentSymbolProviderDart get dart => DocumentSymbolProviderDart(this);
}

extension type DocumentSymbolProviderMetadataDart(DocumentSymbolProviderMetadata $js) implements DocumentSymbolProviderMetadata {
  factory DocumentSymbolProviderMetadataDart.lit$({String? label}) {
    final object$ = JSObject();
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    return DocumentSymbolProviderMetadataDart(DocumentSymbolProviderMetadata(object$));
  }
}

extension DocumentSymbolProviderMetadataToDart on DocumentSymbolProviderMetadata {
  DocumentSymbolProviderMetadataDart get dart => DocumentSymbolProviderMetadataDart(this);
}

extension type EnterActionDart(EnterAction $js) implements EnterAction {
  factory EnterActionDart.lit$({String? appendText, num? indentAction, num? removeText}) {
    final object$ = JSObject();
    if (appendText != null) {
      object$.setProperty('appendText'.toJS, appendText.toJS);
    }
    if (indentAction != null) {
      object$.setProperty('indentAction'.toJS, indentAction.toJS);
    }
    if (removeText != null) {
      object$.setProperty('removeText'.toJS, removeText.toJS);
    }
    return EnterActionDart(EnterAction(object$));
  }
}

extension EnterActionToDart on EnterAction {
  EnterActionDart get dart => EnterActionDart(this);
}

extension type EnvironmentVariableCollectionDart(EnvironmentVariableCollection $js) implements EnvironmentVariableCollection {
  factory EnvironmentVariableCollectionDart.lit$({JSFunction? append, JSFunction? clear, JSFunction? delete, JSAny? description, JSFunction? forEach, JSFunction? get, bool? persistent, JSFunction? prepend, JSFunction? replace}) {
    final object$ = JSObject();
    if (append != null) {
      object$.setProperty('append'.toJS, append);
    }
    if (clear != null) {
      object$.setProperty('clear'.toJS, clear);
    }
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (description != null) {
      object$.setProperty('description'.toJS, description);
    }
    if (forEach != null) {
      object$.setProperty('forEach'.toJS, forEach);
    }
    if (get != null) {
      object$.setProperty('get'.toJS, get);
    }
    if (persistent != null) {
      object$.setProperty('persistent'.toJS, persistent.toJS);
    }
    if (prepend != null) {
      object$.setProperty('prepend'.toJS, prepend);
    }
    if (replace != null) {
      object$.setProperty('replace'.toJS, replace);
    }
    return EnvironmentVariableCollectionDart(EnvironmentVariableCollection(object$));
  }
}

extension EnvironmentVariableCollectionToDart on EnvironmentVariableCollection {
  EnvironmentVariableCollectionDart get dart => EnvironmentVariableCollectionDart(this);
}

extension type EnvironmentVariableMutatorDart(EnvironmentVariableMutator $js) implements EnvironmentVariableMutator {
  factory EnvironmentVariableMutatorDart.lit$({EnvironmentVariableMutatorOptions? options, num? type, String? value}) {
    final object$ = JSObject();
    if (options != null) {
      object$.setProperty('options'.toJS, options);
    }
    if (type != null) {
      object$.setProperty('type'.toJS, type.toJS);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    return EnvironmentVariableMutatorDart(EnvironmentVariableMutator(object$));
  }
}

extension EnvironmentVariableMutatorToDart on EnvironmentVariableMutator {
  EnvironmentVariableMutatorDart get dart => EnvironmentVariableMutatorDart(this);
}

extension type EnvironmentVariableMutatorOptionsDart(EnvironmentVariableMutatorOptions $js) implements EnvironmentVariableMutatorOptions {
  factory EnvironmentVariableMutatorOptionsDart.lit$({bool? applyAtProcessCreation, bool? applyAtShellIntegration}) {
    final object$ = JSObject();
    if (applyAtProcessCreation != null) {
      object$.setProperty('applyAtProcessCreation'.toJS, applyAtProcessCreation.toJS);
    }
    if (applyAtShellIntegration != null) {
      object$.setProperty('applyAtShellIntegration'.toJS, applyAtShellIntegration.toJS);
    }
    return EnvironmentVariableMutatorOptionsDart(EnvironmentVariableMutatorOptions(object$));
  }
}

extension EnvironmentVariableMutatorOptionsToDart on EnvironmentVariableMutatorOptions {
  EnvironmentVariableMutatorOptionsDart get dart => EnvironmentVariableMutatorOptionsDart(this);
}

extension type EnvironmentVariableScopeDart(EnvironmentVariableScope $js) implements EnvironmentVariableScope {
  factory EnvironmentVariableScopeDart.lit$({WorkspaceFolder? workspaceFolder}) {
    final object$ = JSObject();
    if (workspaceFolder != null) {
      object$.setProperty('workspaceFolder'.toJS, workspaceFolder);
    }
    return EnvironmentVariableScopeDart(EnvironmentVariableScope(object$));
  }
}

extension EnvironmentVariableScopeToDart on EnvironmentVariableScope {
  EnvironmentVariableScopeDart get dart => EnvironmentVariableScopeDart(this);
}

extension type EvaluatableExpressionProviderDart(EvaluatableExpressionProvider $js) implements EvaluatableExpressionProvider {
  factory EvaluatableExpressionProviderDart.lit$({JSFunction? provideEvaluatableExpression}) {
    final object$ = JSObject();
    if (provideEvaluatableExpression != null) {
      object$.setProperty('provideEvaluatableExpression'.toJS, provideEvaluatableExpression);
    }
    return EvaluatableExpressionProviderDart(EvaluatableExpressionProvider(object$));
  }
}

extension EvaluatableExpressionProviderToDart on EvaluatableExpressionProvider {
  EvaluatableExpressionProviderDart get dart => EvaluatableExpressionProviderDart(this);
}

extension type ExtensionDart<T extends JSAny?>(Extension<T> $js) implements Extension<T> {
  factory ExtensionDart.lit$({JSFunction? activate, T? exports, num? extensionKind, String? extensionPath, Uri? extensionUri, String? id, bool? isActive, JSAny? packageJSON}) {
    final object$ = JSObject();
    if (activate != null) {
      object$.setProperty('activate'.toJS, activate);
    }
    if (exports != null) {
      object$.setProperty('exports'.toJS, exports);
    }
    if (extensionKind != null) {
      object$.setProperty('extensionKind'.toJS, extensionKind.toJS);
    }
    if (extensionPath != null) {
      object$.setProperty('extensionPath'.toJS, extensionPath.toJS);
    }
    if (extensionUri != null) {
      object$.setProperty('extensionUri'.toJS, extensionUri);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (isActive != null) {
      object$.setProperty('isActive'.toJS, isActive.toJS);
    }
    if (packageJSON != null) {
      object$.setProperty('packageJSON'.toJS, packageJSON);
    }
    return ExtensionDart<T>(Extension<T>(object$));
  }
  Future<T> activate() => $js.activate().toDart;
}

extension ExtensionToDart<T extends JSAny?> on Extension<T> {
  ExtensionDart<T> get dart => ExtensionDart<T>(this);
}

extension type ExtensionContextDart(ExtensionContext $js) implements ExtensionContext {
  factory ExtensionContextDart.lit$({JSFunction? asAbsolutePath, GlobalEnvironmentVariableCollection? environmentVariableCollection, Extension<JSAny?>? extension, num? extensionMode, String? extensionPath, Uri? extensionUri, JSIntersection_c8c004dd0b99? globalState, String? globalStoragePath, Uri? globalStorageUri, LanguageModelAccessInformation? languageModelAccessInformation, String? logPath, Uri? logUri, SecretStorage? secrets, String? storagePath, Uri? storageUri, JSArray<JSAnon_ffa2e03c40a2>? subscriptions, Memento? workspaceState}) {
    final object$ = JSObject();
    if (asAbsolutePath != null) {
      object$.setProperty('asAbsolutePath'.toJS, asAbsolutePath);
    }
    if (environmentVariableCollection != null) {
      object$.setProperty('environmentVariableCollection'.toJS, environmentVariableCollection);
    }
    if (extension != null) {
      object$.setProperty('extension'.toJS, extension);
    }
    if (extensionMode != null) {
      object$.setProperty('extensionMode'.toJS, extensionMode.toJS);
    }
    if (extensionPath != null) {
      object$.setProperty('extensionPath'.toJS, extensionPath.toJS);
    }
    if (extensionUri != null) {
      object$.setProperty('extensionUri'.toJS, extensionUri);
    }
    if (globalState != null) {
      object$.setProperty('globalState'.toJS, globalState);
    }
    if (globalStoragePath != null) {
      object$.setProperty('globalStoragePath'.toJS, globalStoragePath.toJS);
    }
    if (globalStorageUri != null) {
      object$.setProperty('globalStorageUri'.toJS, globalStorageUri);
    }
    if (languageModelAccessInformation != null) {
      object$.setProperty('languageModelAccessInformation'.toJS, languageModelAccessInformation);
    }
    if (logPath != null) {
      object$.setProperty('logPath'.toJS, logPath.toJS);
    }
    if (logUri != null) {
      object$.setProperty('logUri'.toJS, logUri);
    }
    if (secrets != null) {
      object$.setProperty('secrets'.toJS, secrets);
    }
    if (storagePath != null) {
      object$.setProperty('storagePath'.toJS, storagePath.toJS);
    }
    if (storageUri != null) {
      object$.setProperty('storageUri'.toJS, storageUri);
    }
    if (subscriptions != null) {
      object$.setProperty('subscriptions'.toJS, subscriptions);
    }
    if (workspaceState != null) {
      object$.setProperty('workspaceState'.toJS, workspaceState);
    }
    return ExtensionContextDart(ExtensionContext(object$));
  }
}

extension ExtensionContextToDart on ExtensionContext {
  ExtensionContextDart get dart => ExtensionContextDart(this);
}

extension type ExtensionTerminalOptionsDart(ExtensionTerminalOptions $js) implements ExtensionTerminalOptions {
  factory ExtensionTerminalOptionsDart.lit$({ThemeColor? color, JSObject? iconPath, bool? isTransient, JSAny? location, String? name, Pseudoterminal? pty, String? shellIntegrationNonce}) {
    final object$ = JSObject();
    if (color != null) {
      object$.setProperty('color'.toJS, color);
    }
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (isTransient != null) {
      object$.setProperty('isTransient'.toJS, isTransient.toJS);
    }
    if (location != null) {
      object$.setProperty('location'.toJS, location);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (pty != null) {
      object$.setProperty('pty'.toJS, pty);
    }
    if (shellIntegrationNonce != null) {
      object$.setProperty('shellIntegrationNonce'.toJS, shellIntegrationNonce.toJS);
    }
    return ExtensionTerminalOptionsDart(ExtensionTerminalOptions(object$));
  }
}

extension ExtensionTerminalOptionsToDart on ExtensionTerminalOptions {
  ExtensionTerminalOptionsDart get dart => ExtensionTerminalOptionsDart(this);
}

extension type FileChangeEventDart(FileChangeEvent $js) implements FileChangeEvent {
  factory FileChangeEventDart.lit$({num? type, Uri? uri}) {
    final object$ = JSObject();
    if (type != null) {
      object$.setProperty('type'.toJS, type.toJS);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return FileChangeEventDart(FileChangeEvent(object$));
  }
}

extension FileChangeEventToDart on FileChangeEvent {
  FileChangeEventDart get dart => FileChangeEventDart(this);
}

extension type FileCreateEventDart(FileCreateEvent $js) implements FileCreateEvent {
  factory FileCreateEventDart.lit$({JSArray<Uri>? files}) {
    final object$ = JSObject();
    if (files != null) {
      object$.setProperty('files'.toJS, files);
    }
    return FileCreateEventDart(FileCreateEvent(object$));
  }
}

extension FileCreateEventToDart on FileCreateEvent {
  FileCreateEventDart get dart => FileCreateEventDart(this);
}

extension type FileDecorationProviderDart(FileDecorationProvider $js) implements FileDecorationProvider {
  factory FileDecorationProviderDart.lit$({Event<JSObject?>? onDidChangeFileDecorations, JSFunction? provideFileDecoration}) {
    final object$ = JSObject();
    if (onDidChangeFileDecorations != null) {
      object$.setProperty('onDidChangeFileDecorations'.toJS, onDidChangeFileDecorations);
    }
    if (provideFileDecoration != null) {
      object$.setProperty('provideFileDecoration'.toJS, provideFileDecoration);
    }
    return FileDecorationProviderDart(FileDecorationProvider(object$));
  }
  Stream<JSObject?>? get onDidChangeFileDecorationsStream {
    final event$ = $js.onDidChangeFileDecorations;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw as JSObject?,
    );
  }
}

extension FileDecorationProviderToDart on FileDecorationProvider {
  FileDecorationProviderDart get dart => FileDecorationProviderDart(this);
}

extension type FileDeleteEventDart(FileDeleteEvent $js) implements FileDeleteEvent {
  factory FileDeleteEventDart.lit$({JSArray<Uri>? files}) {
    final object$ = JSObject();
    if (files != null) {
      object$.setProperty('files'.toJS, files);
    }
    return FileDeleteEventDart(FileDeleteEvent(object$));
  }
}

extension FileDeleteEventToDart on FileDeleteEvent {
  FileDeleteEventDart get dart => FileDeleteEventDart(this);
}

extension type FileRenameEventDart(FileRenameEvent $js) implements FileRenameEvent {
  factory FileRenameEventDart.lit$({JSArray<JSAnon_7c30c4713d83>? files}) {
    final object$ = JSObject();
    if (files != null) {
      object$.setProperty('files'.toJS, files);
    }
    return FileRenameEventDart(FileRenameEvent(object$));
  }
}

extension FileRenameEventToDart on FileRenameEvent {
  FileRenameEventDart get dart => FileRenameEventDart(this);
}

extension type FileStatDart(FileStat $js) implements FileStat {
  factory FileStatDart.lit$({num? ctime, num? mtime, num? permissions, num? size, num? type}) {
    final object$ = JSObject();
    if (ctime != null) {
      object$.setProperty('ctime'.toJS, ctime.toJS);
    }
    if (mtime != null) {
      object$.setProperty('mtime'.toJS, mtime.toJS);
    }
    if (permissions != null) {
      object$.setProperty('permissions'.toJS, permissions.toJS);
    }
    if (size != null) {
      object$.setProperty('size'.toJS, size.toJS);
    }
    if (type != null) {
      object$.setProperty('type'.toJS, type.toJS);
    }
    return FileStatDart(FileStat(object$));
  }
}

extension FileStatToDart on FileStat {
  FileStatDart get dart => FileStatDart(this);
}

extension type FileSystemDart(FileSystem $js) implements FileSystem {
  factory FileSystemDart.lit$({JSFunction? copy, JSFunction? createDirectory, JSFunction? delete, JSFunction? isWritableFileSystem, JSFunction? readDirectory, JSFunction? readFile, JSFunction? rename, JSFunction? stat, JSFunction? writeFile}) {
    final object$ = JSObject();
    if (copy != null) {
      object$.setProperty('copy'.toJS, copy);
    }
    if (createDirectory != null) {
      object$.setProperty('createDirectory'.toJS, createDirectory);
    }
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (isWritableFileSystem != null) {
      object$.setProperty('isWritableFileSystem'.toJS, isWritableFileSystem);
    }
    if (readDirectory != null) {
      object$.setProperty('readDirectory'.toJS, readDirectory);
    }
    if (readFile != null) {
      object$.setProperty('readFile'.toJS, readFile);
    }
    if (rename != null) {
      object$.setProperty('rename'.toJS, rename);
    }
    if (stat != null) {
      object$.setProperty('stat'.toJS, stat);
    }
    if (writeFile != null) {
      object$.setProperty('writeFile'.toJS, writeFile);
    }
    return FileSystemDart(FileSystem(object$));
  }
  Future<JSAny?> copy(Uri source, Uri target, [JSAnon_b2623fd46fde? options]) => (options != null ? $js.copy(source, target, options) : $js.copy(source, target)).toDart;
  Future<JSAny?> createDirectory(Uri uri) => $js.createDirectory(uri).toDart;
  Future<JSAny?> delete(Uri uri, [JSAnon_576b1a88ebc3? options]) => (options != null ? $js.delete(uri, options) : $js.delete(uri)).toDart;
  Future<JSArray<JSTuple_171b5687ecdc>> readDirectory(Uri uri) => $js.readDirectory(uri).toDart;
  Future<JSUint8Array> readFile(Uri uri) => $js.readFile(uri).toDart;
  Future<JSAny?> rename(Uri source, Uri target, [JSAnon_b2623fd46fde? options]) => (options != null ? $js.rename(source, target, options) : $js.rename(source, target)).toDart;
  Future<FileStat> stat(Uri uri) => $js.stat(uri).toDart;
  Future<JSAny?> writeFile(Uri uri, JSUint8Array content) => $js.writeFile(uri, content).toDart;
}

extension FileSystemToDart on FileSystem {
  FileSystemDart get dart => FileSystemDart(this);
}

extension type FileSystemProviderDart(FileSystemProvider $js) implements FileSystemProvider {
  factory FileSystemProviderDart.lit$({JSFunction? copy, JSFunction? createDirectory, JSFunction? delete, Event<JSArray<FileChangeEvent>>? onDidChangeFile, JSFunction? readDirectory, JSFunction? readFile, JSFunction? rename, JSFunction? stat, JSFunction? watch, JSFunction? writeFile}) {
    final object$ = JSObject();
    if (copy != null) {
      object$.setProperty('copy'.toJS, copy);
    }
    if (createDirectory != null) {
      object$.setProperty('createDirectory'.toJS, createDirectory);
    }
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (onDidChangeFile != null) {
      object$.setProperty('onDidChangeFile'.toJS, onDidChangeFile);
    }
    if (readDirectory != null) {
      object$.setProperty('readDirectory'.toJS, readDirectory);
    }
    if (readFile != null) {
      object$.setProperty('readFile'.toJS, readFile);
    }
    if (rename != null) {
      object$.setProperty('rename'.toJS, rename);
    }
    if (stat != null) {
      object$.setProperty('stat'.toJS, stat);
    }
    if (watch != null) {
      object$.setProperty('watch'.toJS, watch);
    }
    if (writeFile != null) {
      object$.setProperty('writeFile'.toJS, writeFile);
    }
    return FileSystemProviderDart(FileSystemProvider(object$));
  }
  Stream<JSArray<FileChangeEvent>> get onDidChangeFileStream => _eventStream$(
        (listener) => $js.onDidChangeFile.call(listener),
        (raw) => raw as JSArray<FileChangeEvent>,
      );
}

extension FileSystemProviderToDart on FileSystemProvider {
  FileSystemProviderDart get dart => FileSystemProviderDart(this);
}

extension type FileSystemWatcherDart(FileSystemWatcher $js) implements FileSystemWatcher {
  factory FileSystemWatcherDart.lit$({bool? ignoreChangeEvents, bool? ignoreCreateEvents, bool? ignoreDeleteEvents, Event<Uri>? onDidChange, Event<Uri>? onDidCreate, Event<Uri>? onDidDelete, JSFunction? dispose}) {
    final object$ = JSObject();
    if (ignoreChangeEvents != null) {
      object$.setProperty('ignoreChangeEvents'.toJS, ignoreChangeEvents.toJS);
    }
    if (ignoreCreateEvents != null) {
      object$.setProperty('ignoreCreateEvents'.toJS, ignoreCreateEvents.toJS);
    }
    if (ignoreDeleteEvents != null) {
      object$.setProperty('ignoreDeleteEvents'.toJS, ignoreDeleteEvents.toJS);
    }
    if (onDidChange != null) {
      object$.setProperty('onDidChange'.toJS, onDidChange);
    }
    if (onDidCreate != null) {
      object$.setProperty('onDidCreate'.toJS, onDidCreate);
    }
    if (onDidDelete != null) {
      object$.setProperty('onDidDelete'.toJS, onDidDelete);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    return FileSystemWatcherDart(FileSystemWatcher(object$));
  }
  Stream<Uri> get onDidChangeStream => _eventStream$(
        (listener) => $js.onDidChange.call(listener),
        (raw) => raw as Uri,
      );
  Stream<Uri> get onDidCreateStream => _eventStream$(
        (listener) => $js.onDidCreate.call(listener),
        (raw) => raw as Uri,
      );
  Stream<Uri> get onDidDeleteStream => _eventStream$(
        (listener) => $js.onDidDelete.call(listener),
        (raw) => raw as Uri,
      );
}

extension FileSystemWatcherToDart on FileSystemWatcher {
  FileSystemWatcherDart get dart => FileSystemWatcherDart(this);
}

extension type FileWillCreateEventDart(FileWillCreateEvent $js) implements FileWillCreateEvent {
  factory FileWillCreateEventDart.lit$({JSArray<Uri>? files, CancellationToken? token, JSFunction? waitUntil}) {
    final object$ = JSObject();
    if (files != null) {
      object$.setProperty('files'.toJS, files);
    }
    if (token != null) {
      object$.setProperty('token'.toJS, token);
    }
    if (waitUntil != null) {
      object$.setProperty('waitUntil'.toJS, waitUntil);
    }
    return FileWillCreateEventDart(FileWillCreateEvent(object$));
  }
}

extension FileWillCreateEventToDart on FileWillCreateEvent {
  FileWillCreateEventDart get dart => FileWillCreateEventDart(this);
}

extension type FileWillDeleteEventDart(FileWillDeleteEvent $js) implements FileWillDeleteEvent {
  factory FileWillDeleteEventDart.lit$({JSArray<Uri>? files, CancellationToken? token, JSFunction? waitUntil}) {
    final object$ = JSObject();
    if (files != null) {
      object$.setProperty('files'.toJS, files);
    }
    if (token != null) {
      object$.setProperty('token'.toJS, token);
    }
    if (waitUntil != null) {
      object$.setProperty('waitUntil'.toJS, waitUntil);
    }
    return FileWillDeleteEventDart(FileWillDeleteEvent(object$));
  }
}

extension FileWillDeleteEventToDart on FileWillDeleteEvent {
  FileWillDeleteEventDart get dart => FileWillDeleteEventDart(this);
}

extension type FileWillRenameEventDart(FileWillRenameEvent $js) implements FileWillRenameEvent {
  factory FileWillRenameEventDart.lit$({JSArray<JSAnon_7c30c4713d83>? files, CancellationToken? token, JSFunction? waitUntil}) {
    final object$ = JSObject();
    if (files != null) {
      object$.setProperty('files'.toJS, files);
    }
    if (token != null) {
      object$.setProperty('token'.toJS, token);
    }
    if (waitUntil != null) {
      object$.setProperty('waitUntil'.toJS, waitUntil);
    }
    return FileWillRenameEventDart(FileWillRenameEvent(object$));
  }
}

extension FileWillRenameEventToDart on FileWillRenameEvent {
  FileWillRenameEventDart get dart => FileWillRenameEventDart(this);
}

extension type FoldingRangeProviderDart(FoldingRangeProvider $js) implements FoldingRangeProvider {
  factory FoldingRangeProviderDart.lit$({Event<JSAny?>? onDidChangeFoldingRanges, JSFunction? provideFoldingRanges}) {
    final object$ = JSObject();
    if (onDidChangeFoldingRanges != null) {
      object$.setProperty('onDidChangeFoldingRanges'.toJS, onDidChangeFoldingRanges);
    }
    if (provideFoldingRanges != null) {
      object$.setProperty('provideFoldingRanges'.toJS, provideFoldingRanges);
    }
    return FoldingRangeProviderDart(FoldingRangeProvider(object$));
  }
  Stream<JSAny?>? get onDidChangeFoldingRangesStream {
    final event$ = $js.onDidChangeFoldingRanges;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension FoldingRangeProviderToDart on FoldingRangeProvider {
  FoldingRangeProviderDart get dart => FoldingRangeProviderDart(this);
}

extension type FormattingOptionsDart(FormattingOptions $js) implements FormattingOptions {
  factory FormattingOptionsDart.lit$({bool? insertSpaces, num? tabSize}) {
    final object$ = JSObject();
    if (insertSpaces != null) {
      object$.setProperty('insertSpaces'.toJS, insertSpaces.toJS);
    }
    if (tabSize != null) {
      object$.setProperty('tabSize'.toJS, tabSize.toJS);
    }
    return FormattingOptionsDart(FormattingOptions(object$));
  }
}

extension FormattingOptionsToDart on FormattingOptions {
  FormattingOptionsDart get dart => FormattingOptionsDart(this);
}

extension type GlobalEnvironmentVariableCollectionDart(GlobalEnvironmentVariableCollection $js) implements GlobalEnvironmentVariableCollection {
  factory GlobalEnvironmentVariableCollectionDart.lit$({JSFunction? getScoped, JSFunction? append, JSFunction? clear, JSFunction? delete, JSAny? description, JSFunction? forEach, JSFunction? get, bool? persistent, JSFunction? prepend, JSFunction? replace}) {
    final object$ = JSObject();
    if (getScoped != null) {
      object$.setProperty('getScoped'.toJS, getScoped);
    }
    if (append != null) {
      object$.setProperty('append'.toJS, append);
    }
    if (clear != null) {
      object$.setProperty('clear'.toJS, clear);
    }
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (description != null) {
      object$.setProperty('description'.toJS, description);
    }
    if (forEach != null) {
      object$.setProperty('forEach'.toJS, forEach);
    }
    if (get != null) {
      object$.setProperty('get'.toJS, get);
    }
    if (persistent != null) {
      object$.setProperty('persistent'.toJS, persistent.toJS);
    }
    if (prepend != null) {
      object$.setProperty('prepend'.toJS, prepend);
    }
    if (replace != null) {
      object$.setProperty('replace'.toJS, replace);
    }
    return GlobalEnvironmentVariableCollectionDart(GlobalEnvironmentVariableCollection(object$));
  }
}

extension GlobalEnvironmentVariableCollectionToDart on GlobalEnvironmentVariableCollection {
  GlobalEnvironmentVariableCollectionDart get dart => GlobalEnvironmentVariableCollectionDart(this);
}

extension type HoverProviderDart(HoverProvider $js) implements HoverProvider {
  factory HoverProviderDart.lit$({JSFunction? provideHover}) {
    final object$ = JSObject();
    if (provideHover != null) {
      object$.setProperty('provideHover'.toJS, provideHover);
    }
    return HoverProviderDart(HoverProvider(object$));
  }
}

extension HoverProviderToDart on HoverProvider {
  HoverProviderDart get dart => HoverProviderDart(this);
}

extension type ImplementationProviderDart(ImplementationProvider $js) implements ImplementationProvider {
  factory ImplementationProviderDart.lit$({JSFunction? provideImplementation}) {
    final object$ = JSObject();
    if (provideImplementation != null) {
      object$.setProperty('provideImplementation'.toJS, provideImplementation);
    }
    return ImplementationProviderDart(ImplementationProvider(object$));
  }
}

extension ImplementationProviderToDart on ImplementationProvider {
  ImplementationProviderDart get dart => ImplementationProviderDart(this);
}

extension type IndentationRuleDart(IndentationRule $js) implements IndentationRule {
  factory IndentationRuleDart.lit$({JSObject? decreaseIndentPattern, JSObject? increaseIndentPattern, JSObject? indentNextLinePattern, JSObject? unIndentedLinePattern}) {
    final object$ = JSObject();
    if (decreaseIndentPattern != null) {
      object$.setProperty('decreaseIndentPattern'.toJS, decreaseIndentPattern);
    }
    if (increaseIndentPattern != null) {
      object$.setProperty('increaseIndentPattern'.toJS, increaseIndentPattern);
    }
    if (indentNextLinePattern != null) {
      object$.setProperty('indentNextLinePattern'.toJS, indentNextLinePattern);
    }
    if (unIndentedLinePattern != null) {
      object$.setProperty('unIndentedLinePattern'.toJS, unIndentedLinePattern);
    }
    return IndentationRuleDart(IndentationRule(object$));
  }
}

extension IndentationRuleToDart on IndentationRule {
  IndentationRuleDart get dart => IndentationRuleDart(this);
}

extension type InlayHintsProviderDart<T extends JSAny?>(InlayHintsProvider<T> $js) implements InlayHintsProvider<T> {
  factory InlayHintsProviderDart.lit$({Event<JSAny?>? onDidChangeInlayHints, JSFunction? provideInlayHints, JSFunction? resolveInlayHint}) {
    final object$ = JSObject();
    if (onDidChangeInlayHints != null) {
      object$.setProperty('onDidChangeInlayHints'.toJS, onDidChangeInlayHints);
    }
    if (provideInlayHints != null) {
      object$.setProperty('provideInlayHints'.toJS, provideInlayHints);
    }
    if (resolveInlayHint != null) {
      object$.setProperty('resolveInlayHint'.toJS, resolveInlayHint);
    }
    return InlayHintsProviderDart<T>(InlayHintsProvider<T>(object$));
  }
  Stream<JSAny?>? get onDidChangeInlayHintsStream {
    final event$ = $js.onDidChangeInlayHints;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension InlayHintsProviderToDart<T extends JSAny?> on InlayHintsProvider<T> {
  InlayHintsProviderDart<T> get dart => InlayHintsProviderDart<T>(this);
}

extension type InlineCompletionContextDart(InlineCompletionContext $js) implements InlineCompletionContext {
  factory InlineCompletionContextDart.lit$({SelectedCompletionInfo? selectedCompletionInfo, num? triggerKind}) {
    final object$ = JSObject();
    if (selectedCompletionInfo != null) {
      object$.setProperty('selectedCompletionInfo'.toJS, selectedCompletionInfo);
    }
    if (triggerKind != null) {
      object$.setProperty('triggerKind'.toJS, triggerKind.toJS);
    }
    return InlineCompletionContextDart(InlineCompletionContext(object$));
  }
}

extension InlineCompletionContextToDart on InlineCompletionContext {
  InlineCompletionContextDart get dart => InlineCompletionContextDart(this);
}

extension type InlineCompletionItemProviderDart(InlineCompletionItemProvider $js) implements InlineCompletionItemProvider {
  factory InlineCompletionItemProviderDart.lit$({JSFunction? provideInlineCompletionItems}) {
    final object$ = JSObject();
    if (provideInlineCompletionItems != null) {
      object$.setProperty('provideInlineCompletionItems'.toJS, provideInlineCompletionItems);
    }
    return InlineCompletionItemProviderDart(InlineCompletionItemProvider(object$));
  }
}

extension InlineCompletionItemProviderToDart on InlineCompletionItemProvider {
  InlineCompletionItemProviderDart get dart => InlineCompletionItemProviderDart(this);
}

extension type InlineValueContextDart(InlineValueContext $js) implements InlineValueContext {
  factory InlineValueContextDart.lit$({num? frameId, Range? stoppedLocation}) {
    final object$ = JSObject();
    if (frameId != null) {
      object$.setProperty('frameId'.toJS, frameId.toJS);
    }
    if (stoppedLocation != null) {
      object$.setProperty('stoppedLocation'.toJS, stoppedLocation);
    }
    return InlineValueContextDart(InlineValueContext(object$));
  }
}

extension InlineValueContextToDart on InlineValueContext {
  InlineValueContextDart get dart => InlineValueContextDart(this);
}

extension type InlineValuesProviderDart(InlineValuesProvider $js) implements InlineValuesProvider {
  factory InlineValuesProviderDart.lit$({Event<JSAny?>? onDidChangeInlineValues, JSFunction? provideInlineValues}) {
    final object$ = JSObject();
    if (onDidChangeInlineValues != null) {
      object$.setProperty('onDidChangeInlineValues'.toJS, onDidChangeInlineValues);
    }
    if (provideInlineValues != null) {
      object$.setProperty('provideInlineValues'.toJS, provideInlineValues);
    }
    return InlineValuesProviderDart(InlineValuesProvider(object$));
  }
  Stream<JSAny?>? get onDidChangeInlineValuesStream {
    final event$ = $js.onDidChangeInlineValues;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension InlineValuesProviderToDart on InlineValuesProvider {
  InlineValuesProviderDart get dart => InlineValuesProviderDart(this);
}

extension type InputBoxDart(InputBox $js) implements InputBox {
  factory InputBoxDart.lit$({JSArray<QuickInputButton>? buttons, Event<JSAny?>? onDidAccept, Event<JSString>? onDidChangeValue, Event<QuickInputButton>? onDidTriggerButton, bool? password, String? placeholder, String? prompt, JSAny? validationMessage, String? value, JSTuple_9b5999d5c048? valueSelection, bool? busy, JSFunction? dispose, bool? enabled, JSFunction? hide, bool? ignoreFocusOut, Event<JSAny?>? onDidHide, JSFunction? show, num? step, String? title, num? totalSteps}) {
    final object$ = JSObject();
    if (buttons != null) {
      object$.setProperty('buttons'.toJS, buttons);
    }
    if (onDidAccept != null) {
      object$.setProperty('onDidAccept'.toJS, onDidAccept);
    }
    if (onDidChangeValue != null) {
      object$.setProperty('onDidChangeValue'.toJS, onDidChangeValue);
    }
    if (onDidTriggerButton != null) {
      object$.setProperty('onDidTriggerButton'.toJS, onDidTriggerButton);
    }
    if (password != null) {
      object$.setProperty('password'.toJS, password.toJS);
    }
    if (placeholder != null) {
      object$.setProperty('placeholder'.toJS, placeholder.toJS);
    }
    if (prompt != null) {
      object$.setProperty('prompt'.toJS, prompt.toJS);
    }
    if (validationMessage != null) {
      object$.setProperty('validationMessage'.toJS, validationMessage);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    if (valueSelection != null) {
      object$.setProperty('valueSelection'.toJS, valueSelection);
    }
    if (busy != null) {
      object$.setProperty('busy'.toJS, busy.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (enabled != null) {
      object$.setProperty('enabled'.toJS, enabled.toJS);
    }
    if (hide != null) {
      object$.setProperty('hide'.toJS, hide);
    }
    if (ignoreFocusOut != null) {
      object$.setProperty('ignoreFocusOut'.toJS, ignoreFocusOut.toJS);
    }
    if (onDidHide != null) {
      object$.setProperty('onDidHide'.toJS, onDidHide);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    if (step != null) {
      object$.setProperty('step'.toJS, step.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    if (totalSteps != null) {
      object$.setProperty('totalSteps'.toJS, totalSteps.toJS);
    }
    return InputBoxDart(InputBox(object$));
  }
  Stream<JSAny?> get onDidAcceptStream => _eventStream$(
        (listener) => $js.onDidAccept.call(listener),
        (raw) => raw,
      );
  Stream<String> get onDidChangeValueStream => _eventStream$(
        (listener) => $js.onDidChangeValue.call(listener),
        (raw) => (raw! as JSString).toDart,
      );
  Stream<QuickInputButton> get onDidTriggerButtonStream => _eventStream$(
        (listener) => $js.onDidTriggerButton.call(listener),
        (raw) => raw as QuickInputButton,
      );
}

extension InputBoxToDart on InputBox {
  InputBoxDart get dart => InputBoxDart(this);
}

extension type InputBoxOptionsDart(InputBoxOptions $js) implements InputBoxOptions {
  factory InputBoxOptionsDart.lit$({bool? ignoreFocusOut, bool? password, String? placeHolder, String? prompt, String? title, JSFunction? validateInput, String? value, JSTuple_9b5999d5c048? valueSelection}) {
    final object$ = JSObject();
    if (ignoreFocusOut != null) {
      object$.setProperty('ignoreFocusOut'.toJS, ignoreFocusOut.toJS);
    }
    if (password != null) {
      object$.setProperty('password'.toJS, password.toJS);
    }
    if (placeHolder != null) {
      object$.setProperty('placeHolder'.toJS, placeHolder.toJS);
    }
    if (prompt != null) {
      object$.setProperty('prompt'.toJS, prompt.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    if (validateInput != null) {
      object$.setProperty('validateInput'.toJS, validateInput);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    if (valueSelection != null) {
      object$.setProperty('valueSelection'.toJS, valueSelection);
    }
    return InputBoxOptionsDart(InputBoxOptions(object$));
  }
}

extension InputBoxOptionsToDart on InputBoxOptions {
  InputBoxOptionsDart get dart => InputBoxOptionsDart(this);
}

extension type InputBoxValidationMessageDart(InputBoxValidationMessage $js) implements InputBoxValidationMessage {
  factory InputBoxValidationMessageDart.lit$({String? message, num? severity}) {
    final object$ = JSObject();
    if (message != null) {
      object$.setProperty('message'.toJS, message.toJS);
    }
    if (severity != null) {
      object$.setProperty('severity'.toJS, severity.toJS);
    }
    return InputBoxValidationMessageDart(InputBoxValidationMessage(object$));
  }
}

extension InputBoxValidationMessageToDart on InputBoxValidationMessage {
  InputBoxValidationMessageDart get dart => InputBoxValidationMessageDart(this);
}

extension type LanguageConfigurationDart(LanguageConfiguration $js) implements LanguageConfiguration {
  factory LanguageConfigurationDart.lit$({JSArray<AutoClosingPair>? autoClosingPairs, JSArray<JSTuple_58c6c79a4e36>? brackets, CommentRule? comments, IndentationRule? indentationRules, JSArray<OnEnterRule>? onEnterRules, JSObject? wordPattern}) {
    final object$ = JSObject();
    if (autoClosingPairs != null) {
      object$.setProperty('autoClosingPairs'.toJS, autoClosingPairs);
    }
    if (brackets != null) {
      object$.setProperty('brackets'.toJS, brackets);
    }
    if (comments != null) {
      object$.setProperty('comments'.toJS, comments);
    }
    if (indentationRules != null) {
      object$.setProperty('indentationRules'.toJS, indentationRules);
    }
    if (onEnterRules != null) {
      object$.setProperty('onEnterRules'.toJS, onEnterRules);
    }
    if (wordPattern != null) {
      object$.setProperty('wordPattern'.toJS, wordPattern);
    }
    return LanguageConfigurationDart(LanguageConfiguration(object$));
  }
}

extension LanguageConfigurationToDart on LanguageConfiguration {
  LanguageConfigurationDart get dart => LanguageConfigurationDart(this);
}

extension type LanguageModelAccessInformationDart(LanguageModelAccessInformation $js) implements LanguageModelAccessInformation {
  factory LanguageModelAccessInformationDart.lit$({JSFunction? canSendRequest, Event<JSAny?>? onDidChange}) {
    final object$ = JSObject();
    if (canSendRequest != null) {
      object$.setProperty('canSendRequest'.toJS, canSendRequest);
    }
    if (onDidChange != null) {
      object$.setProperty('onDidChange'.toJS, onDidChange);
    }
    return LanguageModelAccessInformationDart(LanguageModelAccessInformation(object$));
  }
  Stream<JSAny?> get onDidChangeStream => _eventStream$(
        (listener) => $js.onDidChange.call(listener),
        (raw) => raw,
      );
}

extension LanguageModelAccessInformationToDart on LanguageModelAccessInformation {
  LanguageModelAccessInformationDart get dart => LanguageModelAccessInformationDart(this);
}

extension type LanguageModelChatDart(LanguageModelChat $js) implements LanguageModelChat {
  factory LanguageModelChatDart.lit$({JSFunction? countTokens, String? family, String? id, num? maxInputTokens, String? name, JSFunction? sendRequest, String? vendor, String? version}) {
    final object$ = JSObject();
    if (countTokens != null) {
      object$.setProperty('countTokens'.toJS, countTokens);
    }
    if (family != null) {
      object$.setProperty('family'.toJS, family.toJS);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (maxInputTokens != null) {
      object$.setProperty('maxInputTokens'.toJS, maxInputTokens.toJS);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (sendRequest != null) {
      object$.setProperty('sendRequest'.toJS, sendRequest);
    }
    if (vendor != null) {
      object$.setProperty('vendor'.toJS, vendor.toJS);
    }
    if (version != null) {
      object$.setProperty('version'.toJS, version.toJS);
    }
    return LanguageModelChatDart(LanguageModelChat(object$));
  }
  Future<num> countTokens(JSAny text, [CancellationToken? token]) => (token != null ? $js.countTokens(text, token) : $js.countTokens(text)).toDart.then((value) => value.toDartDouble);
  Future<LanguageModelChatResponse> sendRequest(JSArray<LanguageModelChatMessage> messages, [LanguageModelChatRequestOptions? options, CancellationToken? token]) => (token != null ? $js.sendRequest(messages, options, token) : options != null ? $js.sendRequest(messages, options) : $js.sendRequest(messages)).toDart;
}

extension LanguageModelChatToDart on LanguageModelChat {
  LanguageModelChatDart get dart => LanguageModelChatDart(this);
}

extension type LanguageModelChatCapabilitiesDart(LanguageModelChatCapabilities $js) implements LanguageModelChatCapabilities {
  factory LanguageModelChatCapabilitiesDart.lit$({bool? imageInput, JSAny? toolCalling}) {
    final object$ = JSObject();
    if (imageInput != null) {
      object$.setProperty('imageInput'.toJS, imageInput.toJS);
    }
    if (toolCalling != null) {
      object$.setProperty('toolCalling'.toJS, toolCalling);
    }
    return LanguageModelChatCapabilitiesDart(LanguageModelChatCapabilities(object$));
  }
}

extension LanguageModelChatCapabilitiesToDart on LanguageModelChatCapabilities {
  LanguageModelChatCapabilitiesDart get dart => LanguageModelChatCapabilitiesDart(this);
}

extension type LanguageModelChatInformationDart(LanguageModelChatInformation $js) implements LanguageModelChatInformation {
  factory LanguageModelChatInformationDart.lit$({LanguageModelChatCapabilities? capabilities, String? detail, String? family, String? id, num? maxInputTokens, num? maxOutputTokens, String? name, String? tooltip, String? version}) {
    final object$ = JSObject();
    if (capabilities != null) {
      object$.setProperty('capabilities'.toJS, capabilities);
    }
    if (detail != null) {
      object$.setProperty('detail'.toJS, detail.toJS);
    }
    if (family != null) {
      object$.setProperty('family'.toJS, family.toJS);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (maxInputTokens != null) {
      object$.setProperty('maxInputTokens'.toJS, maxInputTokens.toJS);
    }
    if (maxOutputTokens != null) {
      object$.setProperty('maxOutputTokens'.toJS, maxOutputTokens.toJS);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (tooltip != null) {
      object$.setProperty('tooltip'.toJS, tooltip.toJS);
    }
    if (version != null) {
      object$.setProperty('version'.toJS, version.toJS);
    }
    return LanguageModelChatInformationDart(LanguageModelChatInformation(object$));
  }
}

extension LanguageModelChatInformationToDart on LanguageModelChatInformation {
  LanguageModelChatInformationDart get dart => LanguageModelChatInformationDart(this);
}

extension type LanguageModelChatProviderDart<T extends JSAny?>(LanguageModelChatProvider<T> $js) implements LanguageModelChatProvider<T> {
  factory LanguageModelChatProviderDart.lit$({Event<JSAny?>? onDidChangeLanguageModelChatInformation, JSFunction? provideLanguageModelChatInformation, JSFunction? provideLanguageModelChatResponse, JSFunction? provideTokenCount}) {
    final object$ = JSObject();
    if (onDidChangeLanguageModelChatInformation != null) {
      object$.setProperty('onDidChangeLanguageModelChatInformation'.toJS, onDidChangeLanguageModelChatInformation);
    }
    if (provideLanguageModelChatInformation != null) {
      object$.setProperty('provideLanguageModelChatInformation'.toJS, provideLanguageModelChatInformation);
    }
    if (provideLanguageModelChatResponse != null) {
      object$.setProperty('provideLanguageModelChatResponse'.toJS, provideLanguageModelChatResponse);
    }
    if (provideTokenCount != null) {
      object$.setProperty('provideTokenCount'.toJS, provideTokenCount);
    }
    return LanguageModelChatProviderDart<T>(LanguageModelChatProvider<T>(object$));
  }
  Stream<JSAny?>? get onDidChangeLanguageModelChatInformationStream {
    final event$ = $js.onDidChangeLanguageModelChatInformation;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
  Future<JSAny?> provideLanguageModelChatResponse(T model, JSArray<LanguageModelChatRequestMessage> messages, ProvideLanguageModelChatResponseOptions options, Progress<JSObject> progress, CancellationToken token) => $js.provideLanguageModelChatResponse(model, messages, options, progress, token).toDart;
  Future<num> provideTokenCount(T model, JSAny text, CancellationToken token) => $js.provideTokenCount(model, text, token).toDart.then((value) => value.toDartDouble);
}

extension LanguageModelChatProviderToDart<T extends JSAny?> on LanguageModelChatProvider<T> {
  LanguageModelChatProviderDart<T> get dart => LanguageModelChatProviderDart<T>(this);
}

extension type LanguageModelChatRequestMessageDart(LanguageModelChatRequestMessage $js) implements LanguageModelChatRequestMessage {
  factory LanguageModelChatRequestMessageDart.lit$({JSArray<JSAny>? content, String? name, num? role}) {
    final object$ = JSObject();
    if (content != null) {
      object$.setProperty('content'.toJS, content);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (role != null) {
      object$.setProperty('role'.toJS, role.toJS);
    }
    return LanguageModelChatRequestMessageDart(LanguageModelChatRequestMessage(object$));
  }
}

extension LanguageModelChatRequestMessageToDart on LanguageModelChatRequestMessage {
  LanguageModelChatRequestMessageDart get dart => LanguageModelChatRequestMessageDart(this);
}

extension type LanguageModelChatRequestOptionsDart(LanguageModelChatRequestOptions $js) implements LanguageModelChatRequestOptions {
  factory LanguageModelChatRequestOptionsDart.lit$({String? justification, JSAnon_90b1eaa702e4? modelOptions, num? toolMode, JSArray<LanguageModelChatTool>? tools}) {
    final object$ = JSObject();
    if (justification != null) {
      object$.setProperty('justification'.toJS, justification.toJS);
    }
    if (modelOptions != null) {
      object$.setProperty('modelOptions'.toJS, modelOptions);
    }
    if (toolMode != null) {
      object$.setProperty('toolMode'.toJS, toolMode.toJS);
    }
    if (tools != null) {
      object$.setProperty('tools'.toJS, tools);
    }
    return LanguageModelChatRequestOptionsDart(LanguageModelChatRequestOptions(object$));
  }
}

extension LanguageModelChatRequestOptionsToDart on LanguageModelChatRequestOptions {
  LanguageModelChatRequestOptionsDart get dart => LanguageModelChatRequestOptionsDart(this);
}

extension type LanguageModelChatResponseDart(LanguageModelChatResponse $js) implements LanguageModelChatResponse {
  factory LanguageModelChatResponseDart.lit$({JSObject? stream, JSObject? text}) {
    final object$ = JSObject();
    if (stream != null) {
      object$.setProperty('stream'.toJS, stream);
    }
    if (text != null) {
      object$.setProperty('text'.toJS, text);
    }
    return LanguageModelChatResponseDart(LanguageModelChatResponse(object$));
  }
}

extension LanguageModelChatResponseToDart on LanguageModelChatResponse {
  LanguageModelChatResponseDart get dart => LanguageModelChatResponseDart(this);
}

extension type LanguageModelChatSelectorDart(LanguageModelChatSelector $js) implements LanguageModelChatSelector {
  factory LanguageModelChatSelectorDart.lit$({String? family, String? id, String? vendor, String? version}) {
    final object$ = JSObject();
    if (family != null) {
      object$.setProperty('family'.toJS, family.toJS);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (vendor != null) {
      object$.setProperty('vendor'.toJS, vendor.toJS);
    }
    if (version != null) {
      object$.setProperty('version'.toJS, version.toJS);
    }
    return LanguageModelChatSelectorDart(LanguageModelChatSelector(object$));
  }
}

extension LanguageModelChatSelectorToDart on LanguageModelChatSelector {
  LanguageModelChatSelectorDart get dart => LanguageModelChatSelectorDart(this);
}

extension type LanguageModelChatToolDart(LanguageModelChatTool $js) implements LanguageModelChatTool {
  factory LanguageModelChatToolDart.lit$({String? description, JSObject? inputSchema, String? name}) {
    final object$ = JSObject();
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (inputSchema != null) {
      object$.setProperty('inputSchema'.toJS, inputSchema);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    return LanguageModelChatToolDart(LanguageModelChatTool(object$));
  }
}

extension LanguageModelChatToolToDart on LanguageModelChatTool {
  LanguageModelChatToolDart get dart => LanguageModelChatToolDart(this);
}

extension type LanguageModelToolDart<T extends JSAny?>(LanguageModelTool<T> $js) implements LanguageModelTool<T> {
  factory LanguageModelToolDart.lit$({JSFunction? invoke, JSFunction? prepareInvocation}) {
    final object$ = JSObject();
    if (invoke != null) {
      object$.setProperty('invoke'.toJS, invoke);
    }
    if (prepareInvocation != null) {
      object$.setProperty('prepareInvocation'.toJS, prepareInvocation);
    }
    return LanguageModelToolDart<T>(LanguageModelTool<T>(object$));
  }
}

extension LanguageModelToolToDart<T extends JSAny?> on LanguageModelTool<T> {
  LanguageModelToolDart<T> get dart => LanguageModelToolDart<T>(this);
}

extension type LanguageModelToolConfirmationMessagesDart(LanguageModelToolConfirmationMessages $js) implements LanguageModelToolConfirmationMessages {
  factory LanguageModelToolConfirmationMessagesDart.lit$({JSAny? message, String? title}) {
    final object$ = JSObject();
    if (message != null) {
      object$.setProperty('message'.toJS, message);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    return LanguageModelToolConfirmationMessagesDart(LanguageModelToolConfirmationMessages(object$));
  }
}

extension LanguageModelToolConfirmationMessagesToDart on LanguageModelToolConfirmationMessages {
  LanguageModelToolConfirmationMessagesDart get dart => LanguageModelToolConfirmationMessagesDart(this);
}

extension type LanguageModelToolInformationDart(LanguageModelToolInformation $js) implements LanguageModelToolInformation {
  factory LanguageModelToolInformationDart.lit$({String? description, JSObject? inputSchema, String? name, JSArray<JSString>? tags}) {
    final object$ = JSObject();
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (inputSchema != null) {
      object$.setProperty('inputSchema'.toJS, inputSchema);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (tags != null) {
      object$.setProperty('tags'.toJS, tags);
    }
    return LanguageModelToolInformationDart(LanguageModelToolInformation(object$));
  }
}

extension LanguageModelToolInformationToDart on LanguageModelToolInformation {
  LanguageModelToolInformationDart get dart => LanguageModelToolInformationDart(this);
}

extension type LanguageModelToolInvocationOptionsDart<T extends JSAny?>(LanguageModelToolInvocationOptions<T> $js) implements LanguageModelToolInvocationOptions<T> {
  factory LanguageModelToolInvocationOptionsDart.lit$({T? input, LanguageModelToolTokenizationOptions? tokenizationOptions, JSAny? toolInvocationToken}) {
    final object$ = JSObject();
    if (input != null) {
      object$.setProperty('input'.toJS, input);
    }
    if (tokenizationOptions != null) {
      object$.setProperty('tokenizationOptions'.toJS, tokenizationOptions);
    }
    if (toolInvocationToken != null) {
      object$.setProperty('toolInvocationToken'.toJS, toolInvocationToken);
    }
    return LanguageModelToolInvocationOptionsDart<T>(LanguageModelToolInvocationOptions<T>(object$));
  }
}

extension LanguageModelToolInvocationOptionsToDart<T extends JSAny?> on LanguageModelToolInvocationOptions<T> {
  LanguageModelToolInvocationOptionsDart<T> get dart => LanguageModelToolInvocationOptionsDart<T>(this);
}

extension type LanguageModelToolInvocationPrepareOptionsDart<T extends JSAny?>(LanguageModelToolInvocationPrepareOptions<T> $js) implements LanguageModelToolInvocationPrepareOptions<T> {
  factory LanguageModelToolInvocationPrepareOptionsDart.lit$({T? input}) {
    final object$ = JSObject();
    if (input != null) {
      object$.setProperty('input'.toJS, input);
    }
    return LanguageModelToolInvocationPrepareOptionsDart<T>(LanguageModelToolInvocationPrepareOptions<T>(object$));
  }
}

extension LanguageModelToolInvocationPrepareOptionsToDart<T extends JSAny?> on LanguageModelToolInvocationPrepareOptions<T> {
  LanguageModelToolInvocationPrepareOptionsDart<T> get dart => LanguageModelToolInvocationPrepareOptionsDart<T>(this);
}

extension type LanguageModelToolTokenizationOptionsDart(LanguageModelToolTokenizationOptions $js) implements LanguageModelToolTokenizationOptions {
  factory LanguageModelToolTokenizationOptionsDart.lit$({JSFunction? countTokens, num? tokenBudget}) {
    final object$ = JSObject();
    if (countTokens != null) {
      object$.setProperty('countTokens'.toJS, countTokens);
    }
    if (tokenBudget != null) {
      object$.setProperty('tokenBudget'.toJS, tokenBudget.toJS);
    }
    return LanguageModelToolTokenizationOptionsDart(LanguageModelToolTokenizationOptions(object$));
  }
  Future<num> countTokens(String text, [CancellationToken? token]) => (token != null ? $js.countTokens(text, token) : $js.countTokens(text)).toDart.then((value) => value.toDartDouble);
}

extension LanguageModelToolTokenizationOptionsToDart on LanguageModelToolTokenizationOptions {
  LanguageModelToolTokenizationOptionsDart get dart => LanguageModelToolTokenizationOptionsDart(this);
}

extension type LanguageStatusItemDart(LanguageStatusItem $js) implements LanguageStatusItem {
  factory LanguageStatusItemDart.lit$({AccessibilityInformation? accessibilityInformation, bool? busy, Command? command, String? detail, JSFunction? dispose, String? id, String? name, JSAny? selector, num? severity, String? text}) {
    final object$ = JSObject();
    if (accessibilityInformation != null) {
      object$.setProperty('accessibilityInformation'.toJS, accessibilityInformation);
    }
    if (busy != null) {
      object$.setProperty('busy'.toJS, busy.toJS);
    }
    if (command != null) {
      object$.setProperty('command'.toJS, command);
    }
    if (detail != null) {
      object$.setProperty('detail'.toJS, detail.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (selector != null) {
      object$.setProperty('selector'.toJS, selector);
    }
    if (severity != null) {
      object$.setProperty('severity'.toJS, severity.toJS);
    }
    if (text != null) {
      object$.setProperty('text'.toJS, text.toJS);
    }
    return LanguageStatusItemDart(LanguageStatusItem(object$));
  }
}

extension LanguageStatusItemToDart on LanguageStatusItem {
  LanguageStatusItemDart get dart => LanguageStatusItemDart(this);
}

extension type LineCommentRuleDart(LineCommentRule $js) implements LineCommentRule {
  factory LineCommentRuleDart.lit$({String? comment, bool? noIndent}) {
    final object$ = JSObject();
    if (comment != null) {
      object$.setProperty('comment'.toJS, comment.toJS);
    }
    if (noIndent != null) {
      object$.setProperty('noIndent'.toJS, noIndent.toJS);
    }
    return LineCommentRuleDart(LineCommentRule(object$));
  }
}

extension LineCommentRuleToDart on LineCommentRule {
  LineCommentRuleDart get dart => LineCommentRuleDart(this);
}

extension type LinkedEditingRangeProviderDart(LinkedEditingRangeProvider $js) implements LinkedEditingRangeProvider {
  factory LinkedEditingRangeProviderDart.lit$({JSFunction? provideLinkedEditingRanges}) {
    final object$ = JSObject();
    if (provideLinkedEditingRanges != null) {
      object$.setProperty('provideLinkedEditingRanges'.toJS, provideLinkedEditingRanges);
    }
    return LinkedEditingRangeProviderDart(LinkedEditingRangeProvider(object$));
  }
}

extension LinkedEditingRangeProviderToDart on LinkedEditingRangeProvider {
  LinkedEditingRangeProviderDart get dart => LinkedEditingRangeProviderDart(this);
}

extension type LocationLinkDart(LocationLink $js) implements LocationLink {
  factory LocationLinkDart.lit$({Range? originSelectionRange, Range? targetRange, Range? targetSelectionRange, Uri? targetUri}) {
    final object$ = JSObject();
    if (originSelectionRange != null) {
      object$.setProperty('originSelectionRange'.toJS, originSelectionRange);
    }
    if (targetRange != null) {
      object$.setProperty('targetRange'.toJS, targetRange);
    }
    if (targetSelectionRange != null) {
      object$.setProperty('targetSelectionRange'.toJS, targetSelectionRange);
    }
    if (targetUri != null) {
      object$.setProperty('targetUri'.toJS, targetUri);
    }
    return LocationLinkDart(LocationLink(object$));
  }
}

extension LocationLinkToDart on LocationLink {
  LocationLinkDart get dart => LocationLinkDart(this);
}

extension type LogOutputChannelDart(LogOutputChannel $js) implements LogOutputChannel {
  factory LogOutputChannelDart.lit$({JSFunction? debug, JSFunction? error, JSFunction? info, num? logLevel, Event<JSNumber>? onDidChangeLogLevel, JSFunction? trace, JSFunction? warn, JSFunction? append, JSFunction? appendLine, JSFunction? clear, JSFunction? dispose, JSFunction? hide, String? name, JSFunction? replace, JSFunction? show}) {
    final object$ = JSObject();
    if (debug != null) {
      object$.setProperty('debug'.toJS, debug);
    }
    if (error != null) {
      object$.setProperty('error'.toJS, error);
    }
    if (info != null) {
      object$.setProperty('info'.toJS, info);
    }
    if (logLevel != null) {
      object$.setProperty('logLevel'.toJS, logLevel.toJS);
    }
    if (onDidChangeLogLevel != null) {
      object$.setProperty('onDidChangeLogLevel'.toJS, onDidChangeLogLevel);
    }
    if (trace != null) {
      object$.setProperty('trace'.toJS, trace);
    }
    if (warn != null) {
      object$.setProperty('warn'.toJS, warn);
    }
    if (append != null) {
      object$.setProperty('append'.toJS, append);
    }
    if (appendLine != null) {
      object$.setProperty('appendLine'.toJS, appendLine);
    }
    if (clear != null) {
      object$.setProperty('clear'.toJS, clear);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (hide != null) {
      object$.setProperty('hide'.toJS, hide);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (replace != null) {
      object$.setProperty('replace'.toJS, replace);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    return LogOutputChannelDart(LogOutputChannel(object$));
  }
  JSAny? debug(String message, [List<JSAny?> args = const []]) => $js.debug(message.toJS, args);
  JSAny? info(String message, [List<JSAny?> args = const []]) => $js.info(message.toJS, args);
  Stream<num> get onDidChangeLogLevelStream => _eventStream$(
        (listener) => $js.onDidChangeLogLevel.call(listener),
        (raw) => (raw! as JSNumber).toDartDouble,
      );
  JSAny? trace(String message, [List<JSAny?> args = const []]) => $js.trace(message.toJS, args);
  JSAny? warn(String message, [List<JSAny?> args = const []]) => $js.warn(message.toJS, args);
}

extension LogOutputChannelToDart on LogOutputChannel {
  LogOutputChannelDart get dart => LogOutputChannelDart(this);
}

extension type McpServerDefinitionProviderDart<T extends JSAny?>(McpServerDefinitionProvider<T> $js) implements McpServerDefinitionProvider<T> {
  factory McpServerDefinitionProviderDart.lit$({Event<JSAny?>? onDidChangeMcpServerDefinitions, JSFunction? provideMcpServerDefinitions, JSFunction? resolveMcpServerDefinition}) {
    final object$ = JSObject();
    if (onDidChangeMcpServerDefinitions != null) {
      object$.setProperty('onDidChangeMcpServerDefinitions'.toJS, onDidChangeMcpServerDefinitions);
    }
    if (provideMcpServerDefinitions != null) {
      object$.setProperty('provideMcpServerDefinitions'.toJS, provideMcpServerDefinitions);
    }
    if (resolveMcpServerDefinition != null) {
      object$.setProperty('resolveMcpServerDefinition'.toJS, resolveMcpServerDefinition);
    }
    return McpServerDefinitionProviderDart<T>(McpServerDefinitionProvider<T>(object$));
  }
  Stream<JSAny?>? get onDidChangeMcpServerDefinitionsStream {
    final event$ = $js.onDidChangeMcpServerDefinitions;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension McpServerDefinitionProviderToDart<T extends JSAny?> on McpServerDefinitionProvider<T> {
  McpServerDefinitionProviderDart<T> get dart => McpServerDefinitionProviderDart<T>(this);
}

extension type MementoDart(Memento $js) implements Memento {
  factory MementoDart.lit$({JSFunction? get, JSFunction? keys, JSFunction? update}) {
    final object$ = JSObject();
    if (get != null) {
      object$.setProperty('get'.toJS, get);
    }
    if (keys != null) {
      object$.setProperty('keys'.toJS, keys);
    }
    if (update != null) {
      object$.setProperty('update'.toJS, update);
    }
    return MementoDart(Memento(object$));
  }
  Future<JSAny?> update(String key, JSAny? value) => $js.update(key, value).toDart;
}

extension MementoToDart on Memento {
  MementoDart get dart => MementoDart(this);
}

extension type MessageItemDart(MessageItem $js) implements MessageItem {
  factory MessageItemDart.lit$({bool? isCloseAffordance, String? title}) {
    final object$ = JSObject();
    if (isCloseAffordance != null) {
      object$.setProperty('isCloseAffordance'.toJS, isCloseAffordance.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    return MessageItemDart(MessageItem(object$));
  }
}

extension MessageItemToDart on MessageItem {
  MessageItemDart get dart => MessageItemDart(this);
}

extension type MessageOptionsDart(MessageOptions $js) implements MessageOptions {
  factory MessageOptionsDart.lit$({String? detail, bool? modal}) {
    final object$ = JSObject();
    if (detail != null) {
      object$.setProperty('detail'.toJS, detail.toJS);
    }
    if (modal != null) {
      object$.setProperty('modal'.toJS, modal.toJS);
    }
    return MessageOptionsDart(MessageOptions(object$));
  }
}

extension MessageOptionsToDart on MessageOptions {
  MessageOptionsDart get dart => MessageOptionsDart(this);
}

extension type NotebookCellDart(NotebookCell $js) implements NotebookCell {
  factory NotebookCellDart.lit$({TextDocument? document, NotebookCellExecutionSummary? executionSummary, num? index, num? kind, JSAnon_cd1da709a211? metadata, NotebookDocument? notebook, JSArray<NotebookCellOutput>? outputs}) {
    final object$ = JSObject();
    if (document != null) {
      object$.setProperty('document'.toJS, document);
    }
    if (executionSummary != null) {
      object$.setProperty('executionSummary'.toJS, executionSummary);
    }
    if (index != null) {
      object$.setProperty('index'.toJS, index.toJS);
    }
    if (kind != null) {
      object$.setProperty('kind'.toJS, kind.toJS);
    }
    if (metadata != null) {
      object$.setProperty('metadata'.toJS, metadata);
    }
    if (notebook != null) {
      object$.setProperty('notebook'.toJS, notebook);
    }
    if (outputs != null) {
      object$.setProperty('outputs'.toJS, outputs);
    }
    return NotebookCellDart(NotebookCell(object$));
  }
}

extension NotebookCellToDart on NotebookCell {
  NotebookCellDart get dart => NotebookCellDart(this);
}

extension type NotebookCellExecutionDart(NotebookCellExecution $js) implements NotebookCellExecution {
  factory NotebookCellExecutionDart.lit$({JSFunction? appendOutput, JSFunction? appendOutputItems, NotebookCell? cell, JSFunction? clearOutput, JSFunction? end, num? executionOrder, JSFunction? replaceOutput, JSFunction? replaceOutputItems, JSFunction? start, CancellationToken? token}) {
    final object$ = JSObject();
    if (appendOutput != null) {
      object$.setProperty('appendOutput'.toJS, appendOutput);
    }
    if (appendOutputItems != null) {
      object$.setProperty('appendOutputItems'.toJS, appendOutputItems);
    }
    if (cell != null) {
      object$.setProperty('cell'.toJS, cell);
    }
    if (clearOutput != null) {
      object$.setProperty('clearOutput'.toJS, clearOutput);
    }
    if (end != null) {
      object$.setProperty('end'.toJS, end);
    }
    if (executionOrder != null) {
      object$.setProperty('executionOrder'.toJS, executionOrder.toJS);
    }
    if (replaceOutput != null) {
      object$.setProperty('replaceOutput'.toJS, replaceOutput);
    }
    if (replaceOutputItems != null) {
      object$.setProperty('replaceOutputItems'.toJS, replaceOutputItems);
    }
    if (start != null) {
      object$.setProperty('start'.toJS, start);
    }
    if (token != null) {
      object$.setProperty('token'.toJS, token);
    }
    return NotebookCellExecutionDart(NotebookCellExecution(object$));
  }
  Future<JSAny?> appendOutput(JSObject out, [NotebookCell? cell]) => (cell != null ? $js.appendOutput(out, cell) : $js.appendOutput(out)).toDart;
  Future<JSAny?> appendOutputItems(JSObject items, NotebookCellOutput output) => $js.appendOutputItems(items, output).toDart;
  Future<JSAny?> clearOutput([NotebookCell? cell]) => (cell != null ? $js.clearOutput(cell) : $js.clearOutput()).toDart;
  Future<JSAny?> replaceOutput(JSObject out, [NotebookCell? cell]) => (cell != null ? $js.replaceOutput(out, cell) : $js.replaceOutput(out)).toDart;
  Future<JSAny?> replaceOutputItems(JSObject items, NotebookCellOutput output) => $js.replaceOutputItems(items, output).toDart;
}

extension NotebookCellExecutionToDart on NotebookCellExecution {
  NotebookCellExecutionDart get dart => NotebookCellExecutionDart(this);
}

extension type NotebookCellExecutionSummaryDart(NotebookCellExecutionSummary $js) implements NotebookCellExecutionSummary {
  factory NotebookCellExecutionSummaryDart.lit$({num? executionOrder, bool? success, JSAnon_2ef6a897fc39? timing}) {
    final object$ = JSObject();
    if (executionOrder != null) {
      object$.setProperty('executionOrder'.toJS, executionOrder.toJS);
    }
    if (success != null) {
      object$.setProperty('success'.toJS, success.toJS);
    }
    if (timing != null) {
      object$.setProperty('timing'.toJS, timing);
    }
    return NotebookCellExecutionSummaryDart(NotebookCellExecutionSummary(object$));
  }
}

extension NotebookCellExecutionSummaryToDart on NotebookCellExecutionSummary {
  NotebookCellExecutionSummaryDart get dart => NotebookCellExecutionSummaryDart(this);
}

extension type NotebookCellStatusBarItemProviderDart(NotebookCellStatusBarItemProvider $js) implements NotebookCellStatusBarItemProvider {
  factory NotebookCellStatusBarItemProviderDart.lit$({Event<JSAny?>? onDidChangeCellStatusBarItems, JSFunction? provideCellStatusBarItems}) {
    final object$ = JSObject();
    if (onDidChangeCellStatusBarItems != null) {
      object$.setProperty('onDidChangeCellStatusBarItems'.toJS, onDidChangeCellStatusBarItems);
    }
    if (provideCellStatusBarItems != null) {
      object$.setProperty('provideCellStatusBarItems'.toJS, provideCellStatusBarItems);
    }
    return NotebookCellStatusBarItemProviderDart(NotebookCellStatusBarItemProvider(object$));
  }
  Stream<JSAny?>? get onDidChangeCellStatusBarItemsStream {
    final event$ = $js.onDidChangeCellStatusBarItems;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension NotebookCellStatusBarItemProviderToDart on NotebookCellStatusBarItemProvider {
  NotebookCellStatusBarItemProviderDart get dart => NotebookCellStatusBarItemProviderDart(this);
}

extension type NotebookControllerDart(NotebookController $js) implements NotebookController {
  factory NotebookControllerDart.lit$({JSFunction? createNotebookCellExecution, String? description, String? detail, JSFunction? dispose, JSFunction? executeHandler, String? id, JSFunction? interruptHandler, String? label, String? notebookType, Event<JSAnon_a6a068851ba0>? onDidChangeSelectedNotebooks, JSArray<JSString>? supportedLanguages, bool? supportsExecutionOrder, JSFunction? updateNotebookAffinity}) {
    final object$ = JSObject();
    if (createNotebookCellExecution != null) {
      object$.setProperty('createNotebookCellExecution'.toJS, createNotebookCellExecution);
    }
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (detail != null) {
      object$.setProperty('detail'.toJS, detail.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (executeHandler != null) {
      object$.setProperty('executeHandler'.toJS, executeHandler);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (interruptHandler != null) {
      object$.setProperty('interruptHandler'.toJS, interruptHandler);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (notebookType != null) {
      object$.setProperty('notebookType'.toJS, notebookType.toJS);
    }
    if (onDidChangeSelectedNotebooks != null) {
      object$.setProperty('onDidChangeSelectedNotebooks'.toJS, onDidChangeSelectedNotebooks);
    }
    if (supportedLanguages != null) {
      object$.setProperty('supportedLanguages'.toJS, supportedLanguages);
    }
    if (supportsExecutionOrder != null) {
      object$.setProperty('supportsExecutionOrder'.toJS, supportsExecutionOrder.toJS);
    }
    if (updateNotebookAffinity != null) {
      object$.setProperty('updateNotebookAffinity'.toJS, updateNotebookAffinity);
    }
    return NotebookControllerDart(NotebookController(object$));
  }
  Stream<JSAnon_a6a068851ba0> get onDidChangeSelectedNotebooksStream => _eventStream$(
        (listener) => $js.onDidChangeSelectedNotebooks.call(listener),
        (raw) => raw as JSAnon_a6a068851ba0,
      );
}

extension NotebookControllerToDart on NotebookController {
  NotebookControllerDart get dart => NotebookControllerDart(this);
}

extension type NotebookDocumentDart(NotebookDocument $js) implements NotebookDocument {
  factory NotebookDocumentDart.lit$({JSFunction? cellAt, num? cellCount, JSFunction? getCells, bool? isClosed, bool? isDirty, bool? isUntitled, JSAnon_90b1eaa702e4? metadata, String? notebookType, JSFunction? save, Uri? uri, num? version}) {
    final object$ = JSObject();
    if (cellAt != null) {
      object$.setProperty('cellAt'.toJS, cellAt);
    }
    if (cellCount != null) {
      object$.setProperty('cellCount'.toJS, cellCount.toJS);
    }
    if (getCells != null) {
      object$.setProperty('getCells'.toJS, getCells);
    }
    if (isClosed != null) {
      object$.setProperty('isClosed'.toJS, isClosed.toJS);
    }
    if (isDirty != null) {
      object$.setProperty('isDirty'.toJS, isDirty.toJS);
    }
    if (isUntitled != null) {
      object$.setProperty('isUntitled'.toJS, isUntitled.toJS);
    }
    if (metadata != null) {
      object$.setProperty('metadata'.toJS, metadata);
    }
    if (notebookType != null) {
      object$.setProperty('notebookType'.toJS, notebookType.toJS);
    }
    if (save != null) {
      object$.setProperty('save'.toJS, save);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    if (version != null) {
      object$.setProperty('version'.toJS, version.toJS);
    }
    return NotebookDocumentDart(NotebookDocument(object$));
  }
  Future<bool> save() => $js.save().toDart.then((value) => value.toDart);
}

extension NotebookDocumentToDart on NotebookDocument {
  NotebookDocumentDart get dart => NotebookDocumentDart(this);
}

extension type NotebookDocumentCellChangeDart(NotebookDocumentCellChange $js) implements NotebookDocumentCellChange {
  factory NotebookDocumentCellChangeDart.lit$({NotebookCell? cell, TextDocument? document, NotebookCellExecutionSummary? executionSummary, JSAnon_90b1eaa702e4? metadata, JSArray<NotebookCellOutput>? outputs}) {
    final object$ = JSObject();
    if (cell != null) {
      object$.setProperty('cell'.toJS, cell);
    }
    if (document != null) {
      object$.setProperty('document'.toJS, document);
    }
    if (executionSummary != null) {
      object$.setProperty('executionSummary'.toJS, executionSummary);
    }
    if (metadata != null) {
      object$.setProperty('metadata'.toJS, metadata);
    }
    if (outputs != null) {
      object$.setProperty('outputs'.toJS, outputs);
    }
    return NotebookDocumentCellChangeDart(NotebookDocumentCellChange(object$));
  }
}

extension NotebookDocumentCellChangeToDart on NotebookDocumentCellChange {
  NotebookDocumentCellChangeDart get dart => NotebookDocumentCellChangeDart(this);
}

extension type NotebookDocumentChangeEventDart(NotebookDocumentChangeEvent $js) implements NotebookDocumentChangeEvent {
  factory NotebookDocumentChangeEventDart.lit$({JSArray<NotebookDocumentCellChange>? cellChanges, JSArray<NotebookDocumentContentChange>? contentChanges, JSAnon_90b1eaa702e4? metadata, NotebookDocument? notebook}) {
    final object$ = JSObject();
    if (cellChanges != null) {
      object$.setProperty('cellChanges'.toJS, cellChanges);
    }
    if (contentChanges != null) {
      object$.setProperty('contentChanges'.toJS, contentChanges);
    }
    if (metadata != null) {
      object$.setProperty('metadata'.toJS, metadata);
    }
    if (notebook != null) {
      object$.setProperty('notebook'.toJS, notebook);
    }
    return NotebookDocumentChangeEventDart(NotebookDocumentChangeEvent(object$));
  }
}

extension NotebookDocumentChangeEventToDart on NotebookDocumentChangeEvent {
  NotebookDocumentChangeEventDart get dart => NotebookDocumentChangeEventDart(this);
}

extension type NotebookDocumentContentChangeDart(NotebookDocumentContentChange $js) implements NotebookDocumentContentChange {
  factory NotebookDocumentContentChangeDart.lit$({JSArray<NotebookCell>? addedCells, NotebookRange? range, JSArray<NotebookCell>? removedCells}) {
    final object$ = JSObject();
    if (addedCells != null) {
      object$.setProperty('addedCells'.toJS, addedCells);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    if (removedCells != null) {
      object$.setProperty('removedCells'.toJS, removedCells);
    }
    return NotebookDocumentContentChangeDart(NotebookDocumentContentChange(object$));
  }
}

extension NotebookDocumentContentChangeToDart on NotebookDocumentContentChange {
  NotebookDocumentContentChangeDart get dart => NotebookDocumentContentChangeDart(this);
}

extension type NotebookDocumentContentOptionsDart(NotebookDocumentContentOptions $js) implements NotebookDocumentContentOptions {
  factory NotebookDocumentContentOptionsDart.lit$({JSAnon_8493e550322c? transientCellMetadata, JSAnon_8493e550322c? transientDocumentMetadata, bool? transientOutputs}) {
    final object$ = JSObject();
    if (transientCellMetadata != null) {
      object$.setProperty('transientCellMetadata'.toJS, transientCellMetadata);
    }
    if (transientDocumentMetadata != null) {
      object$.setProperty('transientDocumentMetadata'.toJS, transientDocumentMetadata);
    }
    if (transientOutputs != null) {
      object$.setProperty('transientOutputs'.toJS, transientOutputs.toJS);
    }
    return NotebookDocumentContentOptionsDart(NotebookDocumentContentOptions(object$));
  }
}

extension NotebookDocumentContentOptionsToDart on NotebookDocumentContentOptions {
  NotebookDocumentContentOptionsDart get dart => NotebookDocumentContentOptionsDart(this);
}

extension type NotebookDocumentShowOptionsDart(NotebookDocumentShowOptions $js) implements NotebookDocumentShowOptions {
  factory NotebookDocumentShowOptionsDart.lit$({bool? preserveFocus, bool? preview, JSArray<NotebookRange>? selections, num? viewColumn}) {
    final object$ = JSObject();
    if (preserveFocus != null) {
      object$.setProperty('preserveFocus'.toJS, preserveFocus.toJS);
    }
    if (preview != null) {
      object$.setProperty('preview'.toJS, preview.toJS);
    }
    if (selections != null) {
      object$.setProperty('selections'.toJS, selections);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    return NotebookDocumentShowOptionsDart(NotebookDocumentShowOptions(object$));
  }
}

extension NotebookDocumentShowOptionsToDart on NotebookDocumentShowOptions {
  NotebookDocumentShowOptionsDart get dart => NotebookDocumentShowOptionsDart(this);
}

extension type NotebookDocumentWillSaveEventDart(NotebookDocumentWillSaveEvent $js) implements NotebookDocumentWillSaveEvent {
  factory NotebookDocumentWillSaveEventDart.lit$({NotebookDocument? notebook, num? reason, CancellationToken? token, JSFunction? waitUntil}) {
    final object$ = JSObject();
    if (notebook != null) {
      object$.setProperty('notebook'.toJS, notebook);
    }
    if (reason != null) {
      object$.setProperty('reason'.toJS, reason.toJS);
    }
    if (token != null) {
      object$.setProperty('token'.toJS, token);
    }
    if (waitUntil != null) {
      object$.setProperty('waitUntil'.toJS, waitUntil);
    }
    return NotebookDocumentWillSaveEventDart(NotebookDocumentWillSaveEvent(object$));
  }
}

extension NotebookDocumentWillSaveEventToDart on NotebookDocumentWillSaveEvent {
  NotebookDocumentWillSaveEventDart get dart => NotebookDocumentWillSaveEventDart(this);
}

extension type NotebookEditorDart(NotebookEditor $js) implements NotebookEditor {
  factory NotebookEditorDart.lit$({NotebookDocument? notebook, JSFunction? revealRange, NotebookRange? selection, JSArray<NotebookRange>? selections, num? viewColumn, JSArray<NotebookRange>? visibleRanges}) {
    final object$ = JSObject();
    if (notebook != null) {
      object$.setProperty('notebook'.toJS, notebook);
    }
    if (revealRange != null) {
      object$.setProperty('revealRange'.toJS, revealRange);
    }
    if (selection != null) {
      object$.setProperty('selection'.toJS, selection);
    }
    if (selections != null) {
      object$.setProperty('selections'.toJS, selections);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    if (visibleRanges != null) {
      object$.setProperty('visibleRanges'.toJS, visibleRanges);
    }
    return NotebookEditorDart(NotebookEditor(object$));
  }
}

extension NotebookEditorToDart on NotebookEditor {
  NotebookEditorDart get dart => NotebookEditorDart(this);
}

extension type NotebookEditorSelectionChangeEventDart(NotebookEditorSelectionChangeEvent $js) implements NotebookEditorSelectionChangeEvent {
  factory NotebookEditorSelectionChangeEventDart.lit$({NotebookEditor? notebookEditor, JSArray<NotebookRange>? selections}) {
    final object$ = JSObject();
    if (notebookEditor != null) {
      object$.setProperty('notebookEditor'.toJS, notebookEditor);
    }
    if (selections != null) {
      object$.setProperty('selections'.toJS, selections);
    }
    return NotebookEditorSelectionChangeEventDart(NotebookEditorSelectionChangeEvent(object$));
  }
}

extension NotebookEditorSelectionChangeEventToDart on NotebookEditorSelectionChangeEvent {
  NotebookEditorSelectionChangeEventDart get dart => NotebookEditorSelectionChangeEventDart(this);
}

extension type NotebookEditorVisibleRangesChangeEventDart(NotebookEditorVisibleRangesChangeEvent $js) implements NotebookEditorVisibleRangesChangeEvent {
  factory NotebookEditorVisibleRangesChangeEventDart.lit$({NotebookEditor? notebookEditor, JSArray<NotebookRange>? visibleRanges}) {
    final object$ = JSObject();
    if (notebookEditor != null) {
      object$.setProperty('notebookEditor'.toJS, notebookEditor);
    }
    if (visibleRanges != null) {
      object$.setProperty('visibleRanges'.toJS, visibleRanges);
    }
    return NotebookEditorVisibleRangesChangeEventDart(NotebookEditorVisibleRangesChangeEvent(object$));
  }
}

extension NotebookEditorVisibleRangesChangeEventToDart on NotebookEditorVisibleRangesChangeEvent {
  NotebookEditorVisibleRangesChangeEventDart get dart => NotebookEditorVisibleRangesChangeEventDart(this);
}

extension type NotebookRendererMessagingDart(NotebookRendererMessaging $js) implements NotebookRendererMessaging {
  factory NotebookRendererMessagingDart.lit$({Event<JSAnon_68b4d8c85bba>? onDidReceiveMessage, JSFunction? postMessage}) {
    final object$ = JSObject();
    if (onDidReceiveMessage != null) {
      object$.setProperty('onDidReceiveMessage'.toJS, onDidReceiveMessage);
    }
    if (postMessage != null) {
      object$.setProperty('postMessage'.toJS, postMessage);
    }
    return NotebookRendererMessagingDart(NotebookRendererMessaging(object$));
  }
  Stream<JSAnon_68b4d8c85bba> get onDidReceiveMessageStream => _eventStream$(
        (listener) => $js.onDidReceiveMessage.call(listener),
        (raw) => raw as JSAnon_68b4d8c85bba,
      );
  Future<bool> postMessage(JSAny? message, [NotebookEditor? editor]) => (editor != null ? $js.postMessage(message, editor) : $js.postMessage(message)).toDart.then((value) => value.toDart);
}

extension NotebookRendererMessagingToDart on NotebookRendererMessaging {
  NotebookRendererMessagingDart get dart => NotebookRendererMessagingDart(this);
}

extension type NotebookSerializerDart(NotebookSerializer $js) implements NotebookSerializer {
  factory NotebookSerializerDart.lit$({JSFunction? deserializeNotebook, JSFunction? serializeNotebook}) {
    final object$ = JSObject();
    if (deserializeNotebook != null) {
      object$.setProperty('deserializeNotebook'.toJS, deserializeNotebook);
    }
    if (serializeNotebook != null) {
      object$.setProperty('serializeNotebook'.toJS, serializeNotebook);
    }
    return NotebookSerializerDart(NotebookSerializer(object$));
  }
}

extension NotebookSerializerToDart on NotebookSerializer {
  NotebookSerializerDart get dart => NotebookSerializerDart(this);
}

extension type OnEnterRuleDart(OnEnterRule $js) implements OnEnterRule {
  factory OnEnterRuleDart.lit$({EnterAction? action, JSObject? afterText, JSObject? beforeText, JSObject? previousLineText}) {
    final object$ = JSObject();
    if (action != null) {
      object$.setProperty('action'.toJS, action);
    }
    if (afterText != null) {
      object$.setProperty('afterText'.toJS, afterText);
    }
    if (beforeText != null) {
      object$.setProperty('beforeText'.toJS, beforeText);
    }
    if (previousLineText != null) {
      object$.setProperty('previousLineText'.toJS, previousLineText);
    }
    return OnEnterRuleDart(OnEnterRule(object$));
  }
}

extension OnEnterRuleToDart on OnEnterRule {
  OnEnterRuleDart get dart => OnEnterRuleDart(this);
}

extension type OnTypeFormattingEditProviderDart(OnTypeFormattingEditProvider $js) implements OnTypeFormattingEditProvider {
  factory OnTypeFormattingEditProviderDart.lit$({JSFunction? provideOnTypeFormattingEdits}) {
    final object$ = JSObject();
    if (provideOnTypeFormattingEdits != null) {
      object$.setProperty('provideOnTypeFormattingEdits'.toJS, provideOnTypeFormattingEdits);
    }
    return OnTypeFormattingEditProviderDart(OnTypeFormattingEditProvider(object$));
  }
}

extension OnTypeFormattingEditProviderToDart on OnTypeFormattingEditProvider {
  OnTypeFormattingEditProviderDart get dart => OnTypeFormattingEditProviderDart(this);
}

extension type OpenDialogOptionsDart(OpenDialogOptions $js) implements OpenDialogOptions {
  factory OpenDialogOptionsDart.lit$({bool? canSelectFiles, bool? canSelectFolders, bool? canSelectMany, Uri? defaultUri, JSAnon_04cd047eb59c? filters, String? openLabel, String? title}) {
    final object$ = JSObject();
    if (canSelectFiles != null) {
      object$.setProperty('canSelectFiles'.toJS, canSelectFiles.toJS);
    }
    if (canSelectFolders != null) {
      object$.setProperty('canSelectFolders'.toJS, canSelectFolders.toJS);
    }
    if (canSelectMany != null) {
      object$.setProperty('canSelectMany'.toJS, canSelectMany.toJS);
    }
    if (defaultUri != null) {
      object$.setProperty('defaultUri'.toJS, defaultUri);
    }
    if (filters != null) {
      object$.setProperty('filters'.toJS, filters);
    }
    if (openLabel != null) {
      object$.setProperty('openLabel'.toJS, openLabel.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    return OpenDialogOptionsDart(OpenDialogOptions(object$));
  }
}

extension OpenDialogOptionsToDart on OpenDialogOptions {
  OpenDialogOptionsDart get dart => OpenDialogOptionsDart(this);
}

extension type OutputChannelDart(OutputChannel $js) implements OutputChannel {
  factory OutputChannelDart.lit$({JSFunction? append, JSFunction? appendLine, JSFunction? clear, JSFunction? dispose, JSFunction? hide, String? name, JSFunction? replace, JSFunction? show}) {
    final object$ = JSObject();
    if (append != null) {
      object$.setProperty('append'.toJS, append);
    }
    if (appendLine != null) {
      object$.setProperty('appendLine'.toJS, appendLine);
    }
    if (clear != null) {
      object$.setProperty('clear'.toJS, clear);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (hide != null) {
      object$.setProperty('hide'.toJS, hide);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (replace != null) {
      object$.setProperty('replace'.toJS, replace);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    return OutputChannelDart(OutputChannel(object$));
  }
}

extension OutputChannelToDart on OutputChannel {
  OutputChannelDart get dart => OutputChannelDart(this);
}

extension type PrepareLanguageModelChatModelOptionsDart(PrepareLanguageModelChatModelOptions $js) implements PrepareLanguageModelChatModelOptions {
  factory PrepareLanguageModelChatModelOptionsDart.lit$({bool? silent}) {
    final object$ = JSObject();
    if (silent != null) {
      object$.setProperty('silent'.toJS, silent.toJS);
    }
    return PrepareLanguageModelChatModelOptionsDart(PrepareLanguageModelChatModelOptions(object$));
  }
}

extension PrepareLanguageModelChatModelOptionsToDart on PrepareLanguageModelChatModelOptions {
  PrepareLanguageModelChatModelOptionsDart get dart => PrepareLanguageModelChatModelOptionsDart(this);
}

extension type PreparedToolInvocationDart(PreparedToolInvocation $js) implements PreparedToolInvocation {
  factory PreparedToolInvocationDart.lit$({LanguageModelToolConfirmationMessages? confirmationMessages, JSAny? invocationMessage}) {
    final object$ = JSObject();
    if (confirmationMessages != null) {
      object$.setProperty('confirmationMessages'.toJS, confirmationMessages);
    }
    if (invocationMessage != null) {
      object$.setProperty('invocationMessage'.toJS, invocationMessage);
    }
    return PreparedToolInvocationDart(PreparedToolInvocation(object$));
  }
}

extension PreparedToolInvocationToDart on PreparedToolInvocation {
  PreparedToolInvocationDart get dart => PreparedToolInvocationDart(this);
}

extension type ProcessExecutionOptionsDart(ProcessExecutionOptions $js) implements ProcessExecutionOptions {
  factory ProcessExecutionOptionsDart.lit$({String? cwd, JSAnon_c77c8585355a? env}) {
    final object$ = JSObject();
    if (cwd != null) {
      object$.setProperty('cwd'.toJS, cwd.toJS);
    }
    if (env != null) {
      object$.setProperty('env'.toJS, env);
    }
    return ProcessExecutionOptionsDart(ProcessExecutionOptions(object$));
  }
}

extension ProcessExecutionOptionsToDart on ProcessExecutionOptions {
  ProcessExecutionOptionsDart get dart => ProcessExecutionOptionsDart(this);
}

extension type ProgressDart<T extends JSAny?>(Progress<T> $js) implements Progress<T> {
  factory ProgressDart.lit$({JSFunction? report}) {
    final object$ = JSObject();
    if (report != null) {
      object$.setProperty('report'.toJS, report);
    }
    return ProgressDart<T>(Progress<T>(object$));
  }
}

extension ProgressToDart<T extends JSAny?> on Progress<T> {
  ProgressDart<T> get dart => ProgressDart<T>(this);
}

extension type ProgressOptionsDart(ProgressOptions $js) implements ProgressOptions {
  factory ProgressOptionsDart.lit$({bool? cancellable, JSAny? location, String? title}) {
    final object$ = JSObject();
    if (cancellable != null) {
      object$.setProperty('cancellable'.toJS, cancellable.toJS);
    }
    if (location != null) {
      object$.setProperty('location'.toJS, location);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    return ProgressOptionsDart(ProgressOptions(object$));
  }
}

extension ProgressOptionsToDart on ProgressOptions {
  ProgressOptionsDart get dart => ProgressOptionsDart(this);
}

extension type ProvideLanguageModelChatResponseOptionsDart(ProvideLanguageModelChatResponseOptions $js) implements ProvideLanguageModelChatResponseOptions {
  factory ProvideLanguageModelChatResponseOptionsDart.lit$({JSAnon_cd1da709a211? modelOptions, num? toolMode, JSArray<LanguageModelChatTool>? tools}) {
    final object$ = JSObject();
    if (modelOptions != null) {
      object$.setProperty('modelOptions'.toJS, modelOptions);
    }
    if (toolMode != null) {
      object$.setProperty('toolMode'.toJS, toolMode.toJS);
    }
    if (tools != null) {
      object$.setProperty('tools'.toJS, tools);
    }
    return ProvideLanguageModelChatResponseOptionsDart(ProvideLanguageModelChatResponseOptions(object$));
  }
}

extension ProvideLanguageModelChatResponseOptionsToDart on ProvideLanguageModelChatResponseOptions {
  ProvideLanguageModelChatResponseOptionsDart get dart => ProvideLanguageModelChatResponseOptionsDart(this);
}

extension type PseudoterminalDart(Pseudoterminal $js) implements Pseudoterminal {
  factory PseudoterminalDart.lit$({JSFunction? close, JSFunction? handleInput, Event<JSString>? onDidChangeName, Event<JSAny>? onDidClose, Event<TerminalDimensions?>? onDidOverrideDimensions, Event<JSString>? onDidWrite, JSFunction? open, JSFunction? setDimensions}) {
    final object$ = JSObject();
    if (close != null) {
      object$.setProperty('close'.toJS, close);
    }
    if (handleInput != null) {
      object$.setProperty('handleInput'.toJS, handleInput);
    }
    if (onDidChangeName != null) {
      object$.setProperty('onDidChangeName'.toJS, onDidChangeName);
    }
    if (onDidClose != null) {
      object$.setProperty('onDidClose'.toJS, onDidClose);
    }
    if (onDidOverrideDimensions != null) {
      object$.setProperty('onDidOverrideDimensions'.toJS, onDidOverrideDimensions);
    }
    if (onDidWrite != null) {
      object$.setProperty('onDidWrite'.toJS, onDidWrite);
    }
    if (open != null) {
      object$.setProperty('open'.toJS, open);
    }
    if (setDimensions != null) {
      object$.setProperty('setDimensions'.toJS, setDimensions);
    }
    return PseudoterminalDart(Pseudoterminal(object$));
  }
  Stream<String>? get onDidChangeNameStream {
    final event$ = $js.onDidChangeName;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => (raw! as JSString).toDart,
    );
  }
  Stream<JSAny>? get onDidCloseStream {
    final event$ = $js.onDidClose;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw as JSAny,
    );
  }
  Stream<TerminalDimensions?>? get onDidOverrideDimensionsStream {
    final event$ = $js.onDidOverrideDimensions;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw as TerminalDimensions?,
    );
  }
  Stream<String> get onDidWriteStream => _eventStream$(
        (listener) => $js.onDidWrite.call(listener),
        (raw) => (raw! as JSString).toDart,
      );
}

extension PseudoterminalToDart on Pseudoterminal {
  PseudoterminalDart get dart => PseudoterminalDart(this);
}

extension type QuickDiffProviderDart(QuickDiffProvider $js) implements QuickDiffProvider {
  factory QuickDiffProviderDart.lit$({JSFunction? provideOriginalResource}) {
    final object$ = JSObject();
    if (provideOriginalResource != null) {
      object$.setProperty('provideOriginalResource'.toJS, provideOriginalResource);
    }
    return QuickDiffProviderDart(QuickDiffProvider(object$));
  }
}

extension QuickDiffProviderToDart on QuickDiffProvider {
  QuickDiffProviderDart get dart => QuickDiffProviderDart(this);
}

extension type QuickInputDart(QuickInput $js) implements QuickInput {
  factory QuickInputDart.lit$({bool? busy, JSFunction? dispose, bool? enabled, JSFunction? hide, bool? ignoreFocusOut, Event<JSAny?>? onDidHide, JSFunction? show, num? step, String? title, num? totalSteps}) {
    final object$ = JSObject();
    if (busy != null) {
      object$.setProperty('busy'.toJS, busy.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (enabled != null) {
      object$.setProperty('enabled'.toJS, enabled.toJS);
    }
    if (hide != null) {
      object$.setProperty('hide'.toJS, hide);
    }
    if (ignoreFocusOut != null) {
      object$.setProperty('ignoreFocusOut'.toJS, ignoreFocusOut.toJS);
    }
    if (onDidHide != null) {
      object$.setProperty('onDidHide'.toJS, onDidHide);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    if (step != null) {
      object$.setProperty('step'.toJS, step.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    if (totalSteps != null) {
      object$.setProperty('totalSteps'.toJS, totalSteps.toJS);
    }
    return QuickInputDart(QuickInput(object$));
  }
  Stream<JSAny?> get onDidHideStream => _eventStream$(
        (listener) => $js.onDidHide.call(listener),
        (raw) => raw,
      );
}

extension QuickInputToDart on QuickInput {
  QuickInputDart get dart => QuickInputDart(this);
}

extension type QuickInputButtonDart(QuickInputButton $js) implements QuickInputButton {
  factory QuickInputButtonDart.lit$({JSObject? iconPath, num? location, JSAnon_dc1f16364c4a? toggle, String? tooltip}) {
    final object$ = JSObject();
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (location != null) {
      object$.setProperty('location'.toJS, location.toJS);
    }
    if (toggle != null) {
      object$.setProperty('toggle'.toJS, toggle);
    }
    if (tooltip != null) {
      object$.setProperty('tooltip'.toJS, tooltip.toJS);
    }
    return QuickInputButtonDart(QuickInputButton(object$));
  }
}

extension QuickInputButtonToDart on QuickInputButton {
  QuickInputButtonDart get dart => QuickInputButtonDart(this);
}

extension type QuickPickDart<T extends JSAny?>(QuickPick<T> $js) implements QuickPick<T> {
  factory QuickPickDart.lit$({JSArray<T>? activeItems, JSArray<QuickInputButton>? buttons, bool? canSelectMany, JSArray<T>? items, bool? keepScrollPosition, bool? matchOnDescription, bool? matchOnDetail, Event<JSAny?>? onDidAccept, Event<JSArray<T>>? onDidChangeActive, Event<JSArray<T>>? onDidChangeSelection, Event<JSString>? onDidChangeValue, Event<QuickInputButton>? onDidTriggerButton, Event<QuickPickItemButtonEvent<T>>? onDidTriggerItemButton, String? placeholder, String? prompt, JSArray<T>? selectedItems, String? value, bool? busy, JSFunction? dispose, bool? enabled, JSFunction? hide, bool? ignoreFocusOut, Event<JSAny?>? onDidHide, JSFunction? show, num? step, String? title, num? totalSteps}) {
    final object$ = JSObject();
    if (activeItems != null) {
      object$.setProperty('activeItems'.toJS, activeItems);
    }
    if (buttons != null) {
      object$.setProperty('buttons'.toJS, buttons);
    }
    if (canSelectMany != null) {
      object$.setProperty('canSelectMany'.toJS, canSelectMany.toJS);
    }
    if (items != null) {
      object$.setProperty('items'.toJS, items);
    }
    if (keepScrollPosition != null) {
      object$.setProperty('keepScrollPosition'.toJS, keepScrollPosition.toJS);
    }
    if (matchOnDescription != null) {
      object$.setProperty('matchOnDescription'.toJS, matchOnDescription.toJS);
    }
    if (matchOnDetail != null) {
      object$.setProperty('matchOnDetail'.toJS, matchOnDetail.toJS);
    }
    if (onDidAccept != null) {
      object$.setProperty('onDidAccept'.toJS, onDidAccept);
    }
    if (onDidChangeActive != null) {
      object$.setProperty('onDidChangeActive'.toJS, onDidChangeActive);
    }
    if (onDidChangeSelection != null) {
      object$.setProperty('onDidChangeSelection'.toJS, onDidChangeSelection);
    }
    if (onDidChangeValue != null) {
      object$.setProperty('onDidChangeValue'.toJS, onDidChangeValue);
    }
    if (onDidTriggerButton != null) {
      object$.setProperty('onDidTriggerButton'.toJS, onDidTriggerButton);
    }
    if (onDidTriggerItemButton != null) {
      object$.setProperty('onDidTriggerItemButton'.toJS, onDidTriggerItemButton);
    }
    if (placeholder != null) {
      object$.setProperty('placeholder'.toJS, placeholder.toJS);
    }
    if (prompt != null) {
      object$.setProperty('prompt'.toJS, prompt.toJS);
    }
    if (selectedItems != null) {
      object$.setProperty('selectedItems'.toJS, selectedItems);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    if (busy != null) {
      object$.setProperty('busy'.toJS, busy.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (enabled != null) {
      object$.setProperty('enabled'.toJS, enabled.toJS);
    }
    if (hide != null) {
      object$.setProperty('hide'.toJS, hide);
    }
    if (ignoreFocusOut != null) {
      object$.setProperty('ignoreFocusOut'.toJS, ignoreFocusOut.toJS);
    }
    if (onDidHide != null) {
      object$.setProperty('onDidHide'.toJS, onDidHide);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    if (step != null) {
      object$.setProperty('step'.toJS, step.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    if (totalSteps != null) {
      object$.setProperty('totalSteps'.toJS, totalSteps.toJS);
    }
    return QuickPickDart<T>(QuickPick<T>(object$));
  }
  Stream<JSAny?> get onDidAcceptStream => _eventStream$(
        (listener) => $js.onDidAccept.call(listener),
        (raw) => raw,
      );
  Stream<JSArray<T>> get onDidChangeActiveStream => _eventStream$(
        (listener) => $js.onDidChangeActive.call(listener),
        (raw) => raw as JSArray<T>,
      );
  Stream<JSArray<T>> get onDidChangeSelectionStream => _eventStream$(
        (listener) => $js.onDidChangeSelection.call(listener),
        (raw) => raw as JSArray<T>,
      );
  Stream<String> get onDidChangeValueStream => _eventStream$(
        (listener) => $js.onDidChangeValue.call(listener),
        (raw) => (raw! as JSString).toDart,
      );
  Stream<QuickInputButton> get onDidTriggerButtonStream => _eventStream$(
        (listener) => $js.onDidTriggerButton.call(listener),
        (raw) => raw as QuickInputButton,
      );
  Stream<QuickPickItemButtonEvent<T>> get onDidTriggerItemButtonStream => _eventStream$(
        (listener) => $js.onDidTriggerItemButton.call(listener),
        (raw) => raw as QuickPickItemButtonEvent<T>,
      );
}

extension QuickPickToDart<T extends JSAny?> on QuickPick<T> {
  QuickPickDart<T> get dart => QuickPickDart<T>(this);
}

extension type QuickPickItemDart(QuickPickItem $js) implements QuickPickItem {
  factory QuickPickItemDart.lit$({bool? alwaysShow, JSArray<QuickInputButton>? buttons, String? description, String? detail, JSObject? iconPath, num? kind, String? label, bool? picked, Uri? resourceUri}) {
    final object$ = JSObject();
    if (alwaysShow != null) {
      object$.setProperty('alwaysShow'.toJS, alwaysShow.toJS);
    }
    if (buttons != null) {
      object$.setProperty('buttons'.toJS, buttons);
    }
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (detail != null) {
      object$.setProperty('detail'.toJS, detail.toJS);
    }
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (kind != null) {
      object$.setProperty('kind'.toJS, kind.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (picked != null) {
      object$.setProperty('picked'.toJS, picked.toJS);
    }
    if (resourceUri != null) {
      object$.setProperty('resourceUri'.toJS, resourceUri);
    }
    return QuickPickItemDart(QuickPickItem(object$));
  }
}

extension QuickPickItemToDart on QuickPickItem {
  QuickPickItemDart get dart => QuickPickItemDart(this);
}

extension type QuickPickItemButtonEventDart<T extends JSAny?>(QuickPickItemButtonEvent<T> $js) implements QuickPickItemButtonEvent<T> {
  factory QuickPickItemButtonEventDart.lit$({QuickInputButton? button, T? item}) {
    final object$ = JSObject();
    if (button != null) {
      object$.setProperty('button'.toJS, button);
    }
    if (item != null) {
      object$.setProperty('item'.toJS, item);
    }
    return QuickPickItemButtonEventDart<T>(QuickPickItemButtonEvent<T>(object$));
  }
}

extension QuickPickItemButtonEventToDart<T extends JSAny?> on QuickPickItemButtonEvent<T> {
  QuickPickItemButtonEventDart<T> get dart => QuickPickItemButtonEventDart<T>(this);
}

extension type QuickPickOptionsDart(QuickPickOptions $js) implements QuickPickOptions {
  factory QuickPickOptionsDart.lit$({bool? canPickMany, bool? ignoreFocusOut, bool? matchOnDescription, bool? matchOnDetail, JSFunction? onDidSelectItem, String? placeHolder, String? prompt, String? title}) {
    final object$ = JSObject();
    if (canPickMany != null) {
      object$.setProperty('canPickMany'.toJS, canPickMany.toJS);
    }
    if (ignoreFocusOut != null) {
      object$.setProperty('ignoreFocusOut'.toJS, ignoreFocusOut.toJS);
    }
    if (matchOnDescription != null) {
      object$.setProperty('matchOnDescription'.toJS, matchOnDescription.toJS);
    }
    if (matchOnDetail != null) {
      object$.setProperty('matchOnDetail'.toJS, matchOnDetail.toJS);
    }
    if (onDidSelectItem != null) {
      object$.setProperty('onDidSelectItem'.toJS, onDidSelectItem);
    }
    if (placeHolder != null) {
      object$.setProperty('placeHolder'.toJS, placeHolder.toJS);
    }
    if (prompt != null) {
      object$.setProperty('prompt'.toJS, prompt.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    return QuickPickOptionsDart(QuickPickOptions(object$));
  }
}

extension QuickPickOptionsToDart on QuickPickOptions {
  QuickPickOptionsDart get dart => QuickPickOptionsDart(this);
}

extension type ReferenceContextDart(ReferenceContext $js) implements ReferenceContext {
  factory ReferenceContextDart.lit$({bool? includeDeclaration}) {
    final object$ = JSObject();
    if (includeDeclaration != null) {
      object$.setProperty('includeDeclaration'.toJS, includeDeclaration.toJS);
    }
    return ReferenceContextDart(ReferenceContext(object$));
  }
}

extension ReferenceContextToDart on ReferenceContext {
  ReferenceContextDart get dart => ReferenceContextDart(this);
}

extension type ReferenceProviderDart(ReferenceProvider $js) implements ReferenceProvider {
  factory ReferenceProviderDart.lit$({JSFunction? provideReferences}) {
    final object$ = JSObject();
    if (provideReferences != null) {
      object$.setProperty('provideReferences'.toJS, provideReferences);
    }
    return ReferenceProviderDart(ReferenceProvider(object$));
  }
}

extension ReferenceProviderToDart on ReferenceProvider {
  ReferenceProviderDart get dart => ReferenceProviderDart(this);
}

extension type RenameProviderDart(RenameProvider $js) implements RenameProvider {
  factory RenameProviderDart.lit$({JSFunction? prepareRename, JSFunction? provideRenameEdits}) {
    final object$ = JSObject();
    if (prepareRename != null) {
      object$.setProperty('prepareRename'.toJS, prepareRename);
    }
    if (provideRenameEdits != null) {
      object$.setProperty('provideRenameEdits'.toJS, provideRenameEdits);
    }
    return RenameProviderDart(RenameProvider(object$));
  }
}

extension RenameProviderToDart on RenameProvider {
  RenameProviderDart get dart => RenameProviderDart(this);
}

extension type RunOptionsDart(RunOptions $js) implements RunOptions {
  factory RunOptionsDart.lit$({bool? reevaluateOnRerun}) {
    final object$ = JSObject();
    if (reevaluateOnRerun != null) {
      object$.setProperty('reevaluateOnRerun'.toJS, reevaluateOnRerun.toJS);
    }
    return RunOptionsDart(RunOptions(object$));
  }
}

extension RunOptionsToDart on RunOptions {
  RunOptionsDart get dart => RunOptionsDart(this);
}

extension type SaveDialogOptionsDart(SaveDialogOptions $js) implements SaveDialogOptions {
  factory SaveDialogOptionsDart.lit$({Uri? defaultUri, JSAnon_04cd047eb59c? filters, String? saveLabel, String? title}) {
    final object$ = JSObject();
    if (defaultUri != null) {
      object$.setProperty('defaultUri'.toJS, defaultUri);
    }
    if (filters != null) {
      object$.setProperty('filters'.toJS, filters);
    }
    if (saveLabel != null) {
      object$.setProperty('saveLabel'.toJS, saveLabel.toJS);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    return SaveDialogOptionsDart(SaveDialogOptions(object$));
  }
}

extension SaveDialogOptionsToDart on SaveDialogOptions {
  SaveDialogOptionsDart get dart => SaveDialogOptionsDart(this);
}

extension type SecretStorageDart(SecretStorage $js) implements SecretStorage {
  factory SecretStorageDart.lit$({JSFunction? delete, JSFunction? get, JSFunction? keys, Event<SecretStorageChangeEvent>? onDidChange, JSFunction? store}) {
    final object$ = JSObject();
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (get != null) {
      object$.setProperty('get'.toJS, get);
    }
    if (keys != null) {
      object$.setProperty('keys'.toJS, keys);
    }
    if (onDidChange != null) {
      object$.setProperty('onDidChange'.toJS, onDidChange);
    }
    if (store != null) {
      object$.setProperty('store'.toJS, store);
    }
    return SecretStorageDart(SecretStorage(object$));
  }
  Future<JSAny?> delete(String key) => $js.delete(key).toDart;
  Future<String?> get(String key) => $js.get(key).toDart.then((value) => value?.toDart);
  Future<JSArray<JSString>> keys() => $js.keys().toDart;
  Stream<SecretStorageChangeEvent> get onDidChangeStream => _eventStream$(
        (listener) => $js.onDidChange.call(listener),
        (raw) => raw as SecretStorageChangeEvent,
      );
  Future<JSAny?> store(String key, String value) => $js.store(key, value).toDart;
}

extension SecretStorageToDart on SecretStorage {
  SecretStorageDart get dart => SecretStorageDart(this);
}

extension type SecretStorageChangeEventDart(SecretStorageChangeEvent $js) implements SecretStorageChangeEvent {
  factory SecretStorageChangeEventDart.lit$({String? key}) {
    final object$ = JSObject();
    if (key != null) {
      object$.setProperty('key'.toJS, key.toJS);
    }
    return SecretStorageChangeEventDart(SecretStorageChangeEvent(object$));
  }
}

extension SecretStorageChangeEventToDart on SecretStorageChangeEvent {
  SecretStorageChangeEventDart get dart => SecretStorageChangeEventDart(this);
}

extension type SelectedCompletionInfoDart(SelectedCompletionInfo $js) implements SelectedCompletionInfo {
  factory SelectedCompletionInfoDart.lit$({Range? range, String? text}) {
    final object$ = JSObject();
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    if (text != null) {
      object$.setProperty('text'.toJS, text.toJS);
    }
    return SelectedCompletionInfoDart(SelectedCompletionInfo(object$));
  }
}

extension SelectedCompletionInfoToDart on SelectedCompletionInfo {
  SelectedCompletionInfoDart get dart => SelectedCompletionInfoDart(this);
}

extension type SelectionRangeProviderDart(SelectionRangeProvider $js) implements SelectionRangeProvider {
  factory SelectionRangeProviderDart.lit$({JSFunction? provideSelectionRanges}) {
    final object$ = JSObject();
    if (provideSelectionRanges != null) {
      object$.setProperty('provideSelectionRanges'.toJS, provideSelectionRanges);
    }
    return SelectionRangeProviderDart(SelectionRangeProvider(object$));
  }
}

extension SelectionRangeProviderToDart on SelectionRangeProvider {
  SelectionRangeProviderDart get dart => SelectionRangeProviderDart(this);
}

extension type ShellExecutionOptionsDart(ShellExecutionOptions $js) implements ShellExecutionOptions {
  factory ShellExecutionOptionsDart.lit$({String? cwd, JSAnon_c77c8585355a? env, String? executable, JSArray<JSString>? shellArgs, ShellQuotingOptions? shellQuoting}) {
    final object$ = JSObject();
    if (cwd != null) {
      object$.setProperty('cwd'.toJS, cwd.toJS);
    }
    if (env != null) {
      object$.setProperty('env'.toJS, env);
    }
    if (executable != null) {
      object$.setProperty('executable'.toJS, executable.toJS);
    }
    if (shellArgs != null) {
      object$.setProperty('shellArgs'.toJS, shellArgs);
    }
    if (shellQuoting != null) {
      object$.setProperty('shellQuoting'.toJS, shellQuoting);
    }
    return ShellExecutionOptionsDart(ShellExecutionOptions(object$));
  }
}

extension ShellExecutionOptionsToDart on ShellExecutionOptions {
  ShellExecutionOptionsDart get dart => ShellExecutionOptionsDart(this);
}

extension type ShellQuotedStringDart(ShellQuotedString $js) implements ShellQuotedString {
  factory ShellQuotedStringDart.lit$({num? quoting, String? value}) {
    final object$ = JSObject();
    if (quoting != null) {
      object$.setProperty('quoting'.toJS, quoting.toJS);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    return ShellQuotedStringDart(ShellQuotedString(object$));
  }
}

extension ShellQuotedStringToDart on ShellQuotedString {
  ShellQuotedStringDart get dart => ShellQuotedStringDart(this);
}

extension type ShellQuotingOptionsDart(ShellQuotingOptions $js) implements ShellQuotingOptions {
  factory ShellQuotingOptionsDart.lit$({JSAny? escape, String? strong, String? weak}) {
    final object$ = JSObject();
    if (escape != null) {
      object$.setProperty('escape'.toJS, escape);
    }
    if (strong != null) {
      object$.setProperty('strong'.toJS, strong.toJS);
    }
    if (weak != null) {
      object$.setProperty('weak'.toJS, weak.toJS);
    }
    return ShellQuotingOptionsDart(ShellQuotingOptions(object$));
  }
}

extension ShellQuotingOptionsToDart on ShellQuotingOptions {
  ShellQuotingOptionsDart get dart => ShellQuotingOptionsDart(this);
}

extension type SignatureHelpContextDart(SignatureHelpContext $js) implements SignatureHelpContext {
  factory SignatureHelpContextDart.lit$({SignatureHelp? activeSignatureHelp, bool? isRetrigger, String? triggerCharacter, num? triggerKind}) {
    final object$ = JSObject();
    if (activeSignatureHelp != null) {
      object$.setProperty('activeSignatureHelp'.toJS, activeSignatureHelp);
    }
    if (isRetrigger != null) {
      object$.setProperty('isRetrigger'.toJS, isRetrigger.toJS);
    }
    if (triggerCharacter != null) {
      object$.setProperty('triggerCharacter'.toJS, triggerCharacter.toJS);
    }
    if (triggerKind != null) {
      object$.setProperty('triggerKind'.toJS, triggerKind.toJS);
    }
    return SignatureHelpContextDart(SignatureHelpContext(object$));
  }
}

extension SignatureHelpContextToDart on SignatureHelpContext {
  SignatureHelpContextDart get dart => SignatureHelpContextDart(this);
}

extension type SignatureHelpProviderDart(SignatureHelpProvider $js) implements SignatureHelpProvider {
  factory SignatureHelpProviderDart.lit$({JSFunction? provideSignatureHelp}) {
    final object$ = JSObject();
    if (provideSignatureHelp != null) {
      object$.setProperty('provideSignatureHelp'.toJS, provideSignatureHelp);
    }
    return SignatureHelpProviderDart(SignatureHelpProvider(object$));
  }
}

extension SignatureHelpProviderToDart on SignatureHelpProvider {
  SignatureHelpProviderDart get dart => SignatureHelpProviderDart(this);
}

extension type SignatureHelpProviderMetadataDart(SignatureHelpProviderMetadata $js) implements SignatureHelpProviderMetadata {
  factory SignatureHelpProviderMetadataDart.lit$({JSArray<JSString>? retriggerCharacters, JSArray<JSString>? triggerCharacters}) {
    final object$ = JSObject();
    if (retriggerCharacters != null) {
      object$.setProperty('retriggerCharacters'.toJS, retriggerCharacters);
    }
    if (triggerCharacters != null) {
      object$.setProperty('triggerCharacters'.toJS, triggerCharacters);
    }
    return SignatureHelpProviderMetadataDart(SignatureHelpProviderMetadata(object$));
  }
}

extension SignatureHelpProviderMetadataToDart on SignatureHelpProviderMetadata {
  SignatureHelpProviderMetadataDart get dart => SignatureHelpProviderMetadataDart(this);
}

extension type SourceControlDart(SourceControl $js) implements SourceControl {
  factory SourceControlDart.lit$({Command? acceptInputCommand, String? commitTemplate, num? count, JSFunction? createResourceGroup, JSFunction? dispose, String? id, SourceControlInputBox? inputBox, String? label, QuickDiffProvider? quickDiffProvider, Uri? rootUri, JSArray<Command>? statusBarCommands}) {
    final object$ = JSObject();
    if (acceptInputCommand != null) {
      object$.setProperty('acceptInputCommand'.toJS, acceptInputCommand);
    }
    if (commitTemplate != null) {
      object$.setProperty('commitTemplate'.toJS, commitTemplate.toJS);
    }
    if (count != null) {
      object$.setProperty('count'.toJS, count.toJS);
    }
    if (createResourceGroup != null) {
      object$.setProperty('createResourceGroup'.toJS, createResourceGroup);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (inputBox != null) {
      object$.setProperty('inputBox'.toJS, inputBox);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (quickDiffProvider != null) {
      object$.setProperty('quickDiffProvider'.toJS, quickDiffProvider);
    }
    if (rootUri != null) {
      object$.setProperty('rootUri'.toJS, rootUri);
    }
    if (statusBarCommands != null) {
      object$.setProperty('statusBarCommands'.toJS, statusBarCommands);
    }
    return SourceControlDart(SourceControl(object$));
  }
}

extension SourceControlToDart on SourceControl {
  SourceControlDart get dart => SourceControlDart(this);
}

extension type SourceControlInputBoxDart(SourceControlInputBox $js) implements SourceControlInputBox {
  factory SourceControlInputBoxDart.lit$({bool? enabled, String? placeholder, String? value, bool? visible}) {
    final object$ = JSObject();
    if (enabled != null) {
      object$.setProperty('enabled'.toJS, enabled.toJS);
    }
    if (placeholder != null) {
      object$.setProperty('placeholder'.toJS, placeholder.toJS);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    if (visible != null) {
      object$.setProperty('visible'.toJS, visible.toJS);
    }
    return SourceControlInputBoxDart(SourceControlInputBox(object$));
  }
}

extension SourceControlInputBoxToDart on SourceControlInputBox {
  SourceControlInputBoxDart get dart => SourceControlInputBoxDart(this);
}

extension type SourceControlResourceDecorationsDart(SourceControlResourceDecorations $js) implements SourceControlResourceDecorations {
  factory SourceControlResourceDecorationsDart.lit$({SourceControlResourceThemableDecorations? dark, bool? faded, SourceControlResourceThemableDecorations? light, bool? strikeThrough, String? tooltip, JSAny? iconPath}) {
    final object$ = JSObject();
    if (dark != null) {
      object$.setProperty('dark'.toJS, dark);
    }
    if (faded != null) {
      object$.setProperty('faded'.toJS, faded.toJS);
    }
    if (light != null) {
      object$.setProperty('light'.toJS, light);
    }
    if (strikeThrough != null) {
      object$.setProperty('strikeThrough'.toJS, strikeThrough.toJS);
    }
    if (tooltip != null) {
      object$.setProperty('tooltip'.toJS, tooltip.toJS);
    }
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    return SourceControlResourceDecorationsDart(SourceControlResourceDecorations(object$));
  }
}

extension SourceControlResourceDecorationsToDart on SourceControlResourceDecorations {
  SourceControlResourceDecorationsDart get dart => SourceControlResourceDecorationsDart(this);
}

extension type SourceControlResourceGroupDart(SourceControlResourceGroup $js) implements SourceControlResourceGroup {
  factory SourceControlResourceGroupDart.lit$({String? contextValue, JSFunction? dispose, bool? hideWhenEmpty, String? id, String? label, JSArray<SourceControlResourceState>? resourceStates}) {
    final object$ = JSObject();
    if (contextValue != null) {
      object$.setProperty('contextValue'.toJS, contextValue.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (hideWhenEmpty != null) {
      object$.setProperty('hideWhenEmpty'.toJS, hideWhenEmpty.toJS);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (resourceStates != null) {
      object$.setProperty('resourceStates'.toJS, resourceStates);
    }
    return SourceControlResourceGroupDart(SourceControlResourceGroup(object$));
  }
}

extension SourceControlResourceGroupToDart on SourceControlResourceGroup {
  SourceControlResourceGroupDart get dart => SourceControlResourceGroupDart(this);
}

extension type SourceControlResourceStateDart(SourceControlResourceState $js) implements SourceControlResourceState {
  factory SourceControlResourceStateDart.lit$({Command? command, String? contextValue, SourceControlResourceDecorations? decorations, Uri? resourceUri}) {
    final object$ = JSObject();
    if (command != null) {
      object$.setProperty('command'.toJS, command);
    }
    if (contextValue != null) {
      object$.setProperty('contextValue'.toJS, contextValue.toJS);
    }
    if (decorations != null) {
      object$.setProperty('decorations'.toJS, decorations);
    }
    if (resourceUri != null) {
      object$.setProperty('resourceUri'.toJS, resourceUri);
    }
    return SourceControlResourceStateDart(SourceControlResourceState(object$));
  }
}

extension SourceControlResourceStateToDart on SourceControlResourceState {
  SourceControlResourceStateDart get dart => SourceControlResourceStateDart(this);
}

extension type SourceControlResourceThemableDecorationsDart(SourceControlResourceThemableDecorations $js) implements SourceControlResourceThemableDecorations {
  factory SourceControlResourceThemableDecorationsDart.lit$({JSAny? iconPath}) {
    final object$ = JSObject();
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    return SourceControlResourceThemableDecorationsDart(SourceControlResourceThemableDecorations(object$));
  }
}

extension SourceControlResourceThemableDecorationsToDart on SourceControlResourceThemableDecorations {
  SourceControlResourceThemableDecorationsDart get dart => SourceControlResourceThemableDecorationsDart(this);
}

extension type StatusBarItemDart(StatusBarItem $js) implements StatusBarItem {
  factory StatusBarItemDart.lit$({AccessibilityInformation? accessibilityInformation, num? alignment, ThemeColor? backgroundColor, JSAny? color, JSAny? command, JSFunction? dispose, JSFunction? hide, String? id, String? name, num? priority, JSFunction? show, String? text, JSAny? tooltip}) {
    final object$ = JSObject();
    if (accessibilityInformation != null) {
      object$.setProperty('accessibilityInformation'.toJS, accessibilityInformation);
    }
    if (alignment != null) {
      object$.setProperty('alignment'.toJS, alignment.toJS);
    }
    if (backgroundColor != null) {
      object$.setProperty('backgroundColor'.toJS, backgroundColor);
    }
    if (color != null) {
      object$.setProperty('color'.toJS, color);
    }
    if (command != null) {
      object$.setProperty('command'.toJS, command);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (hide != null) {
      object$.setProperty('hide'.toJS, hide);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (priority != null) {
      object$.setProperty('priority'.toJS, priority.toJS);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    if (text != null) {
      object$.setProperty('text'.toJS, text.toJS);
    }
    if (tooltip != null) {
      object$.setProperty('tooltip'.toJS, tooltip);
    }
    return StatusBarItemDart(StatusBarItem(object$));
  }
}

extension StatusBarItemToDart on StatusBarItem {
  StatusBarItemDart get dart => StatusBarItemDart(this);
}

extension type TabDart(Tab $js) implements Tab {
  factory TabDart.lit$({TabGroup? group, JSAny? input, bool? isActive, bool? isDirty, bool? isPinned, bool? isPreview, String? label}) {
    final object$ = JSObject();
    if (group != null) {
      object$.setProperty('group'.toJS, group);
    }
    if (input != null) {
      object$.setProperty('input'.toJS, input);
    }
    if (isActive != null) {
      object$.setProperty('isActive'.toJS, isActive.toJS);
    }
    if (isDirty != null) {
      object$.setProperty('isDirty'.toJS, isDirty.toJS);
    }
    if (isPinned != null) {
      object$.setProperty('isPinned'.toJS, isPinned.toJS);
    }
    if (isPreview != null) {
      object$.setProperty('isPreview'.toJS, isPreview.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    return TabDart(Tab(object$));
  }
}

extension TabToDart on Tab {
  TabDart get dart => TabDart(this);
}

extension type TabChangeEventDart(TabChangeEvent $js) implements TabChangeEvent {
  factory TabChangeEventDart.lit$({JSArray<Tab>? changed, JSArray<Tab>? closed, JSArray<Tab>? opened}) {
    final object$ = JSObject();
    if (changed != null) {
      object$.setProperty('changed'.toJS, changed);
    }
    if (closed != null) {
      object$.setProperty('closed'.toJS, closed);
    }
    if (opened != null) {
      object$.setProperty('opened'.toJS, opened);
    }
    return TabChangeEventDart(TabChangeEvent(object$));
  }
}

extension TabChangeEventToDart on TabChangeEvent {
  TabChangeEventDart get dart => TabChangeEventDart(this);
}

extension type TabGroupDart(TabGroup $js) implements TabGroup {
  factory TabGroupDart.lit$({Tab? activeTab, bool? isActive, JSArray<Tab>? tabs, num? viewColumn}) {
    final object$ = JSObject();
    if (activeTab != null) {
      object$.setProperty('activeTab'.toJS, activeTab);
    }
    if (isActive != null) {
      object$.setProperty('isActive'.toJS, isActive.toJS);
    }
    if (tabs != null) {
      object$.setProperty('tabs'.toJS, tabs);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    return TabGroupDart(TabGroup(object$));
  }
}

extension TabGroupToDart on TabGroup {
  TabGroupDart get dart => TabGroupDart(this);
}

extension type TabGroupChangeEventDart(TabGroupChangeEvent $js) implements TabGroupChangeEvent {
  factory TabGroupChangeEventDart.lit$({JSArray<TabGroup>? changed, JSArray<TabGroup>? closed, JSArray<TabGroup>? opened}) {
    final object$ = JSObject();
    if (changed != null) {
      object$.setProperty('changed'.toJS, changed);
    }
    if (closed != null) {
      object$.setProperty('closed'.toJS, closed);
    }
    if (opened != null) {
      object$.setProperty('opened'.toJS, opened);
    }
    return TabGroupChangeEventDart(TabGroupChangeEvent(object$));
  }
}

extension TabGroupChangeEventToDart on TabGroupChangeEvent {
  TabGroupChangeEventDart get dart => TabGroupChangeEventDart(this);
}

extension type TabGroupsDart(TabGroups $js) implements TabGroups {
  factory TabGroupsDart.lit$({TabGroup? activeTabGroup, JSArray<TabGroup>? all, JSFunction? close, Event<TabGroupChangeEvent>? onDidChangeTabGroups, Event<TabChangeEvent>? onDidChangeTabs}) {
    final object$ = JSObject();
    if (activeTabGroup != null) {
      object$.setProperty('activeTabGroup'.toJS, activeTabGroup);
    }
    if (all != null) {
      object$.setProperty('all'.toJS, all);
    }
    if (close != null) {
      object$.setProperty('close'.toJS, close);
    }
    if (onDidChangeTabGroups != null) {
      object$.setProperty('onDidChangeTabGroups'.toJS, onDidChangeTabGroups);
    }
    if (onDidChangeTabs != null) {
      object$.setProperty('onDidChangeTabs'.toJS, onDidChangeTabs);
    }
    return TabGroupsDart(TabGroups(object$));
  }
  Future<bool> close(JSObject tab, [bool? preserveFocus]) => (preserveFocus != null ? $js.close(tab, preserveFocus) : $js.close(tab)).toDart.then((value) => value.toDart);
  Future<bool> close$2(JSObject tabGroup, [bool? preserveFocus]) => (preserveFocus != null ? $js.close$2(tabGroup, preserveFocus) : $js.close$2(tabGroup)).toDart.then((value) => value.toDart);
  Stream<TabGroupChangeEvent> get onDidChangeTabGroupsStream => _eventStream$(
        (listener) => $js.onDidChangeTabGroups.call(listener),
        (raw) => raw as TabGroupChangeEvent,
      );
  Stream<TabChangeEvent> get onDidChangeTabsStream => _eventStream$(
        (listener) => $js.onDidChangeTabs.call(listener),
        (raw) => raw as TabChangeEvent,
      );
}

extension TabGroupsToDart on TabGroups {
  TabGroupsDart get dart => TabGroupsDart(this);
}

extension type TaskDefinitionDart(TaskDefinition $js) implements TaskDefinition {
  factory TaskDefinitionDart.lit$({String? type}) {
    final object$ = JSObject();
    if (type != null) {
      object$.setProperty('type'.toJS, type.toJS);
    }
    return TaskDefinitionDart(TaskDefinition(object$));
  }
}

extension TaskDefinitionToDart on TaskDefinition {
  TaskDefinitionDart get dart => TaskDefinitionDart(this);
}

extension type TaskEndEventDart(TaskEndEvent $js) implements TaskEndEvent {
  factory TaskEndEventDart.lit$({TaskExecution? execution}) {
    final object$ = JSObject();
    if (execution != null) {
      object$.setProperty('execution'.toJS, execution);
    }
    return TaskEndEventDart(TaskEndEvent(object$));
  }
}

extension TaskEndEventToDart on TaskEndEvent {
  TaskEndEventDart get dart => TaskEndEventDart(this);
}

extension type TaskExecutionDart(TaskExecution $js) implements TaskExecution {
  factory TaskExecutionDart.lit$({Task? task, JSFunction? terminate}) {
    final object$ = JSObject();
    if (task != null) {
      object$.setProperty('task'.toJS, task);
    }
    if (terminate != null) {
      object$.setProperty('terminate'.toJS, terminate);
    }
    return TaskExecutionDart(TaskExecution(object$));
  }
}

extension TaskExecutionToDart on TaskExecution {
  TaskExecutionDart get dart => TaskExecutionDart(this);
}

extension type TaskFilterDart(TaskFilter $js) implements TaskFilter {
  factory TaskFilterDart.lit$({String? type, String? version}) {
    final object$ = JSObject();
    if (type != null) {
      object$.setProperty('type'.toJS, type.toJS);
    }
    if (version != null) {
      object$.setProperty('version'.toJS, version.toJS);
    }
    return TaskFilterDart(TaskFilter(object$));
  }
}

extension TaskFilterToDart on TaskFilter {
  TaskFilterDart get dart => TaskFilterDart(this);
}

extension type TaskPresentationOptionsDart(TaskPresentationOptions $js) implements TaskPresentationOptions {
  factory TaskPresentationOptionsDart.lit$({bool? clear, bool? close, bool? echo, bool? focus, num? panel, num? reveal, bool? showReuseMessage}) {
    final object$ = JSObject();
    if (clear != null) {
      object$.setProperty('clear'.toJS, clear.toJS);
    }
    if (close != null) {
      object$.setProperty('close'.toJS, close.toJS);
    }
    if (echo != null) {
      object$.setProperty('echo'.toJS, echo.toJS);
    }
    if (focus != null) {
      object$.setProperty('focus'.toJS, focus.toJS);
    }
    if (panel != null) {
      object$.setProperty('panel'.toJS, panel.toJS);
    }
    if (reveal != null) {
      object$.setProperty('reveal'.toJS, reveal.toJS);
    }
    if (showReuseMessage != null) {
      object$.setProperty('showReuseMessage'.toJS, showReuseMessage.toJS);
    }
    return TaskPresentationOptionsDart(TaskPresentationOptions(object$));
  }
}

extension TaskPresentationOptionsToDart on TaskPresentationOptions {
  TaskPresentationOptionsDart get dart => TaskPresentationOptionsDart(this);
}

extension type TaskProcessEndEventDart(TaskProcessEndEvent $js) implements TaskProcessEndEvent {
  factory TaskProcessEndEventDart.lit$({TaskExecution? execution, num? exitCode}) {
    final object$ = JSObject();
    if (execution != null) {
      object$.setProperty('execution'.toJS, execution);
    }
    if (exitCode != null) {
      object$.setProperty('exitCode'.toJS, exitCode.toJS);
    }
    return TaskProcessEndEventDart(TaskProcessEndEvent(object$));
  }
}

extension TaskProcessEndEventToDart on TaskProcessEndEvent {
  TaskProcessEndEventDart get dart => TaskProcessEndEventDart(this);
}

extension type TaskProcessStartEventDart(TaskProcessStartEvent $js) implements TaskProcessStartEvent {
  factory TaskProcessStartEventDart.lit$({TaskExecution? execution, num? processId}) {
    final object$ = JSObject();
    if (execution != null) {
      object$.setProperty('execution'.toJS, execution);
    }
    if (processId != null) {
      object$.setProperty('processId'.toJS, processId.toJS);
    }
    return TaskProcessStartEventDart(TaskProcessStartEvent(object$));
  }
}

extension TaskProcessStartEventToDart on TaskProcessStartEvent {
  TaskProcessStartEventDart get dart => TaskProcessStartEventDart(this);
}

extension type TaskProviderDart<T extends JSAny?>(TaskProvider<T> $js) implements TaskProvider<T> {
  factory TaskProviderDart.lit$({JSFunction? provideTasks, JSFunction? resolveTask}) {
    final object$ = JSObject();
    if (provideTasks != null) {
      object$.setProperty('provideTasks'.toJS, provideTasks);
    }
    if (resolveTask != null) {
      object$.setProperty('resolveTask'.toJS, resolveTask);
    }
    return TaskProviderDart<T>(TaskProvider<T>(object$));
  }
}

extension TaskProviderToDart<T extends JSAny?> on TaskProvider<T> {
  TaskProviderDart<T> get dart => TaskProviderDart<T>(this);
}

extension type TaskStartEventDart(TaskStartEvent $js) implements TaskStartEvent {
  factory TaskStartEventDart.lit$({TaskExecution? execution}) {
    final object$ = JSObject();
    if (execution != null) {
      object$.setProperty('execution'.toJS, execution);
    }
    return TaskStartEventDart(TaskStartEvent(object$));
  }
}

extension TaskStartEventToDart on TaskStartEvent {
  TaskStartEventDart get dart => TaskStartEventDart(this);
}

extension type TelemetryLoggerDart(TelemetryLogger $js) implements TelemetryLogger {
  factory TelemetryLoggerDart.lit$({JSFunction? dispose, bool? isErrorsEnabled, bool? isUsageEnabled, JSFunction? logError, JSFunction? logUsage, Event<TelemetryLogger>? onDidChangeEnableStates}) {
    final object$ = JSObject();
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (isErrorsEnabled != null) {
      object$.setProperty('isErrorsEnabled'.toJS, isErrorsEnabled.toJS);
    }
    if (isUsageEnabled != null) {
      object$.setProperty('isUsageEnabled'.toJS, isUsageEnabled.toJS);
    }
    if (logError != null) {
      object$.setProperty('logError'.toJS, logError);
    }
    if (logUsage != null) {
      object$.setProperty('logUsage'.toJS, logUsage);
    }
    if (onDidChangeEnableStates != null) {
      object$.setProperty('onDidChangeEnableStates'.toJS, onDidChangeEnableStates);
    }
    return TelemetryLoggerDart(TelemetryLogger(object$));
  }
  Stream<TelemetryLogger> get onDidChangeEnableStatesStream => _eventStream$(
        (listener) => $js.onDidChangeEnableStates.call(listener),
        (raw) => raw as TelemetryLogger,
      );
}

extension TelemetryLoggerToDart on TelemetryLogger {
  TelemetryLoggerDart get dart => TelemetryLoggerDart(this);
}

extension type TelemetryLoggerOptionsDart(TelemetryLoggerOptions $js) implements TelemetryLoggerOptions {
  factory TelemetryLoggerOptionsDart.lit$({JSObject? additionalCommonProperties, bool? ignoreBuiltInCommonProperties, bool? ignoreUnhandledErrors}) {
    final object$ = JSObject();
    if (additionalCommonProperties != null) {
      object$.setProperty('additionalCommonProperties'.toJS, additionalCommonProperties);
    }
    if (ignoreBuiltInCommonProperties != null) {
      object$.setProperty('ignoreBuiltInCommonProperties'.toJS, ignoreBuiltInCommonProperties.toJS);
    }
    if (ignoreUnhandledErrors != null) {
      object$.setProperty('ignoreUnhandledErrors'.toJS, ignoreUnhandledErrors.toJS);
    }
    return TelemetryLoggerOptionsDart(TelemetryLoggerOptions(object$));
  }
}

extension TelemetryLoggerOptionsToDart on TelemetryLoggerOptions {
  TelemetryLoggerOptionsDart get dart => TelemetryLoggerOptionsDart(this);
}

extension type TelemetrySenderDart(TelemetrySender $js) implements TelemetrySender {
  factory TelemetrySenderDart.lit$({JSFunction? flush, JSFunction? sendErrorData, JSFunction? sendEventData}) {
    final object$ = JSObject();
    if (flush != null) {
      object$.setProperty('flush'.toJS, flush);
    }
    if (sendErrorData != null) {
      object$.setProperty('sendErrorData'.toJS, sendErrorData);
    }
    if (sendEventData != null) {
      object$.setProperty('sendEventData'.toJS, sendEventData);
    }
    return TelemetrySenderDart(TelemetrySender(object$));
  }
}

extension TelemetrySenderToDart on TelemetrySender {
  TelemetrySenderDart get dart => TelemetrySenderDart(this);
}

extension type TerminalDart(Terminal $js) implements Terminal {
  factory TerminalDart.lit$({JSObject? creationOptions, JSFunction? dispose, TerminalExitStatus? exitStatus, JSFunction? hide, String? name, JSPromise<JSNumber?>? processId, JSFunction? sendText, TerminalShellIntegration? shellIntegration, JSFunction? show, TerminalState? state}) {
    final object$ = JSObject();
    if (creationOptions != null) {
      object$.setProperty('creationOptions'.toJS, creationOptions);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (exitStatus != null) {
      object$.setProperty('exitStatus'.toJS, exitStatus);
    }
    if (hide != null) {
      object$.setProperty('hide'.toJS, hide);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (processId != null) {
      object$.setProperty('processId'.toJS, processId);
    }
    if (sendText != null) {
      object$.setProperty('sendText'.toJS, sendText);
    }
    if (shellIntegration != null) {
      object$.setProperty('shellIntegration'.toJS, shellIntegration);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    if (state != null) {
      object$.setProperty('state'.toJS, state);
    }
    return TerminalDart(Terminal(object$));
  }
  Future<num?> get processId => $js.processId.toDart.then((value) => value?.toDartDouble);
}

extension TerminalToDart on Terminal {
  TerminalDart get dart => TerminalDart(this);
}

extension type TerminalDimensionsDart(TerminalDimensions $js) implements TerminalDimensions {
  factory TerminalDimensionsDart.lit$({num? columns, num? rows}) {
    final object$ = JSObject();
    if (columns != null) {
      object$.setProperty('columns'.toJS, columns.toJS);
    }
    if (rows != null) {
      object$.setProperty('rows'.toJS, rows.toJS);
    }
    return TerminalDimensionsDart(TerminalDimensions(object$));
  }
}

extension TerminalDimensionsToDart on TerminalDimensions {
  TerminalDimensionsDart get dart => TerminalDimensionsDart(this);
}

extension type TerminalEditorLocationOptionsDart(TerminalEditorLocationOptions $js) implements TerminalEditorLocationOptions {
  factory TerminalEditorLocationOptionsDart.lit$({bool? preserveFocus, num? viewColumn}) {
    final object$ = JSObject();
    if (preserveFocus != null) {
      object$.setProperty('preserveFocus'.toJS, preserveFocus.toJS);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    return TerminalEditorLocationOptionsDart(TerminalEditorLocationOptions(object$));
  }
}

extension TerminalEditorLocationOptionsToDart on TerminalEditorLocationOptions {
  TerminalEditorLocationOptionsDart get dart => TerminalEditorLocationOptionsDart(this);
}

extension type TerminalExitStatusDart(TerminalExitStatus $js) implements TerminalExitStatus {
  factory TerminalExitStatusDart.lit$({num? code, num? reason}) {
    final object$ = JSObject();
    if (code != null) {
      object$.setProperty('code'.toJS, code.toJS);
    }
    if (reason != null) {
      object$.setProperty('reason'.toJS, reason.toJS);
    }
    return TerminalExitStatusDart(TerminalExitStatus(object$));
  }
}

extension TerminalExitStatusToDart on TerminalExitStatus {
  TerminalExitStatusDart get dart => TerminalExitStatusDart(this);
}

extension type TerminalLinkContextDart(TerminalLinkContext $js) implements TerminalLinkContext {
  factory TerminalLinkContextDart.lit$({String? line, Terminal? terminal}) {
    final object$ = JSObject();
    if (line != null) {
      object$.setProperty('line'.toJS, line.toJS);
    }
    if (terminal != null) {
      object$.setProperty('terminal'.toJS, terminal);
    }
    return TerminalLinkContextDart(TerminalLinkContext(object$));
  }
}

extension TerminalLinkContextToDart on TerminalLinkContext {
  TerminalLinkContextDart get dart => TerminalLinkContextDart(this);
}

extension type TerminalLinkProviderDart<T extends JSAny?>(TerminalLinkProvider<T> $js) implements TerminalLinkProvider<T> {
  factory TerminalLinkProviderDart.lit$({JSFunction? handleTerminalLink, JSFunction? provideTerminalLinks}) {
    final object$ = JSObject();
    if (handleTerminalLink != null) {
      object$.setProperty('handleTerminalLink'.toJS, handleTerminalLink);
    }
    if (provideTerminalLinks != null) {
      object$.setProperty('provideTerminalLinks'.toJS, provideTerminalLinks);
    }
    return TerminalLinkProviderDart<T>(TerminalLinkProvider<T>(object$));
  }
}

extension TerminalLinkProviderToDart<T extends JSAny?> on TerminalLinkProvider<T> {
  TerminalLinkProviderDart<T> get dart => TerminalLinkProviderDart<T>(this);
}

extension type TerminalOptionsDart(TerminalOptions $js) implements TerminalOptions {
  factory TerminalOptionsDart.lit$({ThemeColor? color, JSAny? cwd, JSAnon_5cec6a3f14bb? env, bool? hideFromUser, JSObject? iconPath, bool? isTransient, JSAny? location, String? message, String? name, JSAny? shellArgs, String? shellIntegrationNonce, String? shellPath, bool? strictEnv}) {
    final object$ = JSObject();
    if (color != null) {
      object$.setProperty('color'.toJS, color);
    }
    if (cwd != null) {
      object$.setProperty('cwd'.toJS, cwd);
    }
    if (env != null) {
      object$.setProperty('env'.toJS, env);
    }
    if (hideFromUser != null) {
      object$.setProperty('hideFromUser'.toJS, hideFromUser.toJS);
    }
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (isTransient != null) {
      object$.setProperty('isTransient'.toJS, isTransient.toJS);
    }
    if (location != null) {
      object$.setProperty('location'.toJS, location);
    }
    if (message != null) {
      object$.setProperty('message'.toJS, message.toJS);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (shellArgs != null) {
      object$.setProperty('shellArgs'.toJS, shellArgs);
    }
    if (shellIntegrationNonce != null) {
      object$.setProperty('shellIntegrationNonce'.toJS, shellIntegrationNonce.toJS);
    }
    if (shellPath != null) {
      object$.setProperty('shellPath'.toJS, shellPath.toJS);
    }
    if (strictEnv != null) {
      object$.setProperty('strictEnv'.toJS, strictEnv.toJS);
    }
    return TerminalOptionsDart(TerminalOptions(object$));
  }
}

extension TerminalOptionsToDart on TerminalOptions {
  TerminalOptionsDart get dart => TerminalOptionsDart(this);
}

extension type TerminalProfileProviderDart(TerminalProfileProvider $js) implements TerminalProfileProvider {
  factory TerminalProfileProviderDart.lit$({JSFunction? provideTerminalProfile}) {
    final object$ = JSObject();
    if (provideTerminalProfile != null) {
      object$.setProperty('provideTerminalProfile'.toJS, provideTerminalProfile);
    }
    return TerminalProfileProviderDart(TerminalProfileProvider(object$));
  }
}

extension TerminalProfileProviderToDart on TerminalProfileProvider {
  TerminalProfileProviderDart get dart => TerminalProfileProviderDart(this);
}

extension type TerminalShellExecutionDart(TerminalShellExecution $js) implements TerminalShellExecution {
  factory TerminalShellExecutionDart.lit$({TerminalShellExecutionCommandLine? commandLine, Uri? cwd, JSFunction? read}) {
    final object$ = JSObject();
    if (commandLine != null) {
      object$.setProperty('commandLine'.toJS, commandLine);
    }
    if (cwd != null) {
      object$.setProperty('cwd'.toJS, cwd);
    }
    if (read != null) {
      object$.setProperty('read'.toJS, read);
    }
    return TerminalShellExecutionDart(TerminalShellExecution(object$));
  }
}

extension TerminalShellExecutionToDart on TerminalShellExecution {
  TerminalShellExecutionDart get dart => TerminalShellExecutionDart(this);
}

extension type TerminalShellExecutionCommandLineDart(TerminalShellExecutionCommandLine $js) implements TerminalShellExecutionCommandLine {
  factory TerminalShellExecutionCommandLineDart.lit$({num? confidence, bool? isTrusted, String? value}) {
    final object$ = JSObject();
    if (confidence != null) {
      object$.setProperty('confidence'.toJS, confidence.toJS);
    }
    if (isTrusted != null) {
      object$.setProperty('isTrusted'.toJS, isTrusted.toJS);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    return TerminalShellExecutionCommandLineDart(TerminalShellExecutionCommandLine(object$));
  }
}

extension TerminalShellExecutionCommandLineToDart on TerminalShellExecutionCommandLine {
  TerminalShellExecutionCommandLineDart get dart => TerminalShellExecutionCommandLineDart(this);
}

extension type TerminalShellExecutionEndEventDart(TerminalShellExecutionEndEvent $js) implements TerminalShellExecutionEndEvent {
  factory TerminalShellExecutionEndEventDart.lit$({TerminalShellExecution? execution, num? exitCode, TerminalShellIntegration? shellIntegration, Terminal? terminal}) {
    final object$ = JSObject();
    if (execution != null) {
      object$.setProperty('execution'.toJS, execution);
    }
    if (exitCode != null) {
      object$.setProperty('exitCode'.toJS, exitCode.toJS);
    }
    if (shellIntegration != null) {
      object$.setProperty('shellIntegration'.toJS, shellIntegration);
    }
    if (terminal != null) {
      object$.setProperty('terminal'.toJS, terminal);
    }
    return TerminalShellExecutionEndEventDart(TerminalShellExecutionEndEvent(object$));
  }
}

extension TerminalShellExecutionEndEventToDart on TerminalShellExecutionEndEvent {
  TerminalShellExecutionEndEventDart get dart => TerminalShellExecutionEndEventDart(this);
}

extension type TerminalShellExecutionStartEventDart(TerminalShellExecutionStartEvent $js) implements TerminalShellExecutionStartEvent {
  factory TerminalShellExecutionStartEventDart.lit$({TerminalShellExecution? execution, TerminalShellIntegration? shellIntegration, Terminal? terminal}) {
    final object$ = JSObject();
    if (execution != null) {
      object$.setProperty('execution'.toJS, execution);
    }
    if (shellIntegration != null) {
      object$.setProperty('shellIntegration'.toJS, shellIntegration);
    }
    if (terminal != null) {
      object$.setProperty('terminal'.toJS, terminal);
    }
    return TerminalShellExecutionStartEventDart(TerminalShellExecutionStartEvent(object$));
  }
}

extension TerminalShellExecutionStartEventToDart on TerminalShellExecutionStartEvent {
  TerminalShellExecutionStartEventDart get dart => TerminalShellExecutionStartEventDart(this);
}

extension type TerminalShellIntegrationDart(TerminalShellIntegration $js) implements TerminalShellIntegration {
  factory TerminalShellIntegrationDart.lit$({Uri? cwd, JSFunction? executeCommand}) {
    final object$ = JSObject();
    if (cwd != null) {
      object$.setProperty('cwd'.toJS, cwd);
    }
    if (executeCommand != null) {
      object$.setProperty('executeCommand'.toJS, executeCommand);
    }
    return TerminalShellIntegrationDart(TerminalShellIntegration(object$));
  }
}

extension TerminalShellIntegrationToDart on TerminalShellIntegration {
  TerminalShellIntegrationDart get dart => TerminalShellIntegrationDart(this);
}

extension type TerminalShellIntegrationChangeEventDart(TerminalShellIntegrationChangeEvent $js) implements TerminalShellIntegrationChangeEvent {
  factory TerminalShellIntegrationChangeEventDart.lit$({TerminalShellIntegration? shellIntegration, Terminal? terminal}) {
    final object$ = JSObject();
    if (shellIntegration != null) {
      object$.setProperty('shellIntegration'.toJS, shellIntegration);
    }
    if (terminal != null) {
      object$.setProperty('terminal'.toJS, terminal);
    }
    return TerminalShellIntegrationChangeEventDart(TerminalShellIntegrationChangeEvent(object$));
  }
}

extension TerminalShellIntegrationChangeEventToDart on TerminalShellIntegrationChangeEvent {
  TerminalShellIntegrationChangeEventDart get dart => TerminalShellIntegrationChangeEventDart(this);
}

extension type TerminalSplitLocationOptionsDart(TerminalSplitLocationOptions $js) implements TerminalSplitLocationOptions {
  factory TerminalSplitLocationOptionsDart.lit$({Terminal? parentTerminal}) {
    final object$ = JSObject();
    if (parentTerminal != null) {
      object$.setProperty('parentTerminal'.toJS, parentTerminal);
    }
    return TerminalSplitLocationOptionsDart(TerminalSplitLocationOptions(object$));
  }
}

extension TerminalSplitLocationOptionsToDart on TerminalSplitLocationOptions {
  TerminalSplitLocationOptionsDart get dart => TerminalSplitLocationOptionsDart(this);
}

extension type TerminalStateDart(TerminalState $js) implements TerminalState {
  factory TerminalStateDart.lit$({bool? isInteractedWith, String? shell}) {
    final object$ = JSObject();
    if (isInteractedWith != null) {
      object$.setProperty('isInteractedWith'.toJS, isInteractedWith.toJS);
    }
    if (shell != null) {
      object$.setProperty('shell'.toJS, shell.toJS);
    }
    return TerminalStateDart(TerminalState(object$));
  }
}

extension TerminalStateToDart on TerminalState {
  TerminalStateDart get dart => TerminalStateDart(this);
}

extension type TestControllerDart(TestController $js) implements TestController {
  factory TestControllerDart.lit$({JSFunction? createRunProfile, JSFunction? createTestItem, JSFunction? createTestRun, JSFunction? dispose, String? id, JSFunction? invalidateTestResults, TestItemCollection? items, String? label, JSFunction? refreshHandler, JSFunction? resolveHandler}) {
    final object$ = JSObject();
    if (createRunProfile != null) {
      object$.setProperty('createRunProfile'.toJS, createRunProfile);
    }
    if (createTestItem != null) {
      object$.setProperty('createTestItem'.toJS, createTestItem);
    }
    if (createTestRun != null) {
      object$.setProperty('createTestRun'.toJS, createTestRun);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (invalidateTestResults != null) {
      object$.setProperty('invalidateTestResults'.toJS, invalidateTestResults);
    }
    if (items != null) {
      object$.setProperty('items'.toJS, items);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (refreshHandler != null) {
      object$.setProperty('refreshHandler'.toJS, refreshHandler);
    }
    if (resolveHandler != null) {
      object$.setProperty('resolveHandler'.toJS, resolveHandler);
    }
    return TestControllerDart(TestController(object$));
  }
}

extension TestControllerToDart on TestController {
  TestControllerDart get dart => TestControllerDart(this);
}

extension type TestItemDart(TestItem $js) implements TestItem {
  factory TestItemDart.lit$({bool? busy, bool? canResolveChildren, TestItemCollection? children, String? description, JSAny? error, String? id, String? label, TestItem? parent, Range? range, String? sortText, JSArray<TestTag>? tags, Uri? uri}) {
    final object$ = JSObject();
    if (busy != null) {
      object$.setProperty('busy'.toJS, busy.toJS);
    }
    if (canResolveChildren != null) {
      object$.setProperty('canResolveChildren'.toJS, canResolveChildren.toJS);
    }
    if (children != null) {
      object$.setProperty('children'.toJS, children);
    }
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (error != null) {
      object$.setProperty('error'.toJS, error);
    }
    if (id != null) {
      object$.setProperty('id'.toJS, id.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (parent != null) {
      object$.setProperty('parent'.toJS, parent);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    if (sortText != null) {
      object$.setProperty('sortText'.toJS, sortText.toJS);
    }
    if (tags != null) {
      object$.setProperty('tags'.toJS, tags);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return TestItemDart(TestItem(object$));
  }
}

extension TestItemToDart on TestItem {
  TestItemDart get dart => TestItemDart(this);
}

extension type TestItemCollectionDart(TestItemCollection $js) implements TestItemCollection {
  factory TestItemCollectionDart.lit$({JSFunction? add, JSFunction? delete, JSFunction? forEach, JSFunction? get, JSFunction? replace, num? size}) {
    final object$ = JSObject();
    if (add != null) {
      object$.setProperty('add'.toJS, add);
    }
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (forEach != null) {
      object$.setProperty('forEach'.toJS, forEach);
    }
    if (get != null) {
      object$.setProperty('get'.toJS, get);
    }
    if (replace != null) {
      object$.setProperty('replace'.toJS, replace);
    }
    if (size != null) {
      object$.setProperty('size'.toJS, size.toJS);
    }
    return TestItemCollectionDart(TestItemCollection(object$));
  }
}

extension TestItemCollectionToDart on TestItemCollection {
  TestItemCollectionDart get dart => TestItemCollectionDart(this);
}

extension type TestRunDart(TestRun $js) implements TestRun {
  factory TestRunDart.lit$({JSFunction? addCoverage, JSFunction? appendOutput, JSFunction? end, JSFunction? enqueued, JSFunction? errored, JSFunction? failed, bool? isPersisted, String? name, Event<JSAny?>? onDidDispose, JSFunction? passed, JSFunction? skipped, JSFunction? started, CancellationToken? token}) {
    final object$ = JSObject();
    if (addCoverage != null) {
      object$.setProperty('addCoverage'.toJS, addCoverage);
    }
    if (appendOutput != null) {
      object$.setProperty('appendOutput'.toJS, appendOutput);
    }
    if (end != null) {
      object$.setProperty('end'.toJS, end);
    }
    if (enqueued != null) {
      object$.setProperty('enqueued'.toJS, enqueued);
    }
    if (errored != null) {
      object$.setProperty('errored'.toJS, errored);
    }
    if (failed != null) {
      object$.setProperty('failed'.toJS, failed);
    }
    if (isPersisted != null) {
      object$.setProperty('isPersisted'.toJS, isPersisted.toJS);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (onDidDispose != null) {
      object$.setProperty('onDidDispose'.toJS, onDidDispose);
    }
    if (passed != null) {
      object$.setProperty('passed'.toJS, passed);
    }
    if (skipped != null) {
      object$.setProperty('skipped'.toJS, skipped);
    }
    if (started != null) {
      object$.setProperty('started'.toJS, started);
    }
    if (token != null) {
      object$.setProperty('token'.toJS, token);
    }
    return TestRunDart(TestRun(object$));
  }
  Stream<JSAny?> get onDidDisposeStream => _eventStream$(
        (listener) => $js.onDidDispose.call(listener),
        (raw) => raw,
      );
}

extension TestRunToDart on TestRun {
  TestRunDart get dart => TestRunDart(this);
}

extension type TestRunProfileDart(TestRunProfile $js) implements TestRunProfile {
  factory TestRunProfileDart.lit$({JSFunction? configureHandler, JSFunction? dispose, bool? isDefault, num? kind, String? label, JSFunction? loadDetailedCoverage, JSFunction? loadDetailedCoverageForTest, Event<JSBoolean>? onDidChangeDefault, JSFunction? runHandler, bool? supportsContinuousRun, TestTag? tag}) {
    final object$ = JSObject();
    if (configureHandler != null) {
      object$.setProperty('configureHandler'.toJS, configureHandler);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (isDefault != null) {
      object$.setProperty('isDefault'.toJS, isDefault.toJS);
    }
    if (kind != null) {
      object$.setProperty('kind'.toJS, kind.toJS);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (loadDetailedCoverage != null) {
      object$.setProperty('loadDetailedCoverage'.toJS, loadDetailedCoverage);
    }
    if (loadDetailedCoverageForTest != null) {
      object$.setProperty('loadDetailedCoverageForTest'.toJS, loadDetailedCoverageForTest);
    }
    if (onDidChangeDefault != null) {
      object$.setProperty('onDidChangeDefault'.toJS, onDidChangeDefault);
    }
    if (runHandler != null) {
      object$.setProperty('runHandler'.toJS, runHandler);
    }
    if (supportsContinuousRun != null) {
      object$.setProperty('supportsContinuousRun'.toJS, supportsContinuousRun.toJS);
    }
    if (tag != null) {
      object$.setProperty('tag'.toJS, tag);
    }
    return TestRunProfileDart(TestRunProfile(object$));
  }
  Stream<bool> get onDidChangeDefaultStream => _eventStream$(
        (listener) => $js.onDidChangeDefault.call(listener),
        (raw) => (raw! as JSBoolean).toDart,
      );
}

extension TestRunProfileToDart on TestRunProfile {
  TestRunProfileDart get dart => TestRunProfileDart(this);
}

extension type TextDocumentDart(TextDocument $js) implements TextDocument {
  factory TextDocumentDart.lit$({String? encoding, num? eol, String? fileName, JSFunction? getText, JSFunction? getWordRangeAtPosition, bool? isClosed, bool? isDirty, bool? isUntitled, String? languageId, JSFunction? lineAt, num? lineCount, JSFunction? offsetAt, JSFunction? positionAt, JSFunction? save, Uri? uri, JSFunction? validatePosition, JSFunction? validateRange, num? version}) {
    final object$ = JSObject();
    if (encoding != null) {
      object$.setProperty('encoding'.toJS, encoding.toJS);
    }
    if (eol != null) {
      object$.setProperty('eol'.toJS, eol.toJS);
    }
    if (fileName != null) {
      object$.setProperty('fileName'.toJS, fileName.toJS);
    }
    if (getText != null) {
      object$.setProperty('getText'.toJS, getText);
    }
    if (getWordRangeAtPosition != null) {
      object$.setProperty('getWordRangeAtPosition'.toJS, getWordRangeAtPosition);
    }
    if (isClosed != null) {
      object$.setProperty('isClosed'.toJS, isClosed.toJS);
    }
    if (isDirty != null) {
      object$.setProperty('isDirty'.toJS, isDirty.toJS);
    }
    if (isUntitled != null) {
      object$.setProperty('isUntitled'.toJS, isUntitled.toJS);
    }
    if (languageId != null) {
      object$.setProperty('languageId'.toJS, languageId.toJS);
    }
    if (lineAt != null) {
      object$.setProperty('lineAt'.toJS, lineAt);
    }
    if (lineCount != null) {
      object$.setProperty('lineCount'.toJS, lineCount.toJS);
    }
    if (offsetAt != null) {
      object$.setProperty('offsetAt'.toJS, offsetAt);
    }
    if (positionAt != null) {
      object$.setProperty('positionAt'.toJS, positionAt);
    }
    if (save != null) {
      object$.setProperty('save'.toJS, save);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    if (validatePosition != null) {
      object$.setProperty('validatePosition'.toJS, validatePosition);
    }
    if (validateRange != null) {
      object$.setProperty('validateRange'.toJS, validateRange);
    }
    if (version != null) {
      object$.setProperty('version'.toJS, version.toJS);
    }
    return TextDocumentDart(TextDocument(object$));
  }
  Future<bool> save() => $js.save().toDart.then((value) => value.toDart);
}

extension TextDocumentToDart on TextDocument {
  TextDocumentDart get dart => TextDocumentDart(this);
}

extension type TextDocumentChangeEventDart(TextDocumentChangeEvent $js) implements TextDocumentChangeEvent {
  factory TextDocumentChangeEventDart.lit$({JSArray<TextDocumentContentChangeEvent>? contentChanges, TextDocument? document, num? reason}) {
    final object$ = JSObject();
    if (contentChanges != null) {
      object$.setProperty('contentChanges'.toJS, contentChanges);
    }
    if (document != null) {
      object$.setProperty('document'.toJS, document);
    }
    if (reason != null) {
      object$.setProperty('reason'.toJS, reason.toJS);
    }
    return TextDocumentChangeEventDart(TextDocumentChangeEvent(object$));
  }
}

extension TextDocumentChangeEventToDart on TextDocumentChangeEvent {
  TextDocumentChangeEventDart get dart => TextDocumentChangeEventDart(this);
}

extension type TextDocumentContentChangeEventDart(TextDocumentContentChangeEvent $js) implements TextDocumentContentChangeEvent {
  factory TextDocumentContentChangeEventDart.lit$({Range? range, num? rangeLength, num? rangeOffset, String? text}) {
    final object$ = JSObject();
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    if (rangeLength != null) {
      object$.setProperty('rangeLength'.toJS, rangeLength.toJS);
    }
    if (rangeOffset != null) {
      object$.setProperty('rangeOffset'.toJS, rangeOffset.toJS);
    }
    if (text != null) {
      object$.setProperty('text'.toJS, text.toJS);
    }
    return TextDocumentContentChangeEventDart(TextDocumentContentChangeEvent(object$));
  }
}

extension TextDocumentContentChangeEventToDart on TextDocumentContentChangeEvent {
  TextDocumentContentChangeEventDart get dart => TextDocumentContentChangeEventDart(this);
}

extension type TextDocumentContentProviderDart(TextDocumentContentProvider $js) implements TextDocumentContentProvider {
  factory TextDocumentContentProviderDart.lit$({Event<Uri>? onDidChange, JSFunction? provideTextDocumentContent}) {
    final object$ = JSObject();
    if (onDidChange != null) {
      object$.setProperty('onDidChange'.toJS, onDidChange);
    }
    if (provideTextDocumentContent != null) {
      object$.setProperty('provideTextDocumentContent'.toJS, provideTextDocumentContent);
    }
    return TextDocumentContentProviderDart(TextDocumentContentProvider(object$));
  }
  Stream<Uri>? get onDidChangeStream {
    final event$ = $js.onDidChange;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw as Uri,
    );
  }
}

extension TextDocumentContentProviderToDart on TextDocumentContentProvider {
  TextDocumentContentProviderDart get dart => TextDocumentContentProviderDart(this);
}

extension type TextDocumentShowOptionsDart(TextDocumentShowOptions $js) implements TextDocumentShowOptions {
  factory TextDocumentShowOptionsDart.lit$({bool? preserveFocus, bool? preview, Range? selection, num? viewColumn}) {
    final object$ = JSObject();
    if (preserveFocus != null) {
      object$.setProperty('preserveFocus'.toJS, preserveFocus.toJS);
    }
    if (preview != null) {
      object$.setProperty('preview'.toJS, preview.toJS);
    }
    if (selection != null) {
      object$.setProperty('selection'.toJS, selection);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    return TextDocumentShowOptionsDart(TextDocumentShowOptions(object$));
  }
}

extension TextDocumentShowOptionsToDart on TextDocumentShowOptions {
  TextDocumentShowOptionsDart get dart => TextDocumentShowOptionsDart(this);
}

extension type TextDocumentWillSaveEventDart(TextDocumentWillSaveEvent $js) implements TextDocumentWillSaveEvent {
  factory TextDocumentWillSaveEventDart.lit$({TextDocument? document, num? reason, JSFunction? waitUntil}) {
    final object$ = JSObject();
    if (document != null) {
      object$.setProperty('document'.toJS, document);
    }
    if (reason != null) {
      object$.setProperty('reason'.toJS, reason.toJS);
    }
    if (waitUntil != null) {
      object$.setProperty('waitUntil'.toJS, waitUntil);
    }
    return TextDocumentWillSaveEventDart(TextDocumentWillSaveEvent(object$));
  }
}

extension TextDocumentWillSaveEventToDart on TextDocumentWillSaveEvent {
  TextDocumentWillSaveEventDart get dart => TextDocumentWillSaveEventDart(this);
}

extension type TextEditorDart(TextEditor $js) implements TextEditor {
  factory TextEditorDart.lit$({TextDocument? document, JSFunction? edit, JSFunction? hide, JSFunction? insertSnippet, TextEditorOptions? options, JSFunction? revealRange, Selection? selection, JSArray<Selection>? selections, JSFunction? setDecorations, JSFunction? show, num? viewColumn, JSArray<Range>? visibleRanges}) {
    final object$ = JSObject();
    if (document != null) {
      object$.setProperty('document'.toJS, document);
    }
    if (edit != null) {
      object$.setProperty('edit'.toJS, edit);
    }
    if (hide != null) {
      object$.setProperty('hide'.toJS, hide);
    }
    if (insertSnippet != null) {
      object$.setProperty('insertSnippet'.toJS, insertSnippet);
    }
    if (options != null) {
      object$.setProperty('options'.toJS, options);
    }
    if (revealRange != null) {
      object$.setProperty('revealRange'.toJS, revealRange);
    }
    if (selection != null) {
      object$.setProperty('selection'.toJS, selection);
    }
    if (selections != null) {
      object$.setProperty('selections'.toJS, selections);
    }
    if (setDecorations != null) {
      object$.setProperty('setDecorations'.toJS, setDecorations);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    if (visibleRanges != null) {
      object$.setProperty('visibleRanges'.toJS, visibleRanges);
    }
    return TextEditorDart(TextEditor(object$));
  }
  Future<bool> edit(JSFunction callback, [JSAnon_c32f2c0618c1? options]) => (options != null ? $js.edit(callback, options) : $js.edit(callback)).toDart.then((value) => value.toDart);
  Future<bool> insertSnippet(SnippetString snippet, [JSObject? location, JSAnon_d6158a9f7600? options]) => (options != null ? $js.insertSnippet(snippet, location, options) : location != null ? $js.insertSnippet(snippet, location) : $js.insertSnippet(snippet)).toDart.then((value) => value.toDart);
}

extension TextEditorToDart on TextEditor {
  TextEditorDart get dart => TextEditorDart(this);
}

extension type TextEditorDecorationTypeDart(TextEditorDecorationType $js) implements TextEditorDecorationType {
  factory TextEditorDecorationTypeDart.lit$({JSFunction? dispose, String? key}) {
    final object$ = JSObject();
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (key != null) {
      object$.setProperty('key'.toJS, key.toJS);
    }
    return TextEditorDecorationTypeDart(TextEditorDecorationType(object$));
  }
}

extension TextEditorDecorationTypeToDart on TextEditorDecorationType {
  TextEditorDecorationTypeDart get dart => TextEditorDecorationTypeDart(this);
}

extension type TextEditorEditDart(TextEditorEdit $js) implements TextEditorEdit {
  factory TextEditorEditDart.lit$({JSFunction? delete, JSFunction? insert, JSFunction? replace, JSFunction? setEndOfLine}) {
    final object$ = JSObject();
    if (delete != null) {
      object$.setProperty('delete'.toJS, delete);
    }
    if (insert != null) {
      object$.setProperty('insert'.toJS, insert);
    }
    if (replace != null) {
      object$.setProperty('replace'.toJS, replace);
    }
    if (setEndOfLine != null) {
      object$.setProperty('setEndOfLine'.toJS, setEndOfLine);
    }
    return TextEditorEditDart(TextEditorEdit(object$));
  }
}

extension TextEditorEditToDart on TextEditorEdit {
  TextEditorEditDart get dart => TextEditorEditDart(this);
}

extension type TextEditorOptionsDart(TextEditorOptions $js) implements TextEditorOptions {
  factory TextEditorOptionsDart.lit$({num? cursorStyle, JSAny? indentSize, JSAny? insertSpaces, num? lineNumbers, JSAny? tabSize}) {
    final object$ = JSObject();
    if (cursorStyle != null) {
      object$.setProperty('cursorStyle'.toJS, cursorStyle.toJS);
    }
    if (indentSize != null) {
      object$.setProperty('indentSize'.toJS, indentSize);
    }
    if (insertSpaces != null) {
      object$.setProperty('insertSpaces'.toJS, insertSpaces);
    }
    if (lineNumbers != null) {
      object$.setProperty('lineNumbers'.toJS, lineNumbers.toJS);
    }
    if (tabSize != null) {
      object$.setProperty('tabSize'.toJS, tabSize);
    }
    return TextEditorOptionsDart(TextEditorOptions(object$));
  }
}

extension TextEditorOptionsToDart on TextEditorOptions {
  TextEditorOptionsDart get dart => TextEditorOptionsDart(this);
}

extension type TextEditorOptionsChangeEventDart(TextEditorOptionsChangeEvent $js) implements TextEditorOptionsChangeEvent {
  factory TextEditorOptionsChangeEventDart.lit$({TextEditorOptions? options, TextEditor? textEditor}) {
    final object$ = JSObject();
    if (options != null) {
      object$.setProperty('options'.toJS, options);
    }
    if (textEditor != null) {
      object$.setProperty('textEditor'.toJS, textEditor);
    }
    return TextEditorOptionsChangeEventDart(TextEditorOptionsChangeEvent(object$));
  }
}

extension TextEditorOptionsChangeEventToDart on TextEditorOptionsChangeEvent {
  TextEditorOptionsChangeEventDart get dart => TextEditorOptionsChangeEventDart(this);
}

extension type TextEditorSelectionChangeEventDart(TextEditorSelectionChangeEvent $js) implements TextEditorSelectionChangeEvent {
  factory TextEditorSelectionChangeEventDart.lit$({num? kind, JSArray<Selection>? selections, TextEditor? textEditor}) {
    final object$ = JSObject();
    if (kind != null) {
      object$.setProperty('kind'.toJS, kind.toJS);
    }
    if (selections != null) {
      object$.setProperty('selections'.toJS, selections);
    }
    if (textEditor != null) {
      object$.setProperty('textEditor'.toJS, textEditor);
    }
    return TextEditorSelectionChangeEventDart(TextEditorSelectionChangeEvent(object$));
  }
}

extension TextEditorSelectionChangeEventToDart on TextEditorSelectionChangeEvent {
  TextEditorSelectionChangeEventDart get dart => TextEditorSelectionChangeEventDart(this);
}

extension type TextEditorViewColumnChangeEventDart(TextEditorViewColumnChangeEvent $js) implements TextEditorViewColumnChangeEvent {
  factory TextEditorViewColumnChangeEventDart.lit$({TextEditor? textEditor, num? viewColumn}) {
    final object$ = JSObject();
    if (textEditor != null) {
      object$.setProperty('textEditor'.toJS, textEditor);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    return TextEditorViewColumnChangeEventDart(TextEditorViewColumnChangeEvent(object$));
  }
}

extension TextEditorViewColumnChangeEventToDart on TextEditorViewColumnChangeEvent {
  TextEditorViewColumnChangeEventDart get dart => TextEditorViewColumnChangeEventDart(this);
}

extension type TextEditorVisibleRangesChangeEventDart(TextEditorVisibleRangesChangeEvent $js) implements TextEditorVisibleRangesChangeEvent {
  factory TextEditorVisibleRangesChangeEventDart.lit$({TextEditor? textEditor, JSArray<Range>? visibleRanges}) {
    final object$ = JSObject();
    if (textEditor != null) {
      object$.setProperty('textEditor'.toJS, textEditor);
    }
    if (visibleRanges != null) {
      object$.setProperty('visibleRanges'.toJS, visibleRanges);
    }
    return TextEditorVisibleRangesChangeEventDart(TextEditorVisibleRangesChangeEvent(object$));
  }
}

extension TextEditorVisibleRangesChangeEventToDart on TextEditorVisibleRangesChangeEvent {
  TextEditorVisibleRangesChangeEventDart get dart => TextEditorVisibleRangesChangeEventDart(this);
}

extension type TextLineDart(TextLine $js) implements TextLine {
  factory TextLineDart.lit$({num? firstNonWhitespaceCharacterIndex, bool? isEmptyOrWhitespace, num? lineNumber, Range? range, Range? rangeIncludingLineBreak, String? text}) {
    final object$ = JSObject();
    if (firstNonWhitespaceCharacterIndex != null) {
      object$.setProperty('firstNonWhitespaceCharacterIndex'.toJS, firstNonWhitespaceCharacterIndex.toJS);
    }
    if (isEmptyOrWhitespace != null) {
      object$.setProperty('isEmptyOrWhitespace'.toJS, isEmptyOrWhitespace.toJS);
    }
    if (lineNumber != null) {
      object$.setProperty('lineNumber'.toJS, lineNumber.toJS);
    }
    if (range != null) {
      object$.setProperty('range'.toJS, range);
    }
    if (rangeIncludingLineBreak != null) {
      object$.setProperty('rangeIncludingLineBreak'.toJS, rangeIncludingLineBreak);
    }
    if (text != null) {
      object$.setProperty('text'.toJS, text.toJS);
    }
    return TextLineDart(TextLine(object$));
  }
}

extension TextLineToDart on TextLine {
  TextLineDart get dart => TextLineDart(this);
}

extension type ThemableDecorationAttachmentRenderOptionsDart(ThemableDecorationAttachmentRenderOptions $js) implements ThemableDecorationAttachmentRenderOptions {
  factory ThemableDecorationAttachmentRenderOptionsDart.lit$({JSAny? backgroundColor, String? border, JSAny? borderColor, JSAny? color, JSAny? contentIconPath, String? contentText, String? fontStyle, String? fontWeight, String? height, String? margin, String? textDecoration, String? width}) {
    final object$ = JSObject();
    if (backgroundColor != null) {
      object$.setProperty('backgroundColor'.toJS, backgroundColor);
    }
    if (border != null) {
      object$.setProperty('border'.toJS, border.toJS);
    }
    if (borderColor != null) {
      object$.setProperty('borderColor'.toJS, borderColor);
    }
    if (color != null) {
      object$.setProperty('color'.toJS, color);
    }
    if (contentIconPath != null) {
      object$.setProperty('contentIconPath'.toJS, contentIconPath);
    }
    if (contentText != null) {
      object$.setProperty('contentText'.toJS, contentText.toJS);
    }
    if (fontStyle != null) {
      object$.setProperty('fontStyle'.toJS, fontStyle.toJS);
    }
    if (fontWeight != null) {
      object$.setProperty('fontWeight'.toJS, fontWeight.toJS);
    }
    if (height != null) {
      object$.setProperty('height'.toJS, height.toJS);
    }
    if (margin != null) {
      object$.setProperty('margin'.toJS, margin.toJS);
    }
    if (textDecoration != null) {
      object$.setProperty('textDecoration'.toJS, textDecoration.toJS);
    }
    if (width != null) {
      object$.setProperty('width'.toJS, width.toJS);
    }
    return ThemableDecorationAttachmentRenderOptionsDart(ThemableDecorationAttachmentRenderOptions(object$));
  }
}

extension ThemableDecorationAttachmentRenderOptionsToDart on ThemableDecorationAttachmentRenderOptions {
  ThemableDecorationAttachmentRenderOptionsDart get dart => ThemableDecorationAttachmentRenderOptionsDart(this);
}

extension type ThemableDecorationInstanceRenderOptionsDart(ThemableDecorationInstanceRenderOptions $js) implements ThemableDecorationInstanceRenderOptions {
  factory ThemableDecorationInstanceRenderOptionsDart.lit$({ThemableDecorationAttachmentRenderOptions? after, ThemableDecorationAttachmentRenderOptions? before}) {
    final object$ = JSObject();
    if (after != null) {
      object$.setProperty('after'.toJS, after);
    }
    if (before != null) {
      object$.setProperty('before'.toJS, before);
    }
    return ThemableDecorationInstanceRenderOptionsDart(ThemableDecorationInstanceRenderOptions(object$));
  }
}

extension ThemableDecorationInstanceRenderOptionsToDart on ThemableDecorationInstanceRenderOptions {
  ThemableDecorationInstanceRenderOptionsDart get dart => ThemableDecorationInstanceRenderOptionsDart(this);
}

extension type ThemableDecorationRenderOptionsDart(ThemableDecorationRenderOptions $js) implements ThemableDecorationRenderOptions {
  factory ThemableDecorationRenderOptionsDart.lit$({ThemableDecorationAttachmentRenderOptions? after, JSAny? backgroundColor, ThemableDecorationAttachmentRenderOptions? before, String? border, JSAny? borderColor, String? borderRadius, String? borderSpacing, String? borderStyle, String? borderWidth, JSAny? color, String? cursor, String? fontStyle, String? fontWeight, JSAny? gutterIconPath, String? gutterIconSize, String? letterSpacing, String? opacity, String? outline, JSAny? outlineColor, String? outlineStyle, String? outlineWidth, JSAny? overviewRulerColor, String? textDecoration}) {
    final object$ = JSObject();
    if (after != null) {
      object$.setProperty('after'.toJS, after);
    }
    if (backgroundColor != null) {
      object$.setProperty('backgroundColor'.toJS, backgroundColor);
    }
    if (before != null) {
      object$.setProperty('before'.toJS, before);
    }
    if (border != null) {
      object$.setProperty('border'.toJS, border.toJS);
    }
    if (borderColor != null) {
      object$.setProperty('borderColor'.toJS, borderColor);
    }
    if (borderRadius != null) {
      object$.setProperty('borderRadius'.toJS, borderRadius.toJS);
    }
    if (borderSpacing != null) {
      object$.setProperty('borderSpacing'.toJS, borderSpacing.toJS);
    }
    if (borderStyle != null) {
      object$.setProperty('borderStyle'.toJS, borderStyle.toJS);
    }
    if (borderWidth != null) {
      object$.setProperty('borderWidth'.toJS, borderWidth.toJS);
    }
    if (color != null) {
      object$.setProperty('color'.toJS, color);
    }
    if (cursor != null) {
      object$.setProperty('cursor'.toJS, cursor.toJS);
    }
    if (fontStyle != null) {
      object$.setProperty('fontStyle'.toJS, fontStyle.toJS);
    }
    if (fontWeight != null) {
      object$.setProperty('fontWeight'.toJS, fontWeight.toJS);
    }
    if (gutterIconPath != null) {
      object$.setProperty('gutterIconPath'.toJS, gutterIconPath);
    }
    if (gutterIconSize != null) {
      object$.setProperty('gutterIconSize'.toJS, gutterIconSize.toJS);
    }
    if (letterSpacing != null) {
      object$.setProperty('letterSpacing'.toJS, letterSpacing.toJS);
    }
    if (opacity != null) {
      object$.setProperty('opacity'.toJS, opacity.toJS);
    }
    if (outline != null) {
      object$.setProperty('outline'.toJS, outline.toJS);
    }
    if (outlineColor != null) {
      object$.setProperty('outlineColor'.toJS, outlineColor);
    }
    if (outlineStyle != null) {
      object$.setProperty('outlineStyle'.toJS, outlineStyle.toJS);
    }
    if (outlineWidth != null) {
      object$.setProperty('outlineWidth'.toJS, outlineWidth.toJS);
    }
    if (overviewRulerColor != null) {
      object$.setProperty('overviewRulerColor'.toJS, overviewRulerColor);
    }
    if (textDecoration != null) {
      object$.setProperty('textDecoration'.toJS, textDecoration.toJS);
    }
    return ThemableDecorationRenderOptionsDart(ThemableDecorationRenderOptions(object$));
  }
}

extension ThemableDecorationRenderOptionsToDart on ThemableDecorationRenderOptions {
  ThemableDecorationRenderOptionsDart get dart => ThemableDecorationRenderOptionsDart(this);
}

extension type TreeCheckboxChangeEventDart<T extends JSAny?>(TreeCheckboxChangeEvent<T> $js) implements TreeCheckboxChangeEvent<T> {
  factory TreeCheckboxChangeEventDart.lit$({JSArray<JSTuple_87f74e97d0da>? items}) {
    final object$ = JSObject();
    if (items != null) {
      object$.setProperty('items'.toJS, items);
    }
    return TreeCheckboxChangeEventDart<T>(TreeCheckboxChangeEvent<T>(object$));
  }
}

extension TreeCheckboxChangeEventToDart<T extends JSAny?> on TreeCheckboxChangeEvent<T> {
  TreeCheckboxChangeEventDart<T> get dart => TreeCheckboxChangeEventDart<T>(this);
}

extension type TreeDataProviderDart<T extends JSAny?>(TreeDataProvider<T> $js) implements TreeDataProvider<T> {
  factory TreeDataProviderDart.lit$({JSFunction? getChildren, JSFunction? getParent, JSFunction? getTreeItem, Event<JSAny?>? onDidChangeTreeData, JSFunction? resolveTreeItem}) {
    final object$ = JSObject();
    if (getChildren != null) {
      object$.setProperty('getChildren'.toJS, getChildren);
    }
    if (getParent != null) {
      object$.setProperty('getParent'.toJS, getParent);
    }
    if (getTreeItem != null) {
      object$.setProperty('getTreeItem'.toJS, getTreeItem);
    }
    if (onDidChangeTreeData != null) {
      object$.setProperty('onDidChangeTreeData'.toJS, onDidChangeTreeData);
    }
    if (resolveTreeItem != null) {
      object$.setProperty('resolveTreeItem'.toJS, resolveTreeItem);
    }
    return TreeDataProviderDart<T>(TreeDataProvider<T>(object$));
  }
  Stream<JSAny?>? get onDidChangeTreeDataStream {
    final event$ = $js.onDidChangeTreeData;
    if (event$ == null) return null;
    return _eventStream$(
      (listener) => event$.call(listener),
      (raw) => raw,
    );
  }
}

extension TreeDataProviderToDart<T extends JSAny?> on TreeDataProvider<T> {
  TreeDataProviderDart<T> get dart => TreeDataProviderDart<T>(this);
}

extension type TreeDragAndDropControllerDart<T extends JSAny?>(TreeDragAndDropController<T> $js) implements TreeDragAndDropController<T> {
  factory TreeDragAndDropControllerDart.lit$({JSArray<JSString>? dragMimeTypes, JSArray<JSString>? dropMimeTypes, JSFunction? handleDrag, JSFunction? handleDrop}) {
    final object$ = JSObject();
    if (dragMimeTypes != null) {
      object$.setProperty('dragMimeTypes'.toJS, dragMimeTypes);
    }
    if (dropMimeTypes != null) {
      object$.setProperty('dropMimeTypes'.toJS, dropMimeTypes);
    }
    if (handleDrag != null) {
      object$.setProperty('handleDrag'.toJS, handleDrag);
    }
    if (handleDrop != null) {
      object$.setProperty('handleDrop'.toJS, handleDrop);
    }
    return TreeDragAndDropControllerDart<T>(TreeDragAndDropController<T>(object$));
  }
}

extension TreeDragAndDropControllerToDart<T extends JSAny?> on TreeDragAndDropController<T> {
  TreeDragAndDropControllerDart<T> get dart => TreeDragAndDropControllerDart<T>(this);
}

extension type TreeItemLabelDart(TreeItemLabel $js) implements TreeItemLabel {
  factory TreeItemLabelDart.lit$({JSArray<JSTuple_9b5999d5c048>? highlights, String? label}) {
    final object$ = JSObject();
    if (highlights != null) {
      object$.setProperty('highlights'.toJS, highlights);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    return TreeItemLabelDart(TreeItemLabel(object$));
  }
}

extension TreeItemLabelToDart on TreeItemLabel {
  TreeItemLabelDart get dart => TreeItemLabelDart(this);
}

extension type TreeViewDart<T extends JSAny?>(TreeView<T> $js) implements TreeView<T> {
  factory TreeViewDart.lit$({ViewBadge? badge, String? description, String? message, Event<TreeCheckboxChangeEvent<T>>? onDidChangeCheckboxState, Event<TreeViewSelectionChangeEvent<T>>? onDidChangeSelection, Event<TreeViewVisibilityChangeEvent>? onDidChangeVisibility, Event<TreeViewExpansionEvent<T>>? onDidCollapseElement, Event<TreeViewExpansionEvent<T>>? onDidExpandElement, JSFunction? reveal, JSArray<T>? selection, String? title, bool? visible, JSFunction? dispose}) {
    final object$ = JSObject();
    if (badge != null) {
      object$.setProperty('badge'.toJS, badge);
    }
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (message != null) {
      object$.setProperty('message'.toJS, message.toJS);
    }
    if (onDidChangeCheckboxState != null) {
      object$.setProperty('onDidChangeCheckboxState'.toJS, onDidChangeCheckboxState);
    }
    if (onDidChangeSelection != null) {
      object$.setProperty('onDidChangeSelection'.toJS, onDidChangeSelection);
    }
    if (onDidChangeVisibility != null) {
      object$.setProperty('onDidChangeVisibility'.toJS, onDidChangeVisibility);
    }
    if (onDidCollapseElement != null) {
      object$.setProperty('onDidCollapseElement'.toJS, onDidCollapseElement);
    }
    if (onDidExpandElement != null) {
      object$.setProperty('onDidExpandElement'.toJS, onDidExpandElement);
    }
    if (reveal != null) {
      object$.setProperty('reveal'.toJS, reveal);
    }
    if (selection != null) {
      object$.setProperty('selection'.toJS, selection);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    if (visible != null) {
      object$.setProperty('visible'.toJS, visible.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    return TreeViewDart<T>(TreeView<T>(object$));
  }
  Stream<TreeCheckboxChangeEvent<T>> get onDidChangeCheckboxStateStream => _eventStream$(
        (listener) => $js.onDidChangeCheckboxState.call(listener),
        (raw) => raw as TreeCheckboxChangeEvent<T>,
      );
  Stream<TreeViewSelectionChangeEvent<T>> get onDidChangeSelectionStream => _eventStream$(
        (listener) => $js.onDidChangeSelection.call(listener),
        (raw) => raw as TreeViewSelectionChangeEvent<T>,
      );
  Stream<TreeViewVisibilityChangeEvent> get onDidChangeVisibilityStream => _eventStream$(
        (listener) => $js.onDidChangeVisibility.call(listener),
        (raw) => raw as TreeViewVisibilityChangeEvent,
      );
  Stream<TreeViewExpansionEvent<T>> get onDidCollapseElementStream => _eventStream$(
        (listener) => $js.onDidCollapseElement.call(listener),
        (raw) => raw as TreeViewExpansionEvent<T>,
      );
  Stream<TreeViewExpansionEvent<T>> get onDidExpandElementStream => _eventStream$(
        (listener) => $js.onDidExpandElement.call(listener),
        (raw) => raw as TreeViewExpansionEvent<T>,
      );
  Future<JSAny?> reveal(T element, [JSAnon_49025246bc6f? options]) => (options != null ? $js.reveal(element, options) : $js.reveal(element)).toDart;
}

extension TreeViewToDart<T extends JSAny?> on TreeView<T> {
  TreeViewDart<T> get dart => TreeViewDart<T>(this);
}

extension type TreeViewExpansionEventDart<T extends JSAny?>(TreeViewExpansionEvent<T> $js) implements TreeViewExpansionEvent<T> {
  factory TreeViewExpansionEventDart.lit$({T? element}) {
    final object$ = JSObject();
    if (element != null) {
      object$.setProperty('element'.toJS, element);
    }
    return TreeViewExpansionEventDart<T>(TreeViewExpansionEvent<T>(object$));
  }
}

extension TreeViewExpansionEventToDart<T extends JSAny?> on TreeViewExpansionEvent<T> {
  TreeViewExpansionEventDart<T> get dart => TreeViewExpansionEventDart<T>(this);
}

extension type TreeViewOptionsDart<T extends JSAny?>(TreeViewOptions<T> $js) implements TreeViewOptions<T> {
  factory TreeViewOptionsDart.lit$({bool? canSelectMany, TreeDragAndDropController<T>? dragAndDropController, bool? manageCheckboxStateManually, bool? showCollapseAll, TreeDataProvider<T>? treeDataProvider}) {
    final object$ = JSObject();
    if (canSelectMany != null) {
      object$.setProperty('canSelectMany'.toJS, canSelectMany.toJS);
    }
    if (dragAndDropController != null) {
      object$.setProperty('dragAndDropController'.toJS, dragAndDropController);
    }
    if (manageCheckboxStateManually != null) {
      object$.setProperty('manageCheckboxStateManually'.toJS, manageCheckboxStateManually.toJS);
    }
    if (showCollapseAll != null) {
      object$.setProperty('showCollapseAll'.toJS, showCollapseAll.toJS);
    }
    if (treeDataProvider != null) {
      object$.setProperty('treeDataProvider'.toJS, treeDataProvider);
    }
    return TreeViewOptionsDart<T>(TreeViewOptions<T>(object$));
  }
}

extension TreeViewOptionsToDart<T extends JSAny?> on TreeViewOptions<T> {
  TreeViewOptionsDart<T> get dart => TreeViewOptionsDart<T>(this);
}

extension type TreeViewSelectionChangeEventDart<T extends JSAny?>(TreeViewSelectionChangeEvent<T> $js) implements TreeViewSelectionChangeEvent<T> {
  factory TreeViewSelectionChangeEventDart.lit$({JSArray<T>? selection}) {
    final object$ = JSObject();
    if (selection != null) {
      object$.setProperty('selection'.toJS, selection);
    }
    return TreeViewSelectionChangeEventDart<T>(TreeViewSelectionChangeEvent<T>(object$));
  }
}

extension TreeViewSelectionChangeEventToDart<T extends JSAny?> on TreeViewSelectionChangeEvent<T> {
  TreeViewSelectionChangeEventDart<T> get dart => TreeViewSelectionChangeEventDart<T>(this);
}

extension type TreeViewVisibilityChangeEventDart(TreeViewVisibilityChangeEvent $js) implements TreeViewVisibilityChangeEvent {
  factory TreeViewVisibilityChangeEventDart.lit$({bool? visible}) {
    final object$ = JSObject();
    if (visible != null) {
      object$.setProperty('visible'.toJS, visible.toJS);
    }
    return TreeViewVisibilityChangeEventDart(TreeViewVisibilityChangeEvent(object$));
  }
}

extension TreeViewVisibilityChangeEventToDart on TreeViewVisibilityChangeEvent {
  TreeViewVisibilityChangeEventDart get dart => TreeViewVisibilityChangeEventDart(this);
}

extension type TypeDefinitionProviderDart(TypeDefinitionProvider $js) implements TypeDefinitionProvider {
  factory TypeDefinitionProviderDart.lit$({JSFunction? provideTypeDefinition}) {
    final object$ = JSObject();
    if (provideTypeDefinition != null) {
      object$.setProperty('provideTypeDefinition'.toJS, provideTypeDefinition);
    }
    return TypeDefinitionProviderDart(TypeDefinitionProvider(object$));
  }
}

extension TypeDefinitionProviderToDart on TypeDefinitionProvider {
  TypeDefinitionProviderDart get dart => TypeDefinitionProviderDart(this);
}

extension type TypeHierarchyProviderDart(TypeHierarchyProvider $js) implements TypeHierarchyProvider {
  factory TypeHierarchyProviderDart.lit$({JSFunction? prepareTypeHierarchy, JSFunction? provideTypeHierarchySubtypes, JSFunction? provideTypeHierarchySupertypes}) {
    final object$ = JSObject();
    if (prepareTypeHierarchy != null) {
      object$.setProperty('prepareTypeHierarchy'.toJS, prepareTypeHierarchy);
    }
    if (provideTypeHierarchySubtypes != null) {
      object$.setProperty('provideTypeHierarchySubtypes'.toJS, provideTypeHierarchySubtypes);
    }
    if (provideTypeHierarchySupertypes != null) {
      object$.setProperty('provideTypeHierarchySupertypes'.toJS, provideTypeHierarchySupertypes);
    }
    return TypeHierarchyProviderDart(TypeHierarchyProvider(object$));
  }
}

extension TypeHierarchyProviderToDart on TypeHierarchyProvider {
  TypeHierarchyProviderDart get dart => TypeHierarchyProviderDart(this);
}

extension type UriHandlerDart(UriHandler $js) implements UriHandler {
  factory UriHandlerDart.lit$({JSFunction? handleUri}) {
    final object$ = JSObject();
    if (handleUri != null) {
      object$.setProperty('handleUri'.toJS, handleUri);
    }
    return UriHandlerDart(UriHandler(object$));
  }
}

extension UriHandlerToDart on UriHandler {
  UriHandlerDart get dart => UriHandlerDart(this);
}

extension type ViewBadgeDart(ViewBadge $js) implements ViewBadge {
  factory ViewBadgeDart.lit$({String? tooltip, num? value}) {
    final object$ = JSObject();
    if (tooltip != null) {
      object$.setProperty('tooltip'.toJS, tooltip.toJS);
    }
    if (value != null) {
      object$.setProperty('value'.toJS, value.toJS);
    }
    return ViewBadgeDart(ViewBadge(object$));
  }
}

extension ViewBadgeToDart on ViewBadge {
  ViewBadgeDart get dart => ViewBadgeDart(this);
}

extension type WebviewDart(Webview $js) implements Webview {
  factory WebviewDart.lit$({JSFunction? asWebviewUri, String? cspSource, String? html, Event<JSAny?>? onDidReceiveMessage, WebviewOptions? options, JSFunction? postMessage}) {
    final object$ = JSObject();
    if (asWebviewUri != null) {
      object$.setProperty('asWebviewUri'.toJS, asWebviewUri);
    }
    if (cspSource != null) {
      object$.setProperty('cspSource'.toJS, cspSource.toJS);
    }
    if (html != null) {
      object$.setProperty('html'.toJS, html.toJS);
    }
    if (onDidReceiveMessage != null) {
      object$.setProperty('onDidReceiveMessage'.toJS, onDidReceiveMessage);
    }
    if (options != null) {
      object$.setProperty('options'.toJS, options);
    }
    if (postMessage != null) {
      object$.setProperty('postMessage'.toJS, postMessage);
    }
    return WebviewDart(Webview(object$));
  }
  Stream<JSAny?> get onDidReceiveMessageStream => _eventStream$(
        (listener) => $js.onDidReceiveMessage.call(listener),
        (raw) => raw,
      );
  Future<bool> postMessage(JSAny? message) => $js.postMessage(message).toDart.then((value) => value.toDart);
}

extension WebviewToDart on Webview {
  WebviewDart get dart => WebviewDart(this);
}

extension type WebviewOptionsDart(WebviewOptions $js) implements WebviewOptions {
  factory WebviewOptionsDart.lit$({JSAny? enableCommandUris, bool? enableForms, bool? enableScripts, JSArray<Uri>? localResourceRoots, JSArray<WebviewPortMapping>? portMapping}) {
    final object$ = JSObject();
    if (enableCommandUris != null) {
      object$.setProperty('enableCommandUris'.toJS, enableCommandUris);
    }
    if (enableForms != null) {
      object$.setProperty('enableForms'.toJS, enableForms.toJS);
    }
    if (enableScripts != null) {
      object$.setProperty('enableScripts'.toJS, enableScripts.toJS);
    }
    if (localResourceRoots != null) {
      object$.setProperty('localResourceRoots'.toJS, localResourceRoots);
    }
    if (portMapping != null) {
      object$.setProperty('portMapping'.toJS, portMapping);
    }
    return WebviewOptionsDart(WebviewOptions(object$));
  }
}

extension WebviewOptionsToDart on WebviewOptions {
  WebviewOptionsDart get dart => WebviewOptionsDart(this);
}

extension type WebviewPanelDart(WebviewPanel $js) implements WebviewPanel {
  factory WebviewPanelDart.lit$({bool? active, JSFunction? dispose, JSObject? iconPath, Event<WebviewPanelOnDidChangeViewStateEvent>? onDidChangeViewState, Event<JSAny?>? onDidDispose, WebviewPanelOptions? options, JSFunction? reveal, String? title, num? viewColumn, String? viewType, bool? visible, Webview? webview}) {
    final object$ = JSObject();
    if (active != null) {
      object$.setProperty('active'.toJS, active.toJS);
    }
    if (dispose != null) {
      object$.setProperty('dispose'.toJS, dispose);
    }
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (onDidChangeViewState != null) {
      object$.setProperty('onDidChangeViewState'.toJS, onDidChangeViewState);
    }
    if (onDidDispose != null) {
      object$.setProperty('onDidDispose'.toJS, onDidDispose);
    }
    if (options != null) {
      object$.setProperty('options'.toJS, options);
    }
    if (reveal != null) {
      object$.setProperty('reveal'.toJS, reveal);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    if (viewColumn != null) {
      object$.setProperty('viewColumn'.toJS, viewColumn.toJS);
    }
    if (viewType != null) {
      object$.setProperty('viewType'.toJS, viewType.toJS);
    }
    if (visible != null) {
      object$.setProperty('visible'.toJS, visible.toJS);
    }
    if (webview != null) {
      object$.setProperty('webview'.toJS, webview);
    }
    return WebviewPanelDart(WebviewPanel(object$));
  }
  Stream<WebviewPanelOnDidChangeViewStateEvent> get onDidChangeViewStateStream => _eventStream$(
        (listener) => $js.onDidChangeViewState.call(listener),
        (raw) => raw as WebviewPanelOnDidChangeViewStateEvent,
      );
  Stream<JSAny?> get onDidDisposeStream => _eventStream$(
        (listener) => $js.onDidDispose.call(listener),
        (raw) => raw,
      );
}

extension WebviewPanelToDart on WebviewPanel {
  WebviewPanelDart get dart => WebviewPanelDart(this);
}

extension type WebviewPanelOnDidChangeViewStateEventDart(WebviewPanelOnDidChangeViewStateEvent $js) implements WebviewPanelOnDidChangeViewStateEvent {
  factory WebviewPanelOnDidChangeViewStateEventDart.lit$({WebviewPanel? webviewPanel}) {
    final object$ = JSObject();
    if (webviewPanel != null) {
      object$.setProperty('webviewPanel'.toJS, webviewPanel);
    }
    return WebviewPanelOnDidChangeViewStateEventDart(WebviewPanelOnDidChangeViewStateEvent(object$));
  }
}

extension WebviewPanelOnDidChangeViewStateEventToDart on WebviewPanelOnDidChangeViewStateEvent {
  WebviewPanelOnDidChangeViewStateEventDart get dart => WebviewPanelOnDidChangeViewStateEventDart(this);
}

extension type WebviewPanelOptionsDart(WebviewPanelOptions $js) implements WebviewPanelOptions {
  factory WebviewPanelOptionsDart.lit$({bool? enableFindWidget, bool? retainContextWhenHidden}) {
    final object$ = JSObject();
    if (enableFindWidget != null) {
      object$.setProperty('enableFindWidget'.toJS, enableFindWidget.toJS);
    }
    if (retainContextWhenHidden != null) {
      object$.setProperty('retainContextWhenHidden'.toJS, retainContextWhenHidden.toJS);
    }
    return WebviewPanelOptionsDart(WebviewPanelOptions(object$));
  }
}

extension WebviewPanelOptionsToDart on WebviewPanelOptions {
  WebviewPanelOptionsDart get dart => WebviewPanelOptionsDart(this);
}

extension type WebviewPanelSerializerDart<T extends JSAny?>(WebviewPanelSerializer<T> $js) implements WebviewPanelSerializer<T> {
  factory WebviewPanelSerializerDart.lit$({JSFunction? deserializeWebviewPanel}) {
    final object$ = JSObject();
    if (deserializeWebviewPanel != null) {
      object$.setProperty('deserializeWebviewPanel'.toJS, deserializeWebviewPanel);
    }
    return WebviewPanelSerializerDart<T>(WebviewPanelSerializer<T>(object$));
  }
  Future<JSAny?> deserializeWebviewPanel(WebviewPanel webviewPanel, T state) => $js.deserializeWebviewPanel(webviewPanel, state).toDart;
}

extension WebviewPanelSerializerToDart<T extends JSAny?> on WebviewPanelSerializer<T> {
  WebviewPanelSerializerDart<T> get dart => WebviewPanelSerializerDart<T>(this);
}

extension type WebviewPortMappingDart(WebviewPortMapping $js) implements WebviewPortMapping {
  factory WebviewPortMappingDart.lit$({num? extensionHostPort, num? webviewPort}) {
    final object$ = JSObject();
    if (extensionHostPort != null) {
      object$.setProperty('extensionHostPort'.toJS, extensionHostPort.toJS);
    }
    if (webviewPort != null) {
      object$.setProperty('webviewPort'.toJS, webviewPort.toJS);
    }
    return WebviewPortMappingDart(WebviewPortMapping(object$));
  }
}

extension WebviewPortMappingToDart on WebviewPortMapping {
  WebviewPortMappingDart get dart => WebviewPortMappingDart(this);
}

extension type WebviewViewDart(WebviewView $js) implements WebviewView {
  factory WebviewViewDart.lit$({ViewBadge? badge, String? description, Event<JSAny?>? onDidChangeVisibility, Event<JSAny?>? onDidDispose, JSFunction? show, String? title, String? viewType, bool? visible, Webview? webview}) {
    final object$ = JSObject();
    if (badge != null) {
      object$.setProperty('badge'.toJS, badge);
    }
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (onDidChangeVisibility != null) {
      object$.setProperty('onDidChangeVisibility'.toJS, onDidChangeVisibility);
    }
    if (onDidDispose != null) {
      object$.setProperty('onDidDispose'.toJS, onDidDispose);
    }
    if (show != null) {
      object$.setProperty('show'.toJS, show);
    }
    if (title != null) {
      object$.setProperty('title'.toJS, title.toJS);
    }
    if (viewType != null) {
      object$.setProperty('viewType'.toJS, viewType.toJS);
    }
    if (visible != null) {
      object$.setProperty('visible'.toJS, visible.toJS);
    }
    if (webview != null) {
      object$.setProperty('webview'.toJS, webview);
    }
    return WebviewViewDart(WebviewView(object$));
  }
  Stream<JSAny?> get onDidChangeVisibilityStream => _eventStream$(
        (listener) => $js.onDidChangeVisibility.call(listener),
        (raw) => raw,
      );
  Stream<JSAny?> get onDidDisposeStream => _eventStream$(
        (listener) => $js.onDidDispose.call(listener),
        (raw) => raw,
      );
}

extension WebviewViewToDart on WebviewView {
  WebviewViewDart get dart => WebviewViewDart(this);
}

extension type WebviewViewProviderDart(WebviewViewProvider $js) implements WebviewViewProvider {
  factory WebviewViewProviderDart.lit$({JSFunction? resolveWebviewView}) {
    final object$ = JSObject();
    if (resolveWebviewView != null) {
      object$.setProperty('resolveWebviewView'.toJS, resolveWebviewView);
    }
    return WebviewViewProviderDart(WebviewViewProvider(object$));
  }
}

extension WebviewViewProviderToDart on WebviewViewProvider {
  WebviewViewProviderDart get dart => WebviewViewProviderDart(this);
}

extension type WebviewViewResolveContextDart<T extends JSAny?>(WebviewViewResolveContext<T> $js) implements WebviewViewResolveContext<T> {
  factory WebviewViewResolveContextDart.lit$({T? state}) {
    final object$ = JSObject();
    if (state != null) {
      object$.setProperty('state'.toJS, state);
    }
    return WebviewViewResolveContextDart<T>(WebviewViewResolveContext<T>(object$));
  }
}

extension WebviewViewResolveContextToDart<T extends JSAny?> on WebviewViewResolveContext<T> {
  WebviewViewResolveContextDart<T> get dart => WebviewViewResolveContextDart<T>(this);
}

extension type WindowStateDart(WindowState $js) implements WindowState {
  factory WindowStateDart.lit$({bool? active, bool? focused}) {
    final object$ = JSObject();
    if (active != null) {
      object$.setProperty('active'.toJS, active.toJS);
    }
    if (focused != null) {
      object$.setProperty('focused'.toJS, focused.toJS);
    }
    return WindowStateDart(WindowState(object$));
  }
}

extension WindowStateToDart on WindowState {
  WindowStateDart get dart => WindowStateDart(this);
}

extension type WorkspaceConfigurationDart(WorkspaceConfiguration $js) implements WorkspaceConfiguration {
  factory WorkspaceConfigurationDart.lit$({JSFunction? get, JSFunction? has, JSFunction? inspect, JSFunction? update}) {
    final object$ = JSObject();
    if (get != null) {
      object$.setProperty('get'.toJS, get);
    }
    if (has != null) {
      object$.setProperty('has'.toJS, has);
    }
    if (inspect != null) {
      object$.setProperty('inspect'.toJS, inspect);
    }
    if (update != null) {
      object$.setProperty('update'.toJS, update);
    }
    return WorkspaceConfigurationDart(WorkspaceConfiguration(object$));
  }
  Future<JSAny?> update(String section, JSAny? value, [JSAny? configurationTarget, bool? overrideInLanguage]) => (overrideInLanguage != null ? $js.update(section, value, configurationTarget, overrideInLanguage) : configurationTarget != null ? $js.update(section, value, configurationTarget) : $js.update(section, value)).toDart;
}

extension WorkspaceConfigurationToDart on WorkspaceConfiguration {
  WorkspaceConfigurationDart get dart => WorkspaceConfigurationDart(this);
}

extension type WorkspaceEditEntryMetadataDart(WorkspaceEditEntryMetadata $js) implements WorkspaceEditEntryMetadata {
  factory WorkspaceEditEntryMetadataDart.lit$({String? description, JSObject? iconPath, String? label, bool? needsConfirmation}) {
    final object$ = JSObject();
    if (description != null) {
      object$.setProperty('description'.toJS, description.toJS);
    }
    if (iconPath != null) {
      object$.setProperty('iconPath'.toJS, iconPath);
    }
    if (label != null) {
      object$.setProperty('label'.toJS, label.toJS);
    }
    if (needsConfirmation != null) {
      object$.setProperty('needsConfirmation'.toJS, needsConfirmation.toJS);
    }
    return WorkspaceEditEntryMetadataDart(WorkspaceEditEntryMetadata(object$));
  }
}

extension WorkspaceEditEntryMetadataToDart on WorkspaceEditEntryMetadata {
  WorkspaceEditEntryMetadataDart get dart => WorkspaceEditEntryMetadataDart(this);
}

extension type WorkspaceEditMetadataDart(WorkspaceEditMetadata $js) implements WorkspaceEditMetadata {
  factory WorkspaceEditMetadataDart.lit$({bool? isRefactoring}) {
    final object$ = JSObject();
    if (isRefactoring != null) {
      object$.setProperty('isRefactoring'.toJS, isRefactoring.toJS);
    }
    return WorkspaceEditMetadataDart(WorkspaceEditMetadata(object$));
  }
}

extension WorkspaceEditMetadataToDart on WorkspaceEditMetadata {
  WorkspaceEditMetadataDart get dart => WorkspaceEditMetadataDart(this);
}

extension type WorkspaceFolderDart(WorkspaceFolder $js) implements WorkspaceFolder {
  factory WorkspaceFolderDart.lit$({num? index, String? name, Uri? uri}) {
    final object$ = JSObject();
    if (index != null) {
      object$.setProperty('index'.toJS, index.toJS);
    }
    if (name != null) {
      object$.setProperty('name'.toJS, name.toJS);
    }
    if (uri != null) {
      object$.setProperty('uri'.toJS, uri);
    }
    return WorkspaceFolderDart(WorkspaceFolder(object$));
  }
}

extension WorkspaceFolderToDart on WorkspaceFolder {
  WorkspaceFolderDart get dart => WorkspaceFolderDart(this);
}

extension type WorkspaceFolderPickOptionsDart(WorkspaceFolderPickOptions $js) implements WorkspaceFolderPickOptions {
  factory WorkspaceFolderPickOptionsDart.lit$({bool? ignoreFocusOut, String? placeHolder}) {
    final object$ = JSObject();
    if (ignoreFocusOut != null) {
      object$.setProperty('ignoreFocusOut'.toJS, ignoreFocusOut.toJS);
    }
    if (placeHolder != null) {
      object$.setProperty('placeHolder'.toJS, placeHolder.toJS);
    }
    return WorkspaceFolderPickOptionsDart(WorkspaceFolderPickOptions(object$));
  }
}

extension WorkspaceFolderPickOptionsToDart on WorkspaceFolderPickOptions {
  WorkspaceFolderPickOptionsDart get dart => WorkspaceFolderPickOptionsDart(this);
}

extension type WorkspaceFoldersChangeEventDart(WorkspaceFoldersChangeEvent $js) implements WorkspaceFoldersChangeEvent {
  factory WorkspaceFoldersChangeEventDart.lit$({JSArray<WorkspaceFolder>? added, JSArray<WorkspaceFolder>? removed}) {
    final object$ = JSObject();
    if (added != null) {
      object$.setProperty('added'.toJS, added);
    }
    if (removed != null) {
      object$.setProperty('removed'.toJS, removed);
    }
    return WorkspaceFoldersChangeEventDart(WorkspaceFoldersChangeEvent(object$));
  }
}

extension WorkspaceFoldersChangeEventToDart on WorkspaceFoldersChangeEvent {
  WorkspaceFoldersChangeEventDart get dart => WorkspaceFoldersChangeEventDart(this);
}

extension type WorkspaceSymbolProviderDart<T extends JSAny?>(WorkspaceSymbolProvider<T> $js) implements WorkspaceSymbolProvider<T> {
  factory WorkspaceSymbolProviderDart.lit$({JSFunction? provideWorkspaceSymbols, JSFunction? resolveWorkspaceSymbol}) {
    final object$ = JSObject();
    if (provideWorkspaceSymbols != null) {
      object$.setProperty('provideWorkspaceSymbols'.toJS, provideWorkspaceSymbols);
    }
    if (resolveWorkspaceSymbol != null) {
      object$.setProperty('resolveWorkspaceSymbol'.toJS, resolveWorkspaceSymbol);
    }
    return WorkspaceSymbolProviderDart<T>(WorkspaceSymbolProvider<T>(object$));
  }
}

extension WorkspaceSymbolProviderToDart<T extends JSAny?> on WorkspaceSymbolProvider<T> {
  WorkspaceSymbolProviderDart<T> get dart => WorkspaceSymbolProviderDart<T>(this);
}

extension type BranchCoverageCtorDart(BranchCoverageCtor $js) implements BranchCoverageCtor {
  BranchCoverage new$(JSAny executed, [JSObject? location, String? label]) => $js.new$(executed, location, label?.toJS);
}

extension BranchCoverageCtorToDart on BranchCoverageCtor {
  BranchCoverageCtorDart get dart => BranchCoverageCtorDart(this);
}

extension type CallHierarchyItemCtorDart(CallHierarchyItemCtor $js) implements CallHierarchyItemCtor {
  CallHierarchyItem new$(num kind, String name, String detail, Uri uri, Range range, Range selectionRange) => $js.new$(kind.toJS, name.toJS, detail.toJS, uri, range, selectionRange);
}

extension CallHierarchyItemCtorToDart on CallHierarchyItemCtor {
  CallHierarchyItemCtorDart get dart => CallHierarchyItemCtorDart(this);
}

extension type ChatResponseAnchorPartCtorDart(ChatResponseAnchorPartCtor $js) implements ChatResponseAnchorPartCtor {
  ChatResponseAnchorPart new$(JSObject value, [String? title]) => $js.new$(value, title?.toJS);
}

extension ChatResponseAnchorPartCtorToDart on ChatResponseAnchorPartCtor {
  ChatResponseAnchorPartCtorDart get dart => ChatResponseAnchorPartCtorDart(this);
}

extension type ChatResponseProgressPartCtorDart(ChatResponseProgressPartCtor $js) implements ChatResponseProgressPartCtor {
  ChatResponseProgressPart new$(String value) => $js.new$(value.toJS);
}

extension ChatResponseProgressPartCtorToDart on ChatResponseProgressPartCtor {
  ChatResponseProgressPartCtorDart get dart => ChatResponseProgressPartCtorDart(this);
}

extension type CodeActionCtorDart(CodeActionCtor $js) implements CodeActionCtor {
  CodeAction new$(String title, [CodeActionKind? kind]) => $js.new$(title.toJS, kind);
}

extension CodeActionCtorToDart on CodeActionCtor {
  CodeActionCtorDart get dart => CodeActionCtorDart(this);
}

extension type ColorCtorDart(ColorCtor $js) implements ColorCtor {
  Color new$(num red, num green, num blue, num alpha) => $js.new$(red.toJS, green.toJS, blue.toJS, alpha.toJS);
}

extension ColorCtorToDart on ColorCtor {
  ColorCtorDart get dart => ColorCtorDart(this);
}

extension type ColorPresentationCtorDart(ColorPresentationCtor $js) implements ColorPresentationCtor {
  ColorPresentation new$(String label) => $js.new$(label.toJS);
}

extension ColorPresentationCtorToDart on ColorPresentationCtor {
  ColorPresentationCtorDart get dart => ColorPresentationCtorDart(this);
}

extension type CompletionItemCtorDart(CompletionItemCtor $js) implements CompletionItemCtor {
  CompletionItem new$(JSAny label, [num? kind]) => $js.new$(label, kind?.toJS);
}

extension CompletionItemCtorToDart on CompletionItemCtor {
  CompletionItemCtorDart get dart => CompletionItemCtorDart(this);
}

extension type CompletionListCtorDart(CompletionListCtor $js) implements CompletionListCtor {
  CompletionList<T> new$<T extends JSAny?>([JSArray<T>? items, bool? isIncomplete]) => $js.new$<T>(items, isIncomplete?.toJS);
}

extension CompletionListCtorToDart on CompletionListCtor {
  CompletionListCtorDart get dart => CompletionListCtorDart(this);
}

extension type DataTransferItemDart(DataTransferItem $js) implements DataTransferItem {
  Future<String> asString() => $js.asString().toDart.then((value) => value.toDart);
}

extension DataTransferItemToDart on DataTransferItem {
  DataTransferItemDart get dart => DataTransferItemDart(this);
}

extension type DebugAdapterExecutableCtorDart(DebugAdapterExecutableCtor $js) implements DebugAdapterExecutableCtor {
  DebugAdapterExecutable new$(String command, [JSArray<JSString>? args, DebugAdapterExecutableOptions? options]) => $js.new$(command.toJS, args, options);
}

extension DebugAdapterExecutableCtorToDart on DebugAdapterExecutableCtor {
  DebugAdapterExecutableCtorDart get dart => DebugAdapterExecutableCtorDart(this);
}

extension type DebugAdapterNamedPipeServerCtorDart(DebugAdapterNamedPipeServerCtor $js) implements DebugAdapterNamedPipeServerCtor {
  DebugAdapterNamedPipeServer new$(String path) => $js.new$(path.toJS);
}

extension DebugAdapterNamedPipeServerCtorToDart on DebugAdapterNamedPipeServerCtor {
  DebugAdapterNamedPipeServerCtorDart get dart => DebugAdapterNamedPipeServerCtorDart(this);
}

extension type DebugAdapterServerCtorDart(DebugAdapterServerCtor $js) implements DebugAdapterServerCtor {
  DebugAdapterServer new$(num port, [String? host]) => $js.new$(port.toJS, host?.toJS);
}

extension DebugAdapterServerCtorToDart on DebugAdapterServerCtor {
  DebugAdapterServerCtorDart get dart => DebugAdapterServerCtorDart(this);
}

extension type DeclarationCoverageCtorDart(DeclarationCoverageCtor $js) implements DeclarationCoverageCtor {
  DeclarationCoverage new$(String name, JSAny executed, JSObject location) => $js.new$(name.toJS, executed, location);
}

extension DeclarationCoverageCtorToDart on DeclarationCoverageCtor {
  DeclarationCoverageCtorDart get dart => DeclarationCoverageCtorDart(this);
}

extension type DiagnosticCtorDart(DiagnosticCtor $js) implements DiagnosticCtor {
  Diagnostic new$(Range range, String message, [num? severity]) => $js.new$(range, message.toJS, severity?.toJS);
}

extension DiagnosticCtorToDart on DiagnosticCtor {
  DiagnosticCtorDart get dart => DiagnosticCtorDart(this);
}

extension type DiagnosticRelatedInformationCtorDart(DiagnosticRelatedInformationCtor $js) implements DiagnosticRelatedInformationCtor {
  DiagnosticRelatedInformation new$(Location location, String message) => $js.new$(location, message.toJS);
}

extension DiagnosticRelatedInformationCtorToDart on DiagnosticRelatedInformationCtor {
  DiagnosticRelatedInformationCtorDart get dart => DiagnosticRelatedInformationCtorDart(this);
}

extension type DocumentDropEditCtorDart(DocumentDropEditCtor $js) implements DocumentDropEditCtor {
  DocumentDropEdit new$(JSAny insertText, [String? title, DocumentDropOrPasteEditKind? kind]) => $js.new$(insertText, title?.toJS, kind);
}

extension DocumentDropEditCtorToDart on DocumentDropEditCtor {
  DocumentDropEditCtorDart get dart => DocumentDropEditCtorDart(this);
}

extension type DocumentHighlightCtorDart(DocumentHighlightCtor $js) implements DocumentHighlightCtor {
  DocumentHighlight new$(Range range, [num? kind]) => $js.new$(range, kind?.toJS);
}

extension DocumentHighlightCtorToDart on DocumentHighlightCtor {
  DocumentHighlightCtorDart get dart => DocumentHighlightCtorDart(this);
}

extension type DocumentPasteEditCtorDart(DocumentPasteEditCtor $js) implements DocumentPasteEditCtor {
  DocumentPasteEdit new$(JSAny insertText, String title, DocumentDropOrPasteEditKind kind) => $js.new$(insertText, title.toJS, kind);
}

extension DocumentPasteEditCtorToDart on DocumentPasteEditCtor {
  DocumentPasteEditCtorDart get dart => DocumentPasteEditCtorDart(this);
}

extension type DocumentSymbolCtorDart(DocumentSymbolCtor $js) implements DocumentSymbolCtor {
  DocumentSymbol new$(String name, String detail, num kind, Range range, Range selectionRange) => $js.new$(name.toJS, detail.toJS, kind.toJS, range, selectionRange);
}

extension DocumentSymbolCtorToDart on DocumentSymbolCtor {
  DocumentSymbolCtorDart get dart => DocumentSymbolCtorDart(this);
}

extension type EvaluatableExpressionCtorDart(EvaluatableExpressionCtor $js) implements EvaluatableExpressionCtor {
  EvaluatableExpression new$(Range range, [String? expression]) => $js.new$(range, expression?.toJS);
}

extension EvaluatableExpressionCtorToDart on EvaluatableExpressionCtor {
  EvaluatableExpressionCtorDart get dart => EvaluatableExpressionCtorDart(this);
}

extension type EventEmitterDart<T extends JSAny?>(EventEmitter<T> $js) implements EventEmitter<T> {
  Stream<T> get eventStream => _eventStream$(
        (listener) => $js.event.call(listener),
        (raw) => raw as T,
      );
}

extension EventEmitterToDart<T extends JSAny?> on EventEmitter<T> {
  EventEmitterDart<T> get dart => EventEmitterDart<T>(this);
}

extension type FileDecorationCtorDart(FileDecorationCtor $js) implements FileDecorationCtor {
  FileDecoration new$([String? badge, String? tooltip, ThemeColor? color]) => $js.new$(badge?.toJS, tooltip?.toJS, color);
}

extension FileDecorationCtorToDart on FileDecorationCtor {
  FileDecorationCtorDart get dart => FileDecorationCtorDart(this);
}

extension type FoldingRangeCtorDart(FoldingRangeCtor $js) implements FoldingRangeCtor {
  FoldingRange new$(num start, num end, [num? kind]) => $js.new$(start.toJS, end.toJS, kind?.toJS);
}

extension FoldingRangeCtorToDart on FoldingRangeCtor {
  FoldingRangeCtorDart get dart => FoldingRangeCtorDart(this);
}

extension type FunctionBreakpointCtorDart(FunctionBreakpointCtor $js) implements FunctionBreakpointCtor {
  FunctionBreakpoint new$(String functionName, [bool? enabled, String? condition, String? hitCondition, String? logMessage]) => $js.new$(functionName.toJS, enabled?.toJS, condition?.toJS, hitCondition?.toJS, logMessage?.toJS);
}

extension FunctionBreakpointCtorToDart on FunctionBreakpointCtor {
  FunctionBreakpointCtorDart get dart => FunctionBreakpointCtorDart(this);
}

extension type InlayHintCtorDart(InlayHintCtor $js) implements InlayHintCtor {
  InlayHint new$(Position position, JSAny label, [num? kind]) => $js.new$(position, label, kind?.toJS);
}

extension InlayHintCtorToDart on InlayHintCtor {
  InlayHintCtorDart get dart => InlayHintCtorDart(this);
}

extension type InlayHintLabelPartCtorDart(InlayHintLabelPartCtor $js) implements InlayHintLabelPartCtor {
  InlayHintLabelPart new$(String value) => $js.new$(value.toJS);
}

extension InlayHintLabelPartCtorToDart on InlayHintLabelPartCtor {
  InlayHintLabelPartCtorDart get dart => InlayHintLabelPartCtorDart(this);
}

extension type InlineValueEvaluatableExpressionCtorDart(InlineValueEvaluatableExpressionCtor $js) implements InlineValueEvaluatableExpressionCtor {
  InlineValueEvaluatableExpression new$(Range range, [String? expression]) => $js.new$(range, expression?.toJS);
}

extension InlineValueEvaluatableExpressionCtorToDart on InlineValueEvaluatableExpressionCtor {
  InlineValueEvaluatableExpressionCtorDart get dart => InlineValueEvaluatableExpressionCtorDart(this);
}

extension type InlineValueTextCtorDart(InlineValueTextCtor $js) implements InlineValueTextCtor {
  InlineValueText new$(Range range, String text) => $js.new$(range, text.toJS);
}

extension InlineValueTextCtorToDart on InlineValueTextCtor {
  InlineValueTextCtorDart get dart => InlineValueTextCtorDart(this);
}

extension type InlineValueVariableLookupCtorDart(InlineValueVariableLookupCtor $js) implements InlineValueVariableLookupCtor {
  InlineValueVariableLookup new$(Range range, [String? variableName, bool? caseSensitiveLookup]) => $js.new$(range, variableName?.toJS, caseSensitiveLookup?.toJS);
}

extension InlineValueVariableLookupCtorToDart on InlineValueVariableLookupCtor {
  InlineValueVariableLookupCtorDart get dart => InlineValueVariableLookupCtorDart(this);
}

extension type LanguageModelChatMessageCtorDart(LanguageModelChatMessageCtor $js) implements LanguageModelChatMessageCtor {
  LanguageModelChatMessage new$(num role, JSAny content, [String? name]) => $js.new$(role.toJS, content, name?.toJS);
}

extension LanguageModelChatMessageCtorToDart on LanguageModelChatMessageCtor {
  LanguageModelChatMessageCtorDart get dart => LanguageModelChatMessageCtorDart(this);
}

extension type LanguageModelDataPartCtorDart(LanguageModelDataPartCtor $js) implements LanguageModelDataPartCtor {
  LanguageModelDataPart new$(JSUint8Array data, String mimeType) => $js.new$(data, mimeType.toJS);
}

extension LanguageModelDataPartCtorToDart on LanguageModelDataPartCtor {
  LanguageModelDataPartCtorDart get dart => LanguageModelDataPartCtorDart(this);
}

extension type LanguageModelTextPartCtorDart(LanguageModelTextPartCtor $js) implements LanguageModelTextPartCtor {
  LanguageModelTextPart new$(String value) => $js.new$(value.toJS);
}

extension LanguageModelTextPartCtorToDart on LanguageModelTextPartCtor {
  LanguageModelTextPartCtorDart get dart => LanguageModelTextPartCtorDart(this);
}

extension type LanguageModelToolCallPartCtorDart(LanguageModelToolCallPartCtor $js) implements LanguageModelToolCallPartCtor {
  LanguageModelToolCallPart new$(String callId, String name, JSObject input) => $js.new$(callId.toJS, name.toJS, input);
}

extension LanguageModelToolCallPartCtorToDart on LanguageModelToolCallPartCtor {
  LanguageModelToolCallPartCtorDart get dart => LanguageModelToolCallPartCtorDart(this);
}

extension type LanguageModelToolResultPartCtorDart(LanguageModelToolResultPartCtor $js) implements LanguageModelToolResultPartCtor {
  LanguageModelToolResultPart new$(String callId, JSArray<JSAny> content) => $js.new$(callId.toJS, content);
}

extension LanguageModelToolResultPartCtorToDart on LanguageModelToolResultPartCtor {
  LanguageModelToolResultPartCtorDart get dart => LanguageModelToolResultPartCtorDart(this);
}

extension type MarkdownStringCtorDart(MarkdownStringCtor $js) implements MarkdownStringCtor {
  MarkdownString new$([String? value, bool? supportThemeIcons]) => $js.new$(value?.toJS, supportThemeIcons?.toJS);
}

extension MarkdownStringCtorToDart on MarkdownStringCtor {
  MarkdownStringCtorDart get dart => MarkdownStringCtorDart(this);
}

extension type McpHttpServerDefinitionCtorDart(McpHttpServerDefinitionCtor $js) implements McpHttpServerDefinitionCtor {
  McpHttpServerDefinition new$(String label, Uri uri, [JSObject? headers, String? version]) => $js.new$(label.toJS, uri, headers, version?.toJS);
}

extension McpHttpServerDefinitionCtorToDart on McpHttpServerDefinitionCtor {
  McpHttpServerDefinitionCtorDart get dart => McpHttpServerDefinitionCtorDart(this);
}

extension type McpStdioServerDefinitionCtorDart(McpStdioServerDefinitionCtor $js) implements McpStdioServerDefinitionCtor {
  McpStdioServerDefinition new$(String label, String command, [JSArray<JSString>? args, JSObject? env, String? version]) => $js.new$(label.toJS, command.toJS, args, env, version?.toJS);
}

extension McpStdioServerDefinitionCtorToDart on McpStdioServerDefinitionCtor {
  McpStdioServerDefinitionCtorDart get dart => McpStdioServerDefinitionCtorDart(this);
}

extension type NotebookCellDataCtorDart(NotebookCellDataCtor $js) implements NotebookCellDataCtor {
  NotebookCellData new$(num kind, String value, String languageId) => $js.new$(kind.toJS, value.toJS, languageId.toJS);
}

extension NotebookCellDataCtorToDart on NotebookCellDataCtor {
  NotebookCellDataCtorDart get dart => NotebookCellDataCtorDart(this);
}

extension type NotebookCellOutputItemCtorDart(NotebookCellOutputItemCtor $js) implements NotebookCellOutputItemCtor {
  NotebookCellOutputItem new$(JSUint8Array data, String mime) => $js.new$(data, mime.toJS);
}

extension NotebookCellOutputItemCtorToDart on NotebookCellOutputItemCtor {
  NotebookCellOutputItemCtorDart get dart => NotebookCellOutputItemCtorDart(this);
}

extension type NotebookCellStatusBarItemCtorDart(NotebookCellStatusBarItemCtor $js) implements NotebookCellStatusBarItemCtor {
  NotebookCellStatusBarItem new$(String text, num alignment) => $js.new$(text.toJS, alignment.toJS);
}

extension NotebookCellStatusBarItemCtorToDart on NotebookCellStatusBarItemCtor {
  NotebookCellStatusBarItemCtorDart get dart => NotebookCellStatusBarItemCtorDart(this);
}

extension type NotebookRangeCtorDart(NotebookRangeCtor $js) implements NotebookRangeCtor {
  NotebookRange new$(num start, num end) => $js.new$(start.toJS, end.toJS);
}

extension NotebookRangeCtorToDart on NotebookRangeCtor {
  NotebookRangeCtorDart get dart => NotebookRangeCtorDart(this);
}

extension type PositionCtorDart(PositionCtor $js) implements PositionCtor {
  Position new$(num line, num character) => $js.new$(line.toJS, character.toJS);
}

extension PositionCtorToDart on PositionCtor {
  PositionCtorDart get dart => PositionCtorDart(this);
}

extension type ProcessExecutionCtorDart(ProcessExecutionCtor $js) implements ProcessExecutionCtor {
  ProcessExecution new$(String process, [ProcessExecutionOptions? options]) => $js.new$(process.toJS, options);
  ProcessExecution new$$2(String process, JSArray<JSString> args, [ProcessExecutionOptions? options]) => $js.new$$2(process.toJS, args, options);
}

extension ProcessExecutionCtorToDart on ProcessExecutionCtor {
  ProcessExecutionCtorDart get dart => ProcessExecutionCtorDart(this);
}

extension type RangeCtorDart(RangeCtor $js) implements RangeCtor {
  Range new$$2(num startLine, num startCharacter, num endLine, num endCharacter) => $js.new$$2(startLine.toJS, startCharacter.toJS, endLine.toJS, endCharacter.toJS);
}

extension RangeCtorToDart on RangeCtor {
  RangeCtorDart get dart => RangeCtorDart(this);
}

extension type RelativePatternCtorDart(RelativePatternCtor $js) implements RelativePatternCtor {
  RelativePattern new$(JSAny base, String pattern) => $js.new$(base, pattern.toJS);
}

extension RelativePatternCtorToDart on RelativePatternCtor {
  RelativePatternCtorDart get dart => RelativePatternCtorDart(this);
}

extension type SelectionCtorDart(SelectionCtor $js) implements SelectionCtor {
  Selection new$$2(num anchorLine, num anchorCharacter, num activeLine, num activeCharacter) => $js.new$$2(anchorLine.toJS, anchorCharacter.toJS, activeLine.toJS, activeCharacter.toJS);
}

extension SelectionCtorToDart on SelectionCtor {
  SelectionCtorDart get dart => SelectionCtorDart(this);
}

extension type SemanticTokensCtorDart(SemanticTokensCtor $js) implements SemanticTokensCtor {
  SemanticTokens new$(JSUint32Array data, [String? resultId]) => $js.new$(data, resultId?.toJS);
}

extension SemanticTokensCtorToDart on SemanticTokensCtor {
  SemanticTokensCtorDart get dart => SemanticTokensCtorDart(this);
}

extension type SemanticTokensEditCtorDart(SemanticTokensEditCtor $js) implements SemanticTokensEditCtor {
  SemanticTokensEdit new$(num start, num deleteCount, [JSUint32Array? data]) => $js.new$(start.toJS, deleteCount.toJS, data);
}

extension SemanticTokensEditCtorToDart on SemanticTokensEditCtor {
  SemanticTokensEditCtorDart get dart => SemanticTokensEditCtorDart(this);
}

extension type SemanticTokensEditsCtorDart(SemanticTokensEditsCtor $js) implements SemanticTokensEditsCtor {
  SemanticTokensEdits new$(JSArray<SemanticTokensEdit> edits, [String? resultId]) => $js.new$(edits, resultId?.toJS);
}

extension SemanticTokensEditsCtorToDart on SemanticTokensEditsCtor {
  SemanticTokensEditsCtorDart get dart => SemanticTokensEditsCtorDart(this);
}

extension type ShellExecutionCtorDart(ShellExecutionCtor $js) implements ShellExecutionCtor {
  ShellExecution new$(String commandLine, [ShellExecutionOptions? options]) => $js.new$(commandLine.toJS, options);
}

extension ShellExecutionCtorToDart on ShellExecutionCtor {
  ShellExecutionCtorDart get dart => ShellExecutionCtorDart(this);
}

extension type SignatureInformationCtorDart(SignatureInformationCtor $js) implements SignatureInformationCtor {
  SignatureInformation new$(String label, [JSAny? documentation]) => $js.new$(label.toJS, documentation);
}

extension SignatureInformationCtorToDart on SignatureInformationCtor {
  SignatureInformationCtorDart get dart => SignatureInformationCtorDart(this);
}

extension type SnippetStringCtorDart(SnippetStringCtor $js) implements SnippetStringCtor {
  SnippetString new$([String? value]) => $js.new$(value?.toJS);
}

extension SnippetStringCtorToDart on SnippetStringCtor {
  SnippetStringCtorDart get dart => SnippetStringCtorDart(this);
}

extension type SourceBreakpointCtorDart(SourceBreakpointCtor $js) implements SourceBreakpointCtor {
  SourceBreakpoint new$(Location location, [bool? enabled, String? condition, String? hitCondition, String? logMessage]) => $js.new$(location, enabled?.toJS, condition?.toJS, hitCondition?.toJS, logMessage?.toJS);
}

extension SourceBreakpointCtorToDart on SourceBreakpointCtor {
  SourceBreakpointCtorDart get dart => SourceBreakpointCtorDart(this);
}

extension type SymbolInformationCtorDart(SymbolInformationCtor $js) implements SymbolInformationCtor {
  SymbolInformation new$(String name, num kind, String containerName, Location location) => $js.new$(name.toJS, kind.toJS, containerName.toJS, location);
  SymbolInformation new$$2(String name, num kind, Range range, [Uri? uri, String? containerName]) => $js.new$$2(name.toJS, kind.toJS, range, uri, containerName?.toJS);
}

extension SymbolInformationCtorToDart on SymbolInformationCtor {
  SymbolInformationCtorDart get dart => SymbolInformationCtorDart(this);
}

extension type TabInputCustomCtorDart(TabInputCustomCtor $js) implements TabInputCustomCtor {
  TabInputCustom new$(Uri uri, String viewType) => $js.new$(uri, viewType.toJS);
}

extension TabInputCustomCtorToDart on TabInputCustomCtor {
  TabInputCustomCtorDart get dart => TabInputCustomCtorDart(this);
}

extension type TabInputNotebookCtorDart(TabInputNotebookCtor $js) implements TabInputNotebookCtor {
  TabInputNotebook new$(Uri uri, String notebookType) => $js.new$(uri, notebookType.toJS);
}

extension TabInputNotebookCtorToDart on TabInputNotebookCtor {
  TabInputNotebookCtorDart get dart => TabInputNotebookCtorDart(this);
}

extension type TabInputNotebookDiffCtorDart(TabInputNotebookDiffCtor $js) implements TabInputNotebookDiffCtor {
  TabInputNotebookDiff new$(Uri original, Uri modified, String notebookType) => $js.new$(original, modified, notebookType.toJS);
}

extension TabInputNotebookDiffCtorToDart on TabInputNotebookDiffCtor {
  TabInputNotebookDiffCtorDart get dart => TabInputNotebookDiffCtorDart(this);
}

extension type TabInputWebviewCtorDart(TabInputWebviewCtor $js) implements TabInputWebviewCtor {
  TabInputWebview new$(String viewType) => $js.new$(viewType.toJS);
}

extension TabInputWebviewCtorToDart on TabInputWebviewCtor {
  TabInputWebviewCtorDart get dart => TabInputWebviewCtorDart(this);
}

extension type TaskCtorDart(TaskCtor $js) implements TaskCtor {
  Task new$(TaskDefinition taskDefinition, JSAny scope, String name, String source, [JSObject? execution, JSAny? problemMatchers]) => $js.new$(taskDefinition, scope, name.toJS, source.toJS, execution, problemMatchers);
  Task new$$2(TaskDefinition taskDefinition, String name, String source, [JSObject? execution, JSAny? problemMatchers]) => $js.new$$2(taskDefinition, name.toJS, source.toJS, execution, problemMatchers);
}

extension TaskCtorToDart on TaskCtor {
  TaskCtorDart get dart => TaskCtorDart(this);
}

extension type TerminalLinkCtorDart(TerminalLinkCtor $js) implements TerminalLinkCtor {
  TerminalLink new$(num startIndex, num length, [String? tooltip]) => $js.new$(startIndex.toJS, length.toJS, tooltip?.toJS);
}

extension TerminalLinkCtorToDart on TerminalLinkCtor {
  TerminalLinkCtorDart get dart => TerminalLinkCtorDart(this);
}

extension type TestCoverageCountCtorDart(TestCoverageCountCtor $js) implements TestCoverageCountCtor {
  TestCoverageCount new$(num covered, num total) => $js.new$(covered.toJS, total.toJS);
}

extension TestCoverageCountCtorToDart on TestCoverageCountCtor {
  TestCoverageCountCtorDart get dart => TestCoverageCountCtorDart(this);
}

extension type TestMessageStackFrameCtorDart(TestMessageStackFrameCtor $js) implements TestMessageStackFrameCtor {
  TestMessageStackFrame new$(String label, [Uri? uri, Position? position]) => $js.new$(label.toJS, uri, position);
}

extension TestMessageStackFrameCtorToDart on TestMessageStackFrameCtor {
  TestMessageStackFrameCtorDart get dart => TestMessageStackFrameCtorDart(this);
}

extension type TestRunRequestCtorDart(TestRunRequestCtor $js) implements TestRunRequestCtor {
  TestRunRequest new$([JSArray<TestItem>? include, JSArray<TestItem>? exclude, TestRunProfile? profile, bool? continuous, bool? preserveFocus]) => $js.new$(include, exclude, profile, continuous?.toJS, preserveFocus?.toJS);
}

extension TestRunRequestCtorToDart on TestRunRequestCtor {
  TestRunRequestCtorDart get dart => TestRunRequestCtorDart(this);
}

extension type TestTagCtorDart(TestTagCtor $js) implements TestTagCtor {
  TestTag new$(String id) => $js.new$(id.toJS);
}

extension TestTagCtorToDart on TestTagCtor {
  TestTagCtorDart get dart => TestTagCtorDart(this);
}

extension type TextEditCtorDart(TextEditCtor $js) implements TextEditCtor {
  TextEdit new$(Range range, String newText) => $js.new$(range, newText.toJS);
}

extension TextEditCtorToDart on TextEditCtor {
  TextEditCtorDart get dart => TextEditCtorDart(this);
}

extension type ThemeColorCtorDart(ThemeColorCtor $js) implements ThemeColorCtor {
  ThemeColor new$(String id) => $js.new$(id.toJS);
}

extension ThemeColorCtorToDart on ThemeColorCtor {
  ThemeColorCtorDart get dart => ThemeColorCtorDart(this);
}

extension type ThemeIconCtorDart(ThemeIconCtor $js) implements ThemeIconCtor {
  ThemeIcon new$(String id, [ThemeColor? color]) => $js.new$(id.toJS, color);
}

extension ThemeIconCtorToDart on ThemeIconCtor {
  ThemeIconCtorDart get dart => ThemeIconCtorDart(this);
}

extension type TreeItemCtorDart(TreeItemCtor $js) implements TreeItemCtor {
  TreeItem new$(JSAny label, [num? collapsibleState]) => $js.new$(label, collapsibleState?.toJS);
  TreeItem new$$2(Uri resourceUri, [num? collapsibleState]) => $js.new$$2(resourceUri, collapsibleState?.toJS);
}

extension TreeItemCtorToDart on TreeItemCtor {
  TreeItemCtorDart get dart => TreeItemCtorDart(this);
}

extension type TypeHierarchyItemCtorDart(TypeHierarchyItemCtor $js) implements TypeHierarchyItemCtor {
  TypeHierarchyItem new$(num kind, String name, String detail, Uri uri, Range range, Range selectionRange) => $js.new$(kind.toJS, name.toJS, detail.toJS, uri, range, selectionRange);
}

extension TypeHierarchyItemCtorToDart on TypeHierarchyItemCtor {
  TypeHierarchyItemCtorDart get dart => TypeHierarchyItemCtorDart(this);
}

/// The dart-layer view of the VS Code API module object.
///
/// Entered from the parity root with `VscodeApi(rawVscode).dart`.
extension type VscodeApiDart(VscodeApi $js) implements VscodeApi {
  BranchCoverageCtorDart get BranchCoverage => BranchCoverageCtorDart($js.BranchCoverage);
  CallHierarchyItemCtorDart get CallHierarchyItem => CallHierarchyItemCtorDart($js.CallHierarchyItem);
  ChatResponseAnchorPartCtorDart get ChatResponseAnchorPart => ChatResponseAnchorPartCtorDart($js.ChatResponseAnchorPart);
  ChatResponseProgressPartCtorDart get ChatResponseProgressPart => ChatResponseProgressPartCtorDart($js.ChatResponseProgressPart);
  CodeActionCtorDart get CodeAction => CodeActionCtorDart($js.CodeAction);
  ColorCtorDart get Color => ColorCtorDart($js.Color);
  ColorPresentationCtorDart get ColorPresentation => ColorPresentationCtorDart($js.ColorPresentation);
  CompletionItemCtorDart get CompletionItem => CompletionItemCtorDart($js.CompletionItem);
  CompletionListCtorDart get CompletionList => CompletionListCtorDart($js.CompletionList);
  DebugAdapterExecutableCtorDart get DebugAdapterExecutable => DebugAdapterExecutableCtorDart($js.DebugAdapterExecutable);
  DebugAdapterNamedPipeServerCtorDart get DebugAdapterNamedPipeServer => DebugAdapterNamedPipeServerCtorDart($js.DebugAdapterNamedPipeServer);
  DebugAdapterServerCtorDart get DebugAdapterServer => DebugAdapterServerCtorDart($js.DebugAdapterServer);
  DeclarationCoverageCtorDart get DeclarationCoverage => DeclarationCoverageCtorDart($js.DeclarationCoverage);
  DiagnosticCtorDart get Diagnostic => DiagnosticCtorDart($js.Diagnostic);
  DiagnosticRelatedInformationCtorDart get DiagnosticRelatedInformation => DiagnosticRelatedInformationCtorDart($js.DiagnosticRelatedInformation);
  DocumentDropEditCtorDart get DocumentDropEdit => DocumentDropEditCtorDart($js.DocumentDropEdit);
  DocumentHighlightCtorDart get DocumentHighlight => DocumentHighlightCtorDart($js.DocumentHighlight);
  DocumentPasteEditCtorDart get DocumentPasteEdit => DocumentPasteEditCtorDart($js.DocumentPasteEdit);
  DocumentSymbolCtorDart get DocumentSymbol => DocumentSymbolCtorDart($js.DocumentSymbol);
  EvaluatableExpressionCtorDart get EvaluatableExpression => EvaluatableExpressionCtorDart($js.EvaluatableExpression);
  FileDecorationCtorDart get FileDecoration => FileDecorationCtorDart($js.FileDecoration);
  FoldingRangeCtorDart get FoldingRange => FoldingRangeCtorDart($js.FoldingRange);
  FunctionBreakpointCtorDart get FunctionBreakpoint => FunctionBreakpointCtorDart($js.FunctionBreakpoint);
  InlayHintCtorDart get InlayHint => InlayHintCtorDart($js.InlayHint);
  InlayHintLabelPartCtorDart get InlayHintLabelPart => InlayHintLabelPartCtorDart($js.InlayHintLabelPart);
  InlineValueEvaluatableExpressionCtorDart get InlineValueEvaluatableExpression => InlineValueEvaluatableExpressionCtorDart($js.InlineValueEvaluatableExpression);
  InlineValueTextCtorDart get InlineValueText => InlineValueTextCtorDart($js.InlineValueText);
  InlineValueVariableLookupCtorDart get InlineValueVariableLookup => InlineValueVariableLookupCtorDart($js.InlineValueVariableLookup);
  LanguageModelChatMessageCtorDart get LanguageModelChatMessage => LanguageModelChatMessageCtorDart($js.LanguageModelChatMessage);
  LanguageModelDataPartCtorDart get LanguageModelDataPart => LanguageModelDataPartCtorDart($js.LanguageModelDataPart);
  LanguageModelTextPartCtorDart get LanguageModelTextPart => LanguageModelTextPartCtorDart($js.LanguageModelTextPart);
  LanguageModelToolCallPartCtorDart get LanguageModelToolCallPart => LanguageModelToolCallPartCtorDart($js.LanguageModelToolCallPart);
  LanguageModelToolResultPartCtorDart get LanguageModelToolResultPart => LanguageModelToolResultPartCtorDart($js.LanguageModelToolResultPart);
  MarkdownStringCtorDart get MarkdownString => MarkdownStringCtorDart($js.MarkdownString);
  McpHttpServerDefinitionCtorDart get McpHttpServerDefinition => McpHttpServerDefinitionCtorDart($js.McpHttpServerDefinition);
  McpStdioServerDefinitionCtorDart get McpStdioServerDefinition => McpStdioServerDefinitionCtorDart($js.McpStdioServerDefinition);
  NotebookCellDataCtorDart get NotebookCellData => NotebookCellDataCtorDart($js.NotebookCellData);
  NotebookCellOutputItemCtorDart get NotebookCellOutputItem => NotebookCellOutputItemCtorDart($js.NotebookCellOutputItem);
  NotebookCellStatusBarItemCtorDart get NotebookCellStatusBarItem => NotebookCellStatusBarItemCtorDart($js.NotebookCellStatusBarItem);
  NotebookRangeCtorDart get NotebookRange => NotebookRangeCtorDart($js.NotebookRange);
  PositionCtorDart get Position => PositionCtorDart($js.Position);
  ProcessExecutionCtorDart get ProcessExecution => ProcessExecutionCtorDart($js.ProcessExecution);
  RangeCtorDart get Range => RangeCtorDart($js.Range);
  RelativePatternCtorDart get RelativePattern => RelativePatternCtorDart($js.RelativePattern);
  SelectionCtorDart get Selection => SelectionCtorDart($js.Selection);
  SemanticTokensCtorDart get SemanticTokens => SemanticTokensCtorDart($js.SemanticTokens);
  SemanticTokensEditCtorDart get SemanticTokensEdit => SemanticTokensEditCtorDart($js.SemanticTokensEdit);
  SemanticTokensEditsCtorDart get SemanticTokensEdits => SemanticTokensEditsCtorDart($js.SemanticTokensEdits);
  ShellExecutionCtorDart get ShellExecution => ShellExecutionCtorDart($js.ShellExecution);
  SignatureInformationCtorDart get SignatureInformation => SignatureInformationCtorDart($js.SignatureInformation);
  SnippetStringCtorDart get SnippetString => SnippetStringCtorDart($js.SnippetString);
  SourceBreakpointCtorDart get SourceBreakpoint => SourceBreakpointCtorDart($js.SourceBreakpoint);
  SymbolInformationCtorDart get SymbolInformation => SymbolInformationCtorDart($js.SymbolInformation);
  TabInputCustomCtorDart get TabInputCustom => TabInputCustomCtorDart($js.TabInputCustom);
  TabInputNotebookCtorDart get TabInputNotebook => TabInputNotebookCtorDart($js.TabInputNotebook);
  TabInputNotebookDiffCtorDart get TabInputNotebookDiff => TabInputNotebookDiffCtorDart($js.TabInputNotebookDiff);
  TabInputWebviewCtorDart get TabInputWebview => TabInputWebviewCtorDart($js.TabInputWebview);
  TaskCtorDart get Task => TaskCtorDart($js.Task);
  TerminalLinkCtorDart get TerminalLink => TerminalLinkCtorDart($js.TerminalLink);
  TestCoverageCountCtorDart get TestCoverageCount => TestCoverageCountCtorDart($js.TestCoverageCount);
  TestMessageStackFrameCtorDart get TestMessageStackFrame => TestMessageStackFrameCtorDart($js.TestMessageStackFrame);
  TestRunRequestCtorDart get TestRunRequest => TestRunRequestCtorDart($js.TestRunRequest);
  TestTagCtorDart get TestTag => TestTagCtorDart($js.TestTag);
  TextEditCtorDart get TextEdit => TextEditCtorDart($js.TextEdit);
  ThemeColorCtorDart get ThemeColor => ThemeColorCtorDart($js.ThemeColor);
  ThemeIconCtorDart get ThemeIcon => ThemeIconCtorDart($js.ThemeIcon);
  TreeItemCtorDart get TreeItem => TreeItemCtorDart($js.TreeItem);
  TypeHierarchyItemCtorDart get TypeHierarchyItem => TypeHierarchyItemCtorDart($js.TypeHierarchyItem);
  AuthenticationNsDart get authentication => AuthenticationNsDart($js.authentication);
  CommandsNsDart get commands => CommandsNsDart($js.commands);
  DebugNsDart get debug => DebugNsDart($js.debug);
  EnvNsDart get env => EnvNsDart($js.env);
  ExtensionsNsDart get extensions => ExtensionsNsDart($js.extensions);
  L10nNsDart get l10n => L10nNsDart($js.l10n);
  LanguagesNsDart get languages => LanguagesNsDart($js.languages);
  LmNsDart get lm => LmNsDart($js.lm);
  TasksNsDart get tasks => TasksNsDart($js.tasks);
  WindowNsDart get window => WindowNsDart($js.window);
  WorkspaceNsDart get workspace => WorkspaceNsDart($js.workspace);
}

extension VscodeApiToDart on VscodeApi {
  VscodeApiDart get dart => VscodeApiDart(this);
}

Stream<S> _eventStream$<S>(
  JSAny? Function(JSFunction listener) subscribe,
  S Function(JSAny? raw) convert,
) {
  JSAny? registration;
  late final StreamController<S> controller;
  controller = StreamController<S>.broadcast(
    onListen: () {
      registration = subscribe(
        ((JSAny? raw) {
          controller.add(convert(raw));
        }).toJS,
      );
    },
    onCancel: () {
      final registered = registration;
      registration = null;
      if (registered is JSObject) {
        registered.callMethod('dispose'.toJS);
      }
    },
  );
  return controller.stream;
}

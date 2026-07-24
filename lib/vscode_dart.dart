/// The mechanical Dart-ergonomics layer over the Parity Layer.
///
/// A second generated, total, judgment-free rule set (developer-experience
/// D-2) — not the hand-reviewed Idiomatic Facade. Helper boundaries take
/// ordinary `String`/`num`/`bool`, `JSPromise` returns become `Future`s,
/// `Event` members gain broadcast `Stream` accessors (`onDidX` gains
/// `onDidXStream`), and `lit$` factories flatten inherited interface
/// members. Enter the layer with
/// `VscodeApi(rawVscode).dart`; every `XDart` type wraps and implements
/// its parity type `X`, so dart-layer values flow anywhere the parity
/// surface is expected.
library;

export 'src/generated/vscode_dart_layer.g.dart';
export 'src/generated/vscode_parity_layer.g.dart';

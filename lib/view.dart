/// Versioned communication between Host Dart and a Flutter View.
library;

export 'src/view_protocol.dart';
export 'src/view_transport_stub.dart'
    if (dart.library.html) 'src/view_transport_web.dart';

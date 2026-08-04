import 'dart:async';
import 'dart:convert';
import 'dart:math';

/// Stable failures produced by version-1 Host/Flutter View sessions.
enum ViewProtocolErrorCode {
  /// The peer selected a protocol version this runtime cannot speak.
  unsupportedVersion('unsupported_version'),

  /// A frame did not match the exact schema for its declared kind.
  invalidMessage('invalid_message'),

  /// A frame belongs to another Host/Flutter View session.
  sessionMismatch('session_mismatch'),

  /// A frame did not carry the nonce active for its session phase.
  nonceMismatch('nonce_mismatch'),

  /// A call named an operation Host Dart did not expose.
  operationNotAllowed('operation_not_allowed'),

  /// A request ID was reused within one active session.
  duplicateRequest('duplicate_request'),

  /// Host Dart failed while executing an allowed operation.
  operationFailed('operation_failed'),

  /// The session closed before an operation could complete.
  sessionClosed('session_closed'),

  /// An in-flight request was cancelled by its initiator.
  cancelled('cancelled');

  const ViewProtocolErrorCode(this.wireName);

  /// Stable value sent across the runtime seam.
  final String wireName;
}

/// A structured failure raised at the Host/Flutter View protocol seam.
final class ViewProtocolException implements Exception {
  /// Creates a protocol failure with a stable [code].
  factory ViewProtocolException(
    ViewProtocolErrorCode code,
    String message, {
    Object? details,
  }) {
    if (message.isEmpty) {
      throw const ViewProtocolException._(
        ViewProtocolErrorCode.invalidMessage,
        'A structured protocol error message must not be empty.',
      );
    }
    if (!_isProtocolValue(details)) {
      throw const ViewProtocolException._(
        ViewProtocolErrorCode.invalidMessage,
        'Structured protocol error details must be a protocol-safe snapshot.',
      );
    }
    return ViewProtocolException._(
      code,
      message,
      details: _protocolSnapshot(details),
    );
  }

  const ViewProtocolException._(this.code, this.message, {this.details});

  /// Machine-readable failure category.
  final ViewProtocolErrorCode code;

  /// Actionable explanation for a developer.
  final String message;

  /// Optional protocol-safe diagnostic context.
  final Object? details;

  @override
  String toString() => '${code.wireName}: $message';
}

/// Carries protocol messages across a Host Dart/Flutter View runtime seam.
abstract interface class ViewTransport {
  /// Messages received from the other runtime.
  Stream<Object?> get messages;

  /// Sends [message] to the other runtime.
  ///
  /// Completion means the transport finished the strongest delivery handoff
  /// its native API exposes. The Host adapter includes VS Code's asynchronous
  /// acceptance result; the Flutter View API is void and can confirm only its
  /// synchronous handoff. A failure that the transport can observe must
  /// complete with an error rather than use a separate side channel.
  Future<void> send(Object? message);
}

/// Optional receive-side lifecycle for transports with native listeners.
///
/// Sessions close and await this receive side before measuring their final
/// resource counts. The transport must keep [ViewTransport.send] available
/// until the final `closing` frame has been delivered.
abstract interface class ViewTransportLifecycle {
  /// Native receive subscriptions that are still active.
  int get receivingSubscriptionCount;

  /// Stops native message receipt without disabling final outbound delivery.
  Future<void> closeReceiving();
}

/// A connected pair of in-memory transports for deterministic tests.
final class InMemoryViewTransportPair {
  /// Creates two connected transport endpoints.
  factory InMemoryViewTransportPair() {
    final hostMessages = StreamController<Object?>.broadcast(sync: true);
    final viewMessages = StreamController<Object?>.broadcast(sync: true);
    return InMemoryViewTransportPair._(
      _InMemoryViewTransport(hostMessages.stream, viewMessages.add),
      _InMemoryViewTransport(viewMessages.stream, hostMessages.add),
    );
  }

  const InMemoryViewTransportPair._(this.host, this.view);

  /// The endpoint used by Host Dart.
  final ViewTransport host;

  /// The endpoint used by the Flutter View.
  final ViewTransport view;
}

typedef _HostViewOperation = FutureOr<Object?> Function(Object? arguments);

/// Encodes a typed value as a protocol-safe snapshot.
typedef ViewValueEncoder<T> = Object? Function(T value);

/// Decodes and validates a protocol snapshot as a typed value.
typedef ViewValueDecoder<T> = T Function(Object? value);

/// A structural call seam over one connected Flutter View session.
///
/// Function-typed on purpose: an Extension Project's shared package
/// assembles its [ViewOperation]s against one generated copy of this
/// protocol while the Flutter View's session may come from another
/// (`package:flutter_vscode/view.dart`), and two copies of a library
/// never share nominal types. [FlutterViewSession.operationCaller]
/// and [ViewOperation.callThrough] meet at this plain function type,
/// so one shared operation declaration serves both runtimes.
typedef ViewOperationCaller =
    Future<Object?> Function(
      String operation,
      Object? arguments,
    );

/// A typed, allowlistable operation shared by Host Dart and a Flutter View.
///
/// The codecs are deterministic application code. This contract adds no
/// reflection or public generic dispatcher: its name is matched internally
/// against the Host session's explicit allowlist.
final class ViewOperation<Request, Result> {
  /// Creates a typed operation over protocol-safe snapshot values.
  const ViewOperation({
    required String name,
    required ViewValueEncoder<Request> encodeArguments,
    required ViewValueDecoder<Request> decodeArguments,
    required ViewValueEncoder<Result> encodeResult,
    required ViewValueDecoder<Result> decodeResult,
  }) : this._(
         name,
         encodeArguments,
         decodeArguments,
         encodeResult,
         decodeResult,
       );

  const ViewOperation._(
    this._name,
    this._encodeArguments,
    this._decodeArguments,
    this._encodeResult,
    this._decodeResult,
  );

  /// A typed operation whose request side carries no value.
  ///
  /// The supplied void codecs encode `null` and reject any non-null
  /// payload, replacing the hand-written encode-null/decode-guard pair
  /// every no-argument operation otherwise repeats.
  static ViewOperation<void, Result> noArgs<Result>(
    String name, {
    required ViewValueEncoder<Result> encodeResult,
    required ViewValueDecoder<Result> decodeResult,
  }) => ViewOperation<void, Result>._(
    name,
    _encodeVoidValue,
    _decodeVoidValue,
    encodeResult,
    decodeResult,
  );

  /// A typed operation whose result side carries no value.
  ///
  /// The supplied void codecs encode `null` and reject any non-null
  /// payload, replacing the hand-written encode-null/decode-guard pair
  /// every acknowledgement-style operation otherwise repeats.
  static ViewOperation<Request, void> noResult<Request>(
    String name, {
    required ViewValueEncoder<Request> encodeArguments,
    required ViewValueDecoder<Request> decodeArguments,
  }) => ViewOperation<Request, void>._(
    name,
    encodeArguments,
    decodeArguments,
    _encodeVoidValue,
    _decodeVoidValue,
  );

  static Object? _encodeVoidValue(void value) => null;

  static void _decodeVoidValue(Object? value) {
    if (value != null) {
      throw _invalidMessage('A void operation value must be null.');
    }
  }

  final String _name;
  final ViewValueEncoder<Request> _encodeArguments;
  final ViewValueDecoder<Request> _decodeArguments;
  final ViewValueEncoder<Result> _encodeResult;
  final ViewValueDecoder<Result> _decodeResult;

  /// Adapts a typed Host Dart [handler] to an allowlisted protocol operation.
  ViewOperationBinding bind(
    FutureOr<Result> Function(Request request) handler,
  ) {
    _requireNonEmptyProtocolIdentifier(_name, 'operation name');
    return ViewOperationBinding._(
      _name,
      (arguments) async {
        final request = _decode(
          _decodeArguments,
          arguments,
          'arguments',
        );
        return _encodeResult(await handler(request));
      },
    );
  }

  /// Calls this operation through [session] with typed arguments and result.
  Future<Result> call(FlutterViewSession session, Request arguments) async {
    _requireNonEmptyProtocolIdentifier(_name, 'operation name');
    final value = await session._call(
      _name,
      arguments: _encodeArguments(arguments),
    );
    return _decode(_decodeResult, value, 'result');
  }

  /// Calls this operation through [caller] — the cross-copy twin of
  /// [call].
  ///
  /// Use it when this operation value and the connected session come
  /// from two generated copies of this protocol; see
  /// [ViewOperationCaller] for the seam.
  Future<Result> callThrough(
    ViewOperationCaller caller,
    Request arguments,
  ) async {
    _requireNonEmptyProtocolIdentifier(_name, 'operation name');
    final value = await caller(_name, _encodeArguments(arguments));
    return _decode(_decodeResult, value, 'result');
  }

  T _decode<T>(ViewValueDecoder<T> decoder, Object? value, String role) {
    try {
      return decoder(value);
    } on ViewProtocolException {
      rethrow;
    } on Object catch (error) {
      throw ViewProtocolException(
        ViewProtocolErrorCode.invalidMessage,
        'The "$_name" operation $role did not match its typed schema.',
        details: '$error',
      );
    }
  }
}

/// An opaque typed operation binding accepted by [HostViewSession.connect].
///
/// Obtain bindings from [ViewOperation.bind]. The private constructor prevents
/// callers from assembling raw string/object dispatch entries.
final class ViewOperationBinding {
  const ViewOperationBinding._(this._name, this._handler);

  final String _name;
  final _HostViewOperation _handler;
}

/// A total codec for one field kind of a declared view-value schema.
///
/// Kinds compose: [orNull] admits `null`, [listOf] repeats a kind, and
/// [nested] embeds another [ViewValueSchema] — lazily, so a schema can
/// reference itself for recursive trees. Scalar kinds are also usable
/// directly as operation payload codecs via [encode] and [decode].
final class ViewValueKind<F> {
  const ViewValueKind._(this._encode, this._decode);

  /// String values.
  static const ViewValueKind<String> string = ViewValueKind._(
    _passValue,
    _decodeString,
  );

  /// Integer values.
  static const ViewValueKind<int> integer = ViewValueKind._(
    _passValue,
    _decodeInt,
  );

  /// Boolean values.
  static const ViewValueKind<bool> boolean = ViewValueKind._(
    _passValue,
    _decodeBool,
  );

  /// Double values.
  ///
  /// Decoding accepts any wire `num`: compiled JavaScript does not
  /// preserve the int/double distinction for whole numbers.
  static const ViewValueKind<double> doubleNumber = ViewValueKind._(
    _passValue,
    _decodeDouble,
  );

  /// This kind, additionally admitting `null`.
  ViewValueKind<F?> get orNull => ViewValueKind<F?>._(
    (value) => value == null ? null : _encode(value),
    (value) => value == null ? null : _decode(value),
  );

  /// A list whose items all match [of].
  ///
  /// A failing item is rejected naming its index.
  static ViewValueKind<List<F>> listOf<F>(ViewValueKind<F> of) =>
      ViewValueKind<List<F>>._(
        (value) => [for (final item in value) of._encode(item)],
        (value) {
          if (value is! List<Object?>) {
            throw const FormatException('Expected a list value.');
          }
          final items = <F>[];
          for (var index = 0; index < value.length; index += 1) {
            try {
              items.add(of._decode(value[index]));
            } on FormatException catch (error) {
              throw FormatException(
                'The item at index $index: ${error.message}',
              );
            }
          }
          return List.unmodifiable(items);
        },
      );

  /// A nested value declared by [schema].
  ///
  /// The schema is supplied lazily so a declaration can reference
  /// itself (directly or through [listOf]) for recursive trees.
  static ViewValueKind<F> nested<F>(ViewValueSchema<F> Function() schema) =>
      ViewValueKind<F>._(
        (value) => schema().encode(value),
        (value) => schema().decode(value),
      );

  static Object? _passValue(Object? value) => value;

  static String _decodeString(Object? value) => value is String
      ? value
      : throw const FormatException('Expected a string value.');

  static int _decodeInt(Object? value) => value is int
      ? value
      : throw const FormatException('Expected an int value.');

  static bool _decodeBool(Object? value) => value is bool
      ? value
      : throw const FormatException('Expected a bool value.');

  static double _decodeDouble(Object? value) => value is num
      ? value.toDouble()
      : throw const FormatException('Expected a double value.');

  final Object? Function(F value) _encode;
  final F Function(Object? value) _decode;

  /// Encodes [value] as a protocol-safe snapshot.
  Object? encode(F value) => _encode(value);

  /// Decodes and validates a protocol snapshot as this kind.
  F decode(Object? value) => _decode(value);
}

/// Reads one declared field's decoded value inside constructor wiring.
///
/// Returned by a schema's [ViewFieldDeclarator]; call it with the
/// [ViewDecodedFields] the constructor wiring receives.
typedef ViewFieldReader<F> = F Function(ViewDecodedFields fields);

/// Declares one schema field — wire [key], value [kind], and the
/// getter [read] — and returns the field's typed reader.
typedef ViewFieldDeclarator<T> =
    ViewFieldReader<F> Function<F>(
      String key,
      ViewValueKind<F> kind,
      F Function(T value) read,
    );

/// Decoded field values handed to a schema's constructor wiring.
final class ViewDecodedFields {
  const ViewDecodedFields._(this._values);

  final Map<String, Object?> _values;
}

/// The exact wire schema of one view-contract value type, declared
/// once.
///
/// [ViewValueSchema.new]'s callback runs once at construction: it
/// declares each field on the supplied declarator — wire key, value
/// kind, getter — and returns the constructor wiring that rebuilds a
/// [T] from decoded fields. From that single declaration the schema
/// derives [encode], [decode], and the exact-schema guard: a missing
/// key, an unexpected key, or a wrong-typed value throws a
/// [FormatException] naming the key. [encode] and [decode] tear off
/// as [ViewValueEncoder] and [ViewValueDecoder], composing directly
/// into [ViewOperation] codecs.
final class ViewValueSchema<T> {
  /// Declares a schema; see the class for the declaration contract.
  factory ViewValueSchema(
    T Function(ViewDecodedFields fields) Function(
      ViewFieldDeclarator<T> field,
    )
    declare,
  ) {
    final builder = _ViewSchemaBuilder<T>();
    final construct = declare(builder.declareField);
    builder.sealed = true;
    return ViewValueSchema._(List.unmodifiable(builder.fields), construct);
  }

  const ViewValueSchema._(this._fields, this._construct);

  final List<_ViewSchemaField<T>> _fields;
  final T Function(ViewDecodedFields fields) _construct;

  /// Encodes [value] as a protocol-safe snapshot of exactly the
  /// declared keys.
  Object? encode(T value) => <String, Object?>{
    for (final field in _fields) field.key: field.encodeFrom(value),
  };

  /// Decodes and validates a protocol snapshot against the exact
  /// declared schema.
  T decode(Object? value) {
    if (value is! Map<Object?, Object?>) {
      throw const FormatException(
        'Expected a map value carrying exactly the declared keys.',
      );
    }
    for (final field in _fields) {
      if (!value.containsKey(field.key)) {
        throw FormatException('The "${field.key}" key is missing.');
      }
    }
    if (value.length != _fields.length) {
      final declared = <Object?>{for (final field in _fields) field.key};
      final unexpected = [
        for (final key in value.keys)
          if (!declared.contains(key)) '"$key"',
      ].join(', ');
      throw FormatException('Unexpected keys: $unexpected.');
    }
    final decoded = <String, Object?>{};
    for (final field in _fields) {
      try {
        decoded[field.key] = field.decodeRaw(value[field.key]);
      } on FormatException catch (error) {
        throw FormatException('The "${field.key}" key: ${error.message}');
      }
    }
    return _construct(ViewDecodedFields._(decoded));
  }
}

final class _ViewSchemaField<T> {
  const _ViewSchemaField(this.key, this.encodeFrom, this.decodeRaw);

  final String key;
  final Object? Function(T value) encodeFrom;
  final Object? Function(Object? value) decodeRaw;
}

final class _ViewSchemaBuilder<T> {
  final List<_ViewSchemaField<T>> fields = [];
  bool sealed = false;

  ViewFieldReader<F> declareField<F>(
    String key,
    ViewValueKind<F> kind,
    F Function(T value) read,
  ) {
    if (sealed) {
      throw StateError(
        'Schema fields may be declared only inside the declaration '
        'callback.',
      );
    }
    if (fields.any((field) => field.key == key)) {
      throw ArgumentError.value(
        key,
        'key',
        'A schema field key may be declared only once.',
      );
    }
    fields.add(
      _ViewSchemaField<T>(
        key,
        (value) => kind._encode(read(value)),
        kind._decode,
      ),
    );
    return (decoded) => decoded._values[key] as F;
  }
}

/// Final protocol resource counts reported by a closing runtime.
final class ViewCloseReport {
  /// Creates an instrumented close report.
  const ViewCloseReport({
    required this.pendingRequestCount,
    required this.subscriptionCount,
  });

  /// Calls still pending after cleanup.
  final int pendingRequestCount;

  /// Transport subscriptions still active after cleanup.
  final int subscriptionCount;
}

// === View protocol frames: the only region that reads or writes wire keys ===

const String _protocolMarker = 'flutter-vscode.view';
const int _protocolVersion = 2;

/// One version-2 Host/Flutter View protocol frame.
///
/// This sealed hierarchy owns the wire schema. [parse] is the single place
/// the exact per-kind schema is validated, and [toWire] is the single place
/// wire maps are produced, so envelope and payload keys are written in one
/// module. Sessions dispatch on the typed frames and never touch wire keys.
sealed class ViewProtocolFrame {
  ViewProtocolFrame({required this.session, required this.nonce});

  /// Parses and validates [value] as the exact schema of its declared kind.
  ///
  /// Throws a [ViewProtocolException] with
  /// [ViewProtocolErrorCode.invalidMessage] for any schema violation and
  /// [ViewProtocolErrorCode.unsupportedVersion] for a foreign version.
  static ViewProtocolFrame parse(Object? value) {
    if (value is! Map<Object?, Object?> ||
        value.keys.any((key) => key is! String)) {
      throw _invalidMessage('The protocol frame must be a string-keyed map.');
    }
    final message = value.cast<String, Object?>();
    if (message['protocol'] != _protocolMarker) {
      throw _invalidMessage('The protocol marker is missing or invalid.');
    }
    final version = message['version'];
    if (version is! int) {
      throw _invalidMessage('The protocol version must be an integer.');
    }
    if (version != _protocolVersion) {
      throw ViewProtocolException(
        ViewProtocolErrorCode.unsupportedVersion,
        'The peer selected an unsupported Flutter View protocol version.',
      );
    }
    final kind = message['kind'];
    if (kind is! String) {
      throw _invalidMessage('The protocol frame kind must be a string.');
    }
    const envelopeKeys = {'protocol', 'version', 'kind', 'session', 'nonce'};
    final expectedKeys = switch (kind) {
      'ready' || 'shutdown' => envelopeKeys,
      'readyAck' => const {...envelopeKeys, 'activeNonce'},
      'call' || 'hostCall' => const {
        ...envelopeKeys,
        'id',
        'operation',
        'arguments',
      },
      'result' || 'hostResult' => const {...envelopeKeys, 'id', 'result'},
      'rendered' => const {...envelopeKeys, 'value'},
      'error' || 'hostError' => const {...envelopeKeys, 'id', 'error'},
      'cancel' => const {...envelopeKeys, 'id'},
      'event' => const {...envelopeKeys, 'stream', 'payload'},
      'closing' => const {...envelopeKeys, 'report'},
      _ => throw _invalidMessage('The protocol frame kind "$kind" is unknown.'),
    };
    final presentKeys = message.keys.toSet();
    if (presentKeys.difference(expectedKeys).isNotEmpty ||
        expectedKeys.difference(presentKeys).isNotEmpty) {
      throw _invalidMessage(
        'The "$kind" frame does not match its exact schema.',
      );
    }
    if (!_isNonEmptyString(message['session']) ||
        !_isNonEmptyString(message['nonce'])) {
      throw _invalidMessage(
        'Session and nonce values must be non-empty strings.',
      );
    }
    final session = message['session']! as String;
    final nonce = message['nonce']! as String;
    switch (kind) {
      case 'ready':
        return ViewReadyFrame(session: session, nonce: nonce);
      case 'readyAck':
        if (!_isNonEmptyString(message['activeNonce'])) {
          throw _invalidMessage('The active nonce must be a non-empty string.');
        }
        return ViewReadyAckFrame(
          session: session,
          nonce: nonce,
          activeNonce: message['activeNonce']! as String,
        );
      case 'call':
        if (!_isNonEmptyString(message['id']) ||
            !_isNonEmptyString(message['operation']) ||
            !_isProtocolValue(message['arguments'])) {
          throw _invalidMessage('The call frame contains invalid fields.');
        }
        return ViewCallFrame(
          session: session,
          nonce: nonce,
          id: message['id']! as String,
          operation: message['operation']! as String,
          arguments: message['arguments'],
        );
      case 'hostCall':
        if (!_isNonEmptyString(message['id']) ||
            !_isNonEmptyString(message['operation']) ||
            !_isProtocolValue(message['arguments'])) {
          throw _invalidMessage('The hostCall frame contains invalid fields.');
        }
        return ViewHostCallFrame(
          session: session,
          nonce: nonce,
          id: message['id']! as String,
          operation: message['operation']! as String,
          arguments: message['arguments'],
        );
      case 'result':
        if (!_isNonEmptyString(message['id']) ||
            !_isProtocolValue(message['result'])) {
          throw _invalidMessage('The result frame contains invalid fields.');
        }
        return ViewResultFrame(
          session: session,
          nonce: nonce,
          id: message['id']! as String,
          result: message['result'],
        );
      case 'hostResult':
        if (!_isNonEmptyString(message['id']) ||
            !_isProtocolValue(message['result'])) {
          throw _invalidMessage(
            'The hostResult frame contains invalid fields.',
          );
        }
        return ViewHostResultFrame(
          session: session,
          nonce: nonce,
          id: message['id']! as String,
          result: message['result'],
        );
      case 'rendered':
        if (!_isProtocolValue(message['value'])) {
          throw _invalidMessage('The rendered frame value is invalid.');
        }
        return ViewRenderedFrame(
          session: session,
          nonce: nonce,
          value: message['value'],
        );
      case 'error':
        if (!_isNonEmptyString(message['id'])) {
          throw _invalidMessage('The error frame request ID is invalid.');
        }
        return ViewErrorFrame(
          session: session,
          nonce: nonce,
          id: message['id']! as String,
          error: _errorFromFrame(message),
        );
      case 'hostError':
        if (!_isNonEmptyString(message['id'])) {
          throw _invalidMessage('The hostError frame request ID is invalid.');
        }
        return ViewHostErrorFrame(
          session: session,
          nonce: nonce,
          id: message['id']! as String,
          error: _errorFromFrame(message),
        );
      case 'cancel':
        if (!_isNonEmptyString(message['id'])) {
          throw _invalidMessage('The cancel frame request ID is invalid.');
        }
        return ViewCancelFrame(
          session: session,
          nonce: nonce,
          id: message['id']! as String,
        );
      case 'event':
        if (!_isNonEmptyString(message['stream']) ||
            !_isProtocolValue(message['payload'])) {
          throw _invalidMessage('The event frame contains invalid fields.');
        }
        return ViewEventFrame(
          session: session,
          nonce: nonce,
          stream: message['stream']! as String,
          payload: message['payload'],
        );
      case 'shutdown':
        return ViewShutdownFrame(session: session, nonce: nonce);
      case 'closing':
        return ViewClosingFrame(
          session: session,
          nonce: nonce,
          report: _closeReportFromFrame(message),
        );
    }
    // Unreachable: the exact-schema switch already rejected unknown kinds.
    throw _invalidMessage('The protocol frame kind "$kind" is unknown.');
  }

  /// The session identity this frame belongs to.
  final String session;

  /// The bootstrap or active nonce naming the session phase.
  final String nonce;

  /// The stable wire kind discriminator.
  String get kind;

  /// Whether this frame is active for [session] in the phase named [nonce].
  ///
  /// This is the active-frame predicate both session roles share: [parse]
  /// already proved the protocol marker and version, so the session identity
  /// and phase nonce complete the four-field check.
  bool isActive({required String session, required String? nonce}) =>
      this.session == session && this.nonce == nonce;

  /// Serializes this frame as its exact wire map, in stable key order.
  Map<String, Object?> toWire() => {
    'protocol': _protocolMarker,
    'version': _protocolVersion,
    'kind': kind,
    'session': session,
    'nonce': nonce,
    ..._payloadEntries(),
  };

  /// Kind-specific wire fields, in their stable wire order.
  Map<String, Object?> _payloadEntries();
}

/// A Flutter View announces itself on the bootstrap nonce.
final class ViewReadyFrame extends ViewProtocolFrame {
  /// Creates a `ready` frame.
  ViewReadyFrame({required super.session, required super.nonce});

  @override
  String get kind => 'ready';

  @override
  Map<String, Object?> _payloadEntries() => const {};
}

/// Host Dart accepts a handshake and advertises the active nonce.
final class ViewReadyAckFrame extends ViewProtocolFrame {
  /// Creates a `readyAck` frame.
  ViewReadyAckFrame({
    required super.session,
    required super.nonce,
    required this.activeNonce,
  });

  /// The nonce all subsequent frames of this session phase must carry.
  final String activeNonce;

  @override
  String get kind => 'readyAck';

  @override
  Map<String, Object?> _payloadEntries() => {'activeNonce': activeNonce};
}

/// A Flutter View calls an allowlisted Host Dart operation.
final class ViewCallFrame extends ViewProtocolFrame {
  /// Creates a `call` frame.
  ViewCallFrame({
    required super.session,
    required super.nonce,
    required this.id,
    required this.operation,
    required this.arguments,
  });

  /// The session-unique request ID.
  final String id;

  /// The allowlisted operation name.
  final String operation;

  /// The protocol-safe operation arguments.
  final Object? arguments;

  @override
  String get kind => 'call';

  @override
  Map<String, Object?> _payloadEntries() => {
    'id': id,
    'operation': operation,
    'arguments': arguments,
  };
}

/// Host Dart answers a Flutter View call with its result.
final class ViewResultFrame extends ViewProtocolFrame {
  /// Creates a `result` frame.
  ViewResultFrame({
    required super.session,
    required super.nonce,
    required this.id,
    required this.result,
  });

  /// The request ID this result answers.
  final String id;

  /// The protocol-safe operation result.
  final Object? result;

  @override
  String get kind => 'result';

  @override
  Map<String, Object?> _payloadEntries() => {'id': id, 'result': result};
}

/// Host Dart answers a Flutter View call with a structured failure.
final class ViewErrorFrame extends ViewProtocolFrame {
  /// Creates an `error` frame.
  ViewErrorFrame({
    required super.session,
    required super.nonce,
    required this.id,
    required this.error,
  });

  /// The request ID this failure answers.
  final String id;

  /// The structured protocol failure.
  final ViewProtocolException error;

  @override
  String get kind => 'error';

  @override
  Map<String, Object?> _payloadEntries() => {
    'id': id,
    'error': _errorPayload(error),
  };
}

/// A Flutter View reports the protocol-safe value it currently renders.
final class ViewRenderedFrame extends ViewProtocolFrame {
  /// Creates a `rendered` frame.
  ViewRenderedFrame({
    required super.session,
    required super.nonce,
    required this.value,
  });

  /// The protocol-safe rendered value.
  final Object? value;

  @override
  String get kind => 'rendered';

  @override
  Map<String, Object?> _payloadEntries() => {'value': value};
}

/// Host Dart calls an operation the Flutter View allowlisted.
final class ViewHostCallFrame extends ViewProtocolFrame {
  /// Creates a `hostCall` frame.
  ViewHostCallFrame({
    required super.session,
    required super.nonce,
    required this.id,
    required this.operation,
    required this.arguments,
  });

  /// The session-unique host request ID.
  final String id;

  /// The allowlisted operation name.
  final String operation;

  /// The protocol-safe operation arguments.
  final Object? arguments;

  @override
  String get kind => 'hostCall';

  @override
  Map<String, Object?> _payloadEntries() => {
    'id': id,
    'operation': operation,
    'arguments': arguments,
  };
}

/// A Flutter View answers a host call with its result.
final class ViewHostResultFrame extends ViewProtocolFrame {
  /// Creates a `hostResult` frame.
  ViewHostResultFrame({
    required super.session,
    required super.nonce,
    required this.id,
    required this.result,
  });

  /// The host request ID this result answers.
  final String id;

  /// The protocol-safe operation result.
  final Object? result;

  @override
  String get kind => 'hostResult';

  @override
  Map<String, Object?> _payloadEntries() => {'id': id, 'result': result};
}

/// A Flutter View answers a host call with a structured failure.
final class ViewHostErrorFrame extends ViewProtocolFrame {
  /// Creates a `hostError` frame.
  ViewHostErrorFrame({
    required super.session,
    required super.nonce,
    required this.id,
    required this.error,
  });

  /// The host request ID this failure answers.
  final String id;

  /// The structured protocol failure.
  final ViewProtocolException error;

  @override
  String get kind => 'hostError';

  @override
  Map<String, Object?> _payloadEntries() => {
    'id': id,
    'error': _errorPayload(error),
  };
}

/// An initiator abandons its in-flight request.
final class ViewCancelFrame extends ViewProtocolFrame {
  /// Creates a `cancel` frame.
  ViewCancelFrame({
    required super.session,
    required super.nonce,
    required this.id,
  });

  /// The request ID losing response eligibility.
  final String id;

  @override
  String get kind => 'cancel';

  @override
  Map<String, Object?> _payloadEntries() => {'id': id};
}

/// Host Dart pushes a one-way event to the Flutter View.
final class ViewEventFrame extends ViewProtocolFrame {
  /// Creates an `event` frame.
  ViewEventFrame({
    required super.session,
    required super.nonce,
    required this.stream,
    required this.payload,
  });

  /// The event stream name.
  final String stream;

  /// The protocol-safe event payload.
  final Object? payload;

  @override
  String get kind => 'event';

  @override
  Map<String, Object?> _payloadEntries() => {
    'stream': stream,
    'payload': payload,
  };
}

/// Host Dart requests an orderly Flutter View shutdown.
final class ViewShutdownFrame extends ViewProtocolFrame {
  /// Creates a `shutdown` frame.
  ViewShutdownFrame({required super.session, required super.nonce});

  @override
  String get kind => 'shutdown';

  @override
  Map<String, Object?> _payloadEntries() => const {};
}

/// A closing runtime reports its final protocol resource counts.
final class ViewClosingFrame extends ViewProtocolFrame {
  /// Creates a `closing` frame.
  ViewClosingFrame({
    required super.session,
    required super.nonce,
    required this.report,
  });

  /// The measured final resource counts.
  final ViewCloseReport report;

  @override
  String get kind => 'closing';

  @override
  Map<String, Object?> _payloadEntries() => {
    'report': {
      'pendingRequestCount': report.pendingRequestCount,
      'subscriptionCount': report.subscriptionCount,
    },
  };
}

Map<String, Object?> _errorPayload(ViewProtocolException error) => {
  'code': error.code.wireName,
  'message': error.message,
  'details': error.details,
};

bool _isNonEmptyString(Object? value) => value is String && value.isNotEmpty;

ViewProtocolException _errorFromFrame(Map<String, Object?> message) {
  final value = message['error'];
  if (value is! Map<Object?, Object?> ||
      value.keys.any((key) => key is! String)) {
    throw _invalidMessage('The structured error must be a string-keyed map.');
  }
  final error = value.cast<String, Object?>();
  const expectedKeys = {'code', 'message', 'details'};
  if (error.keys.toSet().difference(expectedKeys).isNotEmpty ||
      expectedKeys.difference(error.keys.toSet()).isNotEmpty ||
      error['code'] is! String ||
      !_isNonEmptyString(error['message']) ||
      !_isProtocolValue(error['details'])) {
    throw _invalidMessage('The structured error does not match its schema.');
  }
  final codeName = error['code']! as String;
  final code = ViewProtocolErrorCode.values.where(
    (candidate) => candidate.wireName == codeName,
  );
  if (code.length != 1) {
    throw _invalidMessage('The structured error code "$codeName" is unknown.');
  }
  return ViewProtocolException(
    code.single,
    error['message']! as String,
    details: error['details'],
  );
}

ViewCloseReport _closeReportFromFrame(Map<String, Object?> message) {
  final value = message['report'];
  if (value is! Map<Object?, Object?> ||
      value.keys.any((key) => key is! String)) {
    throw _invalidMessage('The close report must be a string-keyed map.');
  }
  final report = value.cast<String, Object?>();
  const expectedKeys = {'pendingRequestCount', 'subscriptionCount'};
  final pendingRequestCount = report['pendingRequestCount'];
  final subscriptionCount = report['subscriptionCount'];
  if (report.keys.toSet().difference(expectedKeys).isNotEmpty ||
      expectedKeys.difference(report.keys.toSet()).isNotEmpty ||
      pendingRequestCount is! int ||
      pendingRequestCount < 0 ||
      subscriptionCount is! int ||
      subscriptionCount < 0) {
    throw _invalidMessage('The close report does not match its exact schema.');
  }
  return ViewCloseReport(
    pendingRequestCount: pendingRequestCount,
    subscriptionCount: subscriptionCount,
  );
}

// === End of view protocol frames ===

/// The machinery both session roles share: transport subscription and
/// lifecycle, typed-frame send, the pending-response registry, inbound
/// request dedup and cancel bookkeeping, the shared inbound-operation
/// skeleton with structured-error framing, and the idempotent
/// close/terminate scaffolds. The role adapters keep only handshake
/// direction, exposed futures, and allowlist placement.
abstract base class _ViewSessionCore {
  _ViewSessionCore(
    ViewTransport transport,
    String sessionId,
    String bootstrapNonce,
    Map<String, _HostViewOperation> operations,
  ) : _transport = transport,
      _sessionId = sessionId,
      _bootstrapNonce = bootstrapNonce,
      _operations = operations;

  final ViewTransport _transport;
  final String _sessionId;
  final String _bootstrapNonce;
  final Map<String, _HostViewOperation> _operations;

  /// Outbound calls awaiting a peer response, by request ID.
  final Map<String, Completer<Object?>> _pendingResponses = {};

  /// Inbound request IDs already accepted within this session.
  final Set<String> _seenInboundRequestIds = {};

  /// Cancel bookkeeping for inbound requests. The host role stores
  /// response-eligible IDs; the view role stores cancelled IDs.
  final Set<String> _inboundCancellationMarks = {};

  final Completer<ViewCloseReport> _closedSignal = Completer<ViewCloseReport>();

  // The session cancels its owned subscription during every terminal path.
  // ignore: cancel_subscriptions
  StreamSubscription<Object?>? _subscription;
  String? _activeNonce;
  var _closed = false;
  Future<void>? _closeOperation;
  Future<void>? _terminationOperation;

  /// Number of protocol transport subscriptions owned by this session.
  int get subscriptionCount => _subscription == null ? 0 : 1;

  /// Completes after all protocol state and listeners have been released.
  Future<ViewCloseReport> get closed => _closedSignal.future;

  /// Calls this role considers pending, as reported in close reports.
  int get pendingRequestCount;

  /// Dispatches one validated protocol frame for this role.
  void _onFrame(ViewProtocolFrame frame);

  /// Reacts to a frame that failed [ViewProtocolFrame.parse] for this role.
  void _onMalformedFrame(ViewProtocolException error);

  /// The role-specific receive-stream failure explanation.
  String get _receiveFailureMessage;

  /// Releases per-request state when this session becomes terminal.
  void _releaseRequestState(ViewProtocolException? terminalError);

  /// Settles the role-specific lifecycle futures during termination.
  void _resolveTerminalFutures(
    ViewProtocolException? terminalError,
    ViewCloseReport report,
  );

  /// Runs the role-specific close choreography behind [close].
  Future<void> _runClose();

  /// The duplicate-inbound-request explanation for this role.
  String get _duplicateRequestMessage;

  /// The not-allowlisted explanation for this role.
  String _operationNotAllowedMessage(String operation);

  /// The operation-failure explanation for this role.
  String _operationFailedMessage(String operation, Object error);

  /// The non-snapshot-result explanation for this role.
  String _nonSnapshotResultMessage(String operation);

  /// Marks an inbound operation as running; returns its response token.
  Object? _beginInboundOperation(String id);

  /// Marks an inbound operation as no longer running.
  void _endInboundOperation();

  /// Whether the response for [id] may still be delivered.
  bool _mayDeliverInboundResponse(String id, Object? token);

  /// Builds this role's result frame answering an inbound request.
  ViewProtocolFrame _inboundResultFrame(String id, Object? result);

  /// Builds this role's error frame answering an inbound request.
  ViewProtocolFrame _inboundErrorFrame(String id, ViewProtocolException error);

  /// Contains a failed response delivery for this role.
  Future<void> _handleResponseDeliveryFailure();

  ViewTransportLifecycle? get _transportLifecycle => switch (_transport) {
    final ViewTransportLifecycle lifecycle => lifecycle,
    _ => null,
  };

  Future<void> _sendFrame(ViewProtocolFrame frame) =>
      _transport.send(frame.toWire());

  ViewCloseReport _measureCloseReport(ViewTransportLifecycle? lifecycle) =>
      ViewCloseReport(
        pendingRequestCount: pendingRequestCount,
        subscriptionCount:
            subscriptionCount + (lifecycle?.receivingSubscriptionCount ?? 0),
      );

  void _listen() {
    _subscription = _transport.messages.listen(
      _onMessage,
      onError: _onReceiveError,
      onDone: _onReceiveDone,
    );
  }

  void _onReceiveError(Object error, StackTrace stackTrace) {
    if (!_closed) {
      _observeOptionalError(
        _terminate(
          terminalError: ViewProtocolException(
            ViewProtocolErrorCode.sessionClosed,
            _receiveFailureMessage,
            details: '$error',
          ),
        ),
      );
    }
  }

  void _onReceiveDone() {
    if (!_closed) {
      _observeOptionalError(_terminate());
    }
  }

  void _onMessage(Object? value) {
    if (_closed) {
      return;
    }
    final ViewProtocolFrame frame;
    try {
      frame = ViewProtocolFrame.parse(value);
    } on ViewProtocolException catch (error) {
      _onMalformedFrame(error);
      return;
    }
    _onFrame(frame);
  }

  /// Runs one inbound allowlisted operation and frames its response.
  Future<void> _acceptInboundCall(
    String id,
    String operationName,
    Object? arguments,
  ) async {
    if (!_seenInboundRequestIds.add(id)) {
      await _sendStructuredError(
        id,
        ViewProtocolException(
          ViewProtocolErrorCode.duplicateRequest,
          _duplicateRequestMessage,
        ),
      );
      return;
    }
    final operation = _operations[operationName];
    if (operation == null) {
      await _sendStructuredError(
        id,
        ViewProtocolException(
          ViewProtocolErrorCode.operationNotAllowed,
          _operationNotAllowedMessage(operationName),
        ),
      );
      return;
    }
    final token = _beginInboundOperation(id);
    Object? result;
    ViewProtocolException? operationError;
    try {
      try {
        result = await operation(arguments);
      } on ViewProtocolException catch (error) {
        operationError = error;
      } on Object catch (error) {
        operationError = ViewProtocolException(
          ViewProtocolErrorCode.operationFailed,
          _operationFailedMessage(operationName, error),
        );
      }
    } finally {
      _endInboundOperation();
    }
    if (!_mayDeliverInboundResponse(id, token)) {
      // Per-request disposal: a cancelled or superseded request loses
      // response eligibility, so its late result or error is never delivered.
      return;
    }
    if (operationError != null) {
      await _sendStructuredError(id, operationError);
      return;
    }
    if (!_isProtocolValue(result)) {
      await _sendStructuredError(
        id,
        ViewProtocolException(
          ViewProtocolErrorCode.operationFailed,
          _nonSnapshotResultMessage(operationName),
        ),
      );
      return;
    }
    try {
      await _sendFrame(_inboundResultFrame(id, result));
    } on Object {
      await _handleResponseDeliveryFailure();
    }
  }

  Future<void> _sendStructuredError(
    String id,
    ViewProtocolException error,
  ) async {
    try {
      await _sendFrame(_inboundErrorFrame(id, error));
    } on Object {
      await _handleResponseDeliveryFailure();
    }
  }

  /// Closes this session and releases all pending protocol state.
  Future<void> close() {
    final existing = _closeOperation;
    if (existing != null) {
      return existing;
    }
    if (_closed) {
      return _terminationOperation ?? Future.value();
    }
    final completion = Completer<void>();
    _closeOperation = completion.future;
    unawaited(
      _runClose().then(
        (_) => completion.complete(),
        onError: completion.completeError,
      ),
    );
    return completion.future;
  }

  Future<void> _terminate({ViewProtocolException? terminalError}) {
    final existing = _terminationOperation;
    if (existing != null) {
      return existing;
    }
    if (_closed) {
      return _closeOperation ?? Future.value();
    }
    final completion = Completer<void>();
    _terminationOperation = completion.future;
    unawaited(
      _runTerminate(terminalError).then(
        (_) => completion.complete(),
        onError: completion.completeError,
      ),
    );
    return completion.future;
  }

  Future<void> _runTerminate(ViewProtocolException? terminalError) async {
    _closed = true;
    _releaseRequestState(terminalError);
    final subscription = _subscription;
    Object? cancellationError;
    StackTrace? cancellationStackTrace;
    try {
      await subscription?.cancel();
    } on Object catch (error, stackTrace) {
      cancellationError = error;
      cancellationStackTrace = stackTrace;
    } finally {
      _subscription = null;
    }
    final transportLifecycle = _transportLifecycle;
    try {
      await transportLifecycle?.closeReceiving();
    } on Object catch (error, stackTrace) {
      cancellationError ??= error;
      cancellationStackTrace ??= stackTrace;
    } finally {
      _resolveTerminalFutures(
        terminalError,
        _measureCloseReport(transportLifecycle),
      );
    }
    if (cancellationError != null) {
      Error.throwWithStackTrace(
        cancellationError,
        cancellationStackTrace!,
      );
    }
  }
}

/// The Host Dart side of one version-1 Flutter View session.
final class HostViewSession extends _ViewSessionCore {
  /// Starts accepting a Flutter View on [transport].
  factory HostViewSession.connect({
    required ViewTransport transport,
    required String sessionId,
    required String bootstrapNonce,
    Iterable<ViewOperationBinding> operations = const [],
  }) {
    _requireNonEmptyProtocolIdentifier(sessionId, 'sessionId');
    _requireNonEmptyProtocolIdentifier(bootstrapNonce, 'bootstrapNonce');
    final handlers = <String, _HostViewOperation>{};
    for (final operation in operations) {
      if (handlers.containsKey(operation._name)) {
        throw ArgumentError.value(
          operation._name,
          'operations',
          'Host Dart operation names must be unique; '
              '"${operation._name}" was bound more than once.',
        );
      }
      handlers[operation._name] = operation._handler;
    }
    final session = HostViewSession._(
      transport,
      sessionId,
      bootstrapNonce,
      Map.unmodifiable(handlers),
    );
    return session.._listen();
  }

  HostViewSession._(
    super.transport,
    super.sessionId,
    super.bootstrapNonce,
    super.operations,
  ) {
    _observeOptionalError(_ready.future);
    _observeOptionalError(_rendered.future);
    _observeOptionalError(_closeReport.future);
  }

  final Completer<void> _ready = Completer<void>();
  final Completer<Object?> _rendered = Completer<Object?>();
  final Completer<ViewCloseReport> _closeReport = Completer<ViewCloseReport>();
  var _nextHostCallId = 0;
  var _inFlightOperationCount = 0;
  var _generation = 0;

  /// Completes after the versioned session/nonce handshake succeeds.
  Future<void> get ready => _ready.future;

  /// Completes with the first value the Flutter View reports as rendered.
  Future<Object?> get rendered => _rendered.future;

  /// Number of calls whose Host Dart operations have not completed.
  @override
  int get pendingRequestCount => _inFlightOperationCount;

  /// Number of host-initiated calls waiting for a Flutter View result.
  int get pendingHostCallCount => _pendingResponses.length;

  @override
  String get _receiveFailureMessage => 'The Host receive stream failed.';

  @override
  void _onMalformedFrame(ViewProtocolException error) {
    // The Host is the session authority: frames that do not parse are
    // ignored fail-closed rather than terminating the session.
  }

  @override
  void _onFrame(ViewProtocolFrame frame) {
    switch (frame) {
      case ViewReadyFrame():
        _observeOptionalError(_acceptReady(frame));
      case ViewCallFrame():
        _observeOptionalError(_acceptCall(frame));
      case ViewCancelFrame():
        _acceptCancel(frame);
      case ViewHostResultFrame():
        _acceptHostResult(frame);
      case ViewHostErrorFrame():
        _acceptHostError(frame);
      case ViewRenderedFrame():
        _acceptRendered(frame);
      case ViewClosingFrame():
        _acceptClosing(frame);
      default:
        // Other kinds are not host-bound; ignore them fail-closed.
        break;
    }
  }

  bool _isActiveFrame(ViewProtocolFrame frame) =>
      frame.isActive(session: _sessionId, nonce: _activeNonce);

  void _acceptCancel(ViewCancelFrame frame) {
    if (!_isActiveFrame(frame)) {
      return;
    }
    // Per-request disposal: a cancelled view call loses response
    // eligibility, so its late result or error is never delivered.
    _inboundCancellationMarks.remove(frame.id);
  }

  void _acceptHostResult(ViewHostResultFrame frame) {
    if (!_isActiveFrame(frame)) {
      return;
    }
    _pendingResponses.remove(frame.id)?.complete(frame.result);
  }

  void _acceptHostError(ViewHostErrorFrame frame) {
    if (!_isActiveFrame(frame)) {
      return;
    }
    _pendingResponses.remove(frame.id)?.completeError(frame.error);
  }

  /// Calls a Flutter View-bound [operation] and awaits its result.
  Future<Result> call<Request, Result>(
    ViewOperation<Request, Result> operation,
    Request arguments,
  ) => callWithHandle(operation, arguments).result;

  /// Calls a Flutter View-bound [operation], returning a cancellable
  /// handle for the in-flight request.
  HostViewCall<Result> callWithHandle<Request, Result>(
    ViewOperation<Request, Result> operation,
    Request arguments,
  ) {
    final id = 'host-request-${++_nextHostCallId}';
    final completer = Completer<Object?>();
    _observeOptionalError(completer.future);
    if (_closed || !_ready.isCompleted) {
      completer.completeError(
        ViewProtocolException(
          ViewProtocolErrorCode.sessionClosed,
          'The Host Flutter View session is not connected.',
        ),
      );
      return HostViewCall._(
        completer.future.then(operation._decodeResult),
        () {},
      );
    }
    _pendingResponses[id] = completer;
    Object? encoded;
    try {
      encoded = operation._encodeArguments(arguments);
      if (!_isProtocolValue(encoded)) {
        throw _invalidMessage(
          'Host call arguments must be a protocol-safe snapshot.',
        );
      }
    } on Object catch (error, stackTrace) {
      _pendingResponses.remove(id);
      completer.completeError(error, stackTrace);
      return HostViewCall._(
        completer.future.then(operation._decodeResult),
        () {},
      );
    }
    unawaited(
      _sendFrame(
        ViewHostCallFrame(
          session: _sessionId,
          nonce: _activeNonce!,
          id: id,
          operation: operation._name,
          arguments: encoded,
        ),
      ).catchError((Object error, StackTrace stackTrace) {
        _pendingResponses.remove(id);
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      }),
    );
    void cancel() {
      final pending = _pendingResponses.remove(id);
      if (pending == null) {
        return;
      }
      pending.completeError(
        ViewProtocolException(
          ViewProtocolErrorCode.cancelled,
          'The host cancelled the "${operation._name}" call.',
        ),
      );
      if (!_closed) {
        unawaited(
          _sendFrame(
            ViewCancelFrame(
              session: _sessionId,
              nonce: _activeNonce!,
              id: id,
            ),
          ).catchError((Object _) {}),
        );
      }
    }

    return HostViewCall._(
      completer.future.then(operation._decodeResult),
      cancel,
    );
  }

  /// Pushes a one-way event [payload] to the Flutter View on [stream].
  Future<void> emitEvent(String stream, Object? payload) async {
    _requireNonEmptyProtocolIdentifier(stream, 'stream');
    if (_closed || !_ready.isCompleted) {
      throw ViewProtocolException(
        ViewProtocolErrorCode.sessionClosed,
        'The Host Flutter View session is not connected.',
      );
    }
    if (!_isProtocolValue(payload)) {
      throw _invalidMessage(
        'An event payload must be a protocol-safe snapshot.',
      );
    }
    await _sendFrame(
      ViewEventFrame(
        session: _sessionId,
        nonce: _activeNonce!,
        stream: stream,
        payload: _protocolSnapshot(payload),
      ),
    );
  }

  void _acceptRendered(ViewRenderedFrame frame) {
    if (!_isActiveFrame(frame) || _rendered.isCompleted) {
      return;
    }
    _rendered.complete(frame.value);
  }

  void _acceptClosing(ViewClosingFrame frame) {
    if (!_isActiveFrame(frame)) {
      return;
    }
    if (!_closeReport.isCompleted) {
      _closeReport.complete(frame.report);
    }
    _observeOptionalError(_terminate());
  }

  Future<void> _acceptReady(ViewReadyFrame frame) async {
    if (!frame.isActive(session: _sessionId, nonce: _bootstrapNonce)) {
      return;
    }
    final previouslyAdvertisedNonce = _activeNonce;
    if (previouslyAdvertisedNonce != null) {
      _generation += 1;
      _inboundCancellationMarks.clear();
      _seenInboundRequestIds.clear();
    }
    final activeNonce = _createNonce();
    _activeNonce = activeNonce;
    try {
      await _sendFrame(
        ViewReadyAckFrame(
          session: _sessionId,
          nonce: _bootstrapNonce,
          activeNonce: activeNonce,
        ),
      );
    } on Object {
      if (_activeNonce == activeNonce) {
        _activeNonce = previouslyAdvertisedNonce;
      }
      await _closeAfterDeliveryFailure();
      return;
    }
    if (!_closed && _activeNonce == activeNonce && !_ready.isCompleted) {
      _ready.complete();
    }
  }

  Future<void> _acceptCall(ViewCallFrame frame) async {
    if (!_isActiveFrame(frame)) {
      return;
    }
    await _acceptInboundCall(frame.id, frame.operation, frame.arguments);
  }

  @override
  String get _duplicateRequestMessage =>
      'A request ID may be used only once in a Flutter View session.';

  @override
  String _operationNotAllowedMessage(String operation) =>
      'Host Dart does not allow the "$operation" operation.';

  @override
  String _operationFailedMessage(String operation, Object error) =>
      'Host Dart operation "$operation" failed: $error';

  @override
  String _nonSnapshotResultMessage(String operation) =>
      'Host Dart operation "$operation" did not return '
      'a protocol-safe snapshot.';

  @override
  Object? _beginInboundOperation(String id) {
    final generation = _generation;
    _inboundCancellationMarks.add(id);
    _inFlightOperationCount += 1;
    return generation;
  }

  @override
  void _endInboundOperation() {
    _inFlightOperationCount -= 1;
  }

  @override
  bool _mayDeliverInboundResponse(String id, Object? token) =>
      !_closed && token == _generation && _inboundCancellationMarks.remove(id);

  @override
  ViewProtocolFrame _inboundResultFrame(String id, Object? result) =>
      ViewResultFrame(
        session: _sessionId,
        nonce: _activeNonce!,
        id: id,
        result: result,
      );

  @override
  ViewProtocolFrame _inboundErrorFrame(
    String id,
    ViewProtocolException error,
  ) => ViewErrorFrame(
    session: _sessionId,
    nonce: _activeNonce!,
    id: id,
    error: error,
  );

  @override
  Future<void> _handleResponseDeliveryFailure() => _closeAfterDeliveryFailure();

  Future<void> _closeAfterDeliveryFailure() async {
    try {
      await close();
    } on Object {
      // close() always runs terminal cleanup, even when closing delivery fails.
    }
  }

  @override
  Future<void> _runClose() async {
    final nonce = _activeNonce ?? _bootstrapNonce;
    Object? cancellationError;
    StackTrace? cancellationStackTrace;
    try {
      await _terminate();
    } on Object catch (error, stackTrace) {
      cancellationError = error;
      cancellationStackTrace = stackTrace;
    }
    final report = _measureCloseReport(_transportLifecycle);
    Object? deliveryError;
    StackTrace? deliveryStackTrace;
    try {
      await _sendFrame(
        ViewClosingFrame(session: _sessionId, nonce: nonce, report: report),
      );
    } on Object catch (error, stackTrace) {
      deliveryError = error;
      deliveryStackTrace = stackTrace;
    }
    if (deliveryError != null) {
      Error.throwWithStackTrace(deliveryError, deliveryStackTrace!);
    }
    if (cancellationError != null) {
      Error.throwWithStackTrace(
        cancellationError,
        cancellationStackTrace!,
      );
    }
  }

  /// Requests orderly Flutter View shutdown and returns its final counts.
  Future<ViewCloseReport> shutdown() async {
    if (_closed) {
      return _closeReport.future;
    }
    final nonce = _activeNonce;
    if (nonce == null) {
      return Future.error(
        ViewProtocolException(
          ViewProtocolErrorCode.sessionClosed,
          'Cannot shut down a Flutter View before it connects.',
        ),
      );
    }
    try {
      await _sendFrame(ViewShutdownFrame(session: _sessionId, nonce: nonce));
    } on Object catch (error, stackTrace) {
      try {
        await _terminate();
      } on Object {
        // Preserve the first failure: shutdown delivery was rejected.
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
    return _closeReport.future;
  }

  @override
  void _releaseRequestState(ViewProtocolException? terminalError) {
    _generation += 1;
    _inboundCancellationMarks.clear();
    _seenInboundRequestIds.clear();
  }

  @override
  void _resolveTerminalFutures(
    ViewProtocolException? terminalError,
    ViewCloseReport report,
  ) {
    if (!_ready.isCompleted) {
      _ready.completeError(
        terminalError ??
            ViewProtocolException(
              ViewProtocolErrorCode.sessionClosed,
              'The Host Flutter View session closed before the view was '
              'ready.',
            ),
      );
    }
    if (!_rendered.isCompleted) {
      _rendered.completeError(
        terminalError ??
            ViewProtocolException(
              ViewProtocolErrorCode.sessionClosed,
              'The Host Flutter View session closed before the view '
              'rendered.',
            ),
      );
    }
    if (!_closeReport.isCompleted) {
      _closeReport.completeError(
        terminalError ??
            ViewProtocolException(
              ViewProtocolErrorCode.sessionClosed,
              'The Host Flutter View session closed before orderly shutdown '
              'completed.',
            ),
      );
    }
    if (!_closedSignal.isCompleted) {
      _closedSignal.complete(report);
    }
  }
}

/// One cancellable host-initiated call to a Flutter View operation.
final class HostViewCall<Result> {
  HostViewCall._(this.result, this._cancel);

  /// Completes with the operation result, a structured error, or
  /// [ViewProtocolErrorCode.cancelled].
  final Future<Result> result;

  final void Function() _cancel;

  /// Cancels the in-flight call; a late peer response is discarded.
  void cancel() => _cancel();
}

/// The Flutter View side of one version-2 Host Dart session.
final class FlutterViewSession extends _ViewSessionCore {
  FlutterViewSession._(
    super.transport,
    super.sessionId,
    super.bootstrapNonce,
    super.operations,
  ) {
    _observeOptionalError(_connected.future);
  }

  /// Connects to Host Dart using a bootstrap session and nonce.
  ///
  /// [operations] are the typed operations this Flutter View allows the
  /// host to call over the version-2 host-to-view direction.
  static Future<FlutterViewSession> connect({
    required ViewTransport transport,
    required String sessionId,
    required String bootstrapNonce,
    Iterable<ViewOperationBinding> operations = const [],
  }) async {
    _requireNonEmptyProtocolIdentifier(sessionId, 'sessionId');
    _requireNonEmptyProtocolIdentifier(bootstrapNonce, 'bootstrapNonce');
    final handlers = <String, _HostViewOperation>{};
    for (final operation in operations) {
      if (handlers.containsKey(operation._name)) {
        throw ArgumentError.value(
          operation._name,
          'operations',
          'Flutter View operation names must be unique; '
              '"${operation._name}" was bound more than once.',
        );
      }
      handlers[operation._name] = operation._handler;
    }
    final session = FlutterViewSession._(
      transport,
      sessionId,
      bootstrapNonce,
      Map.unmodifiable(handlers),
    ).._listen();
    try {
      await session._sendFrame(
        ViewReadyFrame(session: sessionId, nonce: bootstrapNonce),
      );
    } on Object catch (error, stackTrace) {
      try {
        await session._terminate();
      } on Object {
        // Preserve the first failure: the connection frame was not delivered.
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
    final connected = session._connected.future;
    await connected;
    return session;
  }

  final Completer<void> _connected = Completer<void>();
  final Map<String, StreamController<Object?>> _eventStreams = {};
  var _nextRequestId = 0;

  /// Number of calls waiting for a Host Dart result.
  @override
  int get pendingRequestCount => _pendingResponses.length;

  /// The nonce active for this session phase, once connected.
  String? get activeNonce => _activeNonce;

  @override
  String get _receiveFailureMessage =>
      'The Flutter View receive stream failed.';

  @override
  void _onMalformedFrame(ViewProtocolException error) {
    // The view fails closed: a frame that does not parse rejects the
    // connection and terminates the session.
    _observeOptionalError(_rejectConnection(error));
  }

  @override
  void _onFrame(ViewProtocolFrame frame) {
    if (frame.session != _sessionId) {
      _observeOptionalError(
        _rejectConnection(
          ViewProtocolException(
            ViewProtocolErrorCode.sessionMismatch,
            'The protocol frame belongs to another Flutter View session.',
          ),
        ),
      );
      return;
    }
    final expectedNonce = _connected.isCompleted
        ? _activeNonce
        : _bootstrapNonce;
    if (frame.nonce != expectedNonce) {
      _observeOptionalError(
        _rejectConnection(
          ViewProtocolException(
            ViewProtocolErrorCode.nonceMismatch,
            'The protocol frame nonce is not active for this session.',
          ),
        ),
      );
      return;
    }
    if (!_connected.isCompleted &&
        frame is! ViewReadyAckFrame &&
        frame is! ViewShutdownFrame &&
        frame is! ViewClosingFrame) {
      _observeOptionalError(
        _rejectConnection(
          _invalidMessage(
            'Only a ready acknowledgement or terminal frame is valid during '
            'the Flutter View handshake.',
          ),
        ),
      );
      return;
    }
    switch (frame) {
      case ViewReadyAckFrame() when frame.nonce == _bootstrapNonce:
        _activeNonce = frame.activeNonce;
        if (!_connected.isCompleted) {
          _connected.complete();
        }
      case ViewResultFrame():
        _pendingResponses.remove(frame.id)?.complete(frame.result);
      case ViewErrorFrame():
        _pendingResponses.remove(frame.id)?.completeError(frame.error);
      case ViewHostCallFrame():
        _observeOptionalError(
          _acceptInboundCall(frame.id, frame.operation, frame.arguments),
        );
      case ViewCancelFrame():
        _inboundCancellationMarks.add(frame.id);
      case ViewEventFrame():
        _eventStreams[frame.stream]?.add(frame.payload);
      case ViewShutdownFrame():
        _observeOptionalError(close());
      case ViewClosingFrame():
        _observeOptionalError(_terminate());
      default:
        // A ready acknowledgement outside the bootstrap phase is ignored.
        break;
    }
  }

  @override
  String get _duplicateRequestMessage =>
      'A host request ID may be used only once in a session.';

  @override
  String _operationNotAllowedMessage(String operation) =>
      'The Flutter View does not allow the "$operation" operation.';

  @override
  String _operationFailedMessage(String operation, Object error) =>
      'Flutter View operation "$operation" failed: $error';

  @override
  String _nonSnapshotResultMessage(String operation) =>
      'Flutter View operation "$operation" did not '
      'return a protocol-safe snapshot.';

  @override
  Object? _beginInboundOperation(String id) => null;

  @override
  void _endInboundOperation() {}

  @override
  bool _mayDeliverInboundResponse(String id, Object? token) =>
      !_closed && !_inboundCancellationMarks.remove(id);

  @override
  ViewProtocolFrame _inboundResultFrame(String id, Object? result) =>
      ViewHostResultFrame(
        session: _sessionId,
        nonce: _activeNonce!,
        id: id,
        result: result,
      );

  @override
  ViewProtocolFrame _inboundErrorFrame(
    String id,
    ViewProtocolException error,
  ) => ViewHostErrorFrame(
    session: _sessionId,
    nonce: _activeNonce!,
    id: id,
    error: error,
  );

  @override
  Future<void> _handleResponseDeliveryFailure() => _terminate();

  /// Host-pushed events for [stream], in delivery order.
  Stream<Object?> events(String stream) {
    _requireNonEmptyProtocolIdentifier(stream, 'stream');
    return _eventStreams
        .putIfAbsent(stream, StreamController<Object?>.broadcast)
        .stream;
  }

  /// This session's structural call seam; see [ViewOperationCaller]
  /// for why it is a plain function type.
  ViewOperationCaller get operationCaller =>
      (operation, arguments) => _call(operation, arguments: arguments);

  /// Calls one operation explicitly allowlisted by Host Dart.
  Future<Object?> _call(String operation, {Object? arguments}) async {
    if (_closed) {
      return Future.error(
        ViewProtocolException(
          ViewProtocolErrorCode.sessionClosed,
          'The Flutter View session is closed.',
        ),
      );
    }
    if (!_isProtocolValue(arguments)) {
      return Future.error(
        _invalidMessage(
          'Call arguments must contain only protocol-safe snapshot data.',
        ),
      );
    }
    final id = 'request-${++_nextRequestId}';
    final completer = Completer<Object?>();
    _observeOptionalError(completer.future);
    _pendingResponses[id] = completer;
    try {
      await _sendFrame(
        ViewCallFrame(
          session: _sessionId,
          nonce: _activeNonce!,
          id: id,
          operation: operation,
          arguments: arguments,
        ),
      );
    } on Object catch (error, stackTrace) {
      _pendingResponses.remove(id);
      try {
        await _terminate();
      } on Object {
        // Preserve the first failure: call delivery was rejected.
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
    return completer.future;
  }

  /// Reports the protocol-safe value currently rendered by this Flutter View.
  Future<void> reportRendered(Object? value) async {
    if (_closed) {
      throw ViewProtocolException(
        ViewProtocolErrorCode.sessionClosed,
        'The Flutter View session is closed.',
      );
    }
    if (!_isProtocolValue(value)) {
      throw _invalidMessage(
        'A rendered value must contain only protocol-safe snapshot data.',
      );
    }
    try {
      await _sendFrame(
        ViewRenderedFrame(
          session: _sessionId,
          nonce: _activeNonce!,
          value: value,
        ),
      );
    } on Object catch (error, stackTrace) {
      try {
        await _terminate();
      } on Object {
        // Preserve the first failure: render delivery was rejected.
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<void> _runClose() async {
    _closed = true;
    _releaseRequestState(null);
    final subscription = _subscription;
    Object? deliveryError;
    StackTrace? deliveryStackTrace;
    Object? cancellationError;
    StackTrace? cancellationStackTrace;
    try {
      await subscription?.cancel();
    } on Object catch (error, stackTrace) {
      cancellationError = error;
      cancellationStackTrace = stackTrace;
    } finally {
      _subscription = null;
      _failConnectIfPending();
    }
    final transportLifecycle = _transportLifecycle;
    try {
      await transportLifecycle?.closeReceiving();
    } on Object catch (error, stackTrace) {
      cancellationError ??= error;
      cancellationStackTrace ??= stackTrace;
    }
    final report = _measureCloseReport(transportLifecycle);
    try {
      await _sendFrame(
        ViewClosingFrame(
          session: _sessionId,
          nonce: _activeNonce ?? _bootstrapNonce,
          report: report,
        ),
      );
    } on Object catch (error, stackTrace) {
      deliveryError = error;
      deliveryStackTrace = stackTrace;
    } finally {
      _completeClosed(report);
    }
    if (deliveryError != null) {
      Error.throwWithStackTrace(deliveryError, deliveryStackTrace!);
    }
    if (cancellationError != null) {
      Error.throwWithStackTrace(
        cancellationError,
        cancellationStackTrace!,
      );
    }
  }

  @override
  void _releaseRequestState(ViewProtocolException? terminalError) {
    for (final completer in _pendingResponses.values) {
      if (!completer.isCompleted) {
        completer.completeError(
          terminalError ??
              ViewProtocolException(
                ViewProtocolErrorCode.sessionClosed,
                'The Flutter View session closed before the call completed.',
              ),
        );
      }
    }
    _pendingResponses.clear();
  }

  @override
  void _resolveTerminalFutures(
    ViewProtocolException? terminalError,
    ViewCloseReport report,
  ) {
    _failConnectIfPending(terminalError);
    _completeClosed(report);
  }

  void _failConnectIfPending([ViewProtocolException? terminalError]) {
    if (!_connected.isCompleted) {
      _connected.completeError(
        terminalError ??
            ViewProtocolException(
              ViewProtocolErrorCode.sessionClosed,
              'The Flutter View session closed before the handshake completed.',
            ),
      );
    }
  }

  void _completeClosed(ViewCloseReport report) {
    if (!_closedSignal.isCompleted) {
      _closedSignal.complete(report);
    }
  }

  Future<void> _rejectConnection(ViewProtocolException error) async {
    if (!_connected.isCompleted) {
      _connected.completeError(error);
    }
    await _terminate();
  }
}

final class _InMemoryViewTransport implements ViewTransport {
  const _InMemoryViewTransport(this.messages, this._send);

  @override
  final Stream<Object?> messages;

  final void Function(Object?) _send;

  @override
  Future<void> send(Object? message) {
    _send(jsonDecode(jsonEncode(message)));
    return Future.value();
  }
}

String _createNonce() {
  final random = Random.secure();
  return List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}

void _requireNonEmptyProtocolIdentifier(String value, String name) {
  if (value.isEmpty) {
    throw ViewProtocolException(
      ViewProtocolErrorCode.invalidMessage,
      '$name must be a non-empty protocol identifier.',
    );
  }
}

bool _isProtocolValue(Object? value, [Set<Object>? ancestors]) {
  if (value == null || value is String || value is bool) {
    return true;
  }
  if (value is num) {
    return value.isFinite;
  }
  if (value is List<Object?>) {
    final active = ancestors ?? Set<Object>.identity();
    if (!active.add(value)) {
      return false;
    }
    final valid = value.every((item) => _isProtocolValue(item, active));
    active.remove(value);
    return valid;
  }
  if (value is Map<Object?, Object?>) {
    final active = ancestors ?? Set<Object>.identity();
    if (!active.add(value)) {
      return false;
    }
    final valid = value.entries.every(
      (entry) => entry.key is String && _isProtocolValue(entry.value, active),
    );
    active.remove(value);
    return valid;
  }
  return false;
}

Object? _protocolSnapshot(Object? value) {
  if (value is List<Object?>) {
    return List<Object?>.unmodifiable(value.map(_protocolSnapshot));
  }
  if (value is Map<Object?, Object?>) {
    return Map<String, Object?>.unmodifiable({
      for (final entry in value.entries)
        entry.key! as String: _protocolSnapshot(entry.value),
    });
  }
  return value;
}

ViewProtocolException _invalidMessage(String message) =>
    ViewProtocolException(ViewProtocolErrorCode.invalidMessage, message);

void _observeOptionalError<T>(Future<T> future) {
  // These lifecycle futures are optional signals. This listener prevents an
  // ignored signal from becoming an unhandled zone error; callers awaiting the
  // original future still receive its terminal failure.
  unawaited(
    future.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    ),
  );
}

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
  sessionClosed('session_closed');

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

/// The Host Dart side of one version-1 Flutter View session.
final class HostViewSession {
  /// Starts accepting a Flutter View on [transport].
  factory HostViewSession.connect({
    required ViewTransport transport,
    required String sessionId,
    required String bootstrapNonce,
    required Iterable<ViewOperationBinding> operations,
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
    this._transport,
    this._sessionId,
    this._bootstrapNonce,
    this._operations,
  ) {
    _observeOptionalError(_ready.future);
    _observeOptionalError(_rendered.future);
    _observeOptionalError(_closeReport.future);
  }

  final ViewTransport _transport;
  final String _sessionId;
  final String _bootstrapNonce;
  final Map<String, _HostViewOperation> _operations;
  final Completer<void> _ready = Completer<void>();
  final Completer<Object?> _rendered = Completer<Object?>();
  final Completer<ViewCloseReport> _closeReport = Completer<ViewCloseReport>();
  final Completer<ViewCloseReport> _closedLifecycle =
      Completer<ViewCloseReport>();
  final Set<String> _responseEligibleRequestIds = {};
  final Set<String> _seenRequestIds = {};
  var _inFlightOperationCount = 0;
  // The session cancels its owned subscription during every terminal path.
  // ignore: cancel_subscriptions
  StreamSubscription<Object?>? _subscription;
  String? _activeNonce;
  var _generation = 0;
  var _closed = false;
  Future<void>? _closeOperation;
  Future<void>? _terminationOperation;

  /// Completes after the versioned session/nonce handshake succeeds.
  Future<void> get ready => _ready.future;

  /// Completes with the first value the Flutter View reports as rendered.
  Future<Object?> get rendered => _rendered.future;

  /// Number of calls whose Host Dart operations have not completed.
  int get pendingRequestCount => _inFlightOperationCount;

  /// Number of protocol transport subscriptions owned by this session.
  int get subscriptionCount => _subscription == null ? 0 : 1;

  /// Completes after all Host protocol state and listeners are released.
  Future<ViewCloseReport> get closed => _closedLifecycle.future;

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
            'The Host receive stream failed.',
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
    late final Map<String, Object?> message;
    try {
      message = _parseFrame(value);
    } on ViewProtocolException {
      return;
    }
    switch (message['kind']) {
      case 'ready':
        _observeOptionalError(_acceptReady(message));
      case 'call':
        _observeOptionalError(_acceptCall(message));
      case 'rendered':
        _acceptRendered(message);
      case 'closing':
        _acceptClosing(message);
    }
  }

  void _acceptRendered(Map<String, Object?> message) {
    if (message['session'] != _sessionId ||
        message['nonce'] != _activeNonce ||
        _rendered.isCompleted) {
      return;
    }
    _rendered.complete(message['value']);
  }

  void _acceptClosing(Map<String, Object?> message) {
    if (message['session'] != _sessionId || message['nonce'] != _activeNonce) {
      return;
    }
    if (!_closeReport.isCompleted) {
      _closeReport.complete(_closeReportFromFrame(message));
    }
    _observeOptionalError(_terminate());
  }

  Future<void> _acceptReady(Map<String, Object?> message) async {
    if (message['protocol'] != 'flutter-vscode.view' ||
        message['version'] != 1 ||
        message['session'] != _sessionId ||
        message['nonce'] != _bootstrapNonce) {
      return;
    }
    final previouslyAdvertisedNonce = _activeNonce;
    if (previouslyAdvertisedNonce != null) {
      _generation += 1;
      _responseEligibleRequestIds.clear();
      _seenRequestIds.clear();
    }
    final activeNonce = _createNonce();
    _activeNonce = activeNonce;
    try {
      await _transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'readyAck',
        'session': _sessionId,
        'nonce': _bootstrapNonce,
        'activeNonce': activeNonce,
      });
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

  Future<void> _acceptCall(Map<String, Object?> message) async {
    if (message['protocol'] != 'flutter-vscode.view' ||
        message['version'] != 1 ||
        message['session'] != _sessionId ||
        message['nonce'] != _activeNonce) {
      return;
    }
    final id = message['id']! as String;
    if (!_seenRequestIds.add(id)) {
      await _sendError(
        id,
        ViewProtocolException(
          ViewProtocolErrorCode.duplicateRequest,
          'A request ID may be used only once in a Flutter View session.',
        ),
      );
      return;
    }
    final operation = _operations[message['operation']];
    if (operation == null) {
      await _sendError(
        id,
        ViewProtocolException(
          ViewProtocolErrorCode.operationNotAllowed,
          'Host Dart does not allow the "${message['operation']}" operation.',
        ),
      );
      return;
    }
    final generation = _generation;
    _responseEligibleRequestIds.add(id);
    _inFlightOperationCount += 1;
    Object? result;
    ViewProtocolException? operationError;
    try {
      try {
        result = await operation(message['arguments']);
      } on ViewProtocolException catch (error) {
        operationError = error;
      } on Object catch (error) {
        operationError = ViewProtocolException(
          ViewProtocolErrorCode.operationFailed,
          'Host Dart operation "${message['operation']}" failed: $error',
        );
      }
    } finally {
      _inFlightOperationCount -= 1;
    }
    if (_closed ||
        generation != _generation ||
        !_responseEligibleRequestIds.remove(id)) {
      return;
    }
    if (operationError != null) {
      await _sendError(id, operationError);
      return;
    }
    if (!_isProtocolValue(result)) {
      await _sendError(
        id,
        ViewProtocolException(
          ViewProtocolErrorCode.operationFailed,
          'Host Dart operation "${message['operation']}" did not return '
          'a protocol-safe snapshot.',
        ),
      );
      return;
    }
    try {
      await _transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'result',
        'session': _sessionId,
        'nonce': _activeNonce,
        'id': id,
        'result': result,
      });
    } on Object {
      await _closeAfterDeliveryFailure();
    }
  }

  Future<void> _closeAfterDeliveryFailure() async {
    try {
      await close();
    } on Object {
      // close() always runs terminal cleanup, even when closing delivery fails.
    }
  }

  Future<void> _sendError(String id, ViewProtocolException error) async {
    try {
      await _transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'error',
        'session': _sessionId,
        'nonce': _activeNonce,
        'id': id,
        'error': {
          'code': error.code.wireName,
          'message': error.message,
          'details': error.details,
        },
      });
    } on Object {
      await _closeAfterDeliveryFailure();
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
    final report = ViewCloseReport(
      pendingRequestCount: pendingRequestCount,
      subscriptionCount:
          subscriptionCount + _transportReceivingSubscriptionCount(_transport),
    );
    Object? deliveryError;
    StackTrace? deliveryStackTrace;
    try {
      await _transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'closing',
        'session': _sessionId,
        'nonce': nonce,
        'report': {
          'pendingRequestCount': report.pendingRequestCount,
          'subscriptionCount': report.subscriptionCount,
        },
      });
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
      await _transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'shutdown',
        'session': _sessionId,
        'nonce': nonce,
      });
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

  Future<void> _terminate({ViewProtocolException? terminalError}) {
    final existing = _terminationOperation;
    if (existing != null) {
      return existing;
    }
    if (_closed) {
      return Future.value();
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
    _generation += 1;
    _responseEligibleRequestIds.clear();
    _seenRequestIds.clear();
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
    final transportLifecycle = switch (_transport) {
      final ViewTransportLifecycle lifecycle => lifecycle,
      _ => null,
    };
    try {
      await transportLifecycle?.closeReceiving();
    } on Object catch (error, stackTrace) {
      cancellationError ??= error;
      cancellationStackTrace ??= stackTrace;
    } finally {
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
      if (!_closedLifecycle.isCompleted) {
        _closedLifecycle.complete(
          ViewCloseReport(
            pendingRequestCount: pendingRequestCount,
            subscriptionCount: subscriptionCount +
                (transportLifecycle?.receivingSubscriptionCount ?? 0),
          ),
        );
      }
    }
    if (cancellationError != null) {
      Error.throwWithStackTrace(
        cancellationError,
        cancellationStackTrace!,
      );
    }
  }
}

/// The Flutter View side of one version-1 Host Dart session.
final class FlutterViewSession {
  FlutterViewSession._(
    this._transport,
    this._sessionId,
    this._bootstrapNonce,
  ) {
    _observeOptionalError(_connected.future);
  }

  /// Connects to Host Dart using a bootstrap session and nonce.
  static Future<FlutterViewSession> connect({
    required ViewTransport transport,
    required String sessionId,
    required String bootstrapNonce,
  }) async {
    _requireNonEmptyProtocolIdentifier(sessionId, 'sessionId');
    _requireNonEmptyProtocolIdentifier(bootstrapNonce, 'bootstrapNonce');
    final session = FlutterViewSession._(
      transport,
      sessionId,
      bootstrapNonce,
    ).._listen();
    try {
      await session._transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'ready',
        'session': sessionId,
        'nonce': bootstrapNonce,
      });
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

  final ViewTransport _transport;
  final String _sessionId;
  final String _bootstrapNonce;
  final Completer<void> _connected = Completer<void>();
  final Completer<ViewCloseReport> _closedReport = Completer<ViewCloseReport>();
  final Map<String, Completer<Object?>> _pendingRequests = {};
  // The session cancels its owned subscription during every terminal path.
  // ignore: cancel_subscriptions
  StreamSubscription<Object?>? _subscription;
  String? _activeNonce;
  var _nextRequestId = 0;
  var _closed = false;
  Future<void>? _closeOperation;
  Future<void>? _terminationOperation;

  /// Number of calls waiting for a Host Dart result.
  int get pendingRequestCount => _pendingRequests.length;

  /// Number of protocol transport subscriptions owned by this session.
  int get subscriptionCount => _subscription == null ? 0 : 1;

  /// Completes after all protocol state and listeners have been released.
  Future<ViewCloseReport> get closed => _closedReport.future;

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
            'The Flutter View receive stream failed.',
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
    late final Map<String, Object?> message;
    try {
      message = _parseFrame(value);
    } on ViewProtocolException catch (error) {
      _observeOptionalError(_rejectConnection(error));
      return;
    }
    if (message['session'] != _sessionId) {
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
    final expectedNonce =
        _connected.isCompleted ? _activeNonce : _bootstrapNonce;
    if (message['nonce'] != expectedNonce) {
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
    final kind = message['kind'];
    if (!_connected.isCompleted &&
        kind != 'readyAck' &&
        kind != 'shutdown' &&
        kind != 'closing') {
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
    switch (kind) {
      case 'readyAck':
        if (message['protocol'] == 'flutter-vscode.view' &&
            message['version'] == 1 &&
            message['session'] == _sessionId &&
            message['nonce'] == _bootstrapNonce) {
          _activeNonce = message['activeNonce']! as String;
          if (!_connected.isCompleted) {
            _connected.complete();
          }
        }
      case 'result':
        if (message['protocol'] == 'flutter-vscode.view' &&
            message['version'] == 1 &&
            message['session'] == _sessionId &&
            message['nonce'] == _activeNonce) {
          _pendingRequests.remove(message['id'])?.complete(message['result']);
        }
      case 'error':
        _pendingRequests
            .remove(message['id'])
            ?.completeError(_errorFromFrame(message));
      case 'shutdown':
        _observeOptionalError(_closeAndReport());
      case 'closing':
        _observeOptionalError(_terminate());
    }
  }

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
    _pendingRequests[id] = completer;
    try {
      await _transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'call',
        'session': _sessionId,
        'nonce': _activeNonce,
        'id': id,
        'operation': operation,
        'arguments': arguments,
      });
    } on Object catch (error, stackTrace) {
      _pendingRequests.remove(id);
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
      await _transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'rendered',
        'session': _sessionId,
        'nonce': _activeNonce,
        'value': value,
      });
    } on Object catch (error, stackTrace) {
      try {
        await _terminate();
      } on Object {
        // Preserve the first failure: render delivery was rejected.
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Closes this session and releases all pending protocol state.
  Future<void> close() => _closeAndReport();

  Future<void> _closeAndReport() {
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
      _runCloseAndReport().then(
        (_) => completion.complete(),
        onError: completion.completeError,
      ),
    );
    return completion.future;
  }

  Future<void> _runCloseAndReport() async {
    _closed = true;
    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(
          ViewProtocolException(
            ViewProtocolErrorCode.sessionClosed,
            'The Flutter View session closed before the call completed.',
          ),
        );
      }
    }
    _pendingRequests.clear();
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
    final transportLifecycle = switch (_transport) {
      final ViewTransportLifecycle lifecycle => lifecycle,
      _ => null,
    };
    try {
      await transportLifecycle?.closeReceiving();
    } on Object catch (error, stackTrace) {
      cancellationError ??= error;
      cancellationStackTrace ??= stackTrace;
    }
    final report = ViewCloseReport(
      pendingRequestCount: pendingRequestCount,
      subscriptionCount: subscriptionCount +
          (transportLifecycle?.receivingSubscriptionCount ?? 0),
    );
    try {
      await _transport.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'closing',
        'session': _sessionId,
        'nonce': _activeNonce ?? _bootstrapNonce,
        'report': {
          'pendingRequestCount': report.pendingRequestCount,
          'subscriptionCount': report.subscriptionCount,
        },
      });
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
    for (final completer in _pendingRequests.values) {
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
    _pendingRequests.clear();
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
    final transportLifecycle = switch (_transport) {
      final ViewTransportLifecycle lifecycle => lifecycle,
      _ => null,
    };
    try {
      await transportLifecycle?.closeReceiving();
    } on Object catch (error, stackTrace) {
      cancellationError ??= error;
      cancellationStackTrace ??= stackTrace;
    } finally {
      _failConnectIfPending(terminalError);
      _completeClosed(
        ViewCloseReport(
          pendingRequestCount: pendingRequestCount,
          subscriptionCount: subscriptionCount +
              (transportLifecycle?.receivingSubscriptionCount ?? 0),
        ),
      );
    }
    if (cancellationError != null) {
      Error.throwWithStackTrace(
        cancellationError,
        cancellationStackTrace!,
      );
    }
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
    if (!_closedReport.isCompleted) {
      _closedReport.complete(report);
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

Map<String, Object?> _parseFrame(Object? value) {
  if (value is! Map<Object?, Object?> ||
      value.keys.any((key) => key is! String)) {
    throw _invalidMessage('The protocol frame must be a string-keyed map.');
  }
  final message = value.cast<String, Object?>();
  if (message['protocol'] != 'flutter-vscode.view') {
    throw _invalidMessage('The protocol marker is missing or invalid.');
  }
  final version = message['version'];
  if (version is! int) {
    throw _invalidMessage('The protocol version must be an integer.');
  }
  if (version != 1) {
    throw ViewProtocolException(
      ViewProtocolErrorCode.unsupportedVersion,
      'The peer selected an unsupported Flutter View protocol version.',
    );
  }
  final kind = message['kind'];
  if (kind is! String) {
    throw _invalidMessage('The protocol frame kind must be a string.');
  }
  final expectedKeys = switch (kind) {
    'ready' => const {'protocol', 'version', 'kind', 'session', 'nonce'},
    'readyAck' => const {
        'protocol',
        'version',
        'kind',
        'session',
        'nonce',
        'activeNonce',
      },
    'call' => const {
        'protocol',
        'version',
        'kind',
        'session',
        'nonce',
        'id',
        'operation',
        'arguments',
      },
    'result' => const {
        'protocol',
        'version',
        'kind',
        'session',
        'nonce',
        'id',
        'result',
      },
    'rendered' => const {
        'protocol',
        'version',
        'kind',
        'session',
        'nonce',
        'value',
      },
    'error' => const {
        'protocol',
        'version',
        'kind',
        'session',
        'nonce',
        'id',
        'error',
      },
    'shutdown' => const {'protocol', 'version', 'kind', 'session', 'nonce'},
    'closing' => const {
        'protocol',
        'version',
        'kind',
        'session',
        'nonce',
        'report',
      },
    _ => throw _invalidMessage('The protocol frame kind "$kind" is unknown.'),
  };
  if (message.keys.toSet().difference(expectedKeys).isNotEmpty ||
      expectedKeys.difference(message.keys.toSet()).isNotEmpty) {
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
  switch (kind) {
    case 'readyAck':
      if (!_isNonEmptyString(message['activeNonce'])) {
        throw _invalidMessage('The active nonce must be a non-empty string.');
      }
    case 'call':
      if (!_isNonEmptyString(message['id']) ||
          !_isNonEmptyString(message['operation']) ||
          !_isProtocolValue(message['arguments'])) {
        throw _invalidMessage('The call frame contains invalid fields.');
      }
    case 'result':
      if (!_isNonEmptyString(message['id']) ||
          !_isProtocolValue(message['result'])) {
        throw _invalidMessage('The result frame contains invalid fields.');
      }
    case 'rendered':
      if (!_isProtocolValue(message['value'])) {
        throw _invalidMessage('The rendered frame value is invalid.');
      }
    case 'error':
      if (!_isNonEmptyString(message['id'])) {
        throw _invalidMessage('The error frame request ID is invalid.');
      }
      _errorFromFrame(message);
    case 'closing':
      _closeReportFromFrame(message);
  }
  return message;
}

bool _isNonEmptyString(Object? value) => value is String && value.isNotEmpty;

void _requireNonEmptyProtocolIdentifier(String value, String name) {
  if (value.isEmpty) {
    throw ViewProtocolException(
      ViewProtocolErrorCode.invalidMessage,
      '$name must be a non-empty protocol identifier.',
    );
  }
}

int _transportReceivingSubscriptionCount(ViewTransport transport) {
  return switch (transport) {
    final ViewTransportLifecycle lifecycle =>
      lifecycle.receivingSubscriptionCount,
    _ => 0,
  };
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

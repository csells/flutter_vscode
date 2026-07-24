import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vscode/view.dart';

void main() {
  group('Host and Flutter View protocol', () {
    test('rejects an empty structured error message at construction', () {
      expect(
        () => ViewProtocolException(
          ViewProtocolErrorCode.operationFailed,
          '',
        ),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.invalidMessage,
          ),
        ),
      );
    });

    test('rejects unsafe structured error details at construction', () {
      expect(
        () => ViewProtocolException(
          ViewProtocolErrorCode.operationFailed,
          'The operation failed.',
          details: DateTime.utc(2026),
        ),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.invalidMessage,
          ),
        ),
      );
    });

    test('structured error details remain a protocol-safe snapshot', () {
      final mutableDetails = <Object?>['safe'];
      final error = ViewProtocolException(
        ViewProtocolErrorCode.operationFailed,
        'The operation failed.',
        details: mutableDetails,
      );

      mutableDetails.add(DateTime.utc(2026));

      expect(error.details, ['safe']);
    });

    test('in-memory transport snapshots outbound protocol frames', () async {
      final transport = InMemoryViewTransportPair();
      final received = <Map<String, Object?>>[];
      final subscription = transport.host.messages.listen((message) {
        received.add(
          (message! as Map<Object?, Object?>).cast<String, Object?>(),
        );
      });
      addTearDown(subscription.cancel);
      final arguments = <String, Object?>{'value': 'before'};
      final result = <String, Object?>{'value': 'before'};
      final errorDetails = <String, Object?>{'value': 'before'};
      final rendered = <String, Object?>{'value': 'before'};
      final call = <String, Object?>{
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'call',
        'session': 'session-1',
        'nonce': 'active-1',
        'id': 'request-1',
        'operation': 'fixture.echo',
        'arguments': arguments,
      };

      await transport.view.send(call);
      await transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'result',
        'session': 'session-1',
        'nonce': 'active-1',
        'id': 'request-1',
        'result': result,
      });
      await transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'error',
        'session': 'session-1',
        'nonce': 'active-1',
        'id': 'request-2',
        'error': {
          'code': ViewProtocolErrorCode.operationFailed.wireName,
          'message': 'The operation failed.',
          'details': errorDetails,
        },
      });
      await transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'rendered',
        'session': 'session-1',
        'nonce': 'active-1',
        'value': rendered,
      });

      call['operation'] = 'mutated';
      arguments['value'] = 'after';
      result['value'] = 'after';
      errorDetails['value'] = 'after';
      rendered['value'] = 'after';

      expect(received, hasLength(4));
      expect(received[0]['operation'], 'fixture.echo');
      expect(received[0]['arguments'], {'value': 'before'});
      expect(received[1]['result'], {'value': 'before'});
      expect(
        (received[2]['error']! as Map<Object?, Object?>)['details'],
        {'value': 'before'},
      );
      expect(received[3]['value'], {'value': 'before'});
    });

    test('calls an allowlisted Host operation through a typed contract',
        () async {
      final operation = ViewOperation<String, String>(
        name: 'fixture.readHostValue',
        encodeArguments: (key) => {'key': key},
        decodeArguments: (value) {
          if (value case {'key': final String key} when value.length == 1) {
            return key;
          }
          throw const FormatException('Expected exactly one string key.');
        },
        encodeResult: (value) => value,
        decodeResult: (value) {
          if (value is String) {
            return value;
          }
          throw const FormatException('Expected a string result.');
        },
      );
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [
          operation.bind(
            (key) => key == 'greeting' ? 'hello from Host Dart' : 'unknown',
          ),
        ],
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final result = await operation.call(view, 'greeting');

      expect(result, 'hello from Host Dart');
      await view.close();
      await host.closed;
      expect(host.subscriptionCount, 0);
    });

    test('rejects duplicate typed Host operation bindings', () {
      final operation = _snapshotOperation('fixture.readHostValue');
      final transport = InMemoryViewTransportPair();

      expect(
        () => HostViewSession.connect(
          transport: transport.host,
          sessionId: 'session-1',
          bootstrapNonce: 'bootstrap-1',
          operations: [
            operation.bind((value) => value),
            operation.bind((value) => value),
          ],
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('fixture.readHostValue'),
          ),
        ),
      );
    });

    test('rejects an empty Host operation name before binding', () {
      final operation = _snapshotOperation('');

      expect(
        () => operation.bind((value) => value),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.invalidMessage,
          ),
        ),
      );
    });

    test('Host rejects empty session identifiers before listening', () async {
      final sessions = <HostViewSession>[];
      addTearDown(() async {
        for (final session in sessions) {
          await session.close();
        }
      });

      for (final identifiers in const [
        (sessionId: '', bootstrapNonce: 'bootstrap-1'),
        (sessionId: 'session-1', bootstrapNonce: ''),
      ]) {
        expect(
          () => sessions.add(
            HostViewSession.connect(
              transport: InMemoryViewTransportPair().host,
              sessionId: identifiers.sessionId,
              bootstrapNonce: identifiers.bootstrapNonce,
            ),
          ),
          throwsA(
            isA<ViewProtocolException>().having(
              (error) => error.code,
              'code',
              ViewProtocolErrorCode.invalidMessage,
            ),
          ),
        );
      }

      expect(sessions, isEmpty);
    });

    test('Flutter View rejects empty session identifiers before sending',
        () async {
      for (final identifiers in const [
        (sessionId: '', bootstrapNonce: 'bootstrap-1'),
        (sessionId: 'session-1', bootstrapNonce: ''),
      ]) {
        final transport = _ControllableViewTransport();
        addTearDown(transport.closeMessages);

        await expectLater(
          FlutterViewSession.connect(
            transport: transport,
            sessionId: identifiers.sessionId,
            bootstrapNonce: identifiers.bootstrapNonce,
          ).timeout(const Duration(milliseconds: 100)),
          throwsA(
            isA<ViewProtocolException>().having(
              (error) => error.code,
              'code',
              ViewProtocolErrorCode.invalidMessage,
            ),
          ),
        );
        expect(transport.sent, isEmpty);
      }
    });

    test('connects and completes an allowlisted call', () async {
      final operation = _snapshotOperation('fixture.readHostValue');
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [
          operation.bind((arguments) async {
            expect(arguments, {'key': 'greeting'});
            return 'hello from Host Dart';
          }),
        ],
      );

      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await host.ready;
      expect(
        await operation.call(view, {'key': 'greeting'}),
        'hello from Host Dart',
      );

      await view.close();
      await host.closed;
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('rejects an empty operation name before sending a call', () async {
      final operation = _snapshotOperation('');
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      addTearDown(() async {
        await view.close();
        await host.closed;
      });

      await expectLater(
        operation.call(view, null).timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.invalidMessage,
          ),
        ),
      );

      expect(view.pendingRequestCount, 0);
      expect(host.pendingRequestCount, 0);
    });

    test('rejects a peer that speaks an unsupported version', () async {
      final transport = InMemoryViewTransportPair();
      final peer = transport.host.messages.listen((message) {
        final ready =
            (message! as Map<Object?, Object?>).cast<String, Object?>();
        unawaited(
          transport.host.send({
            'protocol': 'flutter-vscode.view',
            'version': 3,
            'kind': 'readyAck',
            'session': ready['session'],
            'nonce': ready['nonce'],
            'activeNonce': 'active-1',
          }),
        );
      });

      await expectLater(
        FlutterViewSession.connect(
          transport: transport.view,
          sessionId: 'session-1',
          bootstrapNonce: 'bootstrap-1',
        ),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.unsupportedVersion,
          ),
        ),
      );
      await peer.cancel();
    });

    test('rejects a message with fields outside its exact schema', () async {
      final transport = InMemoryViewTransportPair();
      final peer = transport.host.messages.listen((message) {
        final ready =
            (message! as Map<Object?, Object?>).cast<String, Object?>();
        unawaited(
          transport.host.send({
            'protocol': 'flutter-vscode.view',
            'version': 2,
            'kind': 'readyAck',
            'session': ready['session'],
            'nonce': ready['nonce'],
            'activeNonce': 'active-1',
            'unexpected': true,
          }),
        );
      });

      await expectLater(
        FlutterViewSession.connect(
          transport: transport.view,
          sessionId: 'session-1',
          bootstrapNonce: 'bootstrap-1',
        ),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.invalidMessage,
          ),
        ),
      );
      await peer.cancel();
    });

    test('rejects a handshake for another session', () async {
      final transport = InMemoryViewTransportPair();
      final peer = transport.host.messages.listen((message) {
        final ready =
            (message! as Map<Object?, Object?>).cast<String, Object?>();
        unawaited(
          transport.host.send({
            'protocol': 'flutter-vscode.view',
            'version': 2,
            'kind': 'readyAck',
            'session': 'another-session',
            'nonce': ready['nonce'],
            'activeNonce': 'active-1',
          }),
        );
      });

      await expectLater(
        FlutterViewSession.connect(
          transport: transport.view,
          sessionId: 'session-1',
          bootstrapNonce: 'bootstrap-1',
        ).timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionMismatch,
          ),
        ),
      );
      await peer.cancel();
    });

    test('rejects a handshake with the wrong nonce', () async {
      final transport = InMemoryViewTransportPair();
      final peer = transport.host.messages.listen((message) {
        final ready =
            (message! as Map<Object?, Object?>).cast<String, Object?>();
        unawaited(
          transport.host.send({
            'protocol': 'flutter-vscode.view',
            'version': 2,
            'kind': 'readyAck',
            'session': ready['session'],
            'nonce': 'wrong-bootstrap',
            'activeNonce': 'active-1',
          }),
        );
      });

      await expectLater(
        FlutterViewSession.connect(
          transport: transport.view,
          sessionId: 'session-1',
          bootstrapNonce: 'bootstrap-1',
        ).timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.nonceMismatch,
          ),
        ),
      );
      await peer.cancel();
    });

    test('rejects a result frame before the ready acknowledgement', () async {
      final transport = InMemoryViewTransportPair();
      final peer = transport.host.messages.listen((message) {
        final ready =
            (message! as Map<Object?, Object?>).cast<String, Object?>();
        unawaited(
          transport.host.send({
            'protocol': 'flutter-vscode.view',
            'version': 2,
            'kind': 'result',
            'session': ready['session'],
            'nonce': ready['nonce'],
            'id': 'request-1',
            'result': 'too early',
          }),
        );
      });

      await expectLater(
        FlutterViewSession.connect(
          transport: transport.view,
          sessionId: 'session-1',
          bootstrapNonce: 'bootstrap-1',
        ).timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.invalidMessage,
          ),
        ),
      );
      await peer.cancel();
    });

    test('Host ready acknowledgement send failure closes without escaping',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _KindFailingViewTransport(pair.host, 'readyAck');
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await expectLater(
        FlutterViewSession.connect(
          transport: pair.view,
          sessionId: 'session-1',
          bootstrapNonce: 'bootstrap-1',
        ),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await host.closed.timeout(const Duration(milliseconds: 100));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('async Host ready acknowledgement failure settles both sessions',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DeferredFailingViewTransport(pair.host, 'readyAck');
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final connection = FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final hostReady = expectLater(
        host.ready.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );
      final viewConnection = expectLater(
        connection.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await transport.deliveryStarted;
      transport.fail(StateError('native ready acknowledgement rejected'));

      await hostReady;
      await viewConnection;
      await host.closed.timeout(const Duration(milliseconds: 100));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('rejects a call outside the Host Dart operation allowlist', () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final operation = _snapshotOperation('fixture.notAllowed');
      await expectLater(
        operation.call(view, null).timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.operationNotAllowed,
          ),
        ),
      );

      await view.close();
      expect(host.pendingRequestCount, 0);
    });

    test('rejects a duplicate request ID without invoking Host Dart twice',
        () async {
      final operation = _snapshotOperation('fixture.readHostValue');
      final operationResult = Completer<Object?>();
      var invocationCount = 0;
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [
          operation.bind((_) {
            invocationCount += 1;
            return operationResult.future;
          }),
        ],
      );
      final responses = StreamIterator<Object?>(transport.view.messages);

      final readyResponse = responses.moveNext();
      await transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      });
      expect(await readyResponse, isTrue);
      final readyAck =
          (responses.current! as Map<Object?, Object?>).cast<String, Object?>();
      final call = {
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'call',
        'session': 'session-1',
        'nonce': readyAck['activeNonce'],
        'id': 'request-1',
        'operation': 'fixture.readHostValue',
        'arguments': null,
      };

      await transport.view.send(call);
      await transport.view.send(call);

      expect(
        await responses.moveNext().timeout(const Duration(milliseconds: 100)),
        isTrue,
      );
      final error =
          (responses.current! as Map<Object?, Object?>).cast<String, Object?>();
      final structuredError =
          (error['error']! as Map<Object?, Object?>).cast<String, Object?>();
      expect(error['kind'], 'error');
      expect(
        structuredError['code'],
        ViewProtocolErrorCode.duplicateRequest.wireName,
      );
      expect(invocationCount, 1);
      expect(host.pendingRequestCount, 1);

      operationResult.complete('value');
      expect(await responses.moveNext(), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(host.pendingRequestCount, 0);
      await responses.cancel();
      await host.close();
    });

    test('returns a structured error when a Host Dart operation fails',
        () async {
      final operation = _snapshotOperation('fixture.fail');
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [
          operation.bind((_) => throw StateError('database offline')),
        ],
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await expectLater(
        operation.call(view, null).timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>()
              .having(
                (error) => error.code,
                'code',
                ViewProtocolErrorCode.operationFailed,
              )
              .having(
                (error) => error.message,
                'message',
                contains('database offline'),
              ),
        ),
      );
      expect(view.pendingRequestCount, 0);
      expect(host.pendingRequestCount, 0);
      await view.close();
    });

    test('Host result send failure closes both sessions without a zone error',
        () async {
      final operation = _snapshotOperation('fixture.echo');
      final pair = InMemoryViewTransportPair();
      final transport = _KindFailingViewTransport(pair.host, 'result');
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [operation.bind((value) => value)],
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await expectLater(
        operation
            .call(view, 'value')
            .timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await host.closed.timeout(const Duration(milliseconds: 100));
      await view.closed.timeout(const Duration(milliseconds: 100));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
    });

    test('async Host result delivery failure settles the call and sessions',
        () async {
      final operation = _snapshotOperation('fixture.echo');
      final pair = InMemoryViewTransportPair();
      final transport = _DeferredFailingViewTransport(pair.host, 'result');
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [operation.bind((value) => value)],
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final call = operation.call(view, 'value');
      await transport.deliveryStarted;
      transport.fail(StateError('native result delivery rejected'));

      await expectLater(
        call.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );
      await host.closed.timeout(const Duration(milliseconds: 100));
      await view.closed.timeout(const Duration(milliseconds: 100));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
    });

    test('Host error send failure closes both sessions without a zone error',
        () async {
      final operation = _snapshotOperation('fixture.fail');
      final pair = InMemoryViewTransportPair();
      final transport = _KindFailingViewTransport(pair.host, 'error');
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [
          operation.bind((_) => throw StateError('operation failed')),
        ],
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await expectLater(
        operation.call(view, null).timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await host.closed.timeout(const Duration(milliseconds: 100));
      await view.closed.timeout(const Duration(milliseconds: 100));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
    });

    test('host close fails pending calls and releases both session listeners',
        () async {
      final operation = _snapshotOperation('fixture.wait');
      final operationResult = Completer<Object?>();
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [operation.bind((_) => operationResult.future)],
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final pendingCall = operation.call(view, null);
      expect(view.pendingRequestCount, 1);
      expect(host.pendingRequestCount, 1);

      final pendingFailure = expectLater(
        pendingCall,
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );
      await host.close();
      await pendingFailure;
      await view.closed.timeout(const Duration(milliseconds: 100));
      final hostCloseReport = await host.closed;
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
      expect(host.pendingRequestCount, 1);
      expect(host.subscriptionCount, 0);
      expect(hostCloseReport.pendingRequestCount, 1);

      operationResult.complete('late value');
      await Future<void>.delayed(Duration.zero);
      expect(view.pendingRequestCount, 0);
      expect(host.pendingRequestCount, 0);
    });

    test('a reload rotates the nonce and abandons late Host Dart results',
        () async {
      final operation = _snapshotOperation('fixture.wait');
      final operationResult = Completer<Object?>();
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [operation.bind((_) => operationResult.future)],
      );
      final received = <Map<String, Object?>>[];
      final peer = transport.view.messages.listen((message) {
        received.add(
          (message! as Map<Object?, Object?>).cast<String, Object?>(),
        );
      });
      const ready = {
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      };

      await transport.view.send(ready);
      final firstNonce = received.single['activeNonce'];
      await transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'call',
        'session': 'session-1',
        'nonce': firstNonce,
        'id': 'request-1',
        'operation': 'fixture.wait',
        'arguments': null,
      });
      expect(host.pendingRequestCount, 1);

      await transport.view.send(ready);

      expect(received, hasLength(2));
      expect(received.last['kind'], 'readyAck');
      expect(received.last['activeNonce'], isNot(firstNonce));
      expect(host.pendingRequestCount, 1);
      expect(host.subscriptionCount, 1);

      operationResult.complete('late value');
      await Future<void>.delayed(Duration.zero);
      expect(received.where((message) => message['kind'] == 'result'), isEmpty);
      expect(host.pendingRequestCount, 0);

      await host.close();
      await peer.cancel();
    });

    test('Host installs the active nonce before a synchronous ready ack',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _ReadyAckObservingViewTransport(pair.host);
      late HostViewSession host;
      late Future<ViewCloseReport> shutdown;
      host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await pair.view.send(const {
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      });
      await host.ready;
      transport.onReadyAck = () {
        shutdown = host.shutdown();
        unawaited(
          shutdown.then<void>(
            (_) {},
            onError: (Object error, StackTrace stackTrace) {},
          ),
        );
      };
      await pair.view.send(const {
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      });

      expect(transport.sentKinds, ['readyAck', 'readyAck', 'shutdown']);
      final readyAck =
          (transport.sent[1]! as Map<Object?, Object?>).cast<String, Object?>();
      final shutdownFrame =
          (transport.sent[2]! as Map<Object?, Object?>).cast<String, Object?>();
      expect(
        shutdownFrame['nonce'],
        readyAck['activeNonce'],
        reason: 'a shutdown emitted synchronously during ready-ack delivery '
            'must already carry the newly installed nonce',
      );
      await pair.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'closing',
        'session': 'session-1',
        'nonce': readyAck['activeNonce'],
        'report': const {
          'pendingRequestCount': 0,
          'subscriptionCount': 0,
        },
      });
      final report = await shutdown.timeout(const Duration(milliseconds: 100));
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
      await host.closed;
    });

    test('reports the rendered Flutter value through a typed future', () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await view.reportRendered({'text': 'hello from Flutter'});

      expect(
        await host.rendered,
        {'text': 'hello from Flutter'},
      );
      await view.close();
    });

    test('render report delivery failure terminates the Flutter View',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _SwitchableViewTransport(pair.view);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      addTearDown(host.close);
      transport.failSends = true;

      await expectLater(view.reportRendered('hello'), throwsStateError);

      final report = await view.closed.timeout(
        const Duration(milliseconds: 100),
      );
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
    });

    test('async render delivery failure terminates the Flutter View', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DeferredFailingViewTransport(pair.view, 'rendered');
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      addTearDown(host.close);

      final render = Future<void>.sync(() => view.reportRendered('hello'));
      await transport.deliveryStarted;
      transport.fail(StateError('native rendered delivery rejected'));

      await expectLater(render, throwsStateError);
      final report = await view.closed.timeout(
        const Duration(milliseconds: 100),
      );
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
    });

    test('host shutdown observes the Flutter View zero-count close report',
        () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final viewClosed = view.closed;
      final hostClosed = host.closed;
      final report =
          await host.shutdown().timeout(const Duration(milliseconds: 100));
      final viewReport = await viewClosed;
      final hostReport = await hostClosed;

      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
      expect(viewReport.pendingRequestCount, 0);
      expect(viewReport.subscriptionCount, 0);
      expect(hostReport.pendingRequestCount, 0);
      expect(hostReport.subscriptionCount, 0);
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
    });

    test('shutdown after peer close preserves its measured report', () async {
      final transport = InMemoryViewTransportPair();
      late String activeNonce;
      final peer = transport.view.messages.listen((rawMessage) {
        final message =
            (rawMessage! as Map<Object?, Object?>).cast<String, Object?>();
        if (message['kind'] == 'readyAck') {
          activeNonce = message['activeNonce']! as String;
        }
      });
      addTearDown(peer.cancel);
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      await transport.view.send(const {
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      });
      await host.ready;
      await transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'closing',
        'session': 'session-1',
        'nonce': activeNonce,
        'report': const {
          'pendingRequestCount': 3,
          'subscriptionCount': 2,
        },
      });
      await host.closed;

      final report = await host.shutdown();

      expect(report.pendingRequestCount, 3);
      expect(report.subscriptionCount, 2);
    });

    test('Flutter View reports counts after its listener actually cancels',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DelayedCancelViewTransport(pair.view);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final shutdown = host.shutdown();
      await transport.cancellationStarted;

      expect(transport.sentClosing, isFalse);
      expect(view.subscriptionCount, 1);

      transport.allowCancellation();
      final report = await shutdown.timeout(const Duration(milliseconds: 100));

      expect(transport.sentClosingAfterCancellation, isTrue);
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
      expect(view.subscriptionCount, 0);
    });

    test('concurrent Flutter View closes join the same cleanup', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DelayedCancelViewTransport(pair.view);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final firstClose = view.close();
      await transport.cancellationStarted;
      var secondCloseCompleted = false;
      final secondClose = view.close().then((_) {
        secondCloseCompleted = true;
      });
      await Future<void>.delayed(Duration.zero);

      expect(secondCloseCompleted, isFalse);

      transport.allowCancellation();
      await Future.wait([firstClose, secondClose]);
      await host.closed;
      expect(secondCloseCompleted, isTrue);
      expect(view.subscriptionCount, 0);
    });

    test('Flutter View close joins peer-triggered cleanup in progress',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DelayedCancelViewTransport(pair.view);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final hostClose = host.close();
      await transport.cancellationStarted;
      var viewCloseCompleted = false;
      final viewClose = view.close().then((_) {
        viewCloseCompleted = true;
      });
      await Future<void>.delayed(Duration.zero);

      expect(viewCloseCompleted, isFalse);

      transport.allowCancellation();
      await Future.wait([hostClose, viewClose]);
      expect(viewCloseCompleted, isTrue);
      expect(view.subscriptionCount, 0);
    });

    test('Flutter View closes native receiving before reporting counts',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _ReceivingLifecycleViewTransport(pair.view);
      addTearDown(transport.closeReceiving);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final report =
          await host.shutdown().timeout(const Duration(milliseconds: 100));

      expect(transport.sentClosingAfterReceivingClose, isTrue);
      expect(transport.receivingSubscriptionCount, 0);
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
    });

    test('rejects call arguments that are not protocol-safe snapshots',
        () async {
      final operation = _snapshotOperation('fixture.echo');
      var invocationCount = 0;
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [
          operation.bind((value) {
            invocationCount += 1;
            return value;
          }),
        ],
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await expectLater(
        operation
            .call(view, DateTime.utc(2026))
            .timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.invalidMessage,
          ),
        ),
      );
      expect(invocationCount, 0);
      expect(view.pendingRequestCount, 0);
      expect(host.pendingRequestCount, 0);
      await view.close();
    });

    test('returns a structured failure for a non-snapshot Host Dart result',
        () async {
      final operation = _snapshotOperation('fixture.invalidResult');
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [operation.bind((_) => DateTime.utc(2026))],
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await expectLater(
        operation.call(view, null),
        throwsA(
          isA<ViewProtocolException>()
              .having(
                (error) => error.code,
                'code',
                ViewProtocolErrorCode.operationFailed,
              )
              .having(
                (error) => error.message,
                'message',
                contains('protocol-safe snapshot'),
              ),
        ),
      );
      expect(view.pendingRequestCount, 0);
      expect(host.pendingRequestCount, 0);
      await view.close();
    });

    test('ignores a late result for an already completed request', () async {
      final operation = _snapshotOperation('fixture.read');
      final transport = InMemoryViewTransportPair();
      final peer = transport.host.messages.listen((rawMessage) {
        final message =
            (rawMessage! as Map<Object?, Object?>).cast<String, Object?>();
        switch (message['kind']) {
          case 'ready':
            unawaited(
              transport.host.send({
                'protocol': 'flutter-vscode.view',
                'version': 2,
                'kind': 'readyAck',
                'session': message['session'],
                'nonce': message['nonce'],
                'activeNonce': 'active-1',
              }),
            );
          case 'call':
            final result = {
              'protocol': 'flutter-vscode.view',
              'version': 2,
              'kind': 'result',
              'session': message['session'],
              'nonce': message['nonce'],
              'id': message['id'],
              'result': 'first value',
            };
            unawaited(transport.host.send(result));
            unawaited(
              transport.host.send({...result, 'result': 'late value'}),
            );
        }
      });
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      expect(await operation.call(view, null), 'first value');
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 1);

      await view.close();
      await peer.cancel();
    });

    test('host close before ready fails the pending ready future', () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final readyFailure = expectLater(
        host.ready.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await host.close();

      await readyFailure;
      expect(host.subscriptionCount, 0);
    });

    test('Host receive completion terminates every pending lifecycle',
        () async {
      final transport = _ControllableViewTransport();
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final readyFailure = expectLater(
        host.ready.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );
      final renderedFailure = expectLater(
        host.rendered.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await transport.closeMessages();

      await readyFailure;
      await renderedFailure;
      final report = await host.closed.timeout(
        const Duration(milliseconds: 100),
      );
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
      await expectLater(
        host.shutdown(),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );
    });

    test('Host receive error is preserved as the shutdown failure', () async {
      final transport = _ControllableViewTransport();
      addTearDown(transport.closeMessages);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      transport.addReceiveError(StateError('transport receive failed'));

      await host.closed.timeout(const Duration(milliseconds: 100));
      await expectLater(
        host.shutdown(),
        throwsA(
          isA<ViewProtocolException>()
              .having(
                (error) => error.code,
                'code',
                ViewProtocolErrorCode.sessionClosed,
              )
              .having(
                (error) => error.message,
                'message',
                contains('Host receive stream failed'),
              )
              .having(
                (error) => error.details,
                'details',
                contains('transport receive failed'),
              ),
        ),
      );
    });

    test('Host reports counts after its listener actually cancels', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DelayedCancelViewTransport(pair.host);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final close = host.close();
      await transport.cancellationStarted;

      expect(transport.sentClosing, isFalse);
      expect(host.subscriptionCount, 1);

      transport.allowCancellation();
      await close.timeout(const Duration(milliseconds: 100));

      expect(transport.sentClosingAfterCancellation, isTrue);
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('concurrent Host closes join the same cleanup', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DelayedCancelViewTransport(pair.host);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      final firstClose = host.close();
      await transport.cancellationStarted;
      var secondCloseCompleted = false;
      final secondClose = host.close().then((_) {
        secondCloseCompleted = true;
      });
      await Future<void>.delayed(Duration.zero);

      expect(secondCloseCompleted, isFalse);

      transport.allowCancellation();
      await Future.wait([firstClose, secondClose]);
      expect(secondCloseCompleted, isTrue);
      expect(host.subscriptionCount, 0);
    });

    test('Host close joins peer-triggered cleanup already in progress',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DelayedCancelViewTransport(pair.host);
      late String activeNonce;
      final peer = pair.view.messages.listen((rawMessage) {
        final message =
            (rawMessage! as Map<Object?, Object?>).cast<String, Object?>();
        if (message['kind'] == 'readyAck') {
          activeNonce = message['activeNonce']! as String;
        }
      });
      addTearDown(peer.cancel);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      await pair.view.send(const {
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      });
      await host.ready;
      await pair.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'closing',
        'session': 'session-1',
        'nonce': activeNonce,
        'report': const {
          'pendingRequestCount': 0,
          'subscriptionCount': 0,
        },
      });
      await transport.cancellationStarted;
      var closeCompleted = false;
      final close = host.close().then((_) {
        closeCompleted = true;
      });
      await Future<void>.delayed(Duration.zero);

      expect(closeCompleted, isFalse);

      transport.allowCancellation();
      await close;
      expect(closeCompleted, isTrue);
      expect(host.subscriptionCount, 0);
    });

    test('Host closes native receiving before reporting counts', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _ReceivingLifecycleViewTransport(pair.host);
      addTearDown(transport.closeReceiving);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await host.close();
      final report = await view.closed.timeout(
        const Duration(milliseconds: 100),
      );

      expect(transport.sentClosingAfterReceivingClose, isTrue);
      expect(transport.receivingSubscriptionCount, 0);
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
    });

    test('Flutter peer termination reports after its listener cancels',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DelayedCancelViewTransport(pair.view);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      await view.reportRendered(null);
      await host.rendered;

      final close = host.close();
      await transport.cancellationStarted;

      expect(view.subscriptionCount, 1);

      transport.allowCancellation();
      await close.timeout(const Duration(milliseconds: 100));
      final report = await view.closed.timeout(
        const Duration(milliseconds: 100),
      );

      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
      expect(view.subscriptionCount, 0);
    });

    test('Flutter peer termination closes native receiving', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _ReceivingLifecycleViewTransport(pair.view);
      addTearDown(transport.closeReceiving);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await host.close();
      final report = await view.closed.timeout(
        const Duration(milliseconds: 100),
      );

      expect(transport.receivingSubscriptionCount, 0);
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
    });

    test('view close before rendering fails the host rendered future',
        () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final renderedFailure = expectLater(
        host.rendered.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await view.close();

      await renderedFailure;
      expect(host.subscriptionCount, 0);
    });

    test('host close interrupts a pending orderly shutdown report', () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final peer = transport.view.messages.listen((_) {});
      await transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      });
      await host.ready;
      final shutdownFailure = expectLater(
        host.shutdown().timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await host.close();

      await shutdownFailure;
      expect(host.subscriptionCount, 0);
      await peer.cancel();
    });

    test('peer close during handshake fails Flutter View connect', () async {
      final transport = InMemoryViewTransportPair();
      final connection = FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final connectionFailure = expectLater(
        connection.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await transport.host.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'closing',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
        'report': const {
          'pendingRequestCount': 0,
          'subscriptionCount': 0,
        },
      });

      await connectionFailure;
    });

    test('peer shutdown during handshake settles Flutter View connect',
        () async {
      final transport = InMemoryViewTransportPair();
      final closingFrame = Completer<Map<String, Object?>>();
      final peer = transport.host.messages.listen((message) {
        final frame =
            (message! as Map<Object?, Object?>).cast<String, Object?>();
        if (frame['kind'] == 'closing' && !closingFrame.isCompleted) {
          closingFrame.complete(frame);
        }
      });
      final connection = FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final connectionFailure = expectLater(
        connection.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await transport.host.send({
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'shutdown',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      });

      await connectionFailure;
      final frame =
          await closingFrame.future.timeout(const Duration(milliseconds: 100));
      final report =
          (frame['report']! as Map<Object?, Object?>).cast<String, Object?>();
      expect(report['pendingRequestCount'], 0);
      expect(report['subscriptionCount'], 0);
      await peer.cancel();
    });

    test('Flutter receive completion terminates a pending connection',
        () async {
      final transport = _ControllableViewTransport();
      final connection = FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final connectionFailure = expectLater(
        connection.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await transport.closeMessages();

      await connectionFailure;
    });

    test('Flutter receive error fails pending calls and closes', () async {
      final operation = _snapshotOperation('fixture.wait');
      final transport = _ControllableViewTransport();
      addTearDown(transport.closeMessages);
      final connection = FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      transport.addMessage(const {
        'protocol': 'flutter-vscode.view',
        'version': 2,
        'kind': 'readyAck',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
        'activeNonce': 'active-1',
      });
      final view = await connection;
      final callFailure = expectLater(
        operation.call(view, null).timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>()
              .having(
                (error) => error.code,
                'code',
                ViewProtocolErrorCode.sessionClosed,
              )
              .having(
                (error) => error.message,
                'message',
                contains('Flutter View receive stream failed'),
              )
              .having(
                (error) => error.details,
                'details',
                contains('transport receive failed'),
              ),
        ),
      );
      expect(view.pendingRequestCount, 1);

      transport.addReceiveError(StateError('transport receive failed'));

      await callFailure;
      final report = await view.closed.timeout(
        const Duration(milliseconds: 100),
      );
      expect(report.pendingRequestCount, 0);
      expect(report.subscriptionCount, 0);
    });

    test('Host close releases its listener when transport send throws',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _SwitchableViewTransport(pair.host);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      transport.failSends = true;

      await expectLater(host.close(), throwsStateError);

      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
      expect(
        await host.closed.timeout(const Duration(milliseconds: 100)),
        isA<ViewCloseReport>(),
      );
    });

    test('Host shutdown releases its listener when transport send throws',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _SwitchableViewTransport(pair.host);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      transport.failSends = true;

      await expectLater(
        Future<ViewCloseReport>.sync(host.shutdown),
        throwsStateError,
      );

      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
      await host.closed.timeout(const Duration(milliseconds: 100));
      await view.close();
    });

    test('async Host shutdown delivery failure releases Host state', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _DeferredFailingViewTransport(pair.host, 'shutdown');
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      addTearDown(view.close);

      final shutdown = host.shutdown();
      await transport.deliveryStarted;
      transport.fail(StateError('native shutdown delivery rejected'));

      await expectLater(shutdown, throwsStateError);
      await host.closed.timeout(const Duration(milliseconds: 100));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('Host cancellation failure still completes every lifecycle future',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _CancelFailingViewTransport(pair.host);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final readyFailure = expectLater(
        host.ready.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );
      final renderedFailure = expectLater(
        host.rendered.timeout(const Duration(milliseconds: 100)),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.sessionClosed,
          ),
        ),
      );

      await expectLater(host.close(), throwsStateError);

      await readyFailure;
      await renderedFailure;
      await host.closed.timeout(const Duration(milliseconds: 100));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('Flutter View cancellation failure still completes closed', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _CancelFailingViewTransport(pair.view);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await expectLater(view.close(), throwsStateError);

      await view.closed.timeout(const Duration(milliseconds: 100));
      await host.closed.timeout(const Duration(milliseconds: 100));
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('background Host cancellation failure is observed', () async {
      final pair = InMemoryViewTransportPair();
      final transport = _CancelFailingViewTransport(pair.host);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await view.close();

      await host.closed.timeout(const Duration(milliseconds: 100));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('Flutter View call rolls back and closes when transport send throws',
        () async {
      final operation = _snapshotOperation('fixture.echo');
      final pair = InMemoryViewTransportPair();
      final transport = _SwitchableViewTransport(pair.view);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: [operation.bind((value) => value)],
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      transport.failSends = true;

      await expectLater(
        Future<Object?>.sync(() => operation.call(view, null)),
        throwsStateError,
      );

      await view.closed.timeout(const Duration(milliseconds: 100));
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
      await host.close();
    });

    test('Flutter View close completes cleanup when transport send throws',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _SwitchableViewTransport(pair.view);
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      transport.failSends = true;

      await expectLater(view.close(), throwsStateError);

      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
      await view.closed.timeout(const Duration(milliseconds: 100));
      await host.close();
    });
  });
  group('Host and Flutter View protocol v2', () {
    Future<(HostViewSession, FlutterViewSession)> connectPair({
      Iterable<ViewOperationBinding> hostOperations = const [],
      Iterable<ViewOperationBinding> viewOperations = const [],
    }) async {
      final pair = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: hostOperations,
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: viewOperations,
      );
      return (host, view);
    }

    test('the host calls a view-bound operation', () async {
      final operation = _snapshotOperation('view.echo');
      final (host, view) = await connectPair(
        viewOperations: [
          operation.bind((value) => 'view saw $value'),
        ],
      );

      final result = await host.call(operation, 'ping');

      expect(result, 'view saw ping');
      await view.close();
    });

    test('a failing view-bound operation surfaces a structured error',
        () async {
      final operation = _snapshotOperation('view.fails');
      final (host, view) = await connectPair(
        viewOperations: [
          operation.bind((_) => throw StateError('view exploded')),
        ],
      );

      await expectLater(
        host.call(operation, null),
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.operationFailed,
          ),
        ),
      );
      await view.close();
    });

    test('a cancelled host call completes with cancellation', () async {
      final operation = _snapshotOperation('view.slow');
      final gate = Completer<Object?>();
      final (host, view) = await connectPair(
        viewOperations: [
          operation.bind((_) => gate.future),
        ],
      );

      final call = host.callWithHandle(operation, null);
      await pumpEventQueue();
      call.cancel();

      await expectLater(
        call.result,
        throwsA(
          isA<ViewProtocolException>().having(
            (error) => error.code,
            'code',
            ViewProtocolErrorCode.cancelled,
          ),
        ),
      );
      expect(host.pendingHostCallCount, 0);
      gate.complete('too late');
      await pumpEventQueue();
      expect(host.pendingHostCallCount, 0);
      await view.close();
    });

    test('host events reach view stream subscribers in order', () async {
      final (host, view) = await connectPair();
      final seen = <Object?>[];
      final subscription = view.events('coverage').listen(seen.add);

      await host.emitEvent('coverage', {'run': 1});
      await host.emitEvent('coverage', {'run': 2});
      await host.emitEvent('other', {'run': 3});
      await pumpEventQueue();

      expect(seen, [
        {'run': 1},
        {'run': 2},
      ]);
      await subscription.cancel();
      await view.close();
    });

    test('a version-1 frame fails closed as unsupported', () async {
      final pair = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: pair.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );
      final view = await FlutterViewSession.connect(
        transport: pair.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      await pair.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'call',
        'session': 'session-1',
        'nonce': view.activeNonce,
        'id': 'stale-1',
        'operation': 'view.echo',
        'arguments': null,
      });
      await pumpEventQueue();

      // A stale-version frame is ignored fail-closed: never executed,
      // never answered, and the session stays healthy.
      expect(host.pendingRequestCount, 0);
      await view.close();
      await host.closed;
    });
  });

}

ViewOperation<Object?, Object?> _snapshotOperation(String name) {
  return ViewOperation<Object?, Object?>(
    name: name,
    encodeArguments: (value) => value,
    decodeArguments: (value) => value,
    encodeResult: (value) => value,
    decodeResult: (value) => value,
  );
}

final class _SwitchableViewTransport implements ViewTransport {
  _SwitchableViewTransport(this._delegate);

  final ViewTransport _delegate;
  bool failSends = false;

  @override
  Stream<Object?> get messages => _delegate.messages;

  @override
  Future<void> send(Object? message) {
    if (failSends) {
      throw StateError('transport send failed');
    }
    return _delegate.send(message);
  }
}

final class _KindFailingViewTransport implements ViewTransport {
  _KindFailingViewTransport(this._delegate, this._failedKind);

  final ViewTransport _delegate;
  final String _failedKind;

  @override
  Stream<Object?> get messages => _delegate.messages;

  @override
  Future<void> send(Object? message) {
    if (message case <Object?, Object?>{'kind': final String kind}
        when kind == _failedKind) {
      throw StateError('transport send failed for $kind');
    }
    return _delegate.send(message);
  }
}

final class _DeferredFailingViewTransport implements ViewTransport {
  _DeferredFailingViewTransport(this._delegate, this._failedKind);

  final ViewTransport _delegate;
  final String _failedKind;
  final Completer<void> _deliveryStarted = Completer<void>();
  final Completer<void> _delivery = Completer<void>();
  var _matched = false;

  Future<void> get deliveryStarted => _deliveryStarted.future;

  @override
  Stream<Object?> get messages => _delegate.messages;

  @override
  Future<void> send(Object? message) {
    if (!_matched &&
        message is Map<Object?, Object?> &&
        message['kind'] == _failedKind) {
      _matched = true;
      _deliveryStarted.complete();
      return _delivery.future;
    }
    return _delegate.send(message);
  }

  void fail(Object error) {
    _delivery.completeError(error, StackTrace.current);
  }
}

final class _CancelFailingViewTransport implements ViewTransport {
  _CancelFailingViewTransport(this._delegate) {
    _messages = StreamController<Object?>(
      sync: true,
      onListen: () {
        _delegateSubscription = _delegate.messages.listen(
          _messages.add,
          onError: _messages.addError,
          onDone: _messages.close,
        );
      },
      onCancel: () async {
        await _delegateSubscription?.cancel();
        throw StateError('transport cancellation failed');
      },
    );
  }

  final ViewTransport _delegate;
  late final StreamController<Object?> _messages;
  StreamSubscription<Object?>? _delegateSubscription;

  @override
  Stream<Object?> get messages => _messages.stream;

  @override
  Future<void> send(Object? message) => _delegate.send(message);
}

final class _DelayedCancelViewTransport implements ViewTransport {
  _DelayedCancelViewTransport(this._delegate) {
    _messages = StreamController<Object?>(
      sync: true,
      onListen: () {
        _delegateSubscription = _delegate.messages.listen(
          _messages.add,
          onError: _messages.addError,
          onDone: _messages.close,
        );
      },
      onCancel: () async {
        if (!_cancellationStarted.isCompleted) {
          _cancellationStarted.complete();
        }
        await _allowCancellation.future;
        await _delegateSubscription?.cancel();
        _cancellationCompleted = true;
      },
    );
  }

  final ViewTransport _delegate;
  final Completer<void> _cancellationStarted = Completer<void>();
  final Completer<void> _allowCancellation = Completer<void>();
  late final StreamController<Object?> _messages;
  StreamSubscription<Object?>? _delegateSubscription;
  bool _cancellationCompleted = false;
  bool sentClosing = false;
  bool sentClosingAfterCancellation = false;

  Future<void> get cancellationStarted => _cancellationStarted.future;

  void allowCancellation() => _allowCancellation.complete();

  @override
  Stream<Object?> get messages => _messages.stream;

  @override
  Future<void> send(Object? message) {
    if (message case <Object?, Object?>{'kind': 'closing'}) {
      sentClosing = true;
      sentClosingAfterCancellation = _cancellationCompleted;
    }
    return _delegate.send(message);
  }
}

final class _ReceivingLifecycleViewTransport
    implements ViewTransport, ViewTransportLifecycle {
  _ReceivingLifecycleViewTransport(this._delegate) {
    _messages = StreamController<Object?>(
      sync: true,
      onListen: () {
        _delegateSubscription = _delegate.messages.listen(
          _messages.add,
          onError: _messages.addError,
          onDone: _messages.close,
        );
      },
    );
  }

  final ViewTransport _delegate;
  late final StreamController<Object?> _messages;
  // The lifecycle seam closes this owned native-style subscription.
  // ignore: cancel_subscriptions
  StreamSubscription<Object?>? _delegateSubscription;
  bool sentClosingAfterReceivingClose = false;

  @override
  int get receivingSubscriptionCount => _delegateSubscription == null ? 0 : 1;

  @override
  Stream<Object?> get messages => _messages.stream;

  @override
  Future<void> send(Object? message) {
    if (message case <Object?, Object?>{'kind': 'closing'}) {
      sentClosingAfterReceivingClose = _delegateSubscription == null;
    }
    return _delegate.send(message);
  }

  @override
  Future<void> closeReceiving() async {
    final subscription = _delegateSubscription;
    _delegateSubscription = null;
    await subscription?.cancel();
    await _messages.close();
  }
}

final class _ControllableViewTransport implements ViewTransport {
  final StreamController<Object?> _messages =
      StreamController<Object?>.broadcast(sync: true);
  final List<Object?> sent = [];

  @override
  Stream<Object?> get messages => _messages.stream;

  @override
  Future<void> send(Object? message) {
    sent.add(message);
    return Future.value();
  }

  void addMessage(Object? message) => _messages.add(message);

  void addReceiveError(Object error) => _messages.addError(error);

  Future<void> closeMessages() => _messages.close();
}

final class _ReadyAckObservingViewTransport implements ViewTransport {
  _ReadyAckObservingViewTransport(this._delegate);

  final ViewTransport _delegate;
  final List<Object?> sent = [];
  void Function()? onReadyAck;

  List<Object?> get sentKinds => [
        for (final rawMessage in sent)
          (rawMessage! as Map<Object?, Object?>)['kind'],
      ];

  @override
  Stream<Object?> get messages => _delegate.messages;

  @override
  Future<void> send(Object? message) {
    sent.add(message);
    if (message case <Object?, Object?>{'kind': 'readyAck'}) {
      onReadyAck?.call();
    }
    return _delegate.send(message);
  }

}

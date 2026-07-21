import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vscode/view.dart';

void main() {
  group('Host and Flutter View protocol v1', () {
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
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);
    });

    test('rejects a peer that speaks an unsupported version', () async {
      final transport = InMemoryViewTransportPair();
      final peer = transport.host.messages.listen((message) {
        final ready =
            (message! as Map<Object?, Object?>).cast<String, Object?>();
        transport.host.send({
          'protocol': 'flutter-vscode.view',
          'version': 2,
          'kind': 'readyAck',
          'session': ready['session'],
          'nonce': ready['nonce'],
          'activeNonce': 'active-1',
        });
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
        transport.host.send({
          'protocol': 'flutter-vscode.view',
          'version': 1,
          'kind': 'readyAck',
          'session': ready['session'],
          'nonce': ready['nonce'],
          'activeNonce': 'active-1',
          'unexpected': true,
        });
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
        transport.host.send({
          'protocol': 'flutter-vscode.view',
          'version': 1,
          'kind': 'readyAck',
          'session': 'another-session',
          'nonce': ready['nonce'],
          'activeNonce': 'active-1',
        });
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
        transport.host.send({
          'protocol': 'flutter-vscode.view',
          'version': 1,
          'kind': 'readyAck',
          'session': ready['session'],
          'nonce': 'wrong-bootstrap',
          'activeNonce': 'active-1',
        });
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

    test('Host ready acknowledgement send failure closes without escaping',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _KindFailingViewTransport(pair.host, 'readyAck');
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: const [],
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

    test('rejects a call outside the Host Dart operation allowlist', () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: const [],
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
      transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      });
      expect(await readyResponse, isTrue);
      final readyAck =
          (responses.current! as Map<Object?, Object?>).cast<String, Object?>();
      final call = {
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'call',
        'session': 'session-1',
        'nonce': readyAck['activeNonce'],
        'id': 'request-1',
        'operation': 'fixture.readHostValue',
        'arguments': null,
      };

      transport.view.send(call);
      transport.view.send(call);

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
      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 0);

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
        'version': 1,
        'kind': 'ready',
        'session': 'session-1',
        'nonce': 'bootstrap-1',
      };

      transport.view.send(ready);
      final firstNonce = received.single['activeNonce'];
      transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
        'kind': 'call',
        'session': 'session-1',
        'nonce': firstNonce,
        'id': 'request-1',
        'operation': 'fixture.wait',
        'arguments': null,
      });
      expect(host.pendingRequestCount, 1);

      transport.view.send(ready);

      expect(received, hasLength(2));
      expect(received.last['kind'], 'readyAck');
      expect(received.last['activeNonce'], isNot(firstNonce));
      expect(host.pendingRequestCount, 0);
      expect(host.subscriptionCount, 1);

      operationResult.complete('late value');
      await Future<void>.delayed(Duration.zero);
      expect(received.where((message) => message['kind'] == 'result'), isEmpty);
      expect(host.pendingRequestCount, 0);

      await host.close();
      await peer.cancel();
    });

    test('reports the rendered Flutter value through a typed future', () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: const [],
      );
      final view = await FlutterViewSession.connect(
        transport: transport.view,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
      );

      view.reportRendered({'text': 'hello from Flutter'});

      expect(
        await host.rendered,
        {'text': 'hello from Flutter'},
      );
      await view.close();
    });

    test('host shutdown observes the Flutter View zero-count close report',
        () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: const [],
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
            transport.host.send({
              'protocol': 'flutter-vscode.view',
              'version': 1,
              'kind': 'readyAck',
              'session': message['session'],
              'nonce': message['nonce'],
              'activeNonce': 'active-1',
            });
          case 'call':
            final result = {
              'protocol': 'flutter-vscode.view',
              'version': 1,
              'kind': 'result',
              'session': message['session'],
              'nonce': message['nonce'],
              'id': message['id'],
              'result': 'first value',
            };
            transport.host
              ..send(result)
              ..send({...result, 'result': 'late value'});
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
        operations: const [],
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

    test('view close before rendering fails the host rendered future',
        () async {
      final transport = InMemoryViewTransportPair();
      final host = HostViewSession.connect(
        transport: transport.host,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: const [],
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
        operations: const [],
      );
      final peer = transport.view.messages.listen((_) {});
      transport.view.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
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

      transport.host.send({
        'protocol': 'flutter-vscode.view',
        'version': 1,
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

    test('Host close releases its listener when transport send throws',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _SwitchableViewTransport(pair.host);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: const [],
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
        operations: const [],
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

    test('Host cancellation failure still completes every lifecycle future',
        () async {
      final pair = InMemoryViewTransportPair();
      final transport = _CancelFailingViewTransport(pair.host);
      final host = HostViewSession.connect(
        transport: transport,
        sessionId: 'session-1',
        bootstrapNonce: 'bootstrap-1',
        operations: const [],
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
        operations: const [],
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
        operations: const [],
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

      expect(view.pendingRequestCount, 0);
      expect(view.subscriptionCount, 0);
      await view.closed.timeout(const Duration(milliseconds: 100));
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
        operations: const [],
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
  void send(Object? message) {
    if (failSends) {
      throw StateError('transport send failed');
    }
    _delegate.send(message);
  }
}

final class _KindFailingViewTransport implements ViewTransport {
  _KindFailingViewTransport(this._delegate, this._failedKind);

  final ViewTransport _delegate;
  final String _failedKind;

  @override
  Stream<Object?> get messages => _delegate.messages;

  @override
  void send(Object? message) {
    if (message case <Object?, Object?>{'kind': final String kind}
        when kind == _failedKind) {
      throw StateError('transport send failed for $kind');
    }
    _delegate.send(message);
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
  void send(Object? message) => _delegate.send(message);
}

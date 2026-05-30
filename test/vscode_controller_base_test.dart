import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vscode/src/vscode_controller_base.dart';

void main() {
  group('VSCodeControllerBase', () {
    tearDown(() {
      VSCodeControllerBase.debugRequestIdFactory = null;
      VSCodeControllerBase.debugResponseTimeout = const Duration(seconds: 30);
      VSCodeControllerBase.debugPendingRequests.clear();
    });

    test('stores pending request and completes with result', () async {
      VSCodeControllerBase.debugRequestIdFactory = () => 'req-test';

      final future = VSCodeControllerBase.sendCommand<String>(
        'window.showInformationMessage',
        <dynamic>['hello'],
        expectsResponse: true,
      );

      expect(
        VSCodeControllerBase.debugPendingRequests.containsKey('req-test'),
        isTrue,
      );

      VSCodeControllerBase.handleMessage(<String, dynamic>{
        'requestId': 'req-test',
        'result': 'ok',
      });

      expect(await future, 'ok');
      expect(
        VSCodeControllerBase.debugPendingRequests.containsKey('req-test'),
        isFalse,
      );
    });

    test('completes pending request with error', () async {
      VSCodeControllerBase.debugRequestIdFactory = () => 'req-error';

      final future = VSCodeControllerBase.sendCommand<String>(
        'window.showInformationMessage',
        <dynamic>['hello'],
        expectsResponse: true,
      );

      VSCodeControllerBase.handleMessage(<String, dynamic>{
        'requestId': 'req-error',
        'error': 'boom',
      });

      await expectLater(
        future,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('boom'),
          ),
        ),
      );
    });

    test('sendCommand without response returns completed Future<void>', () {
      final future = VSCodeControllerBase.sendCommand<void>(
        'window.showInformationMessage',
        <dynamic>['hello'],
      );

      expect(future, completes);
      expect(VSCodeControllerBase.debugPendingRequests, isEmpty);
    });

    test('ignores messages with unknown request ids', () {
      VSCodeControllerBase.handleMessage(<String, dynamic>{
        'requestId': 'missing-request',
        'result': 'ignored',
      });

      expect(VSCodeControllerBase.debugPendingRequests, isEmpty);
    });

    test('ignores messages without request id', () {
      VSCodeControllerBase.handleMessage(<String, dynamic>{
        'result': 'ignored',
      });

      expect(VSCodeControllerBase.debugPendingRequests, isEmpty);
    });

    test('times out pending requests and cleans them up', () async {
      VSCodeControllerBase.debugRequestIdFactory = () => 'req-timeout';
      VSCodeControllerBase.debugResponseTimeout = const Duration(
        milliseconds: 10,
      );

      final future = VSCodeControllerBase.sendCommand<String>(
        'window.showInputBox',
        <dynamic>['hello'],
        expectsResponse: true,
      );

      await expectLater(future, throwsA(isA<TimeoutException>()));
      expect(VSCodeControllerBase.debugPendingRequests, isEmpty);
    });
  });
}

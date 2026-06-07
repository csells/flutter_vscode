import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vscode/runtime.dart';
import 'package:flutter_vscode_example/api_controller.dart';

void main() {
  group('ApiController (generated)', () {
    tearDown(() {
      VSCodeControllerBase.debugRequestIdFactory = null;
      VSCodeControllerBase.debugResponseTimeout = const Duration(seconds: 30);
      VSCodeControllerBase.debugClearPendingRequests();
    });

    test('showInputBox waits for host response', () async {
      VSCodeControllerBase.debugRequestIdFactory = () => 'req-input';

      final api = createApiController();
      final future = api.showInputBox('Name?');

      expect(
        VSCodeControllerBase.debugPendingRequests.containsKey('req-input'),
        isTrue,
      );

      VSCodeControllerBase.handleMessage(<String, dynamic>{
        'requestId': 'req-input',
        'result': 'Ada',
      });

      expect(await future, 'Ada');
    });

    test('void commands do not register pending requests', () async {
      final api = createApiController();

      await api.showInformationMessage('hello');
      await api.showErrorMessage('oops');

      expect(VSCodeControllerBase.debugPendingRequests, isEmpty);
    });
  });
}

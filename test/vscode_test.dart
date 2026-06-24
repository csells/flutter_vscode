import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vscode/runtime.dart';

void main() {
  group('VSCode.invoke', () {
    tearDown(() {
      VSCodeControllerBase.debugRequestIdFactory = null;
      VSCodeControllerBase.debugResponseTimeout = const Duration(seconds: 30);
      VSCodeControllerBase.debugClearPendingRequests();
    });

    test('invoke waits for host response', () async {
      VSCodeControllerBase.debugRequestIdFactory = () => 'req-invoke';

      final future = VSCode.instance.invoke<String?>(
        'window.showInputBox',
        [
          {'prompt': 'Name?'},
        ],
      );

      VSCodeControllerBase.handleMessage(<String, dynamic>{
        'requestId': 'req-invoke',
        'result': 'Grace',
      });

      expect(await future, 'Grace');
    });

    test('invokeVoid does not register pending requests', () async {
      await VSCode.instance.invoke<void>(
        'window.showInformationMessage',
        ['hello'],
        expectsResponse: false,
      );

      expect(VSCodeControllerBase.debugPendingRequests, isEmpty);
    });

    test('instance is a singleton', () {
      expect(identical(VSCode.instance, VSCode.instance), isTrue);
    });
  });
}

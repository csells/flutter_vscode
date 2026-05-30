import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vscode/src/webview_bridge.dart';

void main() {
  group('WebViewBridge', () {
    test('stub postMessage completes without throwing', () {
      expect(() => WebViewBridge().postMessage(<String, dynamic>{}), returnsNormally);
    });
  });
}

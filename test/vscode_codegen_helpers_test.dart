import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_vscode/src/vscode_codegen_helpers.dart';

void main() {
  group('buildDartSendCommandBody', () {
    test('builds body for synchronous void method', () {
      final body = buildDartSendCommandBody(
        commandId: 'window.showInformationMessage',
        paramListExpression: 'message',
        returnKind: VSCodeReturnKind.voidSync,
      );

      expect(
        body,
        contains(
          "VSCodeControllerBase.sendCommand('window.showInformationMessage', [message], expectsResponse: false,);",
        ),
      );
    });

    test('builds body for Future<void> method', () {
      final body = buildDartSendCommandBody(
        commandId: 'window.showInformationMessage',
        paramListExpression: 'message',
        returnKind: VSCodeReturnKind.futureVoid,
      );

      expect(
        body,
        contains(
          "return VSCodeControllerBase.sendCommand('window.showInformationMessage', [message], expectsResponse: false,);",
        ),
      );
    });

    test('builds body for Future<T> method', () {
      final body = buildDartSendCommandBody(
        commandId: 'window.showInputBox',
        paramListExpression: 'prompt',
        returnKind: VSCodeReturnKind.futureValue,
        futureValueType: 'String?',
      );

      expect(
        body,
        contains(
          "return VSCodeControllerBase.sendCommand<String?>('window.showInputBox', [prompt], expectsResponse: true,);",
        ),
      );
    });
  });

  group('buildTsCommandHandler', () {
    test('builds void-like handler case', () {
      final code = buildTsCommandHandler(
        commandId: 'window.showInformationMessage',
        isVoidLike: true,
        positionalParamCount: 1,
      );

      expect(code, contains("case 'window.showInformationMessage'"));
      expect(
        code,
        contains(
          "const fn = resolveVscodeFn('window.showInformationMessage');",
        ),
      );
      expect(code, contains('void fn(params[0]);'));
      expect(code, contains('return;'));
    });

    test('builds value-returning handler case', () {
      final code = buildTsCommandHandler(
        commandId: 'window.showInputBox',
        isVoidLike: false,
        positionalParamCount: 2,
      );

      expect(code, contains("case 'window.showInputBox'"));
      expect(
        code,
        contains("const fn = resolveVscodeFn('window.showInputBox');"),
      );
      expect(code, contains('const result = await fn(params[0], params[1]);'));
      expect(code, contains('if (requestId) {'));
      expect(code, contains('webview.postMessage({ requestId, result });'));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_vscode/annotations.dart';

void main() {
  test('VSCodeController annotation exists', () {
    const controller = VSCodeController();
    expect(controller, isA<VSCodeController>());
  });
  
  test('VSCodeCommand annotation exists', () {
    const command = VSCodeCommand();
    expect(command, isA<VSCodeCommand>());
  });

  test('VSCodeCommand supports custom command id', () {
    const command = VSCodeCommand('window.showInformationMessage');
    expect(command.command, 'window.showInformationMessage');
  });
}

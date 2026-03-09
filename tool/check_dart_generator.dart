#!/usr/bin/env dart
// Check that VSCodeGenerator produces correct Dart implementation code.
//
// This script exercises the generator via build_runner/build_test to ensure
// the full pipeline works correctly. Core string-generation logic is covered
// by test/vscode_codegen_helpers_test.dart; this is an integration check.

import 'package:build_test/build_test.dart';
import 'package:flutter_vscode/src/vscode_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  test('VSCodeGenerator generates implementation for annotated controller',
      () async {
    final builder = SharedPartBuilder([VSCodeGenerator()], 'vscode');

    await testBuilder(
      builder,
      {
        'flutter_vscode|lib/controller.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

part 'controller.g.part';

@VSCodeController()
abstract class MyController {
  @VSCodeCommand('window.showInformationMessage')
  Future<void> showInfo(String message);

  @VSCodeCommand('window.showInputBox')
  Future<String?> inputBox(String prompt);
}
''',
      },
      outputs: {
        'flutter_vscode|lib/controller.g.part': decodedMatches(
          allOf([
            contains("part of 'controller.dart';"),
            contains(r'class _$MyController implements MyController {'),
            contains(
              "VSCodeControllerBase.sendCommand('window.showInformationMessage'",
            ),
            contains(
              "VSCodeControllerBase.sendCommand<String?>('window.showInputBox'",
            ),
          ]),
        ),
      },
    );
  });
}

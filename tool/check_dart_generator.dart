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

  test('VSCodeGenerator rejects non-abstract controllers', () async {
    final builder = SharedPartBuilder([VSCodeGenerator()], 'vscode');

    await expectLater(
      () => testBuilder(
        builder,
        {
          'flutter_vscode|lib/non_abstract.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

part 'non_abstract.vscode.g.part';

@VSCodeController()
class NotAbstractController {
  @VSCodeCommand('window.showInformationMessage')
  Future<void> showInfo(String message) async {}
}
''',
        },
      ),
      throwsA(
        isA<InvalidGenerationSourceError>().having(
          (e) => e.message,
          'message',
          contains('must be abstract'),
        ),
      ),
    );
  });

  test('VSCodeGenerator rejects optional parameters on commands', () async {
    final builder = SharedPartBuilder([VSCodeGenerator()], 'vscode');

    await expectLater(
      () => testBuilder(
        builder,
        {
          'flutter_vscode|lib/optional_params.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

part 'optional_params.vscode.g.part';

@VSCodeController()
abstract class OptionalParamsController {
  @VSCodeCommand('window.showInformationMessage')
  Future<void> showInfo([String? message]);
}
''',
        },
      ),
      throwsA(
        isA<InvalidGenerationSourceError>().having(
          (e) => e.message,
          'message',
          contains('required positional parameters'),
        ),
      ),
    );
  });
}

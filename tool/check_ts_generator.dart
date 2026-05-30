#!/usr/bin/env dart
// Check that VSCodeTsGenerator produces correct TypeScript handler code.
//
// This script exercises the generator via build_runner/build_test to ensure
// the full pipeline works correctly. Core string-generation logic is covered
// by test/vscode_codegen_helpers_test.dart; this is an integration check.

import 'package:build_test/build_test.dart';
import 'package:flutter_vscode/src/vscode_ts_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  test(
      'VSCodeTsGenerator generates TypeScript handlers for annotated controllers',
      () async {
    final builder = VSCodeTsGenerator();

    await testBuilder(
      builder,
      {
        'flutter_vscode|test/fixtures/controller.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

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
        'flutter_vscode|test/fixtures/controller.handlers.ts': decodedMatches(
          allOf([
            contains("case 'window.showInformationMessage'"),
            contains("case 'window.showInputBox'"),
            contains('export async function handleCommand'),
          ]),
        ),
      },
    );
  });

  test('VSCodeTsGenerator rejects empty command ids', () async {
    final builder = VSCodeTsGenerator();

    await expectLater(
      () => testBuilder(
        builder,
        {
          'flutter_vscode|lib/empty_command.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

@VSCodeController()
abstract class EmptyCommandController {
  @VSCodeCommand('   ')
  Future<void> showInfo(String message);
}
''',
        },
      ),
      throwsA(
        isA<InvalidGenerationSourceError>().having(
          (e) => e.message,
          'message',
          contains('cannot be empty'),
        ),
      ),
    );
  });
}

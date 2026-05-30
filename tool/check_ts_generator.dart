#!/usr/bin/env dart
// Check that VSCodeTsGenerator produces correct TypeScript handler code.
//
// This script exercises the generator via build_runner/build_test to ensure
// the full pipeline works correctly. Core string-generation logic is covered
// by test/vscode_codegen_helpers_test.dart; this is an integration check.

import 'package:build_test/build_test.dart';
import 'package:flutter_vscode/src/vscode_ts_generator.dart';
import 'package:test/test.dart';

import 'build_test_support.dart';

void main() {
  late TestReaderWriter readerWriter;

  setUp(() async {
    readerWriter = await createBuilderTestReaderWriter();
  });

  test(
      'VSCodeTsGenerator generates TypeScript handlers for annotated controllers',
      () async {
    final builder = VSCodeTsGenerator();

    await testBuilders(
      [builder],
      {
        '$builderTestPackage|lib/controller.dart': '''
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
      readerWriter: readerWriter,
      visibleOutputBuilders: {builder},
      outputs: {
        '$builderTestPackage|lib/controller.handlers.ts': decodedMatches(
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

    final result = await testBuilders(
      [builder],
      {
        '$builderTestPackage|lib/empty_command.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

@VSCodeController()
abstract class EmptyCommandController {
  @VSCodeCommand('   ')
  Future<void> showInfo(String message);
}
''',
      },
      readerWriter: readerWriter,
      visibleOutputBuilders: {builder},
    );

    expect(result.succeeded, isFalse);
    expect(result.errors.join('\n'), contains('cannot be empty'));
  });
}

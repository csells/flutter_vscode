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

import 'build_test_support.dart';

void main() {
  late TestReaderWriter readerWriter;

  setUp(() async {
    readerWriter = await createBuilderTestReaderWriter();
  });

  test('VSCodeGenerator generates implementation for annotated controller',
      () async {
    final builder = SharedPartBuilder([VSCodeGenerator()], 'vscode');

    await testBuilders(
      [builder],
      {
        '$builderTestPackage|lib/controller.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

part 'controller.vscode.g.part';

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
        '$builderTestPackage|lib/controller.vscode.g.part': decodedMatches(
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

    final result = await testBuilders(
      [builder],
      {
        '$builderTestPackage|lib/non_abstract.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

part 'non_abstract.vscode.g.part';

@VSCodeController()
class NotAbstractController {
  @VSCodeCommand('window.showInformationMessage')
  Future<void> showInfo(String message) async {}
}
''',
      },
      readerWriter: readerWriter,
      visibleOutputBuilders: {builder},
    );

    expect(result.succeeded, isFalse);
    expect(result.errors.join('\n'), contains('must be abstract'));
  });

  test('VSCodeGenerator rejects optional parameters on commands', () async {
    final builder = SharedPartBuilder([VSCodeGenerator()], 'vscode');

    final result = await testBuilders(
      [builder],
      {
        '$builderTestPackage|lib/optional_params.dart': '''
import 'package:flutter_vscode/flutter_vscode.dart';

part 'optional_params.vscode.g.part';

@VSCodeController()
abstract class OptionalParamsController {
  @VSCodeCommand('window.showInformationMessage')
  Future<void> showInfo([String? message]);
}
''',
      },
      readerWriter: readerWriter,
      visibleOutputBuilders: {builder},
    );

    expect(result.succeeded, isFalse);
    expect(
      result.errors.join('\n'),
      contains('required positional parameters'),
    );
  });
}

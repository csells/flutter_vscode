import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../tool/binding_generator/generator.dart';

void main() {
  test('generator fails closed when a projected manifest predicate drifts', () {
    final inventory = _readJson(
      'tool/bindings/ir/vscode-1.129.1.json',
    );
    final validator = (inventory['manifestValidator']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    final rules = (validator['generatedManifestRules']! as List<Object?>)
        .cast<Map<Object?, Object?>>();
    rules.first['type'] = 'number';

    expect(
      () => VSCodeBindingGenerator().generateCoverageLedger(
        inventory: inventory,
        overrides: _readJson(
          'tool/bindings/overrides/vscode-1.129.1.json',
        ),
      ),
      throwsA(
        isA<VSCodeBindingGenerationException>()
            .having(
              (error) => error.code,
              'code',
              'INVALID_GENERATOR_INPUT',
            )
            .having(
              (error) => error.message,
              'message',
              allOf(
                contains('manifest validator'),
                contains('generatedManifestRules[0].type'),
              ),
            ),
      ),
    );
  });

  test(
    'generator fails closed when integrity-pinned validator body drifts',
    () {
      final inventory = _readJson(
        'tool/bindings/ir/vscode-1.129.1.json',
      );
      final validator =
          (inventory['manifestValidator']! as Map<Object?, Object?>)
              .cast<String, Object?>();
      validator['validatorBodySha256'] = '0' * 64;

      expect(
        () => VSCodeBindingGenerator().generateCoverageLedger(
          inventory: inventory,
          overrides: _readJson(
            'tool/bindings/overrides/vscode-1.129.1.json',
          ),
        ),
        throwsA(
          isA<VSCodeBindingGenerationException>().having(
            (error) => error.message,
            'message',
            contains('inventory.manifestValidator.validatorBodySha256'),
          ),
        ),
      );
    },
  );
}

Map<String, Object?> _readJson(String path) =>
    (jsonDecode(File(path).readAsStringSync()) as Map<Object?, Object?>)
        .cast<String, Object?>();

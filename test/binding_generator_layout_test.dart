/// Structural pin for the A-4 generator unjailing: the IR
/// validation/canonicalization projection, the coverage ledger, the
/// manifest/contribution projection, the shared leaf validators, and the
/// embedded source templates live in sibling modules under
/// `tool/binding_generator/`, leaving `generator.dart` the entangled
/// walking-slice orchestration band. The behavior pins are the existing
/// byte-compare suites; this suite pins only the promised layout.
library;

import 'dart:io';

import 'package:test/test.dart';

/// Expected top-level declarations per sibling module, matched textually
/// against the module source so an absent file or a jailed declaration
/// fails with the missing name.
const _expectedModuleDeclarations = <String, List<String>>{
  'tool/binding_generator/ir_validator.dart': [
    'void validateInputSchemaVersion(',
    'void validateIrModule(',
    'Map<String, Object?> validateIrSource(',
    'void validateIrDeclarationKeys(',
    'void validateIrDeclarationOrder(',
    'void validateIrDeclarationIdentity(',
    'List<List<String?>> irInheritedTypeParameterScopes(',
    'void validateIrDeclarationTypes(',
    'void validateIrOverloadOrdinals(',
    'void validateIrTypeLiteralGraph(',
    'void validateIrExactKeys(',
    'String computeDeclarationFingerprint(',
    'Object? _canonicalizeIrType(',
  ],
  'tool/binding_generator/coverage_ledger.dart': [
    'String emitCoverageLedger(',
  ],
  'tool/binding_generator/manifest_projection.dart': [
    'String validateManifestSchema(',
    'String validateManifestValidator(',
    'String validateCommandsContributionSchema(',
    'List<Map<String, Object?>> projectCommands(',
    'void validateProjectDescriptor(',
    'bool isStrictSemanticVersion(',
  ],
  'tool/binding_generator/templates.dart': [
    'String hostExportsTemplate(',
    'String bootstrapTemplate(',
    'String runtimeTemplate(',
  ],
  'tool/binding_generator/validators.dart': [
    'List<Object?> objectList(',
    'Map<String, Object?> objectMap(',
    'String string(',
    'String sha256Digest(',
    'String nonEmptyString(',
    'String extensionIdentifierComponent(',
    'String nonWhitespaceString(',
    'int integerOrDefault(',
    'int integer(',
  ],
};

void main() {
  for (final entry in _expectedModuleDeclarations.entries) {
    test('${entry.key} exists and owns its promised declarations', () {
      final file = File(entry.key);
      expect(
        file.existsSync(),
        isTrue,
        reason: '${entry.key} must exist as a sibling module of '
            'generator.dart.',
      );
      final source = file.readAsStringSync();
      for (final declaration in entry.value) {
        expect(
          source,
          contains(declaration),
          reason: '${entry.key} must declare `$declaration...` at the '
              'top level.',
        );
      }
    });
  }

  test('generator.dart keeps only the entangled walking-slice band', () {
    final lineCount =
        File('tool/binding_generator/generator.dart').readAsLinesSync().length;
    expect(
      lineCount,
      lessThan(2500),
      reason: 'generator.dart must shrink to the orchestration plus '
          'walking-slice band once the projections, ledger, validators, '
          'and templates move to sibling modules.',
    );
  });
}

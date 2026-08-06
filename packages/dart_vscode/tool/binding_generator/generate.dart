import 'dart:convert';
import 'dart:io';

import 'contract.dart';
import 'dart_layer.dart';
import 'generator.dart';
import 'parity_report.dart';

/// The dart_vscode maintainer entry point.
///
/// Extension authors never run this: the generated API layer, its ledgers,
/// and the evidence artifacts it maintains all ship inside the published
/// `dart_vscode` package. The maintainer reruns it when moving the pinned
/// VS Code baseline.
Future<void> main(List<String> arguments) async {
  try {
    if (arguments.isNotEmpty && arguments.first == '--dart-layer') {
      if (arguments.length != 2) {
        throw const VSCodeBindingGenerationException(
          'INVALID_ARGUMENTS',
          '--dart-layer requires exactly the repository root.',
        );
      }
      final root = arguments[1];
      const package = 'packages/dart_vscode';
      final inventory = await _readJson(
        '$root/$package/tool/bindings/ir/vscode-1.129.1.json',
      );
      final overrides = await _readJson(
        '$root/$package/tool/bindings/overrides/vscode-1.129.1.json',
      );
      final artifacts = emitDartLayer(inventory);
      await File('$root/$package/lib/src/generated/vscode_dart_layer.g.dart')
          .create(recursive: true)
          .then((file) => file.writeAsString(artifacts.library));
      await File('$root/$package/tool/bindings/dart-layer-ledger.json')
          .writeAsString(artifacts.ledger);
      await File('$root/$package/tool/bindings/parity-ledger.json')
          .writeAsString(artifacts.parityLedger);
      // The coverage ledger is maintainer evidence for the shipped slice,
      // regenerated with the layer so the two can never drift apart.
      await File('$root/$package/tool/bindings/coverage-ledger.json')
          .writeAsString(
        VSCodeBindingGenerator().generateCoverageLedger(
          inventory: inventory,
          overrides: overrides,
        ),
      );
      return;
    }
    if (arguments.isNotEmpty && arguments.first == '--parity') {
      if (arguments.length != 2) {
        throw const VSCodeBindingGenerationException(
          'INVALID_ARGUMENTS',
          '--parity requires exactly the repository root.',
        );
      }
      final root = arguments[1];
      const package = 'packages/dart_vscode';
      final coverage = await _readJson(
        '$root/$package/tool/bindings/coverage-ledger.json',
      );
      final inventory = await _readJson(
        '$root/$package/tool/bindings/ir/vscode-1.129.1.json',
      );
      await File('$root/docs/reference/parity.md')
          .writeAsString(buildParityReport(coverage, inventory));
      return;
    }
    if (arguments.isNotEmpty && arguments.first == '--contract') {
      if (arguments.length != 2) {
        throw const VSCodeBindingGenerationException(
          'INVALID_ARGUMENTS',
          '--contract requires exactly the repository root.',
        );
      }
      writeHostContractArtifact(Directory(arguments[1]));
      return;
    }
    throw const VSCodeBindingGenerationException(
      'INVALID_ARGUMENTS',
      'Usage: generate.dart <--dart-layer|--parity|--contract> '
          '<repository root>.',
    );
  } on VSCodeBindingGenerationException catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln('INVALID_JSON: $error');
    exitCode = 1;
  } on FileSystemException catch (error) {
    stderr.writeln('FILE_SYSTEM_ERROR: ${error.message} (${error.path})');
    exitCode = 1;
  }
}

Future<Map<String, Object?>> _readJson(String path) async {
  final decoded = jsonDecode(await File(path).readAsString());
  if (decoded is! Map<Object?, Object?>) {
    throw VSCodeBindingGenerationException(
      'INVALID_JSON',
      '$path must contain a JSON object.',
    );
  }
  return decoded.cast<String, Object?>();
}

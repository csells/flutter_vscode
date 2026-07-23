import 'dart:convert';
import 'dart:io';

import 'contract.dart';
import 'generator.dart';
import 'parity_report.dart';
import 'writer.dart';

Future<void> main(List<String> arguments) async {
  try {
    if (arguments.isNotEmpty && arguments.first == '--parity') {
      if (arguments.length != 2) {
        throw const VSCodeBindingGenerationException(
          'INVALID_ARGUMENTS',
          '--parity requires exactly the repository root.',
        );
      }
      final root = arguments[1];
      final coverage = await _readJson(
        '$root/test/fixtures/host_extension/coverage.json',
      );
      await File('$root/docs/reference/parity.md')
          .writeAsString(buildParityReport(coverage));
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
    final options = _parseArguments(arguments);
    final generated = VSCodeBindingGenerator().generate(
      inventory: await _readJson(options['inventory']!),
      overrides: await _readJson(options['overrides']!),
      project: await _readJson(options['project']!),
    );
    await writeGeneratedBindings(
      generated,
      Directory(options['output-root']!),
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

Map<String, String> _parseArguments(List<String> arguments) {
  const expected = {'inventory', 'overrides', 'project', 'output-root'};
  if (arguments.length.isOdd) {
    throw const VSCodeBindingGenerationException(
      'INVALID_ARGUMENTS',
      'Every generator option requires a value.',
    );
  }
  final options = <String, String>{};
  for (var index = 0; index < arguments.length; index += 2) {
    final option = arguments[index];
    if (!option.startsWith('--')) {
      throw VSCodeBindingGenerationException(
        'INVALID_ARGUMENTS',
        'Expected an option, found $option.',
      );
    }
    final name = option.substring(2);
    if (!expected.contains(name) || options.containsKey(name)) {
      throw VSCodeBindingGenerationException(
        'INVALID_ARGUMENTS',
        'Unknown or duplicate option $option.',
      );
    }
    options[name] = arguments[index + 1];
  }
  final missing = expected.difference(options.keys.toSet()).toList()..sort();
  if (missing.isNotEmpty) {
    throw VSCodeBindingGenerationException(
      'INVALID_ARGUMENTS',
      'Missing required options: ${missing.join(', ')}.',
    );
  }
  return options;
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

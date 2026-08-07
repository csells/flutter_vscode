import 'dart:io';

/// Checks the reachable imports of a Host Dart [entrypoint].
///
/// Implementations throw `HostDartSyntaxException`
/// (`package:flutter_vscode/src/cli/cli_exception.dart`) for malformed
/// sources and return boundary violations otherwise.
typedef CheckHostImports =
    List<String> Function({
      required File entrypoint,
      required File packageConfig,
    });

/// Formats boundary [violations] as an actionable diagnostic.
typedef FormatImportViolations = String Function(List<String> violations);

/// The boundary-checking collaborators the command modules depend on.
///
/// The Host Dart import checker lives in the package's `tool/` area,
/// outside `lib/`; the process adapter wires it in here so the commands
/// stay importable (and testable) in-process.
final class BindingToolchain {
  /// Creates the collaborator bundle the commands consume.
  const BindingToolchain({
    required this.checkHostImports,
    required this.formatImportViolations,
  });

  /// Checks Host Dart dependency boundaries.
  final CheckHostImports checkHostImports;

  /// Formats boundary violations for stderr.
  final FormatImportViolations formatImportViolations;
}

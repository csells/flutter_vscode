import 'dart:io';

/// Generates the deterministic binding files for one Extension Project.
///
/// Returns generated sources keyed by project-relative POSIX path.
typedef GenerateBindings = Map<String, String> Function({
  required Map<String, Object?> inventory,
  required Map<String, Object?> overrides,
  required Map<String, Object?> project,
});

/// Writes generated binding [files] beneath [outputRoot] with safe-path
/// validation.
typedef WriteBindings = Future<void> Function(
  Map<String, String> files,
  Directory outputRoot,
);

/// Emits one generated library's source from the pinned IR [inventory].
typedef EmitLibrary = String Function(Map<String, Object?> inventory);

/// Checks the reachable imports of a Host Dart [entrypoint].
///
/// Implementations throw `HostDartSyntaxException`
/// (`package:flutter_vscode/src/cli/cli_exception.dart`) for malformed
/// sources and return boundary violations otherwise.
typedef CheckHostImports = List<String> Function({
  required File entrypoint,
  required File packageConfig,
});

/// Formats boundary [violations] as an actionable diagnostic.
typedef FormatImportViolations = String Function(List<String> violations);

/// The binding-generation collaborators the command modules depend on.
///
/// The generator, emitters, and boundary checker live in the package's
/// `tool/` area, outside `lib/`; the process adapter wires them in here so
/// the commands stay importable (and testable) in-process.
final class BindingToolchain {
  /// Creates the collaborator bundle the commands consume.
  const BindingToolchain({
    required this.generateBindings,
    required this.writeBindings,
    required this.emitDartLayerLibrary,
    required this.checkHostImports,
    required this.formatImportViolations,
  });

  /// Generates the walking-slice binding files for a project.
  final GenerateBindings generateBindings;

  /// Writes generated files beneath an output root.
  final WriteBindings writeBindings;

  /// Emits the self-contained generated API layer library (the Parity
  /// Layer substrate inlined beneath the Dart-ergonomics layer).
  final EmitLibrary emitDartLayerLibrary;

  /// Checks Host Dart dependency boundaries.
  final CheckHostImports checkHostImports;

  /// Formats boundary violations for stderr.
  final FormatImportViolations formatImportViolations;
}

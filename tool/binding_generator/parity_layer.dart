/// Emits the complete typed Parity Layer from the pinned canonical IR.
///
/// Every rule in this emitter is a Total Mapping Rule (ADR 0012): a
/// judgment-free, deterministic mapping from one class of TypeScript
/// construct to `dart:js_interop` code, applied to every occurrence. A
/// construct with no rule fails generation with an actionable error;
/// nothing is approximated. Strategy and per-construct precedent:
/// `specs/research/js-to-dart-mapping.md`.
library;

/// A construct reached the emitter without a Total Mapping Rule.
final class ParityGenerationException implements Exception {
  /// Creates an actionable totality failure.
  ParityGenerationException(this.declarationId, this.message);

  /// The IR declaration that could not be mapped.
  final String declarationId;

  /// What rule is missing.
  final String message;

  @override
  String toString() =>
      'PARITY_TOTALITY_ERROR: $declarationId: $message';
}

/// The generated artifacts: the Dart library and the disposition ledger.
typedef ParityArtifacts = ({String library, String ledger});

/// Builds the Parity Layer library and its totality ledger from IR JSON.
ParityArtifacts emitParityLayer(Map<String, Object?> inventory) {
  throw UnimplementedError('parity emitter not implemented');
}

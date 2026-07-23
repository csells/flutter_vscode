/// Builds the generated API parity report from the coverage ledger.
///
/// The report is a Framework-Managed Artifact: it is derived mechanically
/// from `coverage.json`, byte-compared against regeneration in tests, and
/// never edited by hand.
library;

/// Renders the parity burn-down for one coverage ledger.
String buildParityReport(Map<String, Object?> coverage) {
  final summary = (coverage['summary']! as Map<Object?, Object?>)
      .cast<String, Object?>();
  final entries = (coverage['entries']! as List<Object?>)
      .cast<Map<Object?, Object?>>()
      .map((entry) => entry.cast<String, Object?>())
      .toList();

  final groups = <String, _GroupCounts>{};
  for (final entry in entries) {
    final group = _groupFor(entry['id']! as String);
    final counts = groups.putIfAbsent(group, _GroupCounts.new);
    final binding = (entry['binding']! as Map<Object?, Object?>)
        .cast<String, Object?>();
    switch (binding['status']) {
      case 'emitted':
        counts.emitted += 1;
      case 'excluded':
        if (entry['visibility'] == 'public') {
          counts.reviewedExcluded += 1;
        } else {
          counts.nonPublic += 1;
        }
      default:
        counts.pending += 1;
    }
  }

  final discovered = summary['discovered'];
  final emitted = summary['bindingsEmitted'];
  final pending = summary['bindingsPending'];
  final buffer = StringBuffer()
    ..writeln('# VS Code API Parity')
    ..writeln()
    ..writeln('<!-- GENERATED FILE - DO NOT EDIT. -->')
    ..writeln('<!-- Regenerate: dart tool/binding_generator/generate.dart')
    ..writeln('     --parity . -->')
    ..writeln()
    ..writeln('Typed parity is total by construction (ADR 0012): the')
    ..writeln('complete Parity Layer at')
    ..writeln('`package:flutter_vscode/vscode_parity.dart` maps every public')
    ..writeln('declaration of the pinned API via Total Mapping Rules, with')
    ..writeln('its own totality ledger gated by the parity suite. A')
    ..writeln('capability the generator cannot map is a defect that fails')
    ..writeln('the build (the vision rule, mechanized).')
    ..writeln()
    ..writeln('Family-level live coverage is proven by the real-host')
    ..writeln('parity smoke: at least one representative member of every')
    ..writeln('API namespace family executes against live VS Code in the')
    ..writeln('Extension Host gate, with the family list derived from the')
    ..writeln('pinned IR so a new family cannot be skipped silently.')
    ..writeln()
    ..writeln('The table below is the behavioral-verification burn-down: a')
    ..writeln('`pending` row is public surface whose typed binding exists')
    ..writeln('but has not yet carried real-Extension-Host evidence through')
    ..writeln('the walking-slice facade and capability fixtures. Generated')
    ..writeln('from the coverage ledger, regenerated and byte-compared by')
    ..writeln('the repository gates.')
    ..writeln()
    ..writeln('Pinned inventory: $discovered declarations discovered; '
        '$emitted emitted and host-verified; '
        '${summary['bindingsExcluded']} excluded '
        '(reviewed or non-public); $pending pending.')
    ..writeln()
    ..writeln('| Container | Emitted | Reviewed excluded | Non-public | '
        'Pending |')
    ..writeln('| --- | ---: | ---: | ---: | ---: |');
  final names = groups.keys.toList()..sort();
  for (final name in names) {
    final counts = groups[name]!;
    buffer.writeln('| `$name` | ${counts.emitted} | '
        '${counts.reviewedExcluded} | ${counts.nonPublic} | '
        '${counts.pending} |');
  }
  buffer
    ..writeln()
    ..writeln('Behavioral evidence enters through the walking-slice facade')
    ..writeln('and capability fixtures; a `pending` entry leaves that state')
    ..writeln('only with executable real-host evidence. A new baseline')
    ..writeln('construct with no Total Mapping Rule blocks the release')
    ..writeln('(ADR 0008 as evolved by ADR 0012).');
  return buffer.toString();
}

String _groupFor(String entryId) {
  const marker = 'vscode.';
  final start = entryId.indexOf(marker);
  if (start < 0) {
    return 'global';
  }
  final qualified = entryId.substring(start + marker.length);
  final segmentEnd = qualified.indexOf(RegExp('[.@/]'));
  final segment =
      segmentEnd < 0 ? qualified : qualified.substring(0, segmentEnd);
  if (segment.isEmpty) {
    return 'vscode (root)';
  }
  final first = segment[0];
  final lowercaseInitial = first.toLowerCase() == first;
  return lowercaseInitial ? 'vscode.$segment' : 'vscode (root)';
}

class _GroupCounts {
  int emitted = 0;
  int reviewedExcluded = 0;
  int nonPublic = 0;
  int pending = 0;
}

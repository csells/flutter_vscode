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
    ..writeln('Per the project vision, a missing Dart path for a public')
    ..writeln('VS Code capability is a defect, not an accepted state: every')
    ..writeln('`pending` row below is unimplemented public surface that the')
    ..writeln('framework still owes an executable, host-verified binding.')
    ..writeln('This report is generated from the coverage ledger, which is')
    ..writeln('itself regenerated and byte-compared by the repository gates,')
    ..writeln('so these numbers cannot drift from machine state.')
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
    ..writeln('New bindings enter through reviewed Semantic Overrides and')
    ..writeln('must carry executable real-host evidence before an entry')
    ..writeln('may leave `pending`; unclassified public symbols block')
    ..writeln('releases (ADR 0008).');
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

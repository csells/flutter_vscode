import 'package:coverage_treemap_shared/lcov.dart';
import 'package:coverage_treemap_shared/view_contract.dart';
import 'package:test/test.dart';

void main() {
  group('coverage snapshot codec', () {
    test('round-trips a report-derived snapshot', () {
      final report = parseLcov('''
SF:lib/src/a.dart
DA:1,1
DA:2,0
end_of_record
SF:lib/b.dart
DA:1,3
end_of_record
''');
      final snapshot =
          CoverageSnapshot.fromReport('coverage/lcov.info', report);
      final decoded =
          decodeCoverageSnapshot(encodeCoverageSnapshot(snapshot));
      expect(decoded.lcovPath, 'coverage/lcov.info');
      expect(decoded.root.linesFound, 3);
      expect(decoded.root.linesHit, 2);
      final lib = decoded.root.children.single;
      expect(lib.name, 'lib');
      expect(lib.children, hasLength(2));
      final src = lib.children.singleWhere((node) => node.name == 'src');
      expect(src.isFile, isFalse);
      expect(src.children.single.name, 'a.dart');
      expect(src.children.single.isFile, isTrue);
      expect(src.coverage, 0.5);
    });

    test('decode rejects payloads with missing or extra keys', () {
      expect(
        () => decodeCoverageSnapshot(<Object?, Object?>{'lcovPath': 'x'}),
        throwsFormatException,
      );
      final valid = encodeCoverageSnapshot(
        const CoverageSnapshot(
          lcovPath: 'coverage/lcov.info',
          root: CoverageNode(name: '', linesFound: 0, linesHit: 0),
        ),
      )! as Map<String, Object?>;
      expect(
        () => decodeCoverageSnapshot({...valid, 'extra': 1}),
        throwsFormatException,
      );
    });
  });

  group('theme report codec', () {
    test('round-trips a report with and without a background', () {
      final full = decodeThemeReport(
        encodeThemeReport(
          const ThemeReport(kind: 'dark', editorBackground: 0xFF1E1E1E),
        ),
      );
      expect(full.kind, 'dark');
      expect(full.editorBackground, 0xFF1E1E1E);

      final bare = decodeThemeReport(
        encodeThemeReport(const ThemeReport(kind: 'highContrast')),
      );
      expect(bare.kind, 'highContrast');
      expect(bare.editorBackground, isNull);
    });

    test('decode rejects malformed payloads', () {
      expect(() => decodeThemeReport(null), throwsFormatException);
      expect(
        () => decodeThemeReport(<Object?, Object?>{'kind': 'dark'}),
        throwsFormatException,
      );
      expect(
        () => decodeThemeReport(<Object?, Object?>{
          'kind': 42,
          'editorBackground': null,
        }),
        throwsFormatException,
      );
      expect(
        () => decodeThemeReport(<Object?, Object?>{
          'kind': 'dark',
          'editorBackground': 'red',
        }),
        throwsFormatException,
      );
      expect(
        () => decodeThemeReport(<Object?, Object?>{
          'kind': 'dark',
          'editorBackground': null,
          'extra': true,
        }),
        throwsFormatException,
      );
    });

  });

  group('void payload codec', () {
    test('accepts only the empty payload', () {
      expect(encodeNoValue(null), isNull);
      expect(() => decodeNoValue(null), returnsNormally);
      expect(() => decodeNoValue('extra'), throwsFormatException);
    });
  });
}

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';

/// Package name used for synthetic controller fixtures in builder tests.
const builderTestPackage = 'builder_test_app';

/// Loads real package sources from the current isolate and returns a
/// [TestReaderWriter] configured for builder integration checks.
Future<TestReaderWriter> createBuilderTestReaderWriter() async {
  final readerWriter = TestReaderWriter(rootPackage: builderTestPackage);
  await readerWriter.testing.loadIsolateSources();
  return readerWriter;
}

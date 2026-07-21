import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('full repository gate installs and exercises the packaged extension', () {
    final fullGate = File('scripts/test_all.sh').readAsStringSync();

    expect(fullGate, contains('./scripts/test_packaged_extension.sh'));
  });
}

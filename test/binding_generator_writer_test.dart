import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../tool/binding_generator/generator.dart';
import '../tool/binding_generator/writer.dart';

void main() {
  test('freezes the generated artifact set at construction', () {
    final source = <String, String>{'package.json': '{}\n'};
    final generated = VSCodeGeneratedBindings(source);

    source['unexpected.js'] = 'unexpected\n';

    expect(generated.files, {'package.json': '{}\n'});
    expect(
      () => generated.files['unexpected.js'] = 'unexpected\n',
      throwsUnsupportedError,
    );
  });

  test('writes every generated artifact beneath the output root', () async {
    final root = await Directory.systemTemp.createTemp(
      'flutter_vscode_binding_writer_',
    );
    addTearDown(() => root.delete(recursive: true));
    final generated = VSCodeGeneratedBindings({
      'host/lib/generated/example.g.dart': 'generated dart\n',
      'package.json': '{}\n',
    });

    await writeGeneratedBindings(generated, root);

    expect(
      await File(
        p.join(root.path, 'host/lib/generated/example.g.dart'),
      ).readAsString(),
      'generated dart\n',
    );
    expect(
      await File(p.join(root.path, 'package.json')).readAsString(),
      '{}\n',
    );
  });
}

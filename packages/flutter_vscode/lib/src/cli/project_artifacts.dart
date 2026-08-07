/// Emission of Project-Derived Artifacts.
///
/// A build emits only files derived from the Extension Project itself:
/// the manifest, the CommonJS bootstrap, and the two generated Dart
/// modules that wire this extension's identity into the
/// `package:dart_vscode` runtime. The VS Code API surface is not
/// generated here — it ships inside `package:dart_vscode`, produced by
/// that package's maintainer pipeline.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_vscode/contributions.dart';
import 'package:flutter_vscode/src/cli/templates.dart';

/// Emits every Project-Derived Artifact for [project], keyed by
/// project-relative POSIX path.
///
/// Throws a `ContributionException` with a stable diagnostic code when the
/// descriptor would be rejected by the pinned platform.
Map<String, String> emitProjectArtifacts(Map<String, Object?> project) {
  final manifest = ManifestProjection.fromProjectDescriptor(project);
  final extensionId = manifest.extensionId;
  final extensionKey = 'e_${sha256.convert(utf8.encode(extensionId))}';
  const encoder = JsonEncoder.withIndent('  ');
  final manifestJson = manifest.toManifestJson(main: './out/bootstrap.cjs');
  return <String, String>{
    'host/lib/generated/vscode_runtime.g.dart': runtimeTemplate(extensionKey),
    'host/lib/generated/host_exports.g.dart': hostExportsTemplate(
      dartExtensionId: jsonEncode(extensionId),
      extensionKey: extensionKey,
    ),
    'host/bootstrap.cjs': bootstrapTemplate(
      javaScriptExtensionKey: jsonEncode(extensionKey),
    ),
    'package.json': '${encoder.convert(manifestJson)}\n',
  };
}

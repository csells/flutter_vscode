/// The typed view-protocol contract between Host Dart and the treemap
/// Flutter View: one operation returning a coverage snapshot.
library;

import 'package:coverage_treemap_shared/lcov.dart';

/// Operation name for requesting the current coverage snapshot.
const coverageSnapshotOperationName = 'coverageTreemap.getSnapshot';

/// One node of the protocol-safe coverage tree.
///
/// A file node has no [children]; a directory node aggregates its
/// subtree's counts.
final class CoverageNode {
  /// Creates a snapshot node.
  const CoverageNode({
    required this.name,
    required this.linesFound,
    required this.linesHit,
    this.children = const [],
    this.isFile = false,
  });

  /// Builds the node tree for [directory].
  factory CoverageNode.fromDirectory(LcovDirectory directory) => CoverageNode(
        name: directory.name,
        linesFound: directory.linesFound,
        linesHit: directory.linesHit,
        children: [
          for (final child in directory.directories)
            CoverageNode.fromDirectory(child),
          for (final file in directory.files)
            CoverageNode(
              name: file.name,
              linesFound: file.linesFound,
              linesHit: file.linesHit,
              isFile: true,
            ),
        ],
      );

  /// Final path segment for display.
  final String name;

  /// Instrumented lines in this subtree.
  final int linesFound;

  /// Executed lines in this subtree.
  final int linesHit;

  /// Child nodes; empty for files.
  final List<CoverageNode> children;

  /// Whether this node is a file rather than a directory.
  final bool isFile;

  /// Covered fraction in [0, 1].
  double get coverage => linesFound == 0 ? 0 : linesHit / linesFound;
}

/// The full snapshot the host serves to the view.
final class CoverageSnapshot {
  /// Creates a snapshot.
  const CoverageSnapshot({required this.lcovPath, required this.root});

  /// Builds a snapshot from a parsed [report].
  factory CoverageSnapshot.fromReport(String lcovPath, LcovReport report) =>
      CoverageSnapshot(
        lcovPath: lcovPath,
        root: CoverageNode.fromDirectory(report.tree),
      );

  /// Workspace-relative path of the parsed tracefile.
  final String lcovPath;

  /// Root of the coverage tree.
  final CoverageNode root;
}

/// Encodes a snapshot request; the operation takes no arguments.
Object? encodeSnapshotRequest(void request) => null;

/// Decodes a snapshot request; the operation takes no arguments.
void decodeSnapshotRequest(Object? value) {
  if (value != null) {
    throw const FormatException('The snapshot request carries no arguments.');
  }
}

/// Encodes [snapshot] as a protocol-safe value.
Object? encodeCoverageSnapshot(CoverageSnapshot snapshot) => <String, Object?>{
      'lcovPath': snapshot.lcovPath,
      'root': _encodeNode(snapshot.root),
    };

Object? _encodeNode(CoverageNode node) => <String, Object?>{
      'name': node.name,
      'linesFound': node.linesFound,
      'linesHit': node.linesHit,
      'isFile': node.isFile,
      'children': [for (final child in node.children) _encodeNode(child)],
    };

/// Validates and decodes the exact snapshot schema.
CoverageSnapshot decodeCoverageSnapshot(Object? value) {
  if (value case <Object?, Object?>{
    'lcovPath': final String lcovPath,
    'root': final Object? root,
  } when value.length == 2) {
    return CoverageSnapshot(lcovPath: lcovPath, root: _decodeNode(root));
  }
  throw const FormatException('Malformed coverage snapshot.');
}

CoverageNode _decodeNode(Object? value) {
  if (value case <Object?, Object?>{
    'name': final String name,
    'linesFound': final int linesFound,
    'linesHit': final int linesHit,
    'isFile': final bool isFile,
    'children': final List<Object?> children,
  } when value.length == 5) {
    return CoverageNode(
      name: name,
      linesFound: linesFound,
      linesHit: linesHit,
      isFile: isFile,
      children: [for (final child in children) _decodeNode(child)],
    );
  }
  throw const FormatException('Malformed coverage node.');
}

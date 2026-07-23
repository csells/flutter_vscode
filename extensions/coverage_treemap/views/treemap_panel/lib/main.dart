/// The coverage treemap Flutter View for the coverage_treemap extension.
library;

import 'dart:async';

import 'package:coverage_treemap_shared/view_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vscode/view.dart';
import 'package:treemap_panel/treemap.dart';

/// The typed view-protocol operation that fetches the coverage snapshot
/// from Host Dart.
const snapshotOperation = ViewOperation<void, CoverageSnapshot>(
  name: coverageSnapshotOperationName,
  encodeArguments: encodeSnapshotRequest,
  decodeArguments: decodeSnapshotRequest,
  encodeResult: encodeCoverageSnapshot,
  decodeResult: decodeCoverageSnapshot,
);

/// Runs the coverage treemap view.
void main() => runApp(const TreemapApp());

/// Dark-themed root widget for the coverage treemap panel.
class TreemapApp extends StatelessWidget {
  /// Creates the root widget.
  const TreemapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coverage Treemap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF35793D),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: treemapSurfaceColor,
      ),
      home: const _TreemapPage(),
    );
  }
}

class _TreemapPage extends StatefulWidget {
  const _TreemapPage();

  @override
  State<_TreemapPage> createState() => _TreemapPageState();
}

class _TreemapPageState extends State<_TreemapPage> {
  FlutterViewSession? _session;
  CoverageSnapshot? _snapshot;
  List<CoverageNode> _path = const [];
  CoverageNode? _selectedFile;
  Object? _error;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      var session = _session;
      session ??= await VSCodeViewBootstrap.acquire().connect();
      _session = session;
      final snapshot = await snapshotOperation.call(session, null);
      if (!mounted) {
        return;
      }
      setState(() {
        _snapshot = snapshot;
        _path = _rebasePath(snapshot.root);
        _selectedFile = null;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  /// Re-resolves the current drill-down path against a fresh [newRoot],
  /// keeping the deepest prefix whose directory names still exist.
  List<CoverageNode> _rebasePath(CoverageNode newRoot) {
    final path = [newRoot];
    for (final previous in _path.skip(1)) {
      CoverageNode? match;
      for (final child in path.last.children) {
        if (!child.isFile && child.name == previous.name) {
          match = child;
          break;
        }
      }
      if (match == null) {
        break;
      }
      path.add(match);
    }
    return path;
  }

  void _refresh() => unawaited(_load());

  void _handleNodeTap(CoverageNode node) {
    setState(() {
      if (node.isFile) {
        _selectedFile = node;
      } else {
        _path = [..._path, node];
        _selectedFile = null;
      }
    });
  }

  void _navigateTo(int index) {
    setState(() {
      _path = _path.sublist(0, index + 1);
      _selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final error = _error;
    if (error != null) {
      return _ErrorPanel(error: error, onRetry: _refresh);
    }
    final snapshot = _snapshot;
    if (snapshot == null || _path.isEmpty) {
      return const _EmptyPanel(isRoot: true);
    }
    final current = _path.last;
    final hasTiles = current.children.any((child) => child.linesFound > 0);
    return Column(
      children: [
        _HeaderBar(
          path: _path,
          lcovPath: snapshot.lcovPath,
          selectedFile: _selectedFile,
          onNavigate: _navigateTo,
          onRefresh: _refresh,
        ),
        Expanded(
          child: hasTiles
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: TreemapView(
                    nodes: current.children,
                    onNodeTap: _handleNodeTap,
                  ),
                )
              : _EmptyPanel(isRoot: _path.length == 1),
        ),
      ],
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.path,
    required this.lcovPath,
    required this.selectedFile,
    required this.onNavigate,
    required this.onRefresh,
  });

  final List<CoverageNode> path;
  final String lcovPath;
  final CoverageNode? selectedFile;
  final ValueChanged<int> onNavigate;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final current = path.last;
    final file = selectedFile;
    final subtitle = file == null
        ? lcovPath
        : '${file.name} — ${coveragePercent(file.coverage, decimals: 1)} '
              '(${file.linesHit}/${file.linesFound} lines)';
    return ColoredBox(
      color: const Color(0xFF252526),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _Breadcrumb(path: path, onNavigate: onNavigate),
                ),
                const SizedBox(width: 12),
                Text(
                  coveragePercent(current.coverage, decimals: 1),
                  style: const TextStyle(
                    color: Color(0xFFF2F2F2),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onRefresh,
                  child: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF9D9D9D), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.path, required this.onNavigate});

  final List<CoverageNode> path;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final crumbs = <Widget>[];
    for (var i = 0; i < path.length; i++) {
      final isLast = i == path.length - 1;
      final name = i == 0 ? 'root' : path[i].name;
      if (i > 0) {
        crumbs.add(
          const Text(
            ' › ',
            style: TextStyle(color: Color(0xFF6E6E6E), fontSize: 13),
          ),
        );
      }
      crumbs.add(
        isLast
            ? Text(
                name,
                style: const TextStyle(
                  color: Color(0xFFF2F2F2),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              )
            : InkWell(
                onTap: () => onNavigate(i),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF6FB1E8),
                    fontSize: 13,
                  ),
                ),
              ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(children: crumbs),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Could not load coverage',
                style: TextStyle(
                  color: Color(0xFFF2F2F2),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF9D9D9D), fontSize: 12),
              ),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.isRoot});

  final bool isRoot;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        isRoot
            ? 'No coverage data — run your tests with coverage'
            : 'This directory has no measurable coverage',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF9D9D9D), fontSize: 13),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:math';

import 'package:coverage_treemap_host/generated/view_protocol.g.dart';
import 'package:coverage_treemap_host/generated/vscode_facade.g.dart';
import 'package:coverage_treemap_host/generated/vscode_parity_layer.g.dart'
    as parity;
import 'package:coverage_treemap_host/host_webview_transport.dart';
import 'package:coverage_treemap_shared/lcov.dart';
import 'package:coverage_treemap_shared/view_contract.dart';

const _snapshotOperation = ViewOperation<void, CoverageSnapshot>(
  name: coverageSnapshotOperationName,
  encodeArguments: encodeSnapshotRequest,
  decodeArguments: decodeSnapshotRequest,
  encodeResult: encodeCoverageSnapshot,
  decodeResult: decodeCoverageSnapshot,
);

const _lcovRelativePath = 'coverage/lcov.info';

@JSExport()
class _Extension {
  _CoverageController? _controller;

  JSPromise<JSAny?> activate(JSObject rawContext, JSObject rawVscode) {
    final controller = _CoverageController(
      ExtensionContext.fromJS(rawContext),
      VSCode.fromJS(rawVscode),
      parity.VscodeApi(rawVscode),
    );
    _controller = controller;
    return toHostPromise(controller.start());
  }

  JSPromise<JSAny?> deactivate() {
    final controller = _controller;
    _controller = null;
    return toHostPromise(
      Future<JSAny?>(() async {
        await controller?.closePanelSession();
        return null;
      }),
    );
  }
}

final class _CoverageController {
  _CoverageController(this._context, this._vscode, this._api);

  final ExtensionContext _context;
  final VSCode _vscode;
  final parity.VscodeApi _api;

  late final parity.TextEditorDecorationType _coveredType;
  late final parity.TextEditorDecorationType _uncoveredType;
  late final parity.StatusBarItem _statusBar;
  LcovReport? _report;
  var _highlightsEnabled = true;
  var _panelOpen = false;
  HostViewSession? _session;
  HostWebviewTransport? _transport;

  Future<JSAny?> start() async {
    _coveredType = _lineDecoration('diffEditor.insertedTextBackground');
    _uncoveredType = _lineDecoration('diffEditor.removedTextBackground');
    _statusBar =
        _api.window.createStatusBarItem$2(_api.StatusBarAlignment.Left, 100);

    _registerCommand('coverage-treemap.refresh', () async {
      await _refresh();
      return null;
    });
    _registerCommand('coverage-treemap.toggleLineHighlights', () async {
      _highlightsEnabled = !_highlightsEnabled;
      _decorateActiveEditor();
      return null;
    });
    _registerCommand('coverage-treemap.showTreemap', () async {
      await _openPanel();
      return null;
    });
    _registerCommand('coverage-treemap.smoke', () async {
      await _refresh();
      final report = _report;
      final payload = report == null
          ? null
          : encodeCoverageSnapshot(
              CoverageSnapshot.fromReport(_lcovRelativePath, report),
            );
      return jsonEncode(payload).toJS;
    });

    final watcher =
        _api.workspace.createFileSystemWatcher('**/$_lcovRelativePath'.toJS);
    _subscribeParity(watcher);
    _subscribeParity(watcher.onDidChange.call(_refreshListener));
    _subscribeParity(watcher.onDidCreate.call(_refreshListener));
    _subscribeParity(watcher.onDidDelete.call(_refreshListener));
    _subscribeParity(
      _api.window.onDidChangeActiveTextEditor.call(
        ((JSAny? _) => _decorateActiveEditor()).toJS,
      ),
    );

    await _refresh();
    return null;
  }

  /// Closes the view session resources when the panel or extension ends.
  Future<void> closePanelSession() async {
    final session = _session;
    final transport = _transport;
    _session = null;
    _transport = null;
    _panelOpen = false;
    await session?.close();
    await transport?.close();
  }

  JSFunction get _refreshListener =>
      ((JSAny? _) => unawaited(_refresh())).toJS;

  void _registerCommand(String name, Future<JSAny?> Function() body) {
    _context.subscriptions.toDart.add(
      _vscode.commands.registerCommandCallback(
        name.toJS,
        (() => toHostPromise(Future<JSAny?>(body))).toJS,
      ),
    );
  }

  void _subscribeParity(JSObject registration) {
    _context.addSubscription(DisposableLike.fromJS(registration));
  }

  Future<void> _refresh() async {
    final content = await _readLcov();
    if (content == null) {
      _report = null;
      _statusBar
        ..text = r'$(beaker) Cov: no data'
        ..show();
      _decorateActiveEditor();
      return;
    }
    try {
      _report = parseLcov(content);
    } on FormatException catch (error) {
      _report = null;
      _api.window.showErrorMessage(
        'Coverage Treemap could not parse $_lcovRelativePath: '
                '${error.message}'
            .toJS,
      );
    }
    final report = _report;
    if (report != null) {
      final percent = (report.coverage * 100).toStringAsFixed(1);
      _statusBar
        ..text = '\$(beaker) Cov $percent%'
        ..show();
    }
    _decorateActiveEditor();
  }

  Future<String?> _readLcov() async {
    final folders = _api.workspace.workspaceFolders?.toDart;
    if (folders == null || folders.isEmpty) {
      return null;
    }
    final uri = _api.Uri.joinPath(
      folders.first.uri,
      ['coverage'.toJS, 'lcov.info'.toJS],
    );
    try {
      final bytes = await _api.workspace.fs.readFile(uri).toDart;
      return utf8.decode(bytes.toDart);
    } on Object {
      // A missing or unreadable coverage file is a normal state.
      return null;
    }
  }

  void _decorateActiveEditor() {
    final editor = _api.window.activeTextEditor;
    if (editor == null) {
      return;
    }
    final report = _report;
    final covered = <parity.Range>[];
    final uncovered = <parity.Range>[];
    if (report != null && _highlightsEnabled) {
      final relative = _api.workspace.asRelativePath(editor.document.uri);
      for (final file in report.files) {
        if (file.path != relative) {
          continue;
        }
        for (final entry in file.lineHits.entries) {
          final line = entry.key - 1;
          if (line < 0) {
            continue;
          }
          final range =
              _api.Range.new$$2(line.toJS, 0.toJS, line.toJS, 0.toJS);
          (entry.value > 0 ? covered : uncovered).add(range);
        }
        break;
      }
    }
    editor
      ..setDecorations(_coveredType, covered.toJS)
      ..setDecorations(_uncoveredType, uncovered.toJS);
  }

  Future<void> _openPanel() async {
    if (_panelOpen) {
      return;
    }
    final sessionId = _secureToken();
    final bootstrapNonce = _secureToken();
    var viewRoot = _context.extensionRootUri;
    for (final segment in ['out', 'views', 'treemap_panel']) {
      viewRoot = joinHostUriPath(viewRoot, segment.toJS);
    }
    final panel = _vscode.windowApi.createFlutterViewPanel(
      viewType: 'coverageTreemap.panel',
      title: 'Coverage Treemap',
      localResourceRoots: [viewRoot],
    );
    _panelOpen = true;
    final transport = HostWebviewTransport(panel.webviewSurface);
    _transport = transport;
    _session = HostViewSession.connect(
      transport: transport,
      sessionId: sessionId,
      bootstrapNonce: bootstrapNonce,
      operations: [
        _snapshotOperation.bind((_) async {
          await _refresh();
          final report = _report;
          if (report == null) {
            throw StateError(
              'No coverage data at $_lcovRelativePath. Run your tests '
              'with coverage first.',
            );
          }
          return CoverageSnapshot.fromReport(_lcovRelativePath, report);
        }),
      ],
    );
    panel.webviewSurface.htmlText = _viewHtml(
      webview: panel.webviewSurface,
      viewRoot: viewRoot,
      sessionId: sessionId,
      bootstrapNonce: bootstrapNonce,
    );
  }

  parity.TextEditorDecorationType _lineDecoration(String colorId) {
    final themable = parity.ThemableDecorationRenderOptions.lit$(
      backgroundColor: _api.ThemeColor.new$(colorId.toJS),
    );
    return _api.window.createTextEditorDecorationType(
      parity.DecorationRenderOptions(themable)..isWholeLine = true,
    );
  }
}

String _secureToken() {
  final random = Random.secure();
  return List.generate(32, (_) => random.nextInt(16).toRadixString(16)).join();
}

String _viewHtml({
  required Webview webview,
  required Uri viewRoot,
  required String sessionId,
  required String bootstrapNonce,
}) {
  final base = webview.asFlutterViewUri(viewRoot).toDartString();
  final bootstrap = webview
      .asFlutterViewUri(joinHostUriPath(viewRoot, 'flutter_bootstrap.js'.toJS))
      .toDartString();
  final csp = webview.contentSecurityPolicySource;
  return '''
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="Content-Security-Policy" content="default-src 'none'; img-src $csp data:; font-src $csp; style-src $csp 'unsafe-inline'; script-src $csp 'wasm-unsafe-eval'; connect-src $csp; worker-src $csp blob:">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="flutter-vscode-session" content="$sessionId">
  <meta name="flutter-vscode-bootstrap-nonce" content="$bootstrapNonce">
  <base href="$base/">
  <title>Coverage Treemap</title>
</head>
<body>
  <script src="$bootstrap"></script>
</body>
</html>
''';
}

void main() {
  registerHostExports(createJSInteropWrapper(_Extension()));
}

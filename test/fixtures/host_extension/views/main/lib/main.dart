import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_vscode/view.dart';
import 'package:flutter_vscode_host_fixture_shared/fixture_view_contract.dart';

const _readHostValueOperation = ViewOperation<ReadHostValueRequest, String>(
  name: readHostValueOperationName,
  encodeArguments: encodeReadHostValueRequest,
  decodeArguments: decodeReadHostValueRequest,
  encodeResult: encodeReadHostValueResult,
  decodeResult: decodeReadHostValueResult,
);

void main() => runApp(const _FixtureView());

class _FixtureView extends StatefulWidget {
  const _FixtureView();

  @override
  State<_FixtureView> createState() => _FixtureViewState();
}

class _FixtureViewState extends State<_FixtureView> {
  late final VSCodeViewBootstrap _bootstrap;
  var _text = 'Connecting to Host Dart…';

  @override
  void initState() {
    super.initState();
    try {
      _bootstrap = VSCodeViewBootstrap.acquire();
      _observeRun(_run());
    } on Object catch (error) {
      _showError(error);
    }
  }

  Future<void> _run() async {
    FlutterViewSession? session;
    Object? firstError;
    StackTrace? firstStackTrace;

    Future<void> preserveFirstError(FutureOr<void> Function() action) async {
      try {
        await action();
      } on Object catch (error, stackTrace) {
        firstError ??= error;
        firstStackTrace ??= stackTrace;
      }
    }

    try {
      final connectedSession = await _bootstrap.connect();
      session = connectedSession;
      final value = await _readHostValueOperation.call(
        connectedSession,
        const ReadHostValueRequest('greeting'),
      );
      if (!mounted) {
        return;
      }

      final rendered = Completer<void>();
      setState(() => _text = value);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          connectedSession.reportRendered(value);
          rendered.complete();
        } on Object catch (error, stackTrace) {
          rendered.completeError(error, stackTrace);
        }
      });
      await rendered.future;
      await connectedSession.closed;
    } on Object catch (error, stackTrace) {
      firstError = error;
      firstStackTrace = stackTrace;
    } finally {
      final connectedSession = session;
      if (connectedSession != null) {
        await preserveFirstError(connectedSession.close);
        await preserveFirstError(() async {
          await connectedSession.closed;
        });
      }
      await preserveFirstError(_bootstrap.close);
    }
    if (firstError != null) {
      Error.throwWithStackTrace(firstError!, firstStackTrace!);
    }
  }

  void _observeRun(Future<void> run) {
    unawaited(
      run.then<void>(
        (_) {},
        onError: (Object error, StackTrace _) {
          try {
            _showError(error);
          } on Object {
            // The State is already gone; the asynchronous failure is observed.
          }
        },
      ),
    );
  }

  void _showError(Object error) {
    if (mounted) {
      setState(() => _text = 'Flutter View failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF1E1E1E),
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            _text,
            key: const ValueKey('host-value'),
            style: const TextStyle(color: Color(0xFFF3F3F3), fontSize: 18),
          ),
        ),
      ),
    );
  }
}

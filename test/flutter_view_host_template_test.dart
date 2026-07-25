import 'dart:io';

import 'package:flutter_vscode/src/cli/flutter_view_host_source.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterViewHost template interface', () {
    test('open() accepts the production injection points', () {
      expect(
        flutterViewHostSource,
        contains('List<String> extraHead = const [],'),
        reason: 'authors inject trusted head fragments (config metas, '
            'nonce-carrying scripts) without owning the view HTML',
      );
      expect(
        flutterViewHostSource,
        contains('String? scriptNonce,'),
        reason: 'inline head scripts need a CSP nonce to execute',
      );
      expect(
        flutterViewHostSource,
        contains('IncomingViewMessageObserver? onIncomingMessage,'),
        reason: 'the existing transport observer must be reachable '
            'through open()',
      );
    });

    test('the host exposes cold-start and reload seams', () {
      expect(
        flutterViewHostSource,
        contains('final DateTime loadStartedAt;'),
        reason: 'cold-start measurement starts the instant the initial '
            'HTML is handed to the webview',
      );
      expect(
        flutterViewHostSource,
        contains('void reload()'),
        reason: 'reloading the running view document in place is a '
            'host-owned capability',
      );
      expect(
        flutterViewHostSource,
        contains('flutter-vscode-reload-generation'),
        reason: 'each reloaded document must be distinct so the webview '
            'always applies it',
      );
    });

    test('the HTML factory carries the nonce and generation inputs', () {
      expect(flutterViewHostSource, contains(r"'nonce-$scriptNonce'"));
      expect(flutterViewHostSource, contains('int reloadGeneration = 0,'));
    });

    test('the checked-in Host fixture module mirrors the template', () {
      expect(
        File(
          'test/fixtures/host_extension/host/lib/generated/'
          'flutter_view_host.g.dart',
        ).readAsStringSync(),
        flutterViewHostSource,
        reason: 'Rebuild the fixture (scripts/build_host_fixture.sh) after '
            'changing the template.',
      );
    });
  });
}

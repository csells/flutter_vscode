import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vscode_example/example_app.dart';

void main() {
  testWidgets('renders example app chrome and primary action', (tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('Flutter VS Code Example'), findsOneWidget);
    expect(find.text('Show Input Box'), findsOneWidget);
    expect(find.text('Show Quick Pick'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}

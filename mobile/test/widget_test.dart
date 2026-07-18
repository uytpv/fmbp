import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fmbp/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App theme and basic initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FMBPApp(),
      ),
    );

    // Verify that the title is loaded in MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

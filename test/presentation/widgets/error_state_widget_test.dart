import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister/presentation/widgets/error_state_widget.dart';

void main() {
  testWidgets(
      'Given error message, When rendered, Then shows icon, text and Retry button',
      (WidgetTester tester) async {
    const errorMessage = 'Something went wrong';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorStateWidget(
            message: errorMessage,
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('When Retry button is tapped, Then onRetry callback is invoked',
      (WidgetTester tester) async {
    var retryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorStateWidget(
            message: 'Test Error',
            onRetry: () => retryCalled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(retryCalled, isTrue);
  });
}

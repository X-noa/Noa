import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noa/screens/chat_screen.dart';
import 'package:noa/widgets/safety_modal.dart';

void main() {
  testWidgets('Safety modal is shown when risk threshold is met', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ChatScreen()));
    await tester.pumpAndSettle(); // Wait for microcopy to load

    // Verify that the initial message is shown.
    expect(find.text('Hey — how are you feeling right now? Talk or try a quick exercise?'), findsOneWidget);

    // Tap the button to trigger the safety modal
    await tester.tap(find.byIcon(Icons.warning));
    await tester.pumpAndSettle();

    // The safety modal should now be visible.
    expect(find.byType(SafetyModal), findsOneWidget);
    expect(find.text('I’m worried about you'), findsOneWidget);
  });
}

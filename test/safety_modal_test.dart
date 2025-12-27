import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noa/screens/chat_screen.dart';
import 'package:noa/widgets/safety_modal.dart';

void main() {
  testWidgets('Safety modal is shown when risk threshold is met', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ChatScreen()));

    // Verify that the initial message is shown.
    expect(find.text('Hey — how are you feeling right now?'), findsOneWidget);

    // Enter a message in the text field and send it.
    await tester.enterText(find.byType(TextField), 'I am feeling really down.');
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    // The safety modal should now be visible.
    expect(find.byType(SafetyModal), findsOneWidget);
    expect(find.text('I’m worried about you.'), findsOneWidget);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictacgo/board.dart';
import 'package:tictacgo/game.dart';

import 'package:tictacgo/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets("All variables are set to their correct default values",
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyGame());

    // Because the host goes first, the text should say "It's your turn!"
    expect(find.text("It's your turn!"), findsOneWidget);

    // Tap a button and trigger a frame.
    await tester.tap(find.byKey(const Key("0, 0")));
    await tester.pumpAndSettle();

    // Because a button has been pressed, it should now be the opponent's turn.
    expect(find.text("It's your opponent's turn!"), findsOneWidget);
  });

  testWidgets("X's and O's show up correctly.", (WidgetTester tester) async {
    (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyGame());

      // Tap a button and trigger a frame.
      await tester.tap(find.byKey(const Key("0, 0")));
      await tester.pumpAndSettle();

      // Expect to find an "X" after tapping a button to make one appear.
      expect(find.text("X"), findsOneWidget);

      // Taps another button and triggers a frame.
      await tester.tap(find.byKey(const Key("0, 1")));
      await tester.pumpAndSettle();

      // Expect to find an "O" after previously tapping a button.
      expect(find.text("O"), findsOneWidget);
    };
  });
}

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
  testWidgets("All variables are set to their correct default values",
      (WidgetTester tester) async {
    // Builds the app.
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
      // Builds the app.
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

  testWidgets("turnText switches appropriately.", (WidgetTester tester) async {
    // Builds the app.
    await tester.pumpWidget(const MyGame());

    // Ensures that once the game has started, text is displayed that shows it is your turn.
    expect(find.byKey(const Key("Your Turn Text")), findsOneWidget);

    // Taps a button and trigger a frame.
    await tester.tap(find.byKey(const Key("0, 0")));
    await tester.pump();

    // Now that the host has made a move, text should display that it is the opponent's turn.
    expect(find.byKey(const Key("Opponent Turn Text")), findsOneWidget);
  });

  testWidgets("The game can be won and the Play Again Button is functional",
      (WidgetTester tester) async {
    // Builds the app.
    await tester.pumpWidget(const MyGame());

    // Creates gameScreenState to ensure Play Again Button sets all spaces to Neutral.
    GameScreenState gameScreenState = GameScreenState();

    // When the game has not been finished, the Play Again Button should not be able to be pressed.
    expect(find.byKey(const Key("Inactive Play Again Button")), findsOneWidget);

    // Puts an "X" at the 0, 0 space and triggers a frame.
    await tester.tap(find.byKey(const Key("0, 0")));
    await tester.pump();

    // Sets the hostsTurn back to true.
    await tester.tap(find.byKey(const Key("0, 0")));
    await tester.pump();

    // Puts an "X" at the 0, 1 space and triggers a frame.
    await tester.tap(find.byKey(const Key("1, 0")));
    await tester.pump();

    // Sets hostsTurn back to true.
    await tester.tap(find.byKey(const Key("1, 0")));
    await tester.pump();

    // Puts an "X" at the 0, 2 space and triggers a frame.
    await tester.tap(find.byKey(const Key("2, 0")));
    await tester.pump();

    // Now that the game has been won by the host, turnText should say "You won!"
    expect(find.byKey(const Key("You Won Turn Text")), findsOneWidget);

    // Now that the game has been finished, the Play Again Button should be active.
    expect(find.byKey(const Key("Active Play Again Button")), findsOneWidget);

    // Taps the Play Again Button and resets the board to all Neutral spaces.
    await tester.tap(find.byKey(const Key("Active Play Again Button")));
    await tester.pumpAndSettle();

    // Ensures that the game's board has been reset and that the Play Again
    // Button is once again Inactive.
    expect(gameScreenState.boardStates[0][0], States.neutral);
    expect(find.byKey(const Key("Inactive Play Again Button")), findsOneWidget);
  });
}

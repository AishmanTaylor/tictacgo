import 'package:flutter/material.dart';

enum States { X, O, neutral } // all possible states a square can have

TextStyle style = const TextStyle(color: Colors.black, fontSize: 75);
TextStyle turnTextStyle = const TextStyle(color: Colors.black, fontSize: 25);
Text activeX = Text("X", style: style);
Text activeO = Text("O", style: style);
Text activeNeutral = Text("", style: style);
Text turnText = Text("", style: turnTextStyle);

int nrows = 3; // number of rows in 3x3 2D array
int ncols = 3; // number of columns in 3x3 2D array
var boardStates = List.generate(
    nrows,
    (i) => List.generate(
        ncols,
        (j) => States
            .neutral)); // 2D array of every square's state; all begin neutral

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  bool hostsTurn = true;
  bool gameWon = false;
  int turnCounter = 0;

  void _updateTurnText() {
    // handles whose turn it is and if player has won or lost
    if (_checkWon(States.X) || _checkWon(States.O)) {
      setState(() {
        gameWon = true;
      });
    }
    if (!gameWon) {
      if (hostsTurn) {
        setState(() {
          turnText = Text("It's your turn!", style: turnTextStyle);
        });
      } else {
        setState(() {
          turnText = Text("It's your opponent's turn!", style: turnTextStyle);
        });
      }
    } else {
      if (turnCounter >= 9) {
        turnText = Text("It's a tie!", style: turnTextStyle);
      } else {
        if (hostsTurn) {
          setState(() {
            turnText = Text("You lost!", style: turnTextStyle);
          });
        } else {
          setState(() {
            turnText = Text("You won!", style: turnTextStyle);
          });
        }
      }
    }
  }

  void _processTurn(int i, int j) {
    // handles how turns are dealt with
    setState(() {
      _calcState(i, j);
      _updateTurnText();
      hostsTurn = !hostsTurn;
      turnCounter++;
    });
  }

  void _calcState(int i, int j) {
    if ((boardStates[i][j] == States.neutral) && (hostsTurn == true)) {
      setState(() {
        boardStates[i][j] = States.X;
      });
    } else if ((boardStates[i][j] == States.neutral) && (hostsTurn == false)) {
      setState(() {
        boardStates[i][j] = States.O;
      });
    }
  }

  bool _checkWon(States goalState) {
    if (boardStates[0][0] == goalState &&
        boardStates[0][1] == goalState &&
        boardStates[0][2] == goalState) {
      // 1st row
      return true;
    } else if (boardStates[0][0] == goalState &&
        boardStates[1][0] == goalState &&
        boardStates[2][0] == goalState) {
      // 1st column
      return true;
    } else if (boardStates[0][0] == goalState &&
        boardStates[1][1] == goalState &&
        boardStates[2][2] == goalState) {
      // diagonal left to right
      return true;
    } else if (boardStates[1][0] == goalState &&
        boardStates[1][1] == goalState &&
        boardStates[1][2] == goalState) {
      // 2nd row
      return true;
    } else if (boardStates[2][0] == goalState &&
        boardStates[2][1] == goalState &&
        boardStates[2][2] == goalState) {
      // 3rd row
      return true;
    } else if (boardStates[0][1] == goalState &&
        boardStates[1][1] == goalState &&
        boardStates[2][1] == goalState) {
      // 2nd column
      return true;
    } else if (boardStates[0][2] == goalState &&
        boardStates[1][2] == goalState &&
        boardStates[2][2] == goalState) {
      // 3rd column
      return true;
    } else if (boardStates[0][2] == goalState &&
        boardStates[1][1] == goalState &&
        boardStates[2][0] == goalState) {
      // diagonal right to left
      return true;
    } else if (turnCounter == 9) {
      return true;
    }
    return false;
  }

  ElevatedButton _displayPlayAgainButton() {
    if (gameWon == false) {
      return const ElevatedButton(onPressed: null, child: Text("Play Again?"));
    } else {
      return ElevatedButton(
          onPressed: _playAgainButton, child: const Text("Play Again?"));
    }
  }

  void _playAgainButton() {
    for (int i = 0; i < boardStates.length; i++) {
      for (int j = 0; j < boardStates.length; j++) {
        setState(() {
          boardStates[i][j] = States.neutral;
          gameWon = false;
          hostsTurn = true;
          turnCounter = 0;
        });
      }
    }
  }

  Text _displayState(int i, int j) {
    if (boardStates[i][j] == States.X) {
      return activeX;
    } else if (boardStates[i][j] == States.O) {
      return activeO;
    } else {
      return activeNeutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateTurnText();
    double topInset = 20; // inset for padding spacing only for the top
    double leftInset = 39; // inset for padding spacing only for the left side
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 30), child: turnText),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _displayPlayAgainButton()),
            Container(
                color: Colors.white,
                height: 350,
                width: 350,
                child: CustomPaint(
                  foregroundPainter:
                      LinePainter(), // displays tic-tac-toe board
                  child: Column(children: [
                    // all the buttons and whatnot
                    Row(children: [
                      Padding(
                          padding:
                              EdgeInsets.only(top: topInset, left: leftInset),
                          child: TextButton(
                              key: const Key("0, 0"),
                              onPressed: () => _processTurn(0, 0),
                              child: _displayState(0, 0))),
                      Padding(
                          padding:
                              EdgeInsets.only(top: topInset, left: leftInset),
                          child: TextButton(
                              key: const Key("0, 1"),
                              onPressed: () => _processTurn(0, 1),
                              child: _displayState(0, 1))),
                      Padding(
                          padding:
                              EdgeInsets.only(top: topInset, left: leftInset),
                          child: TextButton(
                              onPressed: () => _processTurn(0, 2),
                              child: _displayState(0, 2)))
                    ]),
                    Row(children: [
                      Padding(
                          padding: EdgeInsets.only(left: leftInset),
                          child: TextButton(
                              onPressed: () => _processTurn(1, 0),
                              child: _displayState(1, 0))),
                      Padding(
                          padding: EdgeInsets.only(left: leftInset),
                          child: TextButton(
                              onPressed: () => _processTurn(1, 1),
                              child: _displayState(1, 1))),
                      Padding(
                          padding: EdgeInsets.only(left: leftInset),
                          child: TextButton(
                              onPressed: () => _processTurn(1, 2),
                              child: _displayState(1, 2)))
                    ]),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: leftInset),
                            child: TextButton(
                                onPressed: () => _processTurn(2, 0),
                                child: _displayState(2, 0))),
                        Padding(
                            padding: EdgeInsets.only(left: leftInset),
                            child: TextButton(
                                onPressed: () => _processTurn(2, 1),
                                child: _displayState(2, 1))),
                        Padding(
                            padding: EdgeInsets.only(left: leftInset),
                            child: TextButton(
                                onPressed: () => _processTurn(2, 2),
                                child: _displayState(2, 2)))
                      ],
                    )
                  ]),
                ))
          ],
        ),
      ),
    ));
  }
}

class LinePainter extends CustomPainter {
  // creates the tic-tac-toe board
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 4; // sets width of lines

    // top horizontal line
    canvas.drawLine(Offset(size.width * 1 / 12, size.height * 1 / 3),
        Offset(size.width * 11 / 12, size.height * 1 / 3), paint);

    // bottom horizontal line
    canvas.drawLine(Offset(size.width * 1 / 12, size.height * 2 / 3),
        Offset(size.width * 11 / 12, size.height * 2 / 3), paint);

    // left vertical line
    canvas.drawLine(Offset(size.width * 1 / 3, size.height * 1 / 12),
        Offset(size.width * 1 / 3, size.height * 11 / 12), paint);

    // right vertical line
    canvas.drawLine(Offset(size.width * 2 / 3, size.height * 1 / 12),
        Offset(size.width * 2 / 3, size.height * 11 / 12), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

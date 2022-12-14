import 'package:flutter/material.dart';

import 'friends_data.dart';

//enum States { X, O, neutral } // all possible states a square can have
final States = ['X', 'O', 'neutral'];

TextStyle style = const TextStyle(color: Colors.black, fontSize: 75);
TextStyle turnTextStyle = const TextStyle(color: Colors.black, fontSize: 25);
Text activeX = Text("X", style: style);
Text activeO = Text("O", style: style);
Text activeNeutral = Text("", style: style);
Text turnText = Text("", style: turnTextStyle);

// 2D array of every square's state; all begin neutral
var boardStates = List.generate(3, (i) => List.generate(3, (j) => States[2]));

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.friend});

  final Friend? friend;

  @override
  State createState() => GameScreenState();
}

//Creates object for the Game Screen
class GameScreenState extends State<GameScreen> {
  bool hostsTurn = true;
  bool gameWon = false;
  int turnCounter = 0;

  //Handling for if it is your turn or not
  void _updateTurnText() {
    if (_checkWon(States[0]) || _checkWon(States[1])) {
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

  //Handling for sending DONT TOUCH THIS UNDER ANY CIRCUMSTANCE
  Future<void> send(List<dynamic> msg) async {
    print(widget.friend?.ipAddr);
    await widget.friend?.send(msg).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    });
  }

  //Handling for turns
  void _processTurn(int i, int j) {
    setState(() {
      _calcState(i, j);
      _updateTurnText();
      hostsTurn = !hostsTurn;
      turnCounter++;
    });
  }

  //Changes the enum of the cell on the board to X or O
  void _calcState(int i, int j) {
    if ((boardStates[i][j] == States[2]) && (hostsTurn == true)) {
      setState(() {
        boardStates[i][j] = States[0];
        send(boardStates);
      });
    } else if ((boardStates[i][j] == States[2]) && (hostsTurn == false)) {
      setState(() {
        boardStates[i][j] = States[1];
        send(boardStates);
      });
    }
  }

  //Handling to check if there has been three in a row
  bool _checkWon(goalState) {
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

  //Creates play again button
  ElevatedButton _displayPlayAgainButton() {
    if (gameWon == false) {
      return const ElevatedButton(onPressed: null, child: Text("Play Again?"));
    } else {
      return ElevatedButton(
          onPressed: _playAgainButton, child: const Text("Play Again?"));
    }
  }

  //Functionality for play again button
  void _playAgainButton() {
    for (int i = 0; i < boardStates.length; i++) {
      for (int j = 0; j < boardStates.length; j++) {
        setState(() {
          boardStates[i][j] = States[2];
          gameWon = false;
          hostsTurn = true;
          turnCounter = 0;
        });
      }
    }
  }

  //Handling to actually determine if the button should be an X or an O or neutral
  Text _displayState(int i, int j) {
    if (boardStates[i][j] == States[0]) {
      return activeX;
    } else if (boardStates[i][j] == States[1]) {
      return activeO;
    } else {
      return activeNeutral;
    }
  }

  //Builds out the app screen we love GUI :)
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
                  foregroundPainter: LinePainter(),
                  child: Column(children: [
                    Row(children: [
                      Padding(
                          padding:
                              EdgeInsets.only(top: topInset, left: leftInset),
                          child: TextButton(
                              onPressed: () => _processTurn(0, 0),
                              child: _displayState(0, 0))),
                      Padding(
                          padding:
                              EdgeInsets.only(top: topInset, left: leftInset),
                          child: TextButton(
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
                )),
          ],
        ),
      ),
    ));
  }
}

//Generates the 3x3 grid or # for a visual
class LinePainter extends CustomPainter {
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

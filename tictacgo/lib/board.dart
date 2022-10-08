import 'package:flutter/material.dart';

enum States { X, O, neutral } // all possible states a square can have

TextStyle style = const TextStyle(color: Colors.black, fontSize: 75);
Text X = Text("X", style: style);
Text O = Text("O", style: style);
Text neutral = Text("", style: style);

int nrows = 3; // number of rows in 3x3 2D array
int ncols = 3; // number of columns in 3x3 2D array
var boardStates = List.generate(
    nrows,
    (i) => List.generate(
        ncols, (j) => States.neutral)); // 2D array of every square's state

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  bool hostsTurn = true;
  bool firstTurn = true;

  void _changeTurn(int i, int j) {
    firstTurn = false;
    setState(() {
      if ((boardStates[i][j] == States.neutral) && (hostsTurn == true)) {
        boardStates[i][j] == States.X;
      } else if ((boardStates[i][j] == States.neutral) &&
          (hostsTurn == false)) {
        boardStates[i][j] == States.O;
      } else {
        boardStates[i][j] == States.X;
      }
      hostsTurn = !hostsTurn;
    });
  }

  void _calcState(int i, int j) {
    if ((boardStates[i][j] == States.neutral) && (hostsTurn == true)) {
      boardStates[i][j] == States.X;
    } else if ((boardStates[i][j] == States.neutral) && (hostsTurn == false)) {
      boardStates[i][j] == States.O;
    } else {
      boardStates[i][j] == States.X;
    }
  }

  Text _displayState(int i, int j) {
    if (boardStates[i][j] == States.X) {
      return X;
    } else if (boardStates[i][j] == States.O) {
      return O;
    } else {
      return neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    double topInset = 20.0; // inset for padding spacing only for the top
    double leftInsetX = 40;
    double leftInsetO =
        37.3; // inset for padding spacing only for the left side
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                color: Colors.white,
                height: 350,
                width: 350,
                child: CustomPaint(
                  foregroundPainter: LinePainter(),
                  child: Column(children: [
                    Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: topInset,
                              left: hostsTurn ? leftInsetX : leftInsetO),
                          child: TextButton(
                              onPressed: () => _changeTurn(0, 0),
                              child: _displayState(0, 0))),
                      Padding(
                          padding: EdgeInsets.only(
                              top: topInset,
                              left: hostsTurn ? leftInsetX : leftInsetO),
                          child: TextButton(
                              onPressed: () => _changeTurn(0, 1),
                              child: _displayState(0, 1))),
                      Padding(
                          padding: EdgeInsets.only(
                              top: topInset,
                              left: hostsTurn ? leftInsetX : leftInsetO),
                          child: TextButton(
                              onPressed: () => _changeTurn(0, 2),
                              child: _displayState(0, 2)))
                    ]),
                    Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: hostsTurn ? leftInsetX : leftInsetO),
                          child: TextButton(
                              onPressed: () => _changeTurn(1, 0),
                              child: _displayState(1, 0))),
                      Padding(
                          padding: EdgeInsets.only(
                              left: hostsTurn ? leftInsetX : leftInsetO),
                          child: TextButton(
                              onPressed: () => _changeTurn(1, 1),
                              child: _displayState(1, 1))),
                      Padding(
                          padding: EdgeInsets.only(
                              left: hostsTurn ? leftInsetX : leftInsetO),
                          child: TextButton(
                              onPressed: () => _changeTurn(1, 2),
                              child: _displayState(1, 2)))
                    ]),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: hostsTurn ? leftInsetX : leftInsetO),
                            child: TextButton(
                                onPressed: () => _changeTurn(2, 0),
                                child: _displayState(2, 0))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: hostsTurn ? leftInsetX : leftInsetO),
                            child: TextButton(
                                onPressed: () => _changeTurn(2, 1),
                                child: _displayState(2, 1))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: hostsTurn ? leftInsetX : leftInsetO),
                            child: TextButton(
                                onPressed: () => _changeTurn(2, 2),
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

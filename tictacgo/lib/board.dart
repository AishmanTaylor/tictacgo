import 'package:flutter/material.dart';

enum States { X, O, neutral } // all possible states a square can have

TextStyle style = const TextStyle(color: Colors.black, fontSize: 64);
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

  void _changeTurn() {
    firstTurn = false;
    setState(() {
      hostsTurn = !hostsTurn;
    });
  }

  TextButton _handleState(int i, int j) {
    if (firstTurn == true) {
      return TextButton(onPressed: _changeTurn, child: neutral);
    } else {
      if ((boardStates[i][j] == States.neutral) && (hostsTurn == true)) {
        setState(() {
          boardStates[i][j] == States.X;
        });
        return TextButton(onPressed: _changeTurn, child: X);
      } else if ((boardStates[i][j] == States.neutral) &&
          (hostsTurn == false)) {
        setState(() {
          boardStates[i][j] == States.O;
        });
        return TextButton(onPressed: _changeTurn, child: O);
      } else {
        return TextButton(
            onPressed: _changeTurn,
            child: const Text("WRONG", style: TextStyle(fontSize: 64)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double topInset = 20.0; // inset for padding spacing only for the top
    double leftInset = 28.0; // inset for padding spacing only for the left side
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
                          padding:
                              EdgeInsets.only(top: topInset, left: leftInset),
                          child: TextButton(
                              onPressed: _changeTurn,
                              child: _handleState(0, 0))),
                      Padding(
                          padding:
                              EdgeInsets.only(top: topInset, left: leftInset),
                          child: TextButton(
                              onPressed: _changeTurn,
                              child: _handleState(0, 1))),
                      Padding(
                          padding:
                              EdgeInsets.only(top: topInset, left: leftInset),
                          child: TextButton(
                              onPressed: _changeTurn,
                              child: _handleState(0, 2)))
                    ]),
                    Row(children: [
                      Padding(
                          padding: EdgeInsets.only(left: leftInset),
                          child: TextButton(
                              onPressed: _changeTurn,
                              child: _handleState(1, 0))),
                      Padding(
                          padding: EdgeInsets.only(left: leftInset),
                          child: TextButton(
                              onPressed: _changeTurn,
                              child: _handleState(1, 1))),
                      Padding(
                          padding: EdgeInsets.only(left: leftInset),
                          child: TextButton(
                              onPressed: _changeTurn,
                              child: _handleState(1, 2)))
                    ]),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: leftInset),
                            child: TextButton(
                                onPressed: _changeTurn,
                                child: _handleState(2, 0))),
                        Padding(
                            padding: EdgeInsets.only(left: leftInset),
                            child: TextButton(
                                onPressed: _changeTurn,
                                child: _handleState(2, 1))),
                        Padding(
                            padding: EdgeInsets.only(left: leftInset),
                            child: TextButton(
                                onPressed: _changeTurn,
                                child: _handleState(2, 2)))
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

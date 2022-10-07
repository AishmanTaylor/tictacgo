import 'package:flutter/material.dart';

enum States { X, O, neutral }

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  States state = States.neutral;

  void _changeTurn() {
    setState(() {
      if (state == States.neutral) {
        state = States.X;
      } else if (state == States.O) {
        state = States.X;
      } else {
        state = States.O;
      }
    });
  }

  TextButton _setSquareText() {
    if (state == States.neutral) {
      return TextButton(
          onPressed: _changeTurn,
          child: TextButton(
              onPressed: _changeTurn,
              child: const Text("",
                  style: TextStyle(fontSize: 64, color: Colors.black))));
    } else if (state == States.X) {
      return TextButton(
          onPressed: _changeTurn,
          child: const Text("X",
              style: TextStyle(fontSize: 64, color: Colors.black)));
    } else {
      return TextButton(
          onPressed: _changeTurn,
          child: const Text("O",
              style: TextStyle(fontSize: 64, color: Colors.black)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // just for displaying board
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
                  // gotta figure this out
                  child: Column(children: [
                    Row(children: [
                      SizedBox(
                          height: 150,
                          width: 150,
                          child: TextButton(
                              onPressed: _changeTurn, child: _setSquareText())),
                      SizedBox(
                          height: 150,
                          child: TextButton(
                              onPressed: _changeTurn, child: _setSquareText()))
                    ])
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

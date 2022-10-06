import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  bool playersTurn = false;

  GameScreen({super.key, required this.playersTurn});

  @override
  State createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  bool playersTurn = false;

  Text X = const Text("X", style: TextStyle(fontSize: 64, color: Colors.black));

  Text O = const Text("O", style: TextStyle(fontSize: 64, color: Colors.black));

  void _changeTurn() {
    setState(() {
      playersTurn = !playersTurn;
    });
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
                  child: Column(children: [
                    Row(children: [
                      Container(
                          height: 150,
                          width: 150,
                          child: playersTurn == false
                              ? TextButton(onPressed: _changeTurn, child: X)
                              : TextButton(onPressed: _changeTurn, child: O))
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

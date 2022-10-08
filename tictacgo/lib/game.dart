import 'package:flutter/material.dart';
import 'package:tictacgo/board.dart';

void main() {
  runApp(const gameScreen());
}

class gameScreen extends StatelessWidget {
  const gameScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Go',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const gamePage(title: 'Tic-Tac-Go'),
    );
  }
}

class gamePage extends StatefulWidget {
  const gamePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<gamePage> createState() => _gamePageState();
}

class _gamePageState extends State<gamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(child: GameScreen()),
    );
  }
}

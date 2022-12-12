import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

import 'board.dart';
import 'dart:convert';

const int ourPort = 8888;
final m = Mutex();

class Friends extends Iterable<String> {
  Map<String, Friend> _names2Friends = {};
  Map<String, Friend> _ips2Friends = {};

  void add(String name, String ip) {
    Friend f = Friend(ipAddr: ip, name: name);
    _names2Friends[name] = f;
    _ips2Friends[ip] = f;
  }

  String? ipAddr(String? name) => _names2Friends[name]?.ipAddr;

  Friend? getFriend(String? name) => _names2Friends[name];

  void receiveFrom(String ip, String message) {
    print("receiveFrom($ip, $message)");
    if (!_ips2Friends.containsKey(ip)) {
      String newFriend = "Friend${_ips2Friends.length}";
      print("Adding new friend");
      add(newFriend, ip);
      print("added $newFriend!");
    }
    _ips2Friends[ip]!.receiveBoard(message);
  }

  @override
  Iterator<String> get iterator => _names2Friends.keys.iterator;
}

class Friend extends ChangeNotifier {
  final String ipAddr;
  final String name;
  final List<Message> _messages = [];
  final List<Board> _board = [];

  Friend({required this.ipAddr, required this.name});

  Future<void> send(List<dynamic> message) async {
    print("HELLO");
    Socket socket = await Socket.connect(ipAddr, ourPort);
    print(message);
    print(jsonEncode(message));
    print(jsonDecode(jsonEncode(message)));
    socket.write(jsonEncode(message));
    socket.close();
    await _add_board("Me", message);
  }

  Future<void> receiveBoard(String message) async {
    return _add_board(name, jsonDecode(message));
  }

  Future<void> _add_board(String name, List<dynamic> board) async {
    await m.protect(() async {
      _board.add(Board(author: name, content: board));
      notifyListeners();
    });
  }
}

class Board {
  final List<dynamic> content;
  final String author;

  const Board({required this.author, required this.content});

  String get transcript => '$author: $content';
}

class Message {
  final String content;
  final String author;

  const Message({required this.author, required this.content});

  String get transcript => '$author: $content';
}

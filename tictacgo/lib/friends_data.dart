import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

enum States { X, O, neutral }

const int ourPort = 8888;
final m = Mutex();

class Friends extends Iterable<String> {
  final Map<String, Friend> _names2Friends = {};
  final Map<String, Friend> _ips2Friends = {};

  void add(String name, String ip) {
    Friend f = Friend(ipAddr: ip, name: name);
    _names2Friends[name] = f;
    _ips2Friends[ip] = f;
  }

  String? ipAddr(String? name) => _names2Friends[name]?.ipAddr;

  Friend? getFriend(String? name) => _names2Friends[name];

  void receiveFrom(String ip, States message) {
    print("receiveFrom($ip, $message)");
    if (!_ips2Friends.containsKey(ip)) {
      String newFriend = "Friend${_ips2Friends.length}";
      print("Adding new friend");
      add(newFriend, ip);
      print("added $newFriend!");
    }
    _ips2Friends[ip]!.receive(message);
  }

  @override
  Iterator<String> get iterator => _names2Friends.keys.iterator;
}

class Friend extends ChangeNotifier {
  final String ipAddr;
  final String name;
  final List<Message> _messages = [];

  Friend({required this.ipAddr, required this.name});

  Future<void> send(List<List<States>> message) async {
    Socket socket = await Socket.connect(ipAddr, ourPort);
    socket.write(message);
    socket.close();
    await _add_message("Me", message);
  }

  Future<void> receive(States message) async {
    return _add_message(name, message);
  }

  Future<void> _add_message(String name, States message) async {
    await m.protect(() async {
      _messages.add(Message(author: name, content: message));
      notifyListeners();
    });
  }
}

class Message {
  final String content;
  final String author;

  const Message({required this.author, required this.content});

  String get transcript => '$author: $content';
}

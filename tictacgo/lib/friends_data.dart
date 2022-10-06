import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

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

  // void receiveFrom(String ip, String message) {
  //   print("receiveFrom($ip, $message)");
  //   if (!_ips2Friends.containsKey(ip)) {
  //     String newFriend = "Friend${_ips2Friends.length}";
  //     print("Adding new friend");
  //     add(newFriend, ip);
  //     print("added $newFriend!");
  //   }
  //   _ips2Friends[ip]!.receive(message);
  // }

  @override
  Iterator<String> get iterator => _names2Friends.keys.iterator;
}

class Friend extends ChangeNotifier {
  final String ipAddr;
  final String name;
  final List<Message> _messages = [];

  Friend({required this.ipAddr, required this.name});

}

class Message {
  final String content;
  final String author;

  const Message({required this.author, required this.content});

  String get transcript => '$author: $content';
}

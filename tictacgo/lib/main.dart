import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:network_info_plus/network_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:tictacgo/friends_data.dart';
import 'package:tictacgo/text_widgets.dart';
import 'package:tictacgo/drop_down.dart';

import 'list_items.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'TicTacGo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _ipaddress = "Loading...";
  late Friends _friends;
  late List<DropdownMenuItem<String>> _friendList;
  late TextEditingController _nameController, _ipController;

  void initState() {
    super.initState();
    _friends = Friends();
    _nameController = TextEditingController();
    _ipController = TextEditingController();
    _setupServer();
    _findIPAddress();
  }

  Future<void> _findIPAddress() async {
    // Thank you https://stackoverflow.com/questions/52411168/how-to-get-device-ip-in-dart-flutter
    String? ip = await NetworkInfo().getWifiIP();
    setState(() {
      _ipaddress = "My IP: " + ip!;
    });
  }

  Future<void> _setupServer() async {
    try {
      ServerSocket server =
          await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server.listen(_listenToSocket); // StreamSubscription<Socket>
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  void _listenToSocket(Socket socket) {
    socket.listen((data) {
      setState(() {
        // _handleIncomingMessage(socket.remoteAddress.address, data);
      });
    });
  }

  // void _handleIncomingMessage(String ip, Uint8List incomingData) {
  //   String received = String.fromCharCodes(incomingData);
  //   print("Received '$received' from '$ip'");
  //   _friends.receiveFrom(ip, received);
  // }

  void addNew() {
    setState(() {
      _friends.add(_nameController.text, _ipController.text);
    });
  }

  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    _nameController.text = "";
    _ipController.text = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add A Friend'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextEntry(
                    width: 200,
                    label: "Name",
                    inType: TextInputType.text,
                    controller: _nameController),
                TextEntry(
                    width: 200,
                    label: "IP Address",
                    inType: TextInputType.number,
                    controller: _ipController),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    addNew();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void _handleEditFriend(Friend friend) {
    setState(() {
      print("Edit");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // https://stackoverflow.com/questions/53880293/flutter-how-to-get-subtext-aligned-under-title-in-appbar
        bottom: PreferredSize(
            child: Text(
              _ipaddress!,
              textAlign: TextAlign.center,
            ),
            preferredSize: Size.zero),
      ),
      body: Center(
        child: DropdownItem(),
        // ListView(
        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
        //   children: _friends.map((name) {
        //     return FriendListItem(
        //       friend: _friends.getFriend(name)!,
        //       // onListTapped: _handleChat,
        //       onListEdited: _handleEditFriend,
        //     );
        //   }).toList(),
        // ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          left: 30,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // FloatingActionButton.extended(
            //     onPressed: () {
            //       _displayTextInputDialog(context);
            //     },
            //     tooltip: 'Edit Friend',
            //     icon: const Icon(Icons.edit),
            //     label: Text("Edit Friend")),
            Expanded(child: Container()),
            FloatingActionButton.extended(
                onPressed: () {
                  _displayTextInputDialog(context);
                },
                tooltip: 'Add Friend',
                icon: const Icon(Icons.add),
                label: Text("Add Friend")),
          ],
        ),
      ),
    );
  }
}

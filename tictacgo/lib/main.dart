import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:network_info_plus/network_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:tictacgo/friends_data.dart';
import 'package:tictacgo/text_widgets.dart';

import 'board.dart';

void main() {
  runApp(const homeScreen());
}

class homeScreen extends StatelessWidget {
  const homeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'TicTacGo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _ipaddress = "Loading...";
  late Friends _friends;
  late TextEditingController _nameController, _ipController;

  @override
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
      _ipaddress = "My IP: ${ip!}";
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
        _handleIncomingMessage(socket.remoteAddress.address, data);
      });
    });
  }

  void _handleIncomingMessage(String ip, Uint8List incomingData) {
    String received = String.fromCharCodes(incomingData);
    print("Received '$received' from '$ip'");
    _friends.receiveFrom(ip, received);
  }

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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = _friends.map((name) {
      return DropdownMenuItem<String>(
        value: _friends.ipAddr(name),
        child: Text("$name ip:${_friends.ipAddr(name)!}"),
      );
    }).toList();
    return menuItems;
  }

// https://blog.logrocket.com/creating-dropdown-list-flutter/
  String? selectedValue;
  final _dropdownFormKey = GlobalKey<FormState>();
  Friend selectedFriend = Friend(ipAddr: '127.0.0.1', name: 'Me');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // https://stackoverflow.com/questions/53880293/flutter-how-to-get-subtext-aligned-under-title-in-appbar
        bottom: PreferredSize(
            preferredSize: Size.zero,
            child: Text(
              _ipaddress!,
              textAlign: TextAlign.center,
            )),
      ),
      body: Center(
        child: Form(
            key: _dropdownFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.blueAccent,
                    ),
                    validator: (value) =>
                        value == null ? "Select a friend to begin." : null,
                    dropdownColor: Colors.blueAccent,
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                        selectedFriend = _friends.getFriend(newValue)!;
                      });
                    },
                    items: dropdownItems),
                const Padding(padding: EdgeInsets.only(top: 50)),
                ElevatedButton(
                    onPressed: () {
                      if (_dropdownFormKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameScreen(
                                  friend:
                                      selectedFriend)),
                        );
                      }
                    },
                    child: const Text("Start"))
              ],
            )),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
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
                label: const Text("Add Friend")),
          ],
        ),
      ),
    );
  }
}

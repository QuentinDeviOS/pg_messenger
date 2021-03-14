import 'package:flutter/foundation.dart';
import 'package:pg_messenger/Models/webSocketManager.dart';
import 'package:pg_messenger/View/home.dart';
import 'package:pg_messenger/View/login.dart';
import 'package:pg_messenger/View/messageView.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

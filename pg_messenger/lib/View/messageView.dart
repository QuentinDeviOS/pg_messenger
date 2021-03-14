import 'package:flutter/material.dart';
import 'package:pg_messenger/Controller/WebSocketController.dart';

class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final webSocketController = WebSocketController();

  void testSendMessage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [],
      ),
    );
  }
}

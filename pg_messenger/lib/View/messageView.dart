import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pg_messenger/Controller/WebSocketController.dart';
import 'package:pg_messenger/Controller/messageController.dart';
import 'package:pg_messenger/Models/messages.dart';

class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final webSocketController = WebSocketController();
  final messageController = MessageController();

  List<Message> get messageList {
    return messageController.messageList;
  }

  _MessageViewState() {
    messageController.messageStream(webSocketController.channel);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: messageController.controller.stream,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemBuilder: _listBuilder,
                    itemCount: messageList.length,
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _listBuilder(BuildContext context, int numberOfRow) {
    return Text(messageList[numberOfRow].message);
  }
}

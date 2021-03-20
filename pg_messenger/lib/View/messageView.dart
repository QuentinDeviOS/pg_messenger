import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pg_messenger/Controller/WebSocketController.dart';
import 'package:pg_messenger/Controller/messageController.dart';
import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/user.dart';

class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final webSocketController = WebSocketController();
  final messageController = MessageController();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  List<Message> get messageList {
    return messageController.messageList;
  }

  _MessageViewState() {
    messageController.messageStream(webSocketController.channel);
    messageController.controller.stream.listen((event) {
      setState(() {
        print(messageList.toString());
        messageList;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: _listBuilder,
              itemCount: messageList.length,
            ),
          ),
          Form(
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                            labelText: "Envoyer un message",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 4.0, color: Colors.blue.shade400)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 4.0,
                                    color: Colors.blue.shade100))))),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                  color: Colors.blue.shade800,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void sendMessage() {
    if (_textController.text.isNotEmpty) {
      final user =
          User(id: "633A5398-62C6-4138-A53D-6570A3EAD783", username: "nicolas");
      final message = messageController.createNewMessageFromString(
          _textController.text, user);
      webSocketController.sendMessage(message);
    }
  }

  Widget _listBuilder(BuildContext context, int numberOfRow) {
    return Text(messageList[numberOfRow].owner.username +
        " : " +
        messageList[numberOfRow].message);
  }
}

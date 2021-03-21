import 'dart:async';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final ScrollController _scrollController = ScrollController();
  double _oldPositionScrollMax = 0;

  List<Message> get messageList {
    return messageController.messageList;
  }

  _MessageViewState() {
    messageController.messageStream(webSocketController.channel);
    messageController.controller.stream.listen((event) {
      setState(() {
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

  void goToEndList() {
    if (_scrollController.position.pixels == _oldPositionScrollMax) {
      print("go to endlist");
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 250),
      );
      _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
    } else {
      _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
    }
  }

  Widget _listBuilder(BuildContext context, int numberOfRow) {
    SchedulerBinding.instance.addPostFrameCallback((_) => goToEndList());
    print(numberOfRow);
    print(_scrollController.position.maxScrollExtent);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(messageList[numberOfRow].owner.username +
          " : " +
          messageList[numberOfRow].message),
    );
  }
}

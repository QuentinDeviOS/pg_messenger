import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pg_messenger/Constants/constant.dart';
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
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: _singleMessage,
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
                            width: 4.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 4.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    if (_textController.text.isNotEmpty) {
      final user = User(Constant.TEST_USER_ID, Constant.TEST_USER_USERNAME);
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

  Widget _singleMessage(BuildContext context, int num) {
    SchedulerBinding.instance?.addPostFrameCallback((_) => goToEndList());
    print(num);
    print(_scrollController.position.maxScrollExtent);
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(messageList[num].owner.username),
                Spacer(),
                Text("12:34"),
              ],
            ),
            Text(messageList[num].message)
          ],
        ),
      ),
    );
  }
}

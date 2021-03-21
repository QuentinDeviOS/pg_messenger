import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pg_messenger/Constants/constant.dart';
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
      appBar: AppBar(title: Text("Messages")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //controller: _animateToLast,
                  itemBuilder: _singleMessage,
                  itemCount: 20,
                  //itemCount: messageList.length,
                ),
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
            )
          ],
        ),
      ),
    );
  }

  _animateToLast() {
    debugPrint('scroll down');
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
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

  Widget _singleMessage(BuildContext context, int num) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //Text(messageList[num].owner.username),
                Text("username_${num + 1}"),
                Spacer(),
                //Text(messageList[num].owner.username),
                Text("12:34"),
              ],
            ),
            //Text(messageList[num].message),
            Text(
                "Un message ecrijnie ndcjiwedncijwn cijedncijene t par username_${num + 1}")
          ],
        ),
      ),
    );
  }
}

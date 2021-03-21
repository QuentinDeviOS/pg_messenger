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

class _MessageViewState extends State<MessageView> with WidgetsBindingObserver {
  final webSocketController = WebSocketController();
  final messageController = MessageController();
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double? _oldPositionScrollMax;
  FocusNode? inputFieldNode;

  List<Message> get messageList {
    return messageController.messageList;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    inputFieldNode = FocusNode();
    messageController.messageStream(webSocketController.channel);
    messageController.controller.stream.listen((event) {
      setState(() {
        messageList;
      });
    });
    _oldPositionScrollMax = 0;
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    print("Value: $value");
    if (value > 0) {
      _scrollController.position
          .jumpTo(_scrollController.position.maxScrollExtent);
      _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
    }

    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    inputFieldNode?.dispose();
    super.dispose();
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
                      focusNode: inputFieldNode,
                      onFieldSubmitted: (_) {
                        print("submited");
                        sendMessage();
                        _textController.text = "";
                        FocusScope.of(context).requestFocus(inputFieldNode);
                      },
                      onTap: () {},
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
    _textController.text = "";
  }

  void goToEndList() {
    print("go to endlist");

    if (_scrollController.position.pixels == _oldPositionScrollMax) {
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
                Text(messageList[num].timestamp.toString()),
              ],
            ),
            Text(messageList[num].message)
          ],
        ),
      ),
    );
  }
}

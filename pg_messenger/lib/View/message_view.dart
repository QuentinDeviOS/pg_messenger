import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/owner.dart';
import 'package:pg_messenger/Models/global_storage.dart';
import 'package:provider/provider.dart';

class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> with WidgetsBindingObserver {
  final _messageController = MessageController();
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double? _oldPositionScrollMax;
  FocusNode? _inputFieldNode;
  List<Message> _messageList = [];

  List<Message> get messageList {
    return _messageController.messageList;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    //inputFieldNode = FocusNode();
    _messageController.messageStream(onMessageListLoaded: (messageList) {
      setState(() {
        this._messageList = messageList;
      });
    });
    _oldPositionScrollMax = 0;
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
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
    _inputFieldNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: () {
              Provider.of<GlobalStorage>(context, listen: false).logout();
            },
          ),
        ],
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
//                      focusNode: inputFieldNode,
                      onFieldSubmitted: (_) {
                        sendMessage();
                        _textController.text = "";
//                        FocusScope.of(context).requestFocus(inputFieldNode);
                      },
                      onTap: () => goToEndList(),
                      decoration: InputDecoration(
                        labelText: "Send message",
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
      final owner = Owner(
        Provider.of<GlobalStorage>(context, listen: false).id,
        Provider.of<GlobalStorage>(context, listen: false).username,
      );
      final message = _messageController.createNewMessageFromString(
          _textController.text, owner);
      _messageController.sendMessage(message);
    }
    _textController.text = "";
  }

  void goToEndList() async {
    if (_scrollController.position.pixels == _oldPositionScrollMax) {
      _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 250),
      );
    }
    // if (_scrollController.position.pixels !=
    //         _scrollController.position.maxScrollExtent &&
    //     _scrollController.position.pixels == _oldPositionScrollMax) {
    //   await goToEndList();
    // }
    return;
  }

  Widget _singleMessage(BuildContext context, int num) {
    SchedulerBinding.instance?.addPostFrameCallback((_) => goToEndList());
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    messageList[num].ownerId.name.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Text(messageList[num].message)
          ],
        ),
      ),
    );
  }
}

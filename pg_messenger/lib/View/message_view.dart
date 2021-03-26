import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/connection_view.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MessageView extends StatefulWidget {
  final User _currentUser;

  const MessageView(this._currentUser, {Key? key}) : super(key: key);
  @override
  _MessageViewState createState() => _MessageViewState(_currentUser);
}

class _MessageViewState extends State<MessageView> with WidgetsBindingObserver {
  final _itemPositionLisner = ItemPositionsListener.create();
  final _currentUser;
  late MessageController _messageController;
  final _textController = TextEditingController();
  final ItemScrollController _scrollController = ItemScrollController();
  bool _isCurrentView = false;
  int? _oldIndexScrollMax;
  FocusNode? _inputFieldNode;
  List<Message> _messageList = [];

  _MessageViewState(this._currentUser) {
    _messageController = MessageController(_currentUser.token);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _isCurrentView = true;
    _inputFieldNode = FocusNode();
    _messageController.messageStream(
      onMessageListLoaded: (messageList) {
        if (_isCurrentView) {
          setState(() {
            this._messageList = messageList;
          });
        }
      },
    );
    _oldIndexScrollMax = 0;
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      _scrollController.jumpTo(index: _messageList.length - 1, alignment: 0);
    }
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _isCurrentView = false;
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConnectionView()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: _scrollController,
                itemBuilder: _singleMessage,
                itemCount: _messageList.length,
                itemPositionsListener: _itemPositionLisner,
              ),
            ),
            Form(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      focusNode: _inputFieldNode,
                      onFieldSubmitted: (_) {
                        sendMessage();
                        _textController.text = "";
                        FocusScope.of(context).requestFocus(_inputFieldNode);
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
      final message = _messageController.createNewMessageFromString(_textController.text, _currentUser);
      _messageController.sendMessage(message);
    }
    _textController.text = "";
  }

  goToEndList() async {
    if (_itemPositionLisner.itemPositions.value.last.index == _messageList.length - 1 && _oldIndexScrollMax != _messageList.length - 1) {
      _scrollController.scrollTo(index: (_messageList.length - 1), duration: Duration(milliseconds: 500));
      _oldIndexScrollMax = _messageList.length - 1;
    } else if (_oldIndexScrollMax == 0) {
      _scrollController.jumpTo(index: _messageList.length - 1);
      _oldIndexScrollMax = _messageList.length - 1;
    }
    return;
  }

  Widget _singleMessage(BuildContext context, int num) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      goToEndList();
    });
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
                  Text(_messageList[num].username),
                  Spacer(),
                  Text(_formatedTimestamp(_messageList[num].timestamp)),
                ],
              ),
            ),
            Text(_messageList[num].message)
          ],
        ),
      ),
    );
  }

  String _formatedTimestamp(DateTime? timestamp) {
    if (timestamp != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final difference = today.compareTo(timestamp);
      if (difference == 1) {
        return DateFormat("d MMM").format(timestamp).toString();
      } else if (difference == 0) {
        return "Just now";
      } else if (difference == -1) {
        return DateFormat("Hm").format(timestamp).toString();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }
}

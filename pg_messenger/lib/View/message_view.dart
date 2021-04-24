import 'package:flutter/cupertino.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pg_messenger/View/Components/image_message.dart';
import 'package:pg_messenger/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/View/Connection/connection_view.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'Components/drawer.dart';

class MessageView extends StatefulWidget {
  final MessageController _messageController;
  MessageView(
    this._messageController, {
    Key? key,
  }) : super(key: key);
  @override
  _MessageViewState createState() => _MessageViewState(_messageController);
}

class _MessageViewState extends State<MessageView> with WidgetsBindingObserver {
  final MessageController _messageController;

  _MessageViewState(this._messageController);

  @override
  void initState() {
    FlutterAppBadger.removeBadge();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _messageController.launchStream(onNewMessage: () {
      setState(() {});
    });
    _messageController.initView();
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    _messageController.onChangeMetrics(value);
    super.didChangeMetrics();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
      _messageController.launchStream(onNewMessage: () {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _messageController.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpened) {
        if (isOpened) {
        } else {
          _messageController.onDrawerWillClose();
        }
      },
      appBar: AppBar(
        title: Text(_messageController.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: S.of(context).message_logout,
            onPressed: () {
              _messageController.logOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConnectionView()));
            },
          ),
        ],
      ),
      drawer: menuDrawer(context, _messageController, () {
        _messageController.launchStream(onNewMessage: () {
          setState(() {});
        });
      }),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(controller: _messageController.scrollController, itemBuilder: _singleMessage, itemCount: _messageController.messageList.length),
            ),
            Form(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _messageController.takePicture(),
                  ),
                  IconButton(
                    icon: Icon(Icons.insert_photo),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _messageController.getImage(),
                  ),
                  Expanded(
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _messageController.textController,
                      focusNode: _messageController.inputFieldNode,
                      onFieldSubmitted: (_) {
                        if (_messageController.textController.text == "") {
                          FocusScope.of(context).unfocus();
                        }
                        _messageController.sendMessage();
                        _messageController.textController.text = "";
                      },
                      onTap: () => _messageController.goToEndList(),
                      decoration: InputDecoration(
                          hintText: "Aa",
                          border: InputBorder.none,
                          filled: true,
                          contentPadding: EdgeInsets.all(8),
                          //labelText: S.of(context).message_send_button,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                          isDense: true),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _messageController.sendMessage,
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

  Widget _singleMessage(BuildContext context, int num) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _messageController.goToEndList();
    });
    if (_messageController.messageList[num].channel == _messageController.currentChannel) {
      return Card(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 40,
                            width: 40,
                            child: _messageController.ownerImageMap[_messageController.messageList[num].owner],
                          ),
                        )),
                    Text(
                      _messageController.messageList[num].username,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.textDarkModeTitle),
                    ),
                    Spacer(),
                    Text(_messageController.formatedTimestamp(_messageController.messageList[num].timestamp, context)),
                    if (_messageController.messageList[num].flag != true)
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == "report") {
                            _messageController.reportMessage(_messageController.messageList[num], _messageController.currentUser);
                          }
                          if (value == "delete") {
                            _messageController.deleteMessage(_messageController.messageList[num], _messageController.currentUser);
                          }
                        },
                        itemBuilder: (context) => messagePopUpItem(_messageController.messageList[num]),
                      )
                  ],
                ),
              ),
              if (_messageController.messageList[num].isPicture == null || (_messageController.messageList[num].flag != true && !_messageController.messageList[num].isPicture!))
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(_messageController.messageList[num].message),
                ),
              if (_messageController.messageList[num].isPicture != null && _messageController.messageList[num].flag != true && _messageController.messageList[num].isPicture!) imageMessage(message: _messageController.messageList[num], messageController: _messageController),
              if (_messageController.messageList[num].flag == true) Text(S.of(context).message_under_moderation)
            ],
          ),
        ),
      );
    } else {
      return Padding(padding: EdgeInsets.all(0));
    }
  }

  List<PopupMenuEntry<String>> messagePopUpItem(Message message) {
    return [
      if (message.owner != _messageController.currentUser.id)
        PopupMenuItem(
          value: "report",
          child: Row(
            children: [
              Icon(
                Icons.pan_tool,
                size: 12,
                color: Colors.red.shade300,
              ),
              Text(
                S.of(context).message_report,
                style: TextStyle(fontSize: 12, color: Colors.red),
              )
            ],
          ),
        ),
      if (_messageController.currentUser.isModerator == true || message.owner == _messageController.currentUser.id)
        PopupMenuItem(
          value: "delete",
          child: Row(
            children: [
              Icon(
                Icons.delete_forever,
                size: 16,
                color: Colors.red.shade300,
              ),
              Text(
                S.of(context).message_delete,
                style: TextStyle(fontSize: 12, color: Colors.red),
              )
            ],
          ),
        )
    ];
  }
}

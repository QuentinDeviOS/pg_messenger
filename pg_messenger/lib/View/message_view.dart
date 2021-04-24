import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pg_messenger/View/Components/image_message.dart';
import 'package:pg_messenger/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/View/Connection/connection_view.dart';
import 'package:intl/intl.dart';
import 'package:pg_messenger/View/user_settings_view.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_channel_view.dart';

class MessageView extends StatefulWidget {
  final MessageController _messageController;
  MessageView(this._messageController, {Key? key}) : super(key: key);
  @override
  MessageViewState createState() => MessageViewState(_messageController);
}

class MessageViewState extends State<MessageView> with WidgetsBindingObserver {
  final MessageController _messageController;

  bool _isCurrentView = false;

  MessageViewState(this._messageController);

  @override
  void initState() {
    FlutterAppBadger.removeBadge();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _isCurrentView = true;
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
    _isCurrentView = false;
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
              logOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConnectionView()));
            },
          ),
        ],
      ),
      drawer: menuDrawer(context),
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
                    Text(_formatedTimestamp(_messageController.messageList[num].timestamp)),
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



  Widget messageIsText(Message message) {
    return Text(message.message);
  }

  String _formatedTimestamp(DateTime? timestamp) {
    if (timestamp != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final difference = today.compareTo(timestamp);
      if (difference == 1) {
        return DateFormat("d MMM").format(timestamp).toString();
      } else if (difference == 0) {
        return S.of(context).message_just_now;
      } else if (difference == -1) {
        return DateFormat("Hm").format(timestamp).toString();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constant.JSONKEY_TOKEN, "");
    FirebaseMessaging.instance.deleteToken();
  }

  //Menu Drawer
  //

  Widget menuDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.fromLTRB(20, 40, 0, 0)),
              GestureDetector(
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                      if (_messageController.currentUser.profilePict != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            child: _messageController.profilePict,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      if (_messageController.profilePict == null) ProfilePicture().defaultImagePicture(_currentUser.username, height: 60, width: 60),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                      Text(
                        _messageController.currentUser.username,
                        style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.textDarkModeTitle, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserSettingsView(
                                  messageView: this,
                                  user: _messageController.currentUser,
                                )));
                  }),
              Padding(padding: EdgeInsets.fromLTRB(20, 15, 20, 20)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    Text(
                      S.of(context).channel,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.textDarkModeTitle, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    if (_messageController.currentUser.isModerator == true)
                      IconButton(
                          icon: Icon(
                            Icons.plus_one,
                            color: Theme.of(context).colorScheme.textDarkModeTitle,
                          ),
                          onPressed: () => pushToCreateChannelView()),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: itemBuilder,
                  itemCount: _messageController.channelList.length,
                ),
              ),
              Spacer(),
              TextButton(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.textDarkModeTitle,
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                      Text(
                        S.of(context).logout_title,
                        style: TextStyle(color: Theme.of(context).colorScheme.textDarkModeTitle),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  logOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConnectionView()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  pushToCreateChannelView() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateChannelView(_messageController.currentUser)));
  }

  Widget itemBuilder(BuildContext context, int num) {
    if (_messageController.currentUser.isModerator == true) {
      return listViewBuilderIfModerator(num);
    } else {
      return listViewBuilderIfNotModerator(num);
    }
  }

  Widget listViewBuilderIfModerator(int num) {
    return drawerListViewComponent(num);
  }

  Widget listViewBuilderIfNotModerator(int num) {
    if (_messageController.channelList[num].isPublic) {
      return drawerListViewComponent(num);
    } else {
      return Padding(padding: EdgeInsets.all(0));
    }
  }

  Widget drawerListViewComponent(int num) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
      child: GestureDetector(
        child: Row(
          children: [
            Icon(
              Icons.tag,
              size: 20,
              color: Theme.of(context).colorScheme.textDarkModeTitle,
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 3, 0)),
            Text(
              _messageController.channelList[num].name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: () {
          onTapDrawerListTile(num);
        },
      ),
    );
  }

  onTapDrawerListTile(int num) async {
    if (_currentChannel != _channelList[num].id) {
      title = _channelList[num].name;
      _currentChannel = _channelList[num].id;
      _messageController.launchStream(onNewMessage: (){setState(() {
        
      });});
    Navigator.pop(context);
  }

  updateState() async {
    _messageController.refreshMessage(_currentUser, _currentChannel);
    setState(() {});
  }
}

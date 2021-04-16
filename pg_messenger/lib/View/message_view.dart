import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:pg_messenger/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/channel_controller.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/Models/channel.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/Connection/connection_view.dart';
import 'package:intl/intl.dart';
import 'package:pg_messenger/View/user_settings_view.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_channel_view.dart';

class MessageView extends StatefulWidget {
  final User _currentUser;
  final List<Channel> _channelList;
  MessageView(this._currentUser, this._channelList, {Key? key}) : super(key: key);
  @override
  MessageViewState createState() => MessageViewState(_currentUser, _channelList);
}

class MessageViewState extends State<MessageView> with WidgetsBindingObserver {
  List<Channel> channelList;
  String? _currentChannel;
  final User _currentUser;
  var profilePictureController = ProfilePicture();
  late MessageController _messageController = MessageController();
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final channelController = ChannelController();
  bool _isCurrentView = false;
  double? _oldPositionScrollMax;
  FocusNode? _inputFieldNode;
  List<Message> messageList = [];
  Map<String, Widget> _ownerImageMap = Map();
  String title = "Général";

  final ImagePicker imagePicker = ImagePicker();

  MessageViewState(this._currentUser, this.channelList) {
    _messageController.connectToWs(_currentUser, _currentChannel);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _isCurrentView = true;
    _inputFieldNode = FocusNode();
    _messageController.messageStream(
      user: _currentUser,
      onMessageListLoaded: (messageList, imageList) {
        if (_isCurrentView) {
          if (messageList != this.messageList) {
            if (_ownerImageMap != imageList) {
              _ownerImageMap = imageList;
            }
            setState(() {
              this.messageList = messageList;
            });
          }
        }
      },
    );
    _oldPositionScrollMax = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        _closeKeyboard();
      }
    });
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      if (_scrollController.position.pixels == _oldPositionScrollMax) {
        _scrollController.position.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
    super.didChangeMetrics();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _messageController.closeWS();
      _messageController.connectToWs(_currentUser, _currentChannel);
      _messageController.messageStream(
          user: _currentUser,
          onMessageListLoaded: (onMessageListLoaded, imageList) {
            if (messageList != onMessageListLoaded) {
              _ownerImageMap = imageList;
              setState(() {
                messageList = onMessageListLoaded;
              });
            }
          });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _isCurrentView = false;
    _inputFieldNode?.dispose();
    _messageController.closeWS();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpened) {
        if (isOpened) {
        } else {
          _messageController.refreshMessage(_currentUser, _currentChannel);
        }
      },
      appBar: AppBar(
        title: /*Text(S.of(context).message_title)*/ Text(title),
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
              child: ListView.builder(controller: _scrollController, itemBuilder: _singleMessage, itemCount: messageList.length),
            ),
            Form(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _messageController.takePicture(_currentUser, _currentChannel),
                  ),
                  IconButton(
                    icon: Icon(Icons.insert_photo),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _messageController.getImage(_currentUser, _currentChannel),
                  ),
                  Expanded(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _textController,
                      focusNode: _inputFieldNode,
                      onFieldSubmitted: (_) {
                        if (_textController.text == "") {
                          FocusScope.of(context).unfocus();
                        }
                        sendMessage();
                        _textController.text = "";
                      },
                      onTap: () => goToEndList(),
                      decoration: InputDecoration(
                        labelText: S.of(context).message_send_button,
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

  Widget _singleMessage(BuildContext context, int num) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      goToEndList();
    });
    if (messageList[num].channel == _currentChannel) {
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
                            child: _ownerImageMap[messageList[num].owner],
                          ),
                        )),
                    Text(
                      messageList[num].username,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.textDarkModeTitle),
                    ),
                    Spacer(),
                    Text(_formatedTimestamp(messageList[num].timestamp)),
                    if (messageList[num].flag != true)
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == "report") {
                            _messageController.reportMessage(messageList[num], _currentUser);
                          }
                          if (value == "delete") {
                            _messageController.deleteMessage(messageList[num], _currentUser);
                          }
                        },
                        itemBuilder: (context) => messagePopUpItem(messageList[num]),
                      )
                  ],
                ),
              ),
              if (messageList[num].isPicture == null || (messageList[num].flag != true && !messageList[num].isPicture!))
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(messageList[num].message),
                ),
              if (messageList[num].isPicture != null && messageList[num].flag != true && messageList[num].isPicture!) messageIsImage(messageList[num], _currentUser),
              if (messageList[num].flag == true) Text(S.of(context).message_under_moderation)
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
      if (message.owner != _currentUser.id)
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
      if (_currentUser.isModerator == true || message.owner == _currentUser.id)
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

  void sendMessage() {
    if (_textController.text.isNotEmpty) {
      final message = _messageController.createNewMessageFromString(_textController.text, _currentUser, _currentChannel);
      _messageController.sendMessage(message);
    }
    _textController.text = "";
  }

  goToEndList() async {
    if (_scrollController.position.pixels == _oldPositionScrollMax && _oldPositionScrollMax != _scrollController.position.maxScrollExtent && _oldPositionScrollMax != 0) {
      do {
        _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
        await _scrollController.position.moveTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500));
      } while (_scrollController.position.pixels != _scrollController.position.maxScrollExtent);
    } else if (_oldPositionScrollMax == 0) {
      _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
      _scrollController.position.jumpTo(_scrollController.position.maxScrollExtent);
    }
    _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
    return;
  }

  Widget messageIsImage(Message message, User currentUser) {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${currentUser.token}";
    return Image.network(
      Constant.URL_WEB_SERVER_BASE + Constant.PATH_TO_GET_PICTURE + "?filename=${message.message}",
      headers: headers,
    );
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
                    FutureBuilder(
                        future: profilePictureController.getImagePicture(user: _currentUser, randomInt: Random().nextInt(5000), height: 60, width: 60, username: _currentUser.username),
                        builder: (context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                height: 60,
                                width: 60,
                                child: snapshot.data,
                              ),
                            );
                          } else {
                            return profilePictureController.defaultImagePicture(_currentUser.username, height: 60, width: 60);
                          }
                        }),
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                    Text(
                      widget._currentUser.username,
                      style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.textDarkModeTitle, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserSettingsView(
                              user: _currentUser,
                            ))),
              ),
              Padding(padding: EdgeInsets.fromLTRB(20, 15, 20, 20)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Salons",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.textDarkModeTitle, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    if (_currentUser.isModerator == true)
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
                  itemCount: channelList.length,
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
                        "Se deconnecter",
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateChannelView(widget.key, widget._currentUser)));
  }

  Widget itemBuilder(BuildContext context, int num) {
    if (_currentUser.isModerator == true) {
      return listViewBuilderIfModerator(num);
    } else {
      return listViewBuilderIfNotModerator(num);
    }
  }

  Widget listViewBuilderIfModerator(int num) {
    return drawerListViewComponent(num);
  }

  Widget listViewBuilderIfNotModerator(int num) {
    if (channelList[num].isPublic) {
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
              channelList[num].name,
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
    if (_currentChannel != channelList[num].id) {
      title = channelList[num].name;
      _currentChannel = channelList[num].id;
      await _messageController.closeWS();
      _messageController.connectToWs(_currentUser, _currentChannel);
      _messageController.messageStream(
        user: _currentUser,
        onMessageListLoaded: (messageList, imageList) {
          if (_isCurrentView) {
            if (messageList != this.messageList) {
              if (_ownerImageMap != imageList) {
                _ownerImageMap = imageList;
              }
              setState(() {
                this.messageList = messageList;
              });
            }
          }
        },
      );
    }
    Navigator.pop(context);
  }

  _closeKeyboard() {
    if (_inputFieldNode != null) {
      _inputFieldNode!.unfocus();
    }
  }
}

class CustomsColor {}

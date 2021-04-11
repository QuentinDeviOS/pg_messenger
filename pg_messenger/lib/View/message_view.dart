import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/channel.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/connection_view.dart';
import 'package:intl/intl.dart';
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
  final _currentUser;
  late MessageController _messageController;
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isCurrentView = false;
  double? _oldPositionScrollMax;
  FocusNode? _inputFieldNode;
  List<Message> messageList = [];
  String title = "Messages";

  final ImagePicker imagePicker = ImagePicker();

  MessageViewState(User this._currentUser, this.channelList) {
    _messageController = MessageController(_currentUser.token, _currentChannel);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _isCurrentView = true;
    _inputFieldNode = FocusNode();
    _messageController.messageStream(
      onMessageListLoaded: (messageList) {
        print(messageList.length);
        if (_isCurrentView) {
          if (messageList != this.messageList) {
            setState(() {
              this.messageList = messageList;
            });
          }
        }
      },
    );
    _oldPositionScrollMax = 0;
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
      _messageController = MessageController(_currentUser.token, _currentChannel);
      _messageController.messageStream(onMessageListLoaded: (onMessageListLoaded) {
        if (messageList != onMessageListLoaded) {
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
    print(_currentChannel);
    print(messageList[num].channel);
    if (messageList[num].channel == _currentChannel) {
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
                    Text(messageList[num].username),
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
                        itemBuilder: messagePopUpItem,
                      )
                  ],
                ),
              ),
              if (messageList[num].isPicture == null || (messageList[num].flag != true && !messageList[num].isPicture!)) Text(messageList[num].message),
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

  List<PopupMenuEntry<String>> messagePopUpItem(BuildContext context) {
    return [
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
      if (_currentUser.isModerator == true)
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
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(20)),
          Text(
            widget._currentUser.username,
            style: TextStyle(fontSize: 22, color: Colors.black54),
          ),
          ListTile(
            title: Text("General"),
            onTap: () {
              setState(() {
                title = "General";
                _currentChannel = null;
                _messageController.closeWS();
                _messageController = MessageController(_currentUser.token, _currentChannel);
                _messageController.messageStream(
                  onMessageListLoaded: (messageList) {
                    print(messageList.length);
                    if (_isCurrentView) {
                      if (messageList != this.messageList) {
                        setState(() {
                          this.messageList = messageList;
                        });
                      }
                    }
                  },
                );
              });
              Navigator.pop(context);
            },
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: itemBuilder,
            itemCount: channelList.length,
          )),
          Spacer(),
          if (_currentUser.isModerator)
            ListTile(
              title: Row(
                children: [Icon(Icons.plus_one), Text("  Ajouter un channel")],
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateChannelView(widget.key, widget._currentUser))),
            )
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int num) {
    if (_currentUser.isModerator) {
      return listViewBuilderIfModerator(num);
    } else {
      return listViewBuilderIfNotModerator(num);
    }
  }

  Widget listViewBuilderIfModerator(int num) {
    return ListTile(
      title: Text(channelList[num].name),
      onTap: () {
        onTapDrawerListTile(num);
      },
    );
  }

  Widget listViewBuilderIfNotModerator(int num) {
    if (channelList[num].isPublic) {
      return ListTile(
          title: Text(channelList[num].name),
          onTap: () {
            onTapDrawerListTile(num);
          });
    } else {
      return Padding(padding: EdgeInsets.all(0));
    }
  }

  onTapDrawerListTile(int num) {
    setState(() {
      title = channelList[num].name;
      _currentChannel = channelList[num].id;
      _messageController.closeWS();
      _messageController = MessageController(_currentUser.token, _currentChannel);
      _messageController.messageStream(
        onMessageListLoaded: (messageList) {
          print(messageList.length);
          if (_isCurrentView) {
            if (messageList != this.messageList) {
              setState(() {
                this.messageList = messageList;
              });
            }
          }
        },
      );
    });
    Navigator.pop(context);
  }
}

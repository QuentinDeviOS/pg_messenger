import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/connection_view.dart';
import 'package:intl/intl.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MessageView extends StatefulWidget {
  final User _currentUser;

  const MessageView(this._currentUser, {Key? key}) : super(key: key);
  @override
  _MessageViewState createState() => _MessageViewState(_currentUser);
}

class _MessageViewState extends State<MessageView> with WidgetsBindingObserver {
  final _currentUser;
  late MessageController _messageController;
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isCurrentView = false;
  double? _oldPositionScrollMax;
  FocusNode? _inputFieldNode;
  List<Message> _messageList = [];

  final ImagePicker imagePicker = ImagePicker();

  _MessageViewState(User this._currentUser) {
    _messageController = MessageController(_currentUser.token);
  }

  Future _takePicture() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    if (image != null) {
      http.MultipartFile _image =
          await http.MultipartFile.fromPath('file', image.path);

      Map<String, String> headers = Map();
      headers["Content-Type"] = "multipart/form-data";
      headers["Authorization"] = "Bearer ${_currentUser.token}";

      var request = http.MultipartRequest("POST",
          Uri.parse(Constant.URL_WEB_SERVER_BASE + "/photos/upload-picture"));
      request.headers.addAll(headers);
      request.files.add(_image);
      await request.send();
    }
  }

  Future _getImage() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      http.MultipartFile _image =
          await http.MultipartFile.fromPath('file', image.path);

      Map<String, String> headers = Map();
      headers["Content-Type"] = "multipart/form-data";
      headers["Authorization"] = "Bearer ${_currentUser.token}";

      var request = http.MultipartRequest("POST",
          Uri.parse(Constant.URL_WEB_SERVER_BASE + "/photos/upload-picture"));
      request.headers.addAll(headers);
      request.files.add(_image);
      await request.send();
    }
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
          if (_messageList != messageList) {
            setState(() {
              this._messageList = messageList;
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
      _scrollController.position
          .jumpTo(_scrollController.position.maxScrollExtent);
    }
    super.didChangeMetrics();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _messageController = MessageController(_currentUser.token);
      _messageController.messageStream(
          onMessageListLoaded: (onMessageListLoaded) {
        if (_messageList != onMessageListLoaded) {
          setState(() {
            _messageList = onMessageListLoaded;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).message_title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: S.of(context).message_logout,
            onPressed: () {
              logOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ConnectionView()));
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
                  itemCount: _messageList.length),
            ),
            Form(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _takePicture(),
                  ),
                  IconButton(
                    icon: Icon(Icons.insert_photo),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _getImage(),
                  ),
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

  void sendMessage() {
    if (_textController.text.isNotEmpty) {
      final message = _messageController.createNewMessageFromString(
          _textController.text, _currentUser);
      _messageController.sendMessage(message);
    }
    _textController.text = "";
  }

  goToEndList() async {
    if (_scrollController.position.pixels == _oldPositionScrollMax &&
        _oldPositionScrollMax != _scrollController.position.maxScrollExtent &&
        _oldPositionScrollMax != 0) {
      do {
        _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
        await _scrollController.position.moveTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500));
      } while (_scrollController.position.pixels !=
          _scrollController.position.maxScrollExtent);
    } else if (_oldPositionScrollMax == 0) {
      _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
      _scrollController.position
          .jumpTo(_scrollController.position.maxScrollExtent);
    }
    _oldPositionScrollMax = _scrollController.position.maxScrollExtent;
    return;
  }

  Widget _singleMessage(BuildContext context, int num) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
                  if (_messageList[num].flag != true)
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == "report") {
                          _messageController.reportMessage(
                              _messageList[num], _currentUser);
                        }
                      },
                      itemBuilder: (context) => [
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
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                )
                              ],
                            ))
                      ],
                    )
                ],
              ),
            ),
            if (_messageList[num].isPicture == null ||
                (_messageList[num].flag != true &&
                    !_messageList[num].isPicture!))
              Text(_messageList[num].message),
            if (_messageList[num].isPicture != null &&
                _messageList[num].flag != true &&
                _messageList[num].isPicture!)
              messageIsImage(_messageList[num], _currentUser),
            if (_messageList[num].flag == true)
              Text(S.of(context).message_under_moderation)
          ],
        ),
      ),
    );
  }

  Widget messageIsImage(Message message, User currentUser) {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${currentUser.token}";
    return Image.network(
      Constant.URL_WEB_SERVER_BASE +
          Constant.PATH_TO_GET_PICTURE +
          "?filename=${message.message}",
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
}

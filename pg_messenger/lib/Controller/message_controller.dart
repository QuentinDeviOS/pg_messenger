import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/channel_controller.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/Controller/timestamp_controller.dart';
import 'package:pg_messenger/Models/channel.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Controller/web_socket_controller.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageController {
  User get currentUser => _currentUser;
  ScrollController get scrollController => _scrollController;
  TextEditingController get textController => _textController;
  List<Channel> get channelList => _channelList;
  String? get currentChannel => _currentChannel;
  Map<String, Widget> get ownerImageMap => _ownerImageMap;
  List<Message> get messageList => _messageList;
  String get title => _title;

  final FocusNode inputFieldNode = FocusNode();
  final ImagePicker imagePicker = ImagePicker();
  final channelController = ChannelController();
  final profilePictureController = ProfilePicture();
  final TimestampController timestampController = TimestampController();

  final User _currentUser;
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Channel> _channelList;
  String? _currentChannel;
  List<Message> _messageList = [];
  List<Message> _messageListBuilder = [];
  Map<String, Widget> _profilePictureByOwner = Map();
  Map<String, String?> _literalPictureDictionary = Map();
  WebSocketController _webSocketController = WebSocketController();
  bool _isCurrentView = false;
  double? _oldPositionScrollMax;
  Map<String, Widget> _ownerImageMap = Map();

  String _title = "Général";

  MessageController(this._currentUser, this._channelList) {
    prepareNotification();
    _currentUser.getImagePicture(_currentUser.picture);
    connectToWs(_currentUser, _currentChannel);
  }

  connectToWs(User user, String? channel) {
    _webSocketController.connect(user.token, channel);
  }

  Message createNewMessageFromString(
      String messageString, User user, String? channel) {
    return Message("", messageString, user.id, null, "", false, channel);
  }

  Message createNewMessageWithPicture(
      String picturePath, User user, String? channel) {
    return Message("", picturePath, user.id, null, "", true, channel);
  }

  void messageStream(
      {required Function(
              List<Message> messageList, Map<String, Widget> imageFutureList)
          onMessageListLoaded,
      required User user}) async {
    _webSocketController.onReceive(onReceiveData: (data) async {
      var haveData = await hasMessages(data, user);
      if (haveData) {
        onMessageListLoaded(_messageListBuilder, _profilePictureByOwner);
      }
    });
  }

  Future<bool> hasMessages(dynamic messageReceived, User user) async {
    final List<dynamic>? dataListJson = jsonDecode(messageReceived.toString());
    if (dataListJson != null) {
      _messageListBuilder = [];
      for (var messageJson in dataListJson) {
        Message message = Message.fromJson(messageJson);
        if (message.channel != _currentChannel) {
          return false;
        }
        _messageListBuilder.add(message);
        if (message.ownerPicture != null) {
          if (_literalPictureDictionary[message.owner] !=
              message.ownerPicture) {
            Image? image = await profilePictureController.getImagePicture(
                user: user,
                username: message.owner,
                picture: message.ownerPicture);
            Widget defaultImage = profilePictureController
                .defaultImagePicture(message.username, height: 40, width: 40);
            if (image == null) {
              if (_profilePictureByOwner[message.owner] != defaultImage) {
                _profilePictureByOwner[message.owner] = defaultImage;
                _literalPictureDictionary[message.owner] =
                    message.ownerPicture!;
              }
            } else {
              if (_profilePictureByOwner[message.owner] != image) {
                _profilePictureByOwner[message.owner] = image;
                _literalPictureDictionary[message.owner] =
                    message.ownerPicture!;
              }
            }
          }
        } else {
          Widget defaultImage = profilePictureController
              .defaultImagePicture(message.username, height: 40, width: 40);
          _profilePictureByOwner[message.owner] = defaultImage;
        }
      }
      return true;
    }
    return false;
  }

  _sendMessage(Message message) {
    _webSocketController.sendMessage(message);
  }

  reportMessage(Message message, User user) async {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${user.token}";
    headers["Content-Type"] = "application/json; charset=utf-8";
    await http.post(
        Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/report-message"),
        headers: headers,
        body: JsonEncoder().convert(message.toJsonForReport()));
  }

  unflagMessage(Message message, User user) async {
    if (user.isModerator == true) {
      Map<String, String> headers = Map();
      headers["Authorization"] = "Bearer ${user.token}";
      headers["Content-Type"] = "application/json; charset=utf-8";
      await http.post(
          Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/unflag-message"),
          headers: headers,
          body: JsonEncoder().convert(message.toJsonForUnflag()));
    }
  }

  Future takePicture() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.camera);
    uploadImage(image, currentUser, _currentChannel);
  }

  Future getImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    uploadImage(image, currentUser, _currentChannel);
  }

  Future uploadImage(
      PickedFile? image, User currentUser, String? channel) async {
    if (image != null) {
      http.MultipartFile _image =
          await http.MultipartFile.fromPath('file', image.path);

      Map<String, String> headers = Map();
      headers["Content-Type"] = "multipart/form-data";
      headers["Authorization"] = "Bearer ${currentUser.token}";

      var request = http.MultipartRequest(
          "POST",
          Uri.parse(Constant.URL_WEB_SERVER_BASE +
              "/photos/upload-picture?channelID=$channel"));
      request.headers.addAll(headers);
      request.files.add(_image);
      await request.send();
    }
  }

  deleteMessage(Message message, User user) async {
    if (message.owner == user.id || user.isModerator == true) {
      Map<String, String> headers = Map();
      headers["Authorization"] = "Bearer ${user.token}";
      headers["Content-Type"] = "application/json; charset=utf-8";
      await http.post(
          Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/delete-message"),
          headers: headers,
          body: JsonEncoder().convert(message.toJsonForDeletion()));
    }
  }

  closeWS() {
    _webSocketController.closeWS();
  }

  _refreshMessage() {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${_currentUser.token}";
    if (_currentChannel == null) {
      http.get(
          Uri.parse(
              Constant.URL_WEB_SERVER_BASE + "/messages/refresh-messages"),
          headers: headers);
    } else {
      http.get(
          Uri.parse(Constant.URL_WEB_SERVER_BASE +
              "/messages/refresh-messages?channel=" +
              _currentChannel!),
          headers: headers);
    }
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constant.JSONKEY_TOKEN, "");
    FirebaseMessaging.instance.deleteToken();
    await DefaultCacheManager().removeFile(
        Constant.URL_WEB_SERVER_BASE + "/users/profile-picture?refresh=0");
    await DefaultCacheManager().removeFile(
        Constant.URL_WEB_SERVER_BASE + "/users/profile-picture?refresh=1");
  }

  prepareNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (_currentUser.isModerator == true) {
      messaging.subscribeToTopic("moderator");
      messaging.subscribeToTopic("general");
    } else {
      messaging.subscribeToTopic("general");
    }
    return;
  }

  launchStream({required Function onNewMessage}) async {
    await closeWS();
    connectToWs(_currentUser, _currentChannel);
    messageStream(
      user: _currentUser,
      onMessageListLoaded: (messageList, imageList) {
        if (_isCurrentView) {
          if (_messageList != messageList) {
            if (_ownerImageMap != imageList) {
              _ownerImageMap = imageList;
            }
            this._messageList = messageList;
            onNewMessage();
          }
        }
      },
    );
  }

  initView() {
    _isCurrentView = true;
    _oldPositionScrollMax = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        inputFieldNode.unfocus();
      }
    });
  }

  onChangeMetrics(double value) {
    if (value > 0) {
      if (_scrollController.position.pixels == _oldPositionScrollMax) {
        _scrollController.position
            .jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  onDispose() {
    _isCurrentView = false;
    inputFieldNode.dispose();
    closeWS();
  }

  onDrawerWillClose() {
    _refreshMessage();
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

  void sendMessage() {
    if (_textController.text.isNotEmpty) {
      final message = createNewMessageFromString(
          _textController.text, _currentUser, _currentChannel);
      _sendMessage(message);
    }
    _textController.text = "";
    _oldPositionScrollMax = _scrollController.position.pixels;
  }

  jumpToEndAfterImageLoaded() {
    if (_scrollController.position.pixels == _oldPositionScrollMax) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  onTapDrawerListTile(
      int num, BuildContext context, Function onChannelVerify) async {
    if (_currentChannel != _channelList[num].id) {
      _title = _channelList[num].name;
      _currentChannel = _channelList[num].id;
      launchStream(onNewMessage: () => onChannelVerify());
    }
    Navigator.pop(context);
  }
}

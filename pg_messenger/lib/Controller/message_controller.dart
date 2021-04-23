import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Controller/web_socket_controller.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageController {
  List<Message> _messageList = [];
  Map<String, Widget> _profilePictureByOwner = Map();
  Map<String, String?> _literalPricutreDictionary = Map();
  WebSocketController _webSocketController = WebSocketController();
  final _profilePictureController = ProfilePicture();
  String? channel;

  connectToWs(User user, String? channel) {
    _webSocketController.connect(user.token, channel);
    this.channel = channel;
  }

  Message createNewMessageFromString(String messageString, User user, String? channel) {
    return Message("", messageString, user.id, null, "", false, channel);
  }

  Message createNewMessageWithPicture(String picturePath, User user, String? channel) {
    return Message("", picturePath, user.id, null, "", true, channel);
  }

  void messageStream({required Function(List<Message> messageList, Map<String, Widget> imageFutureList) onMessageListLoaded, required User user}) async {
    _webSocketController.onReceive(onReceiveData: (data) async {
      var haveData = await hasMessages(data, user);
      if (haveData) {
        onMessageListLoaded(_messageList, _profilePictureByOwner);
      }
    });
  }

  Future<bool> hasMessages(dynamic messageReceived, User user) async {
    final List<dynamic>? dataListJson = jsonDecode(messageReceived.toString());
    if (dataListJson != null) {
      _messageList = [];
      for (var messageJson in dataListJson) {
        Message message = Message.fromJson(messageJson);
        if (message.channel != channel) {
          return false;
        }
        _messageList.add(message);
        if (message.ownerPicture != null) {
          if (_literalPricutreDictionary[message.owner] != message.ownerPicture) {
            Image? image = await _profilePictureController.getImagePicture(token: user.token, username: message.owner, picture: message.ownerPicture);
            Widget defaultImage = _profilePictureController.defaultImagePicture(message.username, height: 40, width: 40);
            if (image == null) {
              if (_profilePictureByOwner[message.owner] != defaultImage) {
                _profilePictureByOwner[message.owner] = defaultImage;
                _literalPricutreDictionary[message.owner] = message.ownerPicture!;
              }
            } else {
              if (_profilePictureByOwner[message.owner] != image) {
                _profilePictureByOwner[message.owner] = image;
                _literalPricutreDictionary[message.owner] = message.ownerPicture!;
              }
            }
          }
        } else {
          Widget defaultImage = _profilePictureController.defaultImagePicture(message.username, height: 40, width: 40);
          _profilePictureByOwner[message.owner] = defaultImage;
        }
      }
      return true;
    }
    return false;
  }

  sendMessage(Message message) {
    _webSocketController.sendMessage(message);
  }

  reportMessage(Message message, User user) async {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${user.token}";
    headers["Content-Type"] = "application/json; charset=utf-8";
    await http.post(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/report-message"), headers: headers, body: JsonEncoder().convert(message.toJsonForReport()));
  }

  Future takePicture(User currentUser, String? channel) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.camera);
    uploadImage(image, currentUser, channel);
  }

  Future getImage(User currentUser, String? channel) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    uploadImage(image, currentUser, channel);
  }

  Future uploadImage(PickedFile? image, User currentUser, String? channel) async {
    if (image != null) {
      http.MultipartFile _image = await http.MultipartFile.fromPath('file', image.path);

      Map<String, String> headers = Map();
      headers["Content-Type"] = "multipart/form-data";
      headers["Authorization"] = "Bearer ${currentUser.token}";

      var request = http.MultipartRequest("POST", Uri.parse(Constant.URL_WEB_SERVER_BASE + "/photos/upload-picture?channelID=$channel"));
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
      await http.post(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/delete-message"), headers: headers, body: JsonEncoder().convert(message.toJsonForDeletion()));
    }
  }

  closeWS() {
    _webSocketController.closeWS();
  }

  refreshMessage(User user, String? channel) {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${user.token}";
    if (channel == null) {
      http.get(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/refresh-messages"), headers: headers);
    } else {
      http.get(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/refresh-messages?channel=" + channel), headers: headers);
    }
  }

  goToEndList({required ScrollController scrollController, required double? oldPositionScrollMax}) async {
    if (scrollController.position.pixels == oldPositionScrollMax && oldPositionScrollMax != scrollController.position.maxScrollExtent && oldPositionScrollMax != 0) {
      do {
        oldPositionScrollMax = scrollController.position.maxScrollExtent;
        await scrollController.position.moveTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500));
      } while (scrollController.position.pixels != scrollController.position.maxScrollExtent);
    } else if (oldPositionScrollMax == 0) {
      oldPositionScrollMax = scrollController.position.maxScrollExtent;
      scrollController.position.jumpTo(scrollController.position.maxScrollExtent);
    }
    oldPositionScrollMax = scrollController.position.maxScrollExtent;
    return;
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constant.JSONKEY_TOKEN, "");
    FirebaseMessaging.instance.deleteToken();
  }
}

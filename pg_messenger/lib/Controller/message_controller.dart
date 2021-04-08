import 'dart:convert';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Controller/web_socket_controller.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:http/http.dart' as http;

class MessageController {
  List<Message> _messageList = [];
  final String _userToken;
  WebSocketController? _webSocketController;

  MessageController(this._userToken) {
    _webSocketController = WebSocketController(_userToken);
  }

  Message createNewMessageFromString(String messageString, User user) {
    return Message("", messageString, user.id, null, "", false);
  }

  Message createNewMessageWithPicture(String picturePath, User user) {
    return Message("", picturePath, user.id, null, "", true);
  }

  void messageStream(
      {required Function(List<Message> messageList)
          onMessageListLoaded}) async {
    _webSocketController?.onReceive(onReceiveData: (data) {
      if (hasMessages(data)) {
        onMessageListLoaded(_messageList);
      }
    });
  }

  bool hasMessages(dynamic messageReceived) {
    final List<dynamic>? dataListJson = jsonDecode(messageReceived.toString());
    if (dataListJson != null) {
      _messageList = [];
      for (var messageJson in dataListJson) {
        _messageList.add(Message.fromJson(messageJson));
      }
      return true;
    }
    return false;
  }

  sendMessage(Message message) {
    _webSocketController?.sendMessage(message);
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
}

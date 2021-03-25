import 'dart:convert';
import 'package:pg_messenger/Models/message.dart';
// import 'package:pg_messenger/Models/owner.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:pg_messenger/Controller/web_socket_controller.dart';
import 'package:pg_messenger/Models/user.dart';

class MessageController {
  List<Message> _messageList = [];
  final String _userToken;
  WebSocketController? _webSocketController;

  MessageController(this._userToken) {
    _webSocketController = WebSocketController(_userToken);
  }

  Message createNewMessageFromString(String messageString, User user) {
    return Message("", messageString, user.id, null, ""); //manque id ?
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
}

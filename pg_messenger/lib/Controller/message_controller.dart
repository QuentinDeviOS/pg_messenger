import 'dart:convert';
import 'package:pg_messenger/Controller/WebSocketController.dart';
import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/user.dart';

class MessageController {
  List<Message> _messageList = [];
  final WebSocketController _webSocketController = WebSocketController();

  Message createNewMessageFromString(String messageString, User user) {
    return Message(messageString, user, null);
  }

  void messageStream({required Function(List<Message> messageList) onMessageListLoaded}) async {
    _webSocketController.onReceive(onReceiveData: (data) {
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
    _webSocketController.sendMessage(message);
  }
}

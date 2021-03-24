import 'dart:convert';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/owner.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:pg_messenger/Controller/web_socket_controller.dart';
// import 'package:pg_messenger/Models/user.dart';

class MessageController {
  List<Message> _messageList = [];
  final WebSocketController _webSocketController = WebSocketController();

  Message createNewMessageFromString(String messageString, Owner owner) {
    return Message(messageString, owner, null, ""); //manque id ?
  }

  void messageStream(
      {required Function(List<Message> messageList)
          onMessageListLoaded}) async {
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

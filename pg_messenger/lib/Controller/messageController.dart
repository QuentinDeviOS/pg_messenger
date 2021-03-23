import 'dart:async';
import 'dart:convert';

import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:web_socket_channel/io.dart';

class MessageController {
  List<Message> _messageList = [];

  Message createNewMessageFromString(String messageString, User user) {
    return Message(messageString, user, null);
  }

  void messageStream(Future<IOWebSocketChannel> futureChannel,
      {required Function(List<Message> messageList)
          onMessageListLoaded}) async {
    final channel = await futureChannel;
    channel.stream.listen((dataReceived) {
      if (hasMessages(dataReceived)) {
        onMessageListLoaded(_messageList);
      }
    });
  }

  bool hasMessages(dynamic messageReceived) {
    final List<dynamic> messageListJson =
        jsonDecode(messageReceived.toString());
    if (messageListJson.isNotEmpty) {
      _messageList = [];
      for (var messageJson in messageListJson) {
        _messageList.add(Message.fromJson(messageJson));
      }
      return true;
    }
    return false;
  }
}

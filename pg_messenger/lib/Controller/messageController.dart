import 'dart:async';
import 'dart:convert';

import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:web_socket_channel/io.dart';

class MessageController {
  StreamController<List<Message>> controller =
      StreamController<List<Message>>();
  List<Message> _messageList = [];
  List<Message> get messageList {
    return _messageList;
  }

  set messageList(List<Message> messageList) {
    _messageList = messageList;
    //controller.add(messageList);
  }

  MessageController() {
    //controller.add(messageList);
  }

  void messageStream(IOWebSocketChannel channel) {
    channel.stream.listen((message) {
      print("listen");

      // channel.sink.close();
      // print("receive data");
      // final messageJsonString = message.toString();
      // hasMessage(messageJsonString);

      //DEBUG
    });
  }

  Message createNewMessageFromString(String messageString, User user) {
    return Message(messageString, user);
  }

  bool hasMessage(String messageReceived) {
    final List<dynamic> messageListJson = jsonDecode(messageReceived);
    if (messageListJson.isNotEmpty) {
      messageList = [];
      for (var messageJson in messageListJson) {
        if (Message.fromJson(messageJson) != null) {
          messageList.add(Message.fromJson(messageJson));
          print("add message to messageList on controller"); //DEBUG
        }
      }
    }
    return false;
  }
}

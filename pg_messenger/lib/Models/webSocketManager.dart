import 'dart:convert';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  var messageNotificationHasChanged = false;

  IOWebSocketChannel connectToWS(String token) {
    Map<String, dynamic> header = Map();
    header["Authorization"] = token /*token*/; //implementer le token user
    var channel =
        IOWebSocketChannel.connect(Constant.URL_WEB_SERVER, headers: header);
    return channel;
  }

  void sendNewMessageJson(IOWebSocketChannel channel, Message message) {
    channel.sink.add(JsonEncoder().convert(message.toJson()));
  }

  void sendText(IOWebSocketChannel channel, text) {
    channel.sink.add(text);
  }
}

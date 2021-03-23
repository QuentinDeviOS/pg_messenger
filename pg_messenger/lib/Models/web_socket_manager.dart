import 'dart:convert';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  var messageNotificationHasChanged = false;

  Future<IOWebSocketChannel> connectToWS(String token) async {
    Map<String, dynamic> header = Map();
    header["Authorization"] = token;
    var channel =
        IOWebSocketChannel.connect(Constant.URL_WEB_SERVER, headers: header);
    return channel;
  }

  void sendNewMessageJson(
    Future<IOWebSocketChannel> futureChannel,
    Message message,
  ) async {
    final channel = await futureChannel;
    channel.sink.add(JsonEncoder().convert(message.toJson()));
  }

  void sendText(Future<IOWebSocketChannel> futureChannel, text) async {
    final channel = await futureChannel;
    channel.sink.add(text);
  }

  void newMessageNotification(
      Future<IOWebSocketChannel> channel, Message message) {}
}

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

  launchStream(Future<IOWebSocketChannel> futureChannel,
      {required Function(dynamic data) onReceive}) async {
    final channel = await futureChannel;
    channel.stream.listen((data) {
      onReceive(data);
      _onPing(futureChannel, data);
    });
  }

  _onPing(Future<IOWebSocketChannel> futureChannel, dynamic data) async {
    final channel = await futureChannel;
    if (data.toString() == "Ping") {
      channel.sink.add("pong");
    }
  }
}

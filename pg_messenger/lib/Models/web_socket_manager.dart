import 'dart:convert';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  var messageNotificationHasChanged = false;

  Future<IOWebSocketChannel> connectToWS(String token, String? channel) async {
    Map<String, dynamic> header = Map();
    header["Authorization"] = token;
    if (channel != null) {
      var wsChannel = IOWebSocketChannel.connect(Constant.URL_WEB_SOCKET + "?channel=" + channel, headers: header, pingInterval: Duration(seconds: 3));
      return wsChannel;
    } else {
      var wsChannel = IOWebSocketChannel.connect(Constant.URL_WEB_SOCKET, headers: header, pingInterval: Duration(seconds: 3));
      return wsChannel;
    }
  }

  void sendNewMessageJson(Future<IOWebSocketChannel> futureChannel, Message message) async {
    final wsChannel = await futureChannel;
    wsChannel.sink.add(JsonEncoder().convert(message.toJsonForSending()));
  }

  void sendText(Future<IOWebSocketChannel> futureChannel, text) async {
    final wsChannel = await futureChannel;
    wsChannel.sink.add(text);
  }

  launchStream(Future<IOWebSocketChannel> futureChannel, {required Function(dynamic data) onReceive}) async {
    final wsChannel = await futureChannel;
    wsChannel.stream.listen((data) {
      onReceive(data);
      _onPing(futureChannel, data);
    });
  }

  _onPing(Future<IOWebSocketChannel> futureChannel, dynamic data) async {
    final wsChannel = await futureChannel;
    if (data.toString() == "ping") {
      wsChannel.sink.add("pong");
    }
  }
}

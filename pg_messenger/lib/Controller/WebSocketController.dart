import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/webSocketManager.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketController {
  final webSocketManager = WebSocketManager();
  Future<IOWebSocketChannel> channel;
  bool haveNewMessage;

  WebSocketController() {
    channel = webSocketManager.connectToWS("Bearer oPIbqQKdMI5F91OZaPi0Qw==");
    haveNewMessage = webSocketManager.messageNotificationHasChanged;
    sendText("get-all-messages");
  }

  void sendMessage(Message message) {
    webSocketManager.sendNewMessageJson(channel, message);
  }

  void sendText(String text) {
    webSocketManager.sendText(channel, text);
  }
}

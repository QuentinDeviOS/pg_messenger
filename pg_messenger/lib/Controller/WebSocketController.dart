import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/webSocketManager.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketController {
  final webSocketManager = WebSocketManager();
  Future<IOWebSocketChannel> channel;
  bool haveNewMessage;

  WebSocketController() {
    channel = webSocketManager.connectToWS("Bearer JjhZJO1JJBzoOSn5QXf6qQ==");
    haveNewMessage = webSocketManager.messageNotificationHasChanged;
    sendText("get-all-messages");
  }

  void sendMessage(Message message) {
    webSocketManager.newMessageNotification(channel, message);
  }

  void sendText(String text) {
    webSocketManager.sendText(channel, text);
  }
}

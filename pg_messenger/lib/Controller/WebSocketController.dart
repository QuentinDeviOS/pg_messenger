import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/webSocketManager.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketController {
  final webSocketManager = WebSocketManager();
  IOWebSocketChannel channel;
  bool haveNewMessage;

  WebSocketController() {
    channel = webSocketManager.connectToWS("Bearer yPLn7G0ITjYe+Ec3s3j63g==");
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

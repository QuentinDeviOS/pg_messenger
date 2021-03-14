import 'package:pg_messenger/Models/webSocketManager.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketController {
  final webSocketManager = WebSocketManager();
  Future<IOWebSocketChannel> channel;
  bool haveNewMessage;

  WebSocketController() {
    channel = webSocketManager.connectToWS();
    haveNewMessage = webSocketManager.messageNotificationHasChanged;
  }

  void newMessageNotification() {
    webSocketManager.newMessageNotification(channel);
  }
}

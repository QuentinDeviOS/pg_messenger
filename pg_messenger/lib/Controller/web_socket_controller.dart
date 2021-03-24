import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/web_socket_manager.dart';
import 'package:web_socket_channel/io.dart';
import 'package:pg_messenger/Constants/constant.dart';

class WebSocketController {
  final webSocketManager = WebSocketManager();
  late Future<IOWebSocketChannel> channel;
  late bool haveNewMessage;

  WebSocketController() {
    channel = webSocketManager.connectToWS("Bearer ${Constant.TEST_USER_TOKEN}");
    haveNewMessage = webSocketManager.messageNotificationHasChanged;
    sendText("get-all-messages");
  }

  void sendMessage(Message message, String userID) {
    webSocketManager.sendNewMessageJson(channel, message);
  }

  void sendText(String text) {
    webSocketManager.sendText(channel, text);
  }

  onReceive({required Function(dynamic data) onReceiveData}) {
    webSocketManager.launchStream(
      channel,
      onReceive: (data) => onReceiveData(data),
    );
  }
}

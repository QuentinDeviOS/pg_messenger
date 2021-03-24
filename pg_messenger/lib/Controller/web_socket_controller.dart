import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/messages.dart';
import 'package:pg_messenger/Models/webSocketManager.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketController {
  final webSocketManager = WebSocketManager();
  late Future<IOWebSocketChannel> channel;
  late bool haveNewMessage;

  WebSocketController() {
    channel = webSocketManager.connectToWS("Bearer ${Constant.TEST_USER_TOKEN}");
    haveNewMessage = webSocketManager.messageNotificationHasChanged;
    sendText("get-all-messages");
  }

  void sendMessage(Message message) {
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

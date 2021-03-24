import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/web_socket_manager.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketController {
  final _webSocketManager = WebSocketManager();
  late Future<IOWebSocketChannel> channel;
  late bool haveNewMessage;

  WebSocketController() {
    channel =
        _webSocketManager.connectToWS("Bearer ${Constant.TEST_USER_TOKEN}");
    haveNewMessage = _webSocketManager.messageNotificationHasChanged;
    sendText("get-all-messages");
  }

  void sendMessage(Message message) {
    _webSocketManager.sendNewMessageJson(channel, message);
  }

  void sendText(String text) {
    _webSocketManager.sendText(channel, text);
  }

  onReceive({required Function(dynamic data) onReceiveData}) {
    _webSocketManager.launchStream(
      channel,
      onReceive: (data) => onReceiveData(data),
    );
  }
}

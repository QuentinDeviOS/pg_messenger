import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/web_socket_manager.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketController {
  final webSocketManager = WebSocketManager();
  late Future<IOWebSocketChannel> channel;
  late bool haveNewMessage;

  WebSocketController(String token) {
    channel = webSocketManager.connectToWS("Bearer $token");
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

  closeWS() async {
    var chan = await channel;
    chan.sink.close();
  }
}

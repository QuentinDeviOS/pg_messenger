import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/web_socket_manager.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketController {
  final webSocketManager = WebSocketManager();
  late Future<IOWebSocketChannel> wsChannel;
  late bool haveNewMessage;

  connect(String token, String? channel) {
    wsChannel = webSocketManager.connectToWS("Bearer $token", channel);
  }

  void sendMessage(Message message) {
    webSocketManager.sendNewMessageJson(wsChannel, message);
  }

  void sendText(String text) {
    webSocketManager.sendText(wsChannel, text);
  }

  onReceive({required Function(dynamic data) onReceiveData}) {
    webSocketManager.launchStream(
      wsChannel,
      onReceive: (data) => onReceiveData(data),
    );
  }

  closeWS() async {
    var chan = await wsChannel;
    chan.sink.close();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/messageController.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketManager {
  var messageNotificationHasChanged = false;

  Future<IOWebSocketChannel> connectToWS(/*String token*/) async {
    Map<String, dynamic> header = Map();
    header["Authorization"] = "Bearer k18o6SLWD7sJp+CRWcIUig=="
        "Bearer k18o6SLWD7sJp+CRWcIUig==" /*token*/; //implementer le token user
    var channel =
        IOWebSocketChannel.connect(Constant.URL_WEB_SERVER, headers: header);
    channel.stream.listen((message) {
      if (message.toString() == Constant.MESSAGE_JUST_POSTED_BY_ANOTHER) {
        newMessageHasPostedByAnother();
      }
    });
    return channel;
  }

  void newMessageNotification(Future<IOWebSocketChannel> futureChannel) async {
    final channel = await futureChannel;
    channel.sink.add(Constant.MESSAGE_JUST_POSTED);
  }

  void newMessageHasPostedByAnother() {
    //code à implementer lorsque un nouveau message à été envoyé par quelqun d'autre
    /*DEBUG*/ print("ok");
  }
}

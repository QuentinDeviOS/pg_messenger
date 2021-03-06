import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/channel_controller.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Controller/user_controller.dart';
import 'package:pg_messenger/View/Connection/connection_view.dart';
import 'package:pg_messenger/View/message_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingView extends StatelessWidget {
  final channelController = ChannelController();
  final userController = UserController();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getToken(context);
    });

    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  getToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constant.JSONKEY_TOKEN);
    if (token != null && token.length > 1) {
      final user = await userController.getCurrentUserByToken(token);
      final channelList = await channelController.getChannels(token);
      if (channelList != null && user != null) {
        final MessageController _messageController = MessageController(user, channelList);
        await Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => MessageView(_messageController)));
        return;
      }
    }
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConnectionView()));
  }
}

import 'package:flutter/material.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/message.dart';

Widget imageMessage({required MessageController messageController, required Message message}) {
  Map<String, String> headers = Map();
  headers["Authorization"] = "Bearer ${messageController.currentUser.token}";
  return Image.network(
    Constant.URL_WEB_SERVER_BASE + Constant.PATH_TO_GET_PICTURE + "?filename=${message.message}",
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          messageController.jumpToEndAfterImageLoaded();
        });
        return child;
      }
      return CircularProgressIndicator();
    },
    headers: headers,
  );
}

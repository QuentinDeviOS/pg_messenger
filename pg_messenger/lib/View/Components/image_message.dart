import 'package:flutter/material.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Models/user.dart';

Widget imageMessage({required Message message, required User currentUser, required ScrollController scrollController, required double? oldPositionScrollMax}) {
  Map<String, String> headers = Map();
  headers["Authorization"] = "Bearer ${currentUser.token}";
  return Image.network(
    Constant.URL_WEB_SERVER_BASE + Constant.PATH_TO_GET_PICTURE + "?filename=${message.message}",
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          if (scrollController.position.pixels == oldPositionScrollMax) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        });
        return child;
      }
      return CircularProgressIndicator();
    },
    headers: headers,
  );
}

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/message.dart';

Widget imageMessage({required MessageController messageController, required Message message, required BuildContext context}) {
  Map<String, String> headers = Map();
  headers["Authorization"] = "Bearer ${messageController.currentUser.token}";
  return GestureDetector(
    child: Card(
      elevation: 2,
      child: Container(
        height: 200,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
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
            filterQuality: FilterQuality.low,
          ),
        ),
      ),
    ),
    onTap: () {
      showCupertinoModalBottomSheet(
          bounce: true,
          expand: true,
          enableDrag: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          builder: (context) => SafeArea(
                child: Image.network(
                  Constant.URL_WEB_SERVER_BASE + Constant.PATH_TO_GET_PICTURE + "?filename=${message.message}",
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                        messageController.jumpToEndAfterImageLoaded();
                      });
                      return child;
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                  headers: headers,
                  filterQuality: FilterQuality.high,
                ),
              ));
    },
  );
}

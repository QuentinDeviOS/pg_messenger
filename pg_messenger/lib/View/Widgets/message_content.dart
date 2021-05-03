import 'package:flutter/material.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/View/Components/image_message.dart';
import 'package:pg_messenger/generated/l10n.dart';

class MessageContent extends StatelessWidget {
  const MessageContent({
    Key? key,
    required this.messageController,
    required this.num,
  }) : super(key: key);

  final MessageController messageController;
  final int num;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (messageController.messageList[num].isPicture == null ||
            (messageController.messageList[num].flag != true &&
                !messageController.messageList[num].isPicture!))
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(messageController.messageList[num].message),
            ),
          ),
        if (messageController.messageList[num].isPicture != null &&
            messageController.messageList[num].flag != true &&
            messageController.messageList[num].isPicture!)
          imageMessage(
            messageController: messageController,
            message: messageController.messageList[num],
            context: context,
          ),
        if (messageController.messageList[num].flag == true &&
            messageController.currentUser.isModerator == false)
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(S.of(context).message_under_moderation),
            ),
          ),
        if (messageController.messageList[num].flag == true &&
            messageController.currentUser.isModerator == true)
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Text("** " + S.of(context).message_under_moderation + " **",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(messageController.messageList[num].message),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

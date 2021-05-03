import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/View/Widgets/message_bubble.dart';
import 'package:pg_messenger/View/Widgets/message_content.dart';

class SingleMessage extends StatelessWidget {
  final MessageController messageController;
  final int num;
  final EdgeInsets messagePadding;
  final MainAxisAlignment axisMessage;
  final bool isOwn;
  final Color messageColour;
  final Color textColour;

  const SingleMessage({
    Key? key,
    required this.messageController,
    required this.num,
    required this.messagePadding,
    required this.axisMessage,
    required this.isOwn,
    required this.messageColour,
    required this.textColour,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width * 0.60,
      blurSize: 5.0,
      menuItemExtent: 45,
      menuBoxDecoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      duration: Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Colors.black54,
      openWithTap: false,
      menuOffset: 10.0,
      bottomOffsetHeight: 80.0,
      menuItems: <FocusedMenuItem>[
        if (messageController.messageList[num].owner !=
            messageController.currentUser.id)
          FocusedMenuItem(
              title: Text(
                "Report this message",
                style: TextStyle(color: Colors.orange),
              ),
              trailingIcon: Icon(
                Icons.warning,
                color: Colors.orange,
              ),
              onPressed: () {
                messageController.reportMessage(
                    messageController.messageList[num],
                    messageController.currentUser);
                // Navigator.of(context).pop();
              }),
        if (messageController.currentUser.isModerator == true ||
            messageController.messageList[num].owner ==
                messageController.currentUser.id)
          FocusedMenuItem(
              title: Text(
                "Delete this message",
                style: TextStyle(color: Colors.red),
              ),
              trailingIcon: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              onPressed: () {
                messageController.deleteMessage(
                    messageController.messageList[num],
                    messageController.currentUser);
                // Navigator.of(context).pop();
              }),
        if (messageController.currentUser.isModerator == true &&
            messageController.messageList[num].flag == true)
          FocusedMenuItem(
              title: Text(
                "Unflag this message",
                style: TextStyle(color: Colors.green),
              ),
              trailingIcon: Icon(
                Icons.check,
                color: Colors.green,
              ),
              onPressed: () {
                messageController.unflagMessage(
                    messageController.messageList[num],
                    messageController.currentUser);
                // Navigator.of(context).pop();
              }),
      ],
      onPressed: () {},
      child: Padding(
        padding: messagePadding,
        child: Row(
          mainAxisAlignment: axisMessage,
          children: <Widget>[
            Expanded(
              child: CustomPaint(
                painter: MessageBubble(
                  isOwn: isOwn,
                  messageColour: messageColour,
                  textColour: textColour,
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: MessageContent(
                      messageController: messageController, num: num),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

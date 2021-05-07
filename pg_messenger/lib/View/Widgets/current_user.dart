import 'package:flutter/material.dart';
import 'package:pg_messenger/main.dart';
import 'package:pg_messenger/View/Components/menu_channels.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';

class CurrentUser extends StatelessWidget {
  const CurrentUser({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final MenuChannels widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
        if (widget.messageController.currentUser.profilePict != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              child: widget.messageController.currentUser.profilePict,
              height: 60,
              width: 60,
            ),
          ),
        if (widget.messageController.currentUser.profilePict == null)
          ProfilePicture().defaultImagePicture(
              widget.messageController.currentUser.username,
              height: 60,
              width: 60),
        Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
        Text(
          widget.messageController.currentUser.username,
          style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.textDarkModeTitle,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'package:pg_messenger/main.dart';
import '../create_channel_view.dart';
import '../user_settings_view.dart';

Widget menuDrawer(BuildContext context, MessageController _messageController,
    Function upDateState) {
  return Drawer(
    child: SafeArea(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.fromLTRB(20, 40, 0, 0)),
            GestureDetector(
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                    if (_messageController.currentUser.profilePict != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          child: _messageController.currentUser.profilePict,
                          height: 60,
                          width: 60,
                        ),
                      ),
                    if (_messageController.currentUser.profilePict == null)
                      ProfilePicture().defaultImagePicture(
                          _messageController.currentUser.username,
                          height: 60,
                          width: 60),
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                    Text(
                      _messageController.currentUser.username,
                      style: TextStyle(
                          fontSize: 22,
                          color:
                              Theme.of(context).colorScheme.textDarkModeTitle,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserSettingsView(_messageController, () {
                                upDateState();
                              })));
                }),
            Padding(padding: EdgeInsets.fromLTRB(20, 15, 20, 20)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  Text(
                    S.of(context).channel,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.textDarkModeTitle,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  if (_messageController.currentUser.isModerator == true)
                    IconButton(
                        icon: Icon(
                          Icons.plus_one,
                          color:
                              Theme.of(context).colorScheme.textDarkModeTitle,
                        ),
                        onPressed: () => pushToCreateChannelView(
                            context, _messageController)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, num) =>
                    itemBuilder(context, num, _messageController, upDateState),
                itemCount: _messageController.channelList.length,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

pushToCreateChannelView(
    BuildContext context, MessageController _messageController) {
  Navigator.pop(context);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateChannelView(_messageController)));
}

Widget itemBuilder(BuildContext context, int num,
    MessageController _messageController, Function updateState) {
  if (_messageController.currentUser.isModerator == true) {
    return listViewBuilderIfModerator(
        context, num, _messageController, updateState);
  } else {
    return listViewBuilderIfNotModerator(
        context, num, _messageController, updateState);
  }
}

Widget listViewBuilderIfModerator(BuildContext context, int num,
    MessageController _messageController, Function updateState) {
  return drawerListViewComponent(context, num, _messageController, updateState);
}

Widget listViewBuilderIfNotModerator(BuildContext context, int num,
    MessageController _messageController, Function updateState) {
  if (_messageController.channelList[num].isPublic) {
    return drawerListViewComponent(
        context, num, _messageController, updateState);
  } else {
    return Padding(padding: EdgeInsets.all(0));
  }
}

Widget drawerListViewComponent(BuildContext context, int num,
    MessageController _messageController, Function updateState) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
    child: GestureDetector(
      child: Row(
        children: [
          Icon(
            Icons.tag,
            size: 20,
            color: Theme.of(context).colorScheme.textDarkModeTitle,
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 3, 0)),
          Text(
            _messageController.channelList[num].name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          if (!_messageController.channelList[num].isPublic)
            Padding(
              padding: EdgeInsets.only(right: 25),
              child: Text(
                "(Admin)",
                style: TextStyle(fontSize: 10),
              ),
            ),
        ],
      ),
      onTap: () {
        _messageController.onTapDrawerListTile(num, context, () {
          updateState();
        });
      },
    ),
  );
}

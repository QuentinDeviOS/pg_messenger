import 'package:flutter/material.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/channel.dart';
import 'package:pg_messenger/View/Widgets/current_user.dart';
import 'package:pg_messenger/View/create_channel_view.dart';
import 'package:pg_messenger/View/user_settings_view.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'package:pg_messenger/main.dart';

class MenuChannels extends StatefulWidget {
  final bool permanentlyDisplay;
  final MessageController messageController;
  final Function upDateState;
  MenuChannels({
    required this.permanentlyDisplay,
    required this.messageController,
    required this.upDateState,
    Key? key,
  }) : super(key: key);

  @override
  _MenuChannelsState createState() => _MenuChannelsState();
}

class _MenuChannelsState extends State<MenuChannels> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(20, 40, 0, 0)),
                  GestureDetector(
                      child: CurrentUser(widget: widget),
                      onTap: () {
                        //Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserSettingsView(
                                        widget.messageController, () {
                                      widget.upDateState();
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .textDarkModeTitle,
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        if (widget.messageController.currentUser.isModerator ==
                            true)
                          IconButton(
                            icon: Icon(
                              Icons.plus_one,
                              color: Theme.of(context)
                                  .colorScheme
                                  .textDarkModeTitle,
                            ),
                            onPressed: () => pushToCreateChannelView(
                                context, widget.messageController),
                          ),
                      ],
                    ),
                  ),
                  (widget.messageController.currentUser.isModerator == true)
                      ? Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Public"),
                            ],
                          ))
                      : Container(),
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      itemBuilder: (context, num) => publicItemBuilder(context,
                          num, widget.messageController, widget.upDateState),
                      itemCount: widget.messageController.channelList.length,
                    ),
                  ),
                  (widget.messageController.currentUser.isModerator == true)
                      ? Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Admin"),
                            ],
                          ))
                      : Container(),
                  (widget.messageController.currentUser.isModerator == true)
                      ? Flexible(
                          flex: 2,
                          child: ListView.builder(
                            itemBuilder: (context, num) => adminItemBuilder(
                                context,
                                num,
                                widget.messageController,
                                widget.upDateState),
                            itemCount:
                                widget.messageController.channelList.length,
                          ),
                        )
                      : Container(),
                  Spacer(),
                ],
              ),
            ),
            if (widget.permanentlyDisplay)
              VerticalDivider(
                width: 1,
                thickness: 2,
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}

pushToCreateChannelView(
    BuildContext context, MessageController _messageController) {
  Navigator.pop(context);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateChannelView(_messageController)));
}

Widget publicItemBuilder(BuildContext context, int num,
    MessageController _messageController, Function updateState) {
  if (_messageController.channelList[num].isPublic == true) {
    return ChannelItem(channelName: _messageController.channelList[num].name);
  } else {
    return Container();
  }
}

Widget adminItemBuilder(BuildContext context, int num,
    MessageController _messageController, Function updateState) {
  if (_messageController.channelList[num].isPublic == false) {
    return ChannelItem(channelName: _messageController.channelList[num].name);
  } else {
    return Container();
  }
}

class ChannelItem extends StatelessWidget {
  final String channelName;
  const ChannelItem({
    required this.channelName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
      child: GestureDetector(
        child: Row(
          children: [
            Icon(
              Icons.tag,
              size: 18,
              color: Theme.of(context).colorScheme.textDarkModeTitle,
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 3, 0)),
            Text(
              channelName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: () {
          // _messageController.onTapDrawerListTile(num, context, () {
          //   updateState();
          // });
        },
      ),
    );
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

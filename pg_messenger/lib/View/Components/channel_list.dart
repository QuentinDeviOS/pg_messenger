import 'package:flutter/material.dart';
import 'package:pg_messenger/Controller/channel_controller.dart';
import 'package:pg_messenger/Models/channel.dart';

class ChannelList extends StatelessWidget {
  ChannelList({
    required this.channelSelectedCallback,
    required this.selectedChannel,
    required this.token,
  });

  final ValueChanged<AllChannels> channelSelectedCallback;
  final Channel selectedChannel;
  final String token;

  @override
  Widget build(BuildContext context) {
    Future<AllChannels?> _channelController =
        ChannelController().getAllChannels(token);
    Future<Iterable<PublicChannel>?> publicChannel =
        _channelController.then((channel) {
      if (channel != null) {
        return channel.publicChannel
            .map((e) => PublicChannel(e.name, e.usersId, e.id));
      } else {
        return null;
      }
    });
    Future<Iterable<AdminChannel>?> adminChannel =
        _channelController.then((channel) {
      if (channel != null) {
        return channel.adminChannel
            .map((e) => AdminChannel(e.name, e.usersId, e.id));
      } else {
        return null;
      }
    });
    return Container();
    // return ListView(
    //   children: publicChannel.then((channel) {
    //     if (channel != null) {
    //       channel.map((e) {
    //         return ListTile(
    //       title: Text(e.name),
    //       onTap: () => channelSelectedCallback(_channelController),
    //       selected: selectedChannel == channel,
    //     );
    //       });
    //     }
    //   }).toList(),
    // );
  }
}

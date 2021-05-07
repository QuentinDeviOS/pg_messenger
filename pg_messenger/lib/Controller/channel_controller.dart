import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/channel.dart';
import 'package:pg_messenger/Models/user.dart';

class ChannelController {
  Future<int> createNewChannel(User user,
      {required String name, required bool isPublic}) async {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${user.token}";
    headers["Content-Type"] = "application/json; charset=utf-8";
    var body = JsonEncoder().convert({
      Constant.JSONKEY_CHANNEL_NAME: name,
      Constant.JSONKEY_CHANNEL_IS_PUBLIC: isPublic
    });
    var response = await http.post(
        Uri.parse(Constant.URL_WEB_SERVER_BASE + "/channel/create-channel"),
        body: body,
        headers: headers);
    return response.statusCode;
  }

  Future<List<Channel>?> getChannels(String token) async {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer $token";
    final channelListQuery = await http.get(
        Uri.parse(Constant.URL_WEB_SERVER_BASE + "/channel/get-channel"),
        headers: headers);
    if (channelListQuery.statusCode == 200) {
      List<Channel> channelList = [];
      List<dynamic> jsonList = jsonDecode(channelListQuery.body);
      for (var jsonChannel in jsonList) {
        Channel channel = Channel.fromJson(jsonChannel);
        channelList.add(channel);
      }
      final Channel generalChannel = Channel("General", true, [], null);
      channelList.insert(0, generalChannel);
      return channelList;
    }
    return null;
  }

  Future<AllChannels?> getAllChannels(String token) async {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer $token";
    final channelListQuery = await http.get(
        Uri.parse(Constant.URL_WEB_SERVER_BASE + "/channel/get-channel"),
        headers: headers);
    if (channelListQuery.statusCode == 200) {
      List<PublicChannel> publicChannelList = [];
      List<AdminChannel> adminChannelList = [];
      List<dynamic> jsonList = jsonDecode(channelListQuery.body);
      for (var jsonChannel in jsonList) {
        Channel channel = Channel.fromJson(jsonChannel);
        if (channel.isPublic == true) {
          publicChannelList
              .add(PublicChannel(channel.name, [channel.usersId], channel.id));
        } else {
          adminChannelList
              .add(AdminChannel(channel.name, [channel.usersId], channel.id));
        }
      }
      final PublicChannel generalChannel = PublicChannel("General", [], null);
      publicChannelList.insert(0, generalChannel);
      return AllChannels(publicChannelList, adminChannelList);
    }
    return null;
  }
}

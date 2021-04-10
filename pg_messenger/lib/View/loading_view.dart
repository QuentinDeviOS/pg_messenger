import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/channel.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/connection_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'message_view.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getToken(context);
    });

    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  getToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constant.JSONKEY_TOKEN);
    if (token != null && token.length > 1) {
      Map<String, String> header = Map();
      header["Authorization"] = "Bearer $token";
      final loginByToken = await http.get(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/users/me"), headers: header);
      if (loginByToken.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(loginByToken.body);
        User user = User.fromLogin(
          json[Constant.JSONKEY_USER_ID],
          json[Constant.JSONKEY_USER_USERNAME],
          DateTime.parse(json[Constant.JSONKEY_USER_DATE_CREATION]),
          token,
          json[Constant.JSONKEY_USER_IS_ACTIVE],
          json[Constant.JSONKEY_USER_IS_MODERATOR],
          json[Constant.JSONKEY_USER_PICTURE],
        );
        final channelListQuery = await http.get(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/channel/get-channel"), headers: header);
        print(channelListQuery.statusCode);
        if (channelListQuery.statusCode == 200) {
          List<Channel> channelList = [];
          List<dynamic> jsonList = jsonDecode(channelListQuery.body);
          print("jsonlist : $jsonList");
          for (var jsonChannel in jsonList) {
            print(jsonChannel);
            Channel channel = Channel.fromJson(jsonChannel);
            channelList.add(channel);
          }
          await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MessageView(user, channelList)));
          return;
        }
      }
    }
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConnectionView()));
  }
}

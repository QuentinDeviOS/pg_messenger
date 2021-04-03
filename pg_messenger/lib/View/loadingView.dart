import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pg_messenger/Constants/constant.dart';
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
      child: CircularProgressIndicator(),
    );
  }

  getToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constant.JSONKEY_TOKEN);
    if (token != null && token.length > 1) {
      Map<String, String> header = Map();
      header["Authorization"] = "Bearer $token";
      final loginByToken = await http.get(
          Uri.parse(Constant.URL_WEB_SERVER_BASE + "/users/me"),
          headers: header);
      if (loginByToken.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(loginByToken.body);
        User user = User.fromLogin(
          json[Constant.JSONKEY_USER_ID],
          json[Constant.JSONKEY_USER_USERNAME],
          DateTime.parse(json[Constant.JSONKEY_USER_DATE_CREATION]),
          token,
        );
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MessageView(user)));
        return;
      }
    }
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ConnectionView()));
  }
}

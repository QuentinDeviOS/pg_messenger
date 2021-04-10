import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/user.dart';

class ChannelController {
  Future<int> createNewChannel(User user, {required String name, required bool isPublic}) async {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${user.token}";
    headers["Content-Type"] = "application/json; charset=utf-8";
    print(headers);
    var body = JsonEncoder().convert({Constant.JSONKEY_CHANNEL_NAME: name, Constant.JSONKEY_CHANNEL_IS_PUBLIC: isPublic});
    print(body);
    var response = await http.post(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/channel/create-channel"), body: body, headers: headers);
    return response.statusCode;
  }
}

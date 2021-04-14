import 'dart:convert';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:pg_messenger/Models/user.dart';

class UserController {
  Future<User?> getCurrentUserByToken(String token) async {
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
      return user;
    }
    return null;
  }
}

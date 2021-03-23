import 'package:pg_messenger/Models/user.dart';

class UserToken {
  final String _token;
  final User _user;

  String get token => _token;
  User get user => _user;

  const UserToken(this._token, this._user);

  Map<String, dynamic> toJson() => {'token': token, 'user': _user.toJSON()};

  UserToken.fromJson(Map<String, dynamic> json)
      : _token = json["token"],
        _user = User(
          json["user"]["id"],
          json["user"]["name"],
          DateTime.parse(json["user"]["createdAt"]),
        );
}

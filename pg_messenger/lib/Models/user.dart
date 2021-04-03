import 'package:pg_messenger/Constants/constant.dart';

class User {
  final String _username;
  final String _id;
  final DateTime? _createdAt;
  final String _token;

  String get username => _username;
  String get id => _id;
  DateTime? get createdAt => _createdAt;
  String get token => _token;

  User.fromLogin(
    this._id,
    this._username,
    this._createdAt,
    this._token,
  );

  User.fromJsonResponseLogin(Map<String, dynamic> json)
      : this._username =
            json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_USERNAME],
        this._id = json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_ID],
        this._createdAt = DateTime.parse(
            json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_DATE_CREATION]),
        this._token = json[Constant.JSONKEY_TOKEN];

  User.fromJsonResponseMessage(
      Map<String, dynamic> json, this._username, this._createdAt, this._token)
      : this._id = json[Constant.JSONKEY_USER_ID];

  Map<String, dynamic> toJsonForSendMessage() => {
        Constant.JSONKEY_USER_ID: _id,
      };
}

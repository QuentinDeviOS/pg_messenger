import 'package:pg_messenger/Models/user.dart';

class Message {
  final String _message;
  final User _owner;
  double? _timestamp;

  String get message => _message;
  User get owner => _owner;
  double? get timestamp => _timestamp;

  Message(this._message, this._owner, this._timestamp);

  Map<String, dynamic> toJson() =>
      {'subject': message, 'owner': _owner.toJSON()};

  Message.fromJson(Map<String, dynamic> json)
      : _message = json["subject"],
        _owner = User(json["userID"], json["username"], null),
        _timestamp = json["timestamp"];
}

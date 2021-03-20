import 'package:pg_messenger/Models/user.dart';

class Message {
    final String _message;
    final User _owner;

    String get message => _message;
    User get owner => _owner;

    const Message(this._message, this._owner);

  Map<String, dynamic> toJson() =>
      {'subject': message, 'owner': _owner.id};

  Message.fromJson(Map<String, dynamic> json)
    : _message = json["subject"],
      _owner = User(json["userID"], json["username"]);
}

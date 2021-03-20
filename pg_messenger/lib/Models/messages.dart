import 'package:pg_messenger/Models/user.dart';

class Message {
  final String _id;
  final String _message;
  final User _owner;

  const Message(this._message, this._owner, {this._id});

  Map<String, dynamic> toJson() =>
      {'subject': message, 'owner': _owner.toJSON()};

  Message.fromJson(Map<String, dynamic> json)
      : message = json["subject"],
        owner = User(id: json["userID"], username: json["username"]),
        id = json["id"];
}

import 'package:pg_messenger/Models/user.dart';

class Message {
  final String id;
  final String message;
  final User owner;
  Message(this.message, this.owner, {this.id});

  Map<String, dynamic> toJson() =>
      {'subject': message, 'owner': owner.toJSON()};

  Message.fromJson(Map<String, dynamic> json)
      : message = json["subject"],
        owner = User(id: json["userID"], username: json["username"]),
        id = json["id"];
}

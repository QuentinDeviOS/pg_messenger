import 'package:pg_messenger/Models/user.dart';

class Message {
  String message;
  User owner;
  Message(this.message, this.owner);

  Map<String, dynamic> toJson() =>
      {'subject': message, 'owner': owner.toJSON()};
}

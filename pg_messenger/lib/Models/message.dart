import 'package:pg_messenger/Models/owner.dart';

class Message {
  final String _message;
  final Owner _owner;
  final DateTime? _timestamp;
  final String _id;

  String get message => _message;
  Owner get ownerId => _owner;
  DateTime? get timestamp => _timestamp;
  String get id => _id;

  const Message(this._message, this._owner, this._timestamp, this._id);

  Map<String, dynamic> toJson() => {
        'subject': message,
        'owner': _owner.toJson(),
        'timestamp': timestamp,
        'id': id,
      };

  Message.fromJson(Map<String, dynamic> json)
      : _message = json["subject"],
        _owner = Owner(
          json["owner"]["id"],
          null,
        ),
        _timestamp = DateTime.parse(json["createdAt"]),
        _id = json["id"];
}

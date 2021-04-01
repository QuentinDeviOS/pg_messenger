import 'package:pg_messenger/Constants/constant.dart';

class Message {
  final String _username;
  final String _message;
  final String _ownerID;
  final String _messageID;
  double? _timestamp;

  String get messageID => _messageID;
  String get username => _username;
  String get message => _message;
  String get owner => _ownerID;
  DateTime? get timestamp {
    return DateTime.fromMillisecondsSinceEpoch((_timestamp! * 1000).truncate());
  }

  Message(this._messageID, this._message, this._ownerID, this._timestamp, this._username);

  Map<String, dynamic> toJson() => {
        Constant.JSONKEY_MESSAGE_MESSAGE: message,
        'ownerId': {'id': _ownerID}
      };

  Message.fromJson(Map<String, dynamic> json)
      : _message = json[Constant.JSONKEY_MESSAGE_MESSAGE],
        _ownerID = json[Constant.JSONKEY_MESSAGE_USERID],
        _username = json[Constant.JSONKEY_MESSAGE_USERNAME],
        _timestamp = json[Constant.JSONKEY_MESSAGE_TIMESTAMP],
        _messageID = json[Constant.JSONKEY_MESSAGE_ID];
}

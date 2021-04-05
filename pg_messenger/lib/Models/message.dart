import 'package:pg_messenger/Constants/constant.dart';

class Message {
  final String _username;
  final String _message;
  final String _ownerID;
  final String _messageID;
  double? _timestamp;
  bool? _flag;
  bool _isPicture;

  String get messageID => _messageID;
  String get username => _username;
  String get message => _message;
  String get owner => _ownerID;
  bool? get flag => _flag;
  bool get isPicture => _isPicture;
  DateTime? get timestamp {
    return DateTime.fromMillisecondsSinceEpoch((_timestamp! * 1000).truncate());
  }

  Message(
    this._messageID,
    this._message,
    this._ownerID,
    this._timestamp,
    this._username,
    this._isPicture,
  );

  Map<String, dynamic> toJsonForSending() => {
        Constant.JSONKEY_MESSAGE_MESSAGE: message,
        Constant.JSONKEY_MESSAGE_OWNER: {
          Constant.JSONKEY_MESSAGE_OWNER_ID: _ownerID
        },
        Constant.JSONKEY_MESSAGE_IS_PICTURE: _isPicture,
      };

  Map<String, dynamic> toJsonForReport() {
    return {Constant.JSONKEY_MESSAGE_ID: _messageID};
  }

  Message.fromJson(Map<String, dynamic> json)
      : _message = json[Constant.JSONKEY_MESSAGE_MESSAGE],
        _ownerID = json[Constant.JSONKEY_MESSAGE_USERID],
        _username = json[Constant.JSONKEY_MESSAGE_USERNAME],
        _timestamp = json[Constant.JSONKEY_MESSAGE_TIMESTAMP],
        _messageID = json[Constant.JSONKEY_MESSAGE_ID],
        _flag = json[Constant.JSONKEY_MESSAGE_FLAG],
        _isPicture = json[Constant.JSONKEY_MESSAGE_IS_PICTURE];
}

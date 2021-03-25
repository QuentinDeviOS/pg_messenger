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
        'subject': message,
        'owner': {'id': _ownerID}
      };

  Message.fromJson(Map<String, dynamic> json)
      : _message = json["subject"],
        _ownerID = json["userID"],
        _username = json["username"],
        _timestamp = json['timestamp'],
        _messageID = json["id"];
}

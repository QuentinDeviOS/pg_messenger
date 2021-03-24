class User {
  final String _username;
  final String _id;
  final DateTime? _createdAt;
  final String _token;

  String get username => _username;
  String get id => _id;
  DateTime? get createdAt => _createdAt;
  String get token => _token;

  User.fromLogin(this._id, this._username, this._createdAt, this._token);

  User.fromJsonResponseLogin(Map<String, dynamic> json)
      : this._username = json["user"]["name"],
        this._id = json["user"]["id"],
        this._createdAt = DateTime.parse(json["user"]["createdAt"]),
        this._token = json["token"];

  Map<String, dynamic> toJsonForSendMessage() => {'id': _id};
}

class User {
  final String _username;
  String? _id;
  DateTime? _createdAt;
  String? _token;
  String? _password;

  String get username => _username;
  String? get id => _id;
  DateTime? get createdAt => _createdAt;
  String? get token => _token;

  User.fromLogin(this._id, this._username, this._createdAt, this._token);

  User.forRegister(String password, this._username) {
    _id = null;
    _createdAt = null;
    _token = null;
    _password = password;
  }

  User.fromJson(Map<String, dynamic> json)
      : this._username = json["user"]["name"],
        this._id = json["user"]["id"],
        this._createdAt = json["user"]["createdAt"],
        this._token = json["token"];

  Map<String, dynamic> toJsonForRegister() => {'name': username, 'password': _password};
}

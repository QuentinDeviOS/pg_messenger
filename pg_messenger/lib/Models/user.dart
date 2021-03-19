class User {
  final String _username;
  final String _id;

  String get username => _username;
  String get id => _id;

  User(this._username, this._id);
  User.fromJson(Map<String, dynamic> json)
      : this._username = json["name"],
        this._id = json["id"];

  Map<String, dynamic> toJSON() => {'username': username, 'id': id};
}

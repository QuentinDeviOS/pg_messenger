class User {
  final String _username;
  final String _id;
  final DateTime? _createdAt;

  String get username => _username;
  String get id => _id;
  DateTime? get createdAt => _createdAt;

  const User(this._id, this._username, this._createdAt);

  User.fromJson(Map<String, dynamic> json)
      : this._username = json["name"],
        this._id = json["id"],
        this._createdAt = json["createdAt"];

  Map<String, dynamic> toJSON() => {
        'name': username,
        'id': id,
        'createdAt': createdAt,
      };
}

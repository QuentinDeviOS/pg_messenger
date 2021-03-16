class User {
  final String username;
  final String id;

  User({this.username, this.id});
  User.fromJson(Map<String, dynamic> json)
      : this.username = json["name"],
        this.id = json["id"];

  Map<String, dynamic> toJSON() => {'username': username, 'id': id};
}

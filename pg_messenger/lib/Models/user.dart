import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
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

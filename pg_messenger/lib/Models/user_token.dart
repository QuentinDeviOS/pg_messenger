import 'package:json_annotation/json_annotation.dart';
import 'package:pg_messenger/Models/user.dart';

/// This allows the `UserToken` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user_token.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class UserToken {
  final String token;
  final User user;

  const UserToken(this.token, this.user);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserTokenFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UserToken.fromJson(Map<String, dynamic> json) =>
      _$UserTokenFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserTokenToJson`.
  Map<String, dynamic> toJson() => _$UserTokenToJson(this);
}

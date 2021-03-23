// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserToken _$UserTokenFromJson(Map<String, dynamic> json) {
  return UserToken(
    json['token'] as String,
    User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserTokenToJson(UserToken instance) => <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
    };

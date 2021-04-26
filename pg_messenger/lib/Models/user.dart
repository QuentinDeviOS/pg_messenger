import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';

class User {
  final _profilePictureController = ProfilePicture();
  final String _username;
  final String _id;
  final DateTime? _createdAt;
  final String _token;
  final bool? _isActive;
  final bool? _isModerator;
  String? _picture;

  Image? profilePict;
  int _intToRefresh = 0;

  String get username => _username;
  String get id => _id;
  DateTime? get createdAt => _createdAt;
  String get token => _token;
  bool? get isActive => _isActive;
  bool? get isModerator => _isModerator;
  String? get picture => _picture;

  User.fromLogin(
    this._id,
    this._username,
    this._createdAt,
    this._token,
    this._isActive,
    this._isModerator,
    this._picture,
  );

  User.fromJsonResponseLogin(Map<String, dynamic> json)
      : this._username = json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_USERNAME],
        this._id = json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_ID],
        this._createdAt = DateTime.parse(json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_DATE_CREATION]),
        this._token = json[Constant.JSONKEY_TOKEN],
        this._isActive = json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_IS_ACTIVE],
        this._isModerator = json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_IS_MODERATOR],
        this._picture = json[Constant.JSONKEY_USER][Constant.JSONKEY_USER_PICTURE];

  User.fromJsonResponseMessage(Map<String, dynamic> json, this._username, this._createdAt, this._token, this._isActive, this._isModerator, this._picture) : this._id = json[Constant.JSONKEY_USER_ID];

  Map<String, dynamic> toJsonForSendMessage() => {
        Constant.JSONKEY_USER_ID: _id,
      };

  getImagePicture() async {
    if (_intToRefresh == 0) {
      _intToRefresh = 1;
      await DefaultCacheManager().removeFile(Constant.URL_WEB_SERVER_BASE + "/users/profile-picture?refresh=0");
      profilePict = await _profilePictureController.getImagePicture(user: this, username: this.username);
      return;
    } else {
      _intToRefresh = 0;
      await DefaultCacheManager().removeFile(Constant.URL_WEB_SERVER_BASE + "/users/profile-picture?refresh=1");
      profilePict = await _profilePictureController.getImagePicture(user: this, username: this.username);
      return;
    }
  }
}

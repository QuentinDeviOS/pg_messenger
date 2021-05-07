import 'package:pg_messenger/Models/user.dart';

class Channel {
  String? get id => _id;
  String get name => _name;
  bool get isPublic => _isPublic;
  List<dynamic>? get usersId => _usersId;

  final String? _id;
  final String _name;
  final bool _isPublic;
  final List<dynamic>? _usersId;

  Channel(this._name, this._isPublic, this._usersId, this._id);

  Channel.fromJson(Map<String, dynamic> json)
      : this._name = json['name'],
        this._isPublic = json['isPublic'],
        this._usersId = json['channelUser'],
        this._id = json['id'];

  toJsonForCreate(
      {required String name, required bool isPublic, required User user}) {}
}

class PublicChannel extends Channel {
  PublicChannel(String name, List? usersId, String? id)
      : super(name, true, usersId, id);
  PublicChannel.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class AdminChannel extends Channel {
  AdminChannel(String name, List? usersId, String? id)
      : super(name, false, usersId, id);
  AdminChannel.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class AllChannels {
  final List<PublicChannel> publicChannel;
  final List<AdminChannel> adminChannel;
  AllChannels(this.publicChannel, this.adminChannel);
}

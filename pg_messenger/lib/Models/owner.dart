import 'package:pg_messenger/Constants/constant.dart';

class Owner {
  final String _id;
  final String? _name;

  String get id => _id;
  String? get name => _name;

  const Owner(this._id, this._name);

  Map<String, dynamic> toJson() => {
        Constant.JSONKEY_USER_ID: id,
      };

  Owner.fromJson(Map<String, dynamic> json)
      : _id = json[Constant.JSONKEY_USER_ID],
        _name = json[Constant.JSONKEY_USER_USERNAME];
}

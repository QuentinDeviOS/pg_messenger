import 'package:flutter/material.dart';
import 'package:pg_messenger/Models/user.dart';

class GlobalStorage extends ChangeNotifier {
  final List<String> _token = [];
  final User _user;

  GlobalStorage(this._user);

  //UnmodifiableListView<String> get token => UnmodifiableListView(_token);
  String get token => _token.first;
  String get id => _user.id;
  String get username => _user.username;
  DateTime? get createdAt => _user.createdAt;

  bool get isLoggedIn => (_token.length > 0) ? true : false;

  void login(String token) {
    _token.add(token);
    notifyListeners();
  }

  void logout() {
    _token.clear();
    notifyListeners();
  }
}

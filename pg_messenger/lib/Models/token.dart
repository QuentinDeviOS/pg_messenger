import 'dart:collection';
import 'package:flutter/material.dart';

class Token extends ChangeNotifier {
  final List<String> _token = [];

  UnmodifiableListView<String> get token => UnmodifiableListView(_token);

  bool get isSet => (_token.length > 0) ? true : false;

  void login(String token) {
    _token.add(token);
    notifyListeners();
  }

  void logout() {
    _token.clear();
    notifyListeners();
  }
}

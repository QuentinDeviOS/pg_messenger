import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:pg_messenger/Models/user_token.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:pg_messenger/Models/user_token.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _userLogin;

  Future<UserToken> _loginUser() async {
    final uri = Uri.parse("https://skyisthelimit.net/users/login");
    final client =
        http_auth.BasicAuthClient("Quentin", "KLzV@LYU2.XxmGtcJwRgs92MGCVCiz");
    final response = await client.post(uri);
    if (response.statusCode == 200) {
      return UserToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Erreur de chargement des données");
    }
  }

  _userLoginSubmitted(value) {
    setState(() {
      _userLogin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        TextField(onSubmitted: _userLoginSubmitted),
        FutureBuilder<UserToken>(
          future: _loginUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Text(snapshot.data!.token);
            } else if (snapshot.hasError) {
              return Text("Erreur de chargement");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ]),
    );
  }
}

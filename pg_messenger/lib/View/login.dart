import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/user_token.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _userLogin;

  Future<UserToken> _loginUser() async {
    final uri = Uri.parse("https://skyisthelimit.net/users/login");
    final client = http_auth.BasicAuthClient(
        Constant.TEST_USER_USERNAME, Constant.TEST_USER_LOGIN_PASSWORD);
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
      appBar: AppBar(title: Text("Login")),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(20),
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              hintText: "username",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: "password",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            child: Text('Login'),
            onPressed: () {},
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.all(40),
          child: FutureBuilder<UserToken>(
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
        ),
      ]),
    );
  }
}

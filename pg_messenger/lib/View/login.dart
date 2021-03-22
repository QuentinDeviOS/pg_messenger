import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/user_token.dart';
import 'package:pg_messenger/View/messageView.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _username = "";
  String _password = "";

  _usernameModified(value) {
    setState(() {
      _username = value;
    });
  }

  _passwordModified(value) {
    setState(() {
      _password = value;
    });
  }

  Future<UserToken> _loginUser() async {
    final uri = Uri.parse("https://skyisthelimit.net/users/login");
    final client = http_auth.BasicAuthClient(_username, _password);
    final response = await client.post(uri);
    if (response.statusCode == 200) {
      final userToken = UserToken.fromJson(jsonDecode(response.body));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageView(userToken: userToken),
          ));
      return userToken;
    } else {
      throw Exception("Error when loading data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                onChanged: _usernameModified,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "username",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                onChanged: _passwordModified,
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
                child: Text('Log In'),
                onPressed: () => _loginUser,
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Text('Override Log In (testing)'),
                onPressed: () {
                  context.read<UserToken>().setToken(
                        Constant.TEST_USER_TOKEN,
                        Constant.TEST_USER_ID,
                        Constant.TEST_USER_USERNAME,
                      );
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

// FutureBuilder<UserToken>(
//             future: _loginUser(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data != null) {
//                 return Text(snapshot.data!.token);
//               } else if (snapshot.hasError) {
//               }
//             },
//           )

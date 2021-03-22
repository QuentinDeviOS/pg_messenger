import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/token.dart';
import 'package:pg_messenger/Models/user_token.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: _usernameController,
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
                controller: _passwordController,
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
                  context.read<Token>().login(Constant.TEST_USER_TOKEN);
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<UserToken> _loginUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final uri = Uri.parse("https://skyisthelimit.net/users/login");
    final client = http_auth.BasicAuthClient(username, password);
    final response = await client.post(uri);
    if (response.statusCode == 200) {
      return UserToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error when loading data");
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
}

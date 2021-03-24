import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/global_storage.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:provider/provider.dart';

import 'message_view.dart';

class LoginView extends StatelessWidget {
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
                onPressed: () => _loginUser(context),
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Text('Override Log In (testing)'),
                onPressed: () {
                  context.read<GlobalStorage>().login(Constant.TEST_USER_TOKEN);
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<User?> _loginUser(context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      final uri = Uri.parse("https://skyisthelimit.net/users/login");
      final client = http_auth.BasicAuthClient(username, password);
      final response = await client.post(uri);
      if (response.statusCode == 200) {
        User user = User.fromJsonResponseLogin(jsonDecode(response.body));
        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MessageView(user)));
      } else {
        _wrongLogin(context);
      }
    }
    return null;
  }

  _wrongLogin(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Are you sure about your credentials?"),
      content: Text("Username and/or password do not match."),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}

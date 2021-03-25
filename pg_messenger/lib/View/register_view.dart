import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/message_view.dart';

class RegisterView extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordVerificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Login")),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: _usernameController,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
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
                controller: _emailController,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "email",
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
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: _passwordVerificationController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "password verification",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                child: Text('Register'),
                onPressed: () => _registerUser(context),
              ),
            ),
            Spacer(),
          ]),
        ),
      ),
    );
  }

  Future<User?> _registerUser(context) async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String passwordVerification = _passwordVerificationController.text;

    if (password != passwordVerification) {
      _wrongImput(context, "Both password must match");
      return null;
    } else if (!email.contains('@')) {
      _wrongImput(context, "Must be a valid email address");
      return null;
    } else if (username.isNotEmpty && password.isNotEmpty) {
      final response = await createUser(username, email, password);
      if (response.statusCode == 200) {
        User user = User.fromJsonResponseLogin(jsonDecode(response.body));
        await Navigator.push(context, MaterialPageRoute(builder: (context) => MessageView(user)));
      } else {
        _wrongRegistration(context, response.body);
      }
    }
    return null;
  }

  Future<http.Response> createUser(
    String username,
    String email,
    String password,
  ) {
    return http.post(
      Uri.https('skyisthelimit.net', 'users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': username,
        'email': email,
        'password': password,
      }),
    );
  }

  _wrongImput(BuildContext context, String error) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(error),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  _wrongRegistration(BuildContext context, String responseBodyError) {
    Map<String, dynamic> json = jsonDecode(responseBodyError);
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(json["reason"]),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}

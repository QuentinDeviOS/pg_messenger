import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/loading_view.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
        appBar: AppBar(title: Text(S.of(context).login_title)),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: AutofillGroup(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _usernameController,
                    autofillHints: <String>[AutofillHints.username],
                    enableSuggestions: false,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: S.of(context).login_username,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _passwordController,
                    autofillHints: <String>[AutofillHints.password],
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: S.of(context).login_password,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: Text(S.of(context).login_send_button),
                    onPressed: () => _loginUser(context),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> _loginUser(context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      final uri = Uri.parse(Constant.URL_WEB_SERVER_BASE + "/users/login");
      final client = http_auth.BasicAuthClient(username, password);
      final response = await client.post(uri);
      if (response.statusCode == 200) {
        User user = User.fromJsonResponseLogin(jsonDecode(response.body));
        await registerToken(user.token);
        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingView()));
      } else {
        _wrongLogin(context);
      }
    }
    return null;
  }

  _wrongLogin(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(S.of(context).register_alert_OK_button),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).login_error_title),
      content: Text(S.of(context).login_error_text),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  registerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Constant.JSONKEY_TOKEN, token);
  }
}

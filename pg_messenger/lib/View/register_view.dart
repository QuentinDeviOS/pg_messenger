import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/message_view.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

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
        appBar: AppBar(title: Text(S.of(context).register_title)),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _usernameController,
                        autofillHints: <String>[AutofillHints.nickname],
                        enableSuggestions: false,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: S.of(context).register_username,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _emailController,
                        autofillHints: <String>[AutofillHints.email],
                        enableSuggestions: false,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: S.of(context).register_email,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _passwordController,
                        autofillHints: <String>[AutofillHints.newPassword],
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: S.of(context).register_password,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _passwordVerificationController,
                        autofillHints: <String>[AutofillHints.newPassword],
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText:
                              S.of(context).register_password_verification,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: S.of(context).register_EULA_message,
                              style: TextStyle(color: Colors.red),
                            ),
                            TextSpan(
                              text: S.of(context).register_EULA_message_link,
                              style: TextStyle(color: Colors.blue),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () async {
                                  final url = Constant.URL_TC;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw S
                                        .of(context)
                                        .register_EULA_launching_error(url);
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        child: Text(S.of(context).register_send_button),
                        onPressed: () => _registerUser(context),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> _registerUser(context) async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String passwordVerification = _passwordVerificationController.text;
    bool isActive = true;
    bool isModerator = false;

    if (password != passwordVerification) {
      _wrongImput(context, S.of(context).register_error_password);
      return null;
    } else if (!email.contains('@')) {
      _wrongImput(context, S.of(context).register_error_email);
      return null;
    } else if (username.isNotEmpty && password.isNotEmpty) {
      final response = await createUser(username, email, password, isActive, isModerator);
      if (response.statusCode == 200) {
        User user = User.fromJsonResponseLogin(jsonDecode(response.body));
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => MessageView(user)));
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
    bool isActive,
    bool isModerator,
  ) {
    return http.post(
      Uri.https(Constant.URL_BASE, 'users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        Constant.JSONKEY_USER_USERNAME: username,
        Constant.JSONKEY_USER_EMAIL: email,
        Constant.JSONKEY_USER_PASSWORD: password,
        Constant.JSONKEY_USER_IS_ACTIVE: true,
        Constant.JSONKEY_USER_IS_MODERATOR: false,
      }),
    );
  }

  _wrongImput(BuildContext context, String error) {
    Widget okButton = TextButton(
      child: Text(S.of(context).register_alert_OK_button),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).register_alert_title),
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
      child: Text(S.of(context).register_alert_OK_button),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).register_alert_title),
      content: Text(json[Constant.JSONKEY_USER_RESPONSE_ERROR_REASON]),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}

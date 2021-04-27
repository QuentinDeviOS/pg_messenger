import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/Connection/loading_view.dart';
import 'package:pg_messenger/generated/l10n.dart';

class ChangePassword extends StatefulWidget {
  final MessageController messageController;
  const ChangePassword(this.messageController);
  @override
  _ChangePasswordState createState() =>
      _ChangePasswordState(this.messageController);
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _showContent = false;
  final MessageController _messageController;
  final TextEditingController _actualPasswordController =
      TextEditingController();
  final FocusNode _focusFirstNewPassword = FocusNode();
  final TextEditingController _firstNewPassword = TextEditingController();
  final FocusNode _focusSecondNewPassword = FocusNode();
  final TextEditingController _secondNewPassword = TextEditingController();

  _ChangePasswordState(this._messageController);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
            title: Text(S.of(context).settings_change_password_title),
            trailing: Icon(
                _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onTap: () {
              setState(() {
                _showContent = !_showContent;
              });
            }),
        _showContent
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _actualPasswordController,
                            autofillHints: [AutofillHints.password],
                            obscureText: true,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText:
                                    S.of(context).settings_actual_password),
                            onFieldSubmitted: (value) {
                              if (_actualPasswordController.text == "") {
                                FocusScope.of(context).unfocus();
                              } else {
                                _focusFirstNewPassword.requestFocus();
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _firstNewPassword,
                            focusNode: _focusFirstNewPassword,
                            autofillHints: [AutofillHints.newPassword],
                            obscureText: true,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: S.of(context).settings_new_password),
                            onFieldSubmitted: (value) {
                              if (_actualPasswordController.text == "") {
                                FocusScope.of(context).unfocus();
                              } else {
                                _focusSecondNewPassword.requestFocus();
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _secondNewPassword,
                            focusNode: _focusSecondNewPassword,
                            autofillHints: [AutofillHints.newPassword],
                            obscureText: true,
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                hintText: S.of(context).settings_new_password),
                            onFieldSubmitted: (value) {
                              if (_actualPasswordController.text == "") {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              onPressed: () => _changePassword(context),
                              child: Text(S
                                  .of(context)
                                  .settings_change_password_button)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container()
      ]),
    );
  }

  Future<Response> _updatePassword(
      User user, String currentPassword, String newPassword) async {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${user.token}";
    headers["Content-Type"] = "application/json; charset=utf-8";
    var body = JsonEncoder().convert(
        {"currentPassword": currentPassword, "newPassword": newPassword});
    var response = await http.post(
        Uri.parse(Constant.URL_WEB_SERVER_BASE + '/users/update-password'),
        headers: headers,
        body: body);
    return response;
  }

  Future<User?> _changePassword(context) async {
    String password = _actualPasswordController.text;
    String newPassword = _firstNewPassword.text;
    String newPasswordVerification = _secondNewPassword.text;

    if (newPassword != newPasswordVerification) {
      _wrongInput(context, S.of(context).register_error_password);
      return null;
    } else if (newPassword.isNotEmpty) {
      final response = await _updatePassword(
          _messageController.currentUser, password, newPassword);
      if (response.statusCode == 401) {
        _wrongUpdatePassword(context,
            S.of(context).settings_wrong_actual_password, response.statusCode);
      } else if (response.statusCode == 200) {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoadingView()));
      } else {
        _wrongUpdatePassword(
            context, jsonDecode(response.body)["reason"], response.statusCode);
      }
      return null;
    }
  }

  _wrongInput(BuildContext context, String error) {
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

  _wrongUpdatePassword(BuildContext context, String? error, int statusCode) {
    Widget okButton = TextButton(
      child: Text(S.of(context).register_alert_OK_button),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).register_alert_title),
      content: Text(error ??
          S.of(context).settings_default_message_error_new_password +
              "$statusCode"),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}

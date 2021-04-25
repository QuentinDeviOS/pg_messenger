import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/Connection/loading_view.dart';
import 'package:pg_messenger/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsView extends StatefulWidget {
  final MessageController messageController;
  final Function callback;
  const UserSettingsView(this.messageController, this.callback);

  @override
  _UserSettingsViewState createState() =>
      _UserSettingsViewState(this.messageController);
}

class _UserSettingsViewState extends State<UserSettingsView> {
  final MessageController _messagecontroller;

  final _passwordController = TextEditingController();
  final _passwordVerificationController = TextEditingController();

  var _profilePictureController = ProfilePicture();
  var _randomInt = 1;

  _UserSettingsViewState(this._messagecontroller) {
    _profilePictureController = ProfilePicture();
    _randomInt = _randomInt + 1;
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  final TextEditingController _actualPasswordController =
      TextEditingController();
  final FocusNode _focusFirstNewPassword = FocusNode();
  final TextEditingController _firstNewPassword = TextEditingController();
  final FocusNode _focusSecondNewPassword = FocusNode();
  final TextEditingController _secondNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier mes préférences")),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: _profilePictureBuilderWidget(),
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: Text("Changer ma photo de profil"),
                  onPressed: () => onTapAddingPicture(context),
                ),
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    children: [
                      Text(
                        "Changer mon mot de passe :",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _actualPasswordController,
                          autofillHints: [AutofillHints.password],
                          decoration: InputDecoration(
                              hintText: "Mot de passe actuelle"),
                          onFieldSubmitted: (value) {
                            if (_actualPasswordController.text == "") {
                              FocusScope.of(context).unfocus();
                            } else {
                              _focusFirstNewPassword.requestFocus();
                            }
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _firstNewPassword,
                          focusNode: _focusFirstNewPassword,
                          autofillHints: [AutofillHints.password],
                          decoration:
                              InputDecoration(hintText: "Nouveau mot de passe"),
                          onFieldSubmitted: (value) {
                            if (_actualPasswordController.text == "") {
                              FocusScope.of(context).unfocus();
                            } else {
                              _focusFirstNewPassword.requestFocus();
                            }
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _secondNewPassword,
                          focusNode: _focusSecondNewPassword,
                          autofillHints: [AutofillHints.password],
                          decoration:
                              InputDecoration(hintText: "Nouveau mot de passe"),
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
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                            onPressed: () {
                              return;
                            },
                            child: Text("Changer mon mot de passe")),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilePictureBuilderWidget() {
    if (_messagecontroller.currentUser.profilePict != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 150,
            width: 150,
            child: _messagecontroller.currentUser.profilePict,
          ));
    }
    return _profilePictureController.defaultImagePicture(
        _messagecontroller.currentUser.username,
        height: 150,
        width: 150);
  }

  onTapAddingPicture(context) async {
    showMaterialModalBottomSheet(
        bounce: true,
        elevation: 20,
        expand: false,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  child: ListTile(
                    title: Text("Importer depuis la photothèque"),
                    onTap: () async {
                      await _profilePictureController.getImage(
                        _messagecontroller.currentUser,
                        () async {
                          await _messagecontroller.currentUser
                              .getImagePicture();
                          setState(() {
                            widget.callback();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                    leading: Icon(Icons.photo_album),
                  ),
                ),
              ),
              ListTile(
                title: Text("Prendre une nouvelle photo"),
                onTap: () async {
                  await _profilePictureController.takePicture(
                    _messagecontroller.currentUser,
                    onComplete: () async {
                      await _messagecontroller.currentUser.getImagePicture();
                      setState(() {
                        widget.callback();
                      });
                      Navigator.pop(context);
                    },
                  );
                },
                leading: Icon(Icons.camera),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 50))
            ],
          );
        });
  }

  Future<http.Response> updatePassword(
    String password,
  ) {
    return http.post(
      Uri.parse(Constant.URL_WEB_SERVER_BASE + '/users/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        Constant.JSONKEY_USER_PASSWORD: password,
      }),
    );
  }

  Future<User?> _changePassword(context) async {
    String password = _passwordController.text;
    String passwordVerification = _passwordVerificationController.text;

    if (password != passwordVerification) {
      _wrongInput(context, S.of(context).register_error_password);
      return null;
    } else if (password.isNotEmpty) {
      final response = await updatePassword(password);
      if (response.statusCode == 200) {
        User user = User.fromJsonResponseLogin(jsonDecode(response.body));
        await _registerToken(user.token);
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoadingView()));
      } else {
        _wrongRegistration(context, response.body);
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

  _registerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Constant.JSONKEY_TOKEN, token);
  }
}

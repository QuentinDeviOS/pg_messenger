import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/Connection/connection_view.dart';
import 'package:pg_messenger/View/Connection/loading_view.dart';
import 'package:pg_messenger/generated/l10n.dart';

class UserSettingsView extends StatefulWidget {
  final MessageController messageController;
  final Function callback;
  const UserSettingsView(this.messageController, this.callback);

  @override
  _UserSettingsViewState createState() =>
      _UserSettingsViewState(this.messageController);
}

class _UserSettingsViewState extends State<UserSettingsView> {
  final MessageController _messageController;
  var _profilePictureController = ProfilePicture();
  var _randomInt = 1;

  _UserSettingsViewState(this._messageController) {
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
      appBar: AppBar(
        title: Text(S.of(context).settings_title),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _messageController.logOut();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => ConnectionView()),
                    (_) {
                  return false;
                });
              }),
        ],
      ),
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
                  child: Text(S.of(context).settings_change_picture),
                  onPressed: () => onTapAddingPicture(context),
                ),
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Column(
                    children: [
                      Text(
                        S.of(context).settings_change_password_title,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _actualPasswordController,
                          autofillHints: [AutofillHints.password],
                          obscureText: true,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              hintText: S.of(context).settings_actual_password),
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
                      Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
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
                            child: Text(
                                S.of(context).settings_change_password_button)),
                      ),
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
    if (_messageController.currentUser.profilePict != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 150,
            width: 150,
            child: _messageController.currentUser.profilePict,
          ));
    }
    return _profilePictureController.defaultImagePicture(
        _messageController.currentUser.username,
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
                    title: Text(S.of(context).picture_import_gallery),
                    onTap: () async {
                      await _profilePictureController.getImage(
                        _messageController.currentUser,
                        () async {
                          await _messageController.currentUser
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
                title: Text(S.of(context).picture_new),
                onTap: () async {
                  await _profilePictureController.takePicture(
                    _messageController.currentUser,
                    onComplete: () async {
                      await _messageController.currentUser.getImagePicture();
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
        _wrongUpdatePassword(
            context, S.of(context).settings_wrong_actual_password);
      } else if (response.statusCode == 200) {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoadingView()));
      } else {
        _wrongUpdatePassword(context, jsonDecode(response.body)["reason"]);
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

  _wrongUpdatePassword(BuildContext context, String error) {
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
}

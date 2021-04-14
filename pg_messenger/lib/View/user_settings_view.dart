import 'dart:math';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/Models/user.dart';

class UserSettingsView extends StatefulWidget {
  final User user;

  const UserSettingsView({Key? key, required this.user}) : super(key: key);

  @override
  _UserSettingsViewState createState() => _UserSettingsViewState(user);
}

class _UserSettingsViewState extends State<UserSettingsView> {
  final User user;

  var _profilePictureController = ProfilePicture();

  var _profilePictureFuture;

  _UserSettingsViewState(this.user) {
    _profilePictureController = ProfilePicture();
    _profilePictureFuture = _profilePictureController.getImagePicture(user: user, randomInt: Random().nextInt(5000), height: 150, width: 150, username: user.username);
  }

  final TextEditingController _actualPasswordController = TextEditingController();
  final FocusNode _focusFirstNewPassword = FocusNode();
  final TextEditingController _firstNewPassword = TextEditingController();
  final FocusNode _focusSecondNewPassword = FocusNode();
  final TextEditingController _secondNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier mes préférences")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: FutureBuilder(
                      future: _profilePictureFuture,
                      builder: _profilePictureBuilderWidget,
                    )),
              ),
              Center(
                child: ElevatedButton(
                  child: Text("Changer ma photo de profil"),
                  onPressed: () => onTapAddingPicture(context, user),
                ),
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    children: [
                      Text(
                        "Changer mon mot de passe :",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _actualPasswordController,
                          autofillHints: [AutofillHints.password],
                          decoration: InputDecoration(hintText: "Mot de passe actuelle"),
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
                          decoration: InputDecoration(hintText: "Nouveau mot de passe"),
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
                          decoration: InputDecoration(hintText: "Nouveau mot de passe"),
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

  Widget _profilePictureBuilderWidget(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 150,
            width: 150,
            child: snapshot.data,
          ));
    }
    return Text("data");
  }

  onTapAddingPicture(context, User currentUser) async {
    showMaterialModalBottomSheet(
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
                    onTap: () {
                      _profilePictureController.getImage(user, () {
                        setState(() {
                          _profilePictureFuture = _profilePictureController.getImagePicture(user: user, randomInt: Random().nextInt(5000), height: 150, width: 150, username: user.username);
                        });
                      });
                    },
                    leading: Icon(Icons.photo_album),
                  ),
                ),
              ),
              ListTile(
                title: Text("Prendre une nouvelle photo"),
                onTap: () async {
                  await _profilePictureController.takePicture(
                    currentUser,
                    onComplete: () {
                      setState(() {
                        _profilePictureFuture = _profilePictureController.getImagePicture(user: user, randomInt: Random().nextInt(5000), height: 150, width: 150, username: user.username);
                      });
                    },
                  );
                },
                leading: Icon(Icons.camera),
              )
            ],
          );
        });
  }
}

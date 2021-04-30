import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'package:pg_messenger/Controller/profile_picture_controller.dart';
import 'package:pg_messenger/View/Connection/connection_view.dart';
import 'package:pg_messenger/View/Widgets/change_password.dart';
import 'package:pg_messenger/generated/l10n.dart';

class UserSettingsView extends StatefulWidget {
  final MessageController messageController;
  final Function callback;
  const UserSettingsView(this.messageController, this.callback);

  @override
  _UserSettingsViewState createState() => _UserSettingsViewState(this.messageController);
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
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ConnectionView()), (_) {
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _messageController.currentUser.username,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              ChangePassword(_messageController),
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
    return _profilePictureController.defaultImagePicture(_messageController.currentUser.username, height: 150, width: 150);
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
                      await _profilePictureController.getImageFromGalleryAndUpload(
                        _messageController.currentUser,
                        (imageName) async {
                          await _messageController.currentUser.getImagePicture(imageName);
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
                  await _profilePictureController.takePictureAndUpload(
                    _messageController.currentUser,
                    onComplete: (imageName) async {
                      await _messageController.currentUser.getImagePicture(imageName);
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
}

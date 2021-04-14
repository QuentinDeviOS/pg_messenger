import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:pg_messenger/Models/user.dart';

class ProfilePicture {
  Future<bool> canGetPicture(User user, String? picture) async {
    Map<String, String> headers = Map();
    var requestUri;
    headers["Authorization"] = "Bearer ${user.token}";
    if (picture != null) {
      requestUri = Constant.URL_WEB_SERVER_BASE + "/users/canGetPicture?picture=$picture&refresh=" + Random().nextInt(5000000).toString();
    } else {
      requestUri = Constant.URL_WEB_SERVER_BASE + "/users/canGetPicture?refresh=" + Random().nextInt(5000000).toString();
    }
    var response = await http.get(Uri.parse(requestUri), headers: headers);
    if (response.statusCode == 200) {
      print("I returned true");
      return true;
    } else {
      print("I returned False");
      return true;
    }
  }

  Future<Image?> getImagePicture({required User user, String? picture, required int randomInt, required String username, required double height, required double width}) async {
    bool canGetPictureBool = await canGetPicture(user, picture);
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${user.token}";
    if (canGetPictureBool) {
      if (picture != null) {
        return Image.network(
          Constant.URL_WEB_SERVER_BASE + "/users/profile-picture?picture=$picture&refresh=" + randomInt.toString(),
          headers: headers,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return defaultImagePicture(username, height: height, width: width);
          },
        );
      } else {
        return Image.network(
          Constant.URL_WEB_SERVER_BASE + "/users/profile-picture?refresh=" + randomInt.toString(),
          headers: headers,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return defaultImagePicture(username, height: height, width: width);
          },
        );
      }
    } else {
      return null;
    }
  }

  Future uploadProfilePict(PickedFile? image, User currentUser, Function onUploadComplete) async {
    if (image != null) {
      http.MultipartFile _image = await http.MultipartFile.fromPath('file', image.path);

      Map<String, String> headers = Map();
      headers["Content-Type"] = "multipart/form-data";
      headers["Authorization"] = "Bearer ${currentUser.token}";

      var request = http.MultipartRequest("POST", Uri.parse(Constant.URL_WEB_SERVER_BASE + "/users/profile-picture"));
      request.headers.addAll(headers);
      request.files.add(_image);
      var response = await request.send();
      if (response.statusCode == 200) {
        onUploadComplete();
      }
    }
  }

  Widget defaultImagePicture(String username, {required double height, required double width}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: height,
        width: width,
        color: Colors.green.shade200,
        child: Center(
            child: Text(
          username.characters.first,
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }

  Future takePicture(User currentUser, {required Function() onComplete}) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.camera);
    return await uploadProfilePict(image, currentUser, () => onComplete());
  }

  Future getImage(User currentUser, Function() onComplete) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    await uploadProfilePict(image, currentUser, () => onComplete());
  }
}
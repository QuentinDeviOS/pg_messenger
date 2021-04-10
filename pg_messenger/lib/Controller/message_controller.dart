import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:pg_messenger/Constants/constant.dart';
import 'package:pg_messenger/Models/message.dart';
import 'package:pg_messenger/Controller/web_socket_controller.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:http/http.dart' as http;

class MessageController {
  List<Message> _messageList = [];
  final String _userToken;
  WebSocketController? _webSocketController;

  MessageController(this._userToken) {
    _webSocketController = WebSocketController(_userToken);
  }

  Message createNewMessageFromString(String messageString, User user, String? channel) {
    return Message("", messageString, user.id, null, "", false, channel);
  }

  Message createNewMessageWithPicture(String picturePath, User user, String? channel) {
    return Message("", picturePath, user.id, null, "", true, channel);
  }

  void messageStream({required Function(List<Message> messageList) onMessageListLoaded}) async {
    _webSocketController?.onReceive(onReceiveData: (data) {
      if (hasMessages(data)) {
        onMessageListLoaded(_messageList);
      }
    });
  }

  bool hasMessages(dynamic messageReceived) {
    final List<dynamic>? dataListJson = jsonDecode(messageReceived.toString());
    if (dataListJson != null) {
      _messageList = [];
      for (var messageJson in dataListJson) {
        _messageList.add(Message.fromJson(messageJson));
      }
      return true;
    }
    return false;
  }

  sendMessage(Message message) {
    _webSocketController?.sendMessage(message);
  }

  reportMessage(Message message, User user) async {
    Map<String, String> headers = Map();
    headers["Authorization"] = "Bearer ${user.token}";
    headers["Content-Type"] = "application/json; charset=utf-8";
    await http.post(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/report-message"), headers: headers, body: JsonEncoder().convert(message.toJsonForReport()));
  }

  Future takePicture(User currentUser) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.camera);
    uploadImage(image, currentUser);
  }

  Future getImage(User currentUser) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    uploadImage(image, currentUser);
  }

  Future uploadImage(PickedFile? image, User currentUser) async {
    if (image != null) {
      http.MultipartFile _image = await http.MultipartFile.fromPath('file', image.path);

      Map<String, String> headers = Map();
      headers["Content-Type"] = "multipart/form-data";
      headers["Authorization"] = "Bearer ${currentUser.token}";

      var request = http.MultipartRequest("POST", Uri.parse(Constant.URL_WEB_SERVER_BASE + "/photos/upload-picture"));
      request.headers.addAll(headers);
      request.files.add(_image);
      await request.send();
    }
  }

  deleteMessage(Message message, User user) async {
    if (message.owner == user.id || user.isModerator == true) {
      Map<String, String> headers = Map();
      headers["Authorization"] = "Bearer ${user.token}";
      headers["Content-Type"] = "application/json; charset=utf-8";
      await http.post(Uri.parse(Constant.URL_WEB_SERVER_BASE + "/messages/delete-message"), headers: headers, body: JsonEncoder().convert(message.toJsonForDeletion()));
    }
  }

  closeWS() {
    _webSocketController?.closeWS();
  }
}

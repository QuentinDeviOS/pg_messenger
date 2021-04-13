import 'package:flutter/material.dart';
import 'package:pg_messenger/Controller/channel_controller.dart';
import 'package:pg_messenger/Models/user.dart';
import 'package:pg_messenger/View/loading_view.dart';
import 'package:pg_messenger/View/message_view.dart';

class CreateChannelView extends StatefulWidget {
  final User _currentUser;

  CreateChannelView(Key? key, this._currentUser) : super(key: key);

  @override
  _CreateChannelViewState createState() => _CreateChannelViewState();
}

class _CreateChannelViewState extends State<CreateChannelView> {
  final _channelController = ChannelController();

  final _controller = TextEditingController();

  bool _isPublic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un nouveaux channel de discution"),
      ),
      body: Column(
        children: [
          Spacer(),
          Text(
            "Créer un nouveau Channel",
            style: TextStyle(fontSize: 22, color: Color(Colors.black54.value), fontWeight: FontWeight.bold),
          ),
          Form(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(hintText: "Nom du channel"),
                  controller: _controller,
                  onFieldSubmitted: (value) => createChannel(_isPublic),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
              Row(
                children: [
                  Checkbox(
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value as bool;
                      });
                    },
                  ),
                  Text("Créer ce Channel en Public")
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: ElevatedButton(
                    onPressed: () => createChannel(_isPublic),
                    child: Row(
                      children: [Icon(Icons.create_new_folder), Text("     Créer le channel !")],
                    )),
              )
            ],
          )),
          Spacer()
        ],
      ),
    );
  }

  createChannel(bool isPublic) async {
    final channelController = ChannelController();
    if (_controller.text.length < 3) {
    } else {
      var responseCode = await _channelController.createNewChannel(widget._currentUser, name: _controller.text, isPublic: isPublic);
      if (responseCode == 200) {
        final channelList = await channelController.getChannels(widget._currentUser.token);
        await Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            if (channelList != null) {
              return MessageView(widget._currentUser, channelList);
            }
            return LoadingView();
          },
        ));
      }
    }
  }
}

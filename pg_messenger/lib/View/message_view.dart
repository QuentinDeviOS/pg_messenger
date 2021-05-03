import 'package:flutter/cupertino.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pg_messenger/View/Widgets/single_message.dart';
import 'package:pg_messenger/View/user_settings_view.dart';
import 'package:pg_messenger/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pg_messenger/Controller/message_controller.dart';
import 'Components/drawer.dart';

class MessageView extends StatefulWidget {
  final MessageController _messageController;
  MessageView(
    this._messageController, {
    Key? key,
  }) : super(key: key);
  @override
  _MessageViewState createState() => _MessageViewState(_messageController);
}

class _MessageViewState extends State<MessageView> with WidgetsBindingObserver {
  final MessageController _messageController;

  _MessageViewState(this._messageController);

  @override
  void initState() {
    FlutterAppBadger.removeBadge();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _messageController.launchStream(onNewMessage: () {
      setState(() {});
    });
    _messageController.initView();
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    _messageController.onChangeMetrics(value);
    super.didChangeMetrics();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
      _messageController.launchStream(onNewMessage: () {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _messageController.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpened) {
        if (isOpened) {
        } else {
          _messageController.onDrawerWillClose();
        }
      },
      appBar: AppBar(
        title: Text(_messageController.title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserSettingsView(_messageController, () {})));
              }),
        ],
      ),
      drawer: menuDrawer(context, _messageController, () {
        _messageController.launchStream(onNewMessage: () {
          setState(() {});
        });
      }),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(controller: _messageController.scrollController, itemBuilder: _singleMessageBuilder, itemCount: _messageController.messageList.length),
            ),
            SizedBox(
              height: 5,
            ),
            Form(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _messageController.takePicture(),
                  ),
                  IconButton(
                    icon: Icon(Icons.insert_photo),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _messageController.getImage(),
                  ),
                  Expanded(
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _messageController.textController,
                      focusNode: _messageController.inputFieldNode,
                      onFieldSubmitted: (_) {
                        if (_messageController.textController.text == "") {
                          FocusScope.of(context).unfocus();
                        }
                        _messageController.sendMessage();
                        _messageController.textController.text = "";
                      },
                      onTap: () => _messageController.goToEndList(),
                      decoration: InputDecoration(
                          hintText: "Aa",
                          border: InputBorder.none,
                          filled: true,
                          contentPadding: EdgeInsets.all(8),
                          //labelText: S.of(context).message_send_button,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                          isDense: true),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _messageController.sendMessage,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _singleMessageBuilder(BuildContext context, int num) {
    bool isOwn = false;
    MainAxisAlignment axisMessage = MainAxisAlignment.start;
    Color messageColour = Theme.of(context).colorScheme.bubbleMessageDarkMode;
    Color textColour = Theme.of(context).colorScheme.bubbleMessageDarkModeTexte;
    EdgeInsets messagePadding = EdgeInsets.only(left: 15.0, right: 40.0);

    if (_messageController.messageList[num].owner == _messageController.currentUser.id) {
      isOwn = true;
      axisMessage = MainAxisAlignment.end;
      messageColour = Theme.of(context).colorScheme.bubbleMessageDarkModeAdmin;
      textColour = Theme.of(context).colorScheme.bubbleMessageDarkModeAdminTexte;
      messagePadding = EdgeInsets.only(right: 25.0);
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _messageController.goToEndList();
    });
    if (_messageController.messageList[num].channel == _messageController.currentChannel) {
      return Column(children: [
        if (!isOwn)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 60.0),
                child: Text(
                  _messageController.messageList[num].username,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  _messageController.formatedTimestamp(_messageController.messageList[num].timestamp, context),
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ],
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isOwn)
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    height: 30,
                    width: 30,
                    child: _messageController.ownerImageMap[_messageController.messageList[num].owner],
                  ),
                ),
              ),
            if (isOwn) Spacer(),
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              child: SingleMessage(
                messageController: _messageController,
                num: num,
                messagePadding: messagePadding,
                axisMessage: axisMessage,
                isOwn: isOwn,
                messageColour: messageColour,
                textColour: textColour,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ]);
    } else {
      return Container();
    }
  }
}

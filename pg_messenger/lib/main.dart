// import 'package:flutter/foundation.dart';
// import 'package:pg_messenger/Models/webSocketManager.dart';
// import 'package:pg_messenger/View/home.dart';
// import 'package:pg_messenger/View/login.dart';
// import 'package:pg_messenger/View/messageView.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: (),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'Models/Messages.dart';
import 'Models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //on crée notre header avec notre token pour se connecter au WS
    Map<String, dynamic> header = Map();
    header["Authorization"] = "Bearer tn+N3o7j7cPrPguDIkIvuA==";
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        //On se connecter au WebSocket
        channel: IOWebSocketChannel.connect(
            'ws://10.0.2.2:888/messages/new-message-added',
            headers: header),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                //snapshot correspond à un envoie de donnée depuis le serveur peut importe ce qu'il envoie, c'est recu ici
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData
                      ? '${snapshot.data.toString()}'
                      : ''), //Et du coup on l'affiche ici
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final user = User(
          id: "BD43343F-C0D5-4B40-A02C-03900045C770",
          username: "nicolas"); //on récupére l'utilisateur en cours
      final message = Message(_controller.text,
          user); //on crée un Objet message depuis l'utilisateur en cours et le message récupérer
      final messageJson =
          JsonEncoder().convert(message.toJson()); //on converti le tous en json
      widget.channel.sink
          .add(messageJson); //et on envoie ca au serveur par le WebSocket
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}

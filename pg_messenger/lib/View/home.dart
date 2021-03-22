import 'package:flutter/material.dart';
import 'package:pg_messenger/Models/user_token.dart';
import 'package:pg_messenger/View/connection.dart';
import 'package:pg_messenger/View/messageView.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserToken>(builder: (context, userToken, _) {
      return Container(
        child: (userToken.toString() != "") ? Connection() : MessageView(),
      );
    });
  }
}

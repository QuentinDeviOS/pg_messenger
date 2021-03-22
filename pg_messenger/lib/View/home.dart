import 'package:flutter/material.dart';
import 'package:pg_messenger/Models/token.dart';
import 'package:pg_messenger/View/connection.dart';
import 'package:pg_messenger/View/messageView.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Token>(builder: (context, token, _) {
      return Container(
        child: (token.isSet) ? MessageView() : Connection(),
      );
    });
  }
}

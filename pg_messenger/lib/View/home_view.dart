import 'package:flutter/material.dart';
import 'package:pg_messenger/Models/global_storage.dart';
import 'package:pg_messenger/View/connection_view.dart';
import 'package:pg_messenger/View/message_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStorage>(builder: (context, store, _) {
      return Container(
        child: (store.isLoggedIn) ? MessageView() : ConnectionView(),
      );
    });
  }
}

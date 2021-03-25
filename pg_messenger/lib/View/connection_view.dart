import 'package:flutter/material.dart';
import 'package:pg_messenger/View/login_view.dart';
import 'package:pg_messenger/View/register_view.dart';
import 'package:pg_messenger/generated/l10n.dart';

class ConnectionView extends StatefulWidget {
  ConnectionView({Key? key}) : super(key: key);

  @override
  _ConnectionViewState createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    LoginView(),
    RegisterView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: "",
            //label: "S.of(context).login_title",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            //label: register_title,
            label: "",
          ),
        ],
        selectedItemColor: Theme.of(context).bottomAppBarTheme.color,
        onTap: _onItemTapped,
      ),
      body: Container(
        child: _pages[_currentIndex],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

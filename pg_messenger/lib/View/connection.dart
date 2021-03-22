import 'package:flutter/material.dart';
import 'package:pg_messenger/View/login.dart';
import 'package:pg_messenger/View/register.dart';

class Connection extends StatefulWidget {
  Connection({Key? key}) : super(key: key);

  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Login(),
    Register(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Register',
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

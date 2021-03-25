import 'package:flutter/material.dart';
import 'package:pg_messenger/View/connection_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purple Giraffe Messenger',
      theme: ThemeData(
        primarySwatch: purpleGiraffe,
      ),
      home: ConnectionView(),
    );
  }
}

MaterialColor purpleGiraffe = MaterialColor(0xFF9C386C, pgColour);
Map<int, Color> pgColour = {
  50: Color.fromRGBO(156, 56, 108, .1),
  100: Color.fromRGBO(156, 56, 108, .2),
  200: Color.fromRGBO(156, 56, 108, .3),
  300: Color.fromRGBO(156, 56, 108, .4),
  400: Color.fromRGBO(156, 56, 108, .5),
  500: Color.fromRGBO(156, 56, 108, .6),
  600: Color.fromRGBO(156, 56, 108, .7),
  700: Color.fromRGBO(156, 56, 108, .8),
  800: Color.fromRGBO(156, 56, 108, .9),
  900: Color.fromRGBO(156, 56, 108, 1),
};

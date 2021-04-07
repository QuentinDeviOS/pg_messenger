import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pg_messenger/View/loading_view.dart';
import 'package:pg_messenger/generated/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Purple Giraffe Messenger",
      theme: ThemeData(
        primarySwatch: purpleGiraffe,
      ),
      home: LoadingView(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
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

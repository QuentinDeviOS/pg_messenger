import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pg_messenger/View/Connection/loading_view.dart';
import 'package:pg_messenger/generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Purple Giraffe Messenger",
      theme: ThemeData(primarySwatch: purpleGiraffe),
      darkTheme: ThemeData(brightness: Brightness.dark, primarySwatch: purpleGiraffe, primaryColor: purpleGiraffe, accentColor: purpleGiraffe, toggleableActiveColor: purpleGiraffe),
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

extension CustomColors on ColorScheme {
  Color get textDarkModeTitle => brightness == Brightness.light ? Colors.grey.shade700 : Colors.grey.shade400;
  Color get bubbleMessageDarkMode => brightness == Brightness.light ? Color.fromRGBO(212, 172, 193, 1) : Color.fromRGBO(113, 53, 84, 1);
  Color get bubbleMessageDarkModeTexte => brightness == Brightness.light ? Colors.black : Colors.white;
  Color get bubbleMessageDarkModeAdmin => brightness == Brightness.light ? Colors.green.shade300 : Colors.green.shade600;
  Color get bubbleMessageDarkModeAdminTexte => brightness == Brightness.light ? Colors.black : Colors.white;
  Color get bubbleMessageImageBackground => brightness == Brightness.light ? Color.fromRGBO(212, 172, 193, 0.7) : Color.fromRGBO(113, 53, 84, 0.4);
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

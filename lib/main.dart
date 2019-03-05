import 'package:flutter/material.dart';
import 'package:wowsy/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
        primaryColor: Color(0xFF44318e),
//        accentColor: Color(0xFFd83f87),
        accentColor: Color(0xFFe98074),
//        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: Home(),
    );
  }
}

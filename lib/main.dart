import 'package:flutter/material.dart';
import 'package:wowsy/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF44318e),
        accentColor: Color(0xFFe98074),
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, fontFamily: "Quicksand", color: Color(0xFFe98074)),
          title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: "Quicksand"),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Quicksand'),
        ),
      ),
      home: Home(),
    );
  }
}

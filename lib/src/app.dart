import 'package:flutter/material.dart';
import 'screens/loginScreen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: LoginScreen(),
      title: 'TicTacOnline',
    );
  }
}

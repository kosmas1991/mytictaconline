import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String gameId;

  const GameScreen({Key key, this.gameId}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(child: Text('game screen for ' + widget.gameId)),
    ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {

  final DocumentReference gameRef;
  final DocumentReference opGameRef;

  const GameScreen({Key key, this.gameRef, this.opGameRef}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(child: Text('game screen for ' + widget.gameRef.toString())),
          StreamBuilder<DocumentSnapshot>(
            stream: widget.gameRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String,dynamic> myMap = snapshot.data.data();
                return Text(myMap.toString());
              } else{
                return Text('NO DATA');
              }
            },
          )
        ],
      ),
    ));
  }
}

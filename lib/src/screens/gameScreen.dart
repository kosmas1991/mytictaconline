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
          Container(
              child: Text('game screen for ' + widget.gameRef.toString())),
          StreamBuilder<DocumentSnapshot>(
            stream: widget.gameRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> myMap = snapshot.data.data();
                return Column(
                  children: [
                    Text(myMap.toString()),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TicField(widget.gameRef, myMap["0"] == ""? Icons.crop_square: myMap["0"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["0"] == ""? Colors.grey: myMap["0"] == "x" ? Colors.red:Colors.green, 0, myMap["0"] == ""? true:false),
                              TicField(widget.gameRef, myMap["1"] == ""? Icons.crop_square: myMap["1"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["1"] == ""? Colors.grey: myMap["1"] == "x" ? Colors.red:Colors.green, 1, myMap["1"] == ""? true:false),
                              TicField(widget.gameRef, myMap["2"] == ""? Icons.crop_square: myMap["2"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["2"] == ""? Colors.grey: myMap["2"] == "x" ? Colors.red:Colors.green, 2, myMap["2"] == ""? true:false),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TicField(widget.gameRef, myMap["3"] == ""? Icons.crop_square: myMap["3"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["3"] == ""? Colors.grey: myMap["3"] == "x" ? Colors.red:Colors.green, 3, myMap["3"] == ""? true:false),
                              TicField(widget.gameRef, myMap["4"] == ""? Icons.crop_square: myMap["4"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["4"] == ""? Colors.grey: myMap["4"] == "x" ? Colors.red:Colors.green, 4, myMap["4"] == ""? true:false),
                              TicField(widget.gameRef, myMap["5"] == ""? Icons.crop_square: myMap["5"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["5"] == ""? Colors.grey: myMap["5"] == "x" ? Colors.red:Colors.green, 5, myMap["5"] == ""? true:false),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TicField(widget.gameRef, myMap["6"] == ""? Icons.crop_square: myMap["6"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["6"] == ""? Colors.grey: myMap["6"] == "x" ? Colors.red:Colors.green, 6, myMap["6"] == ""? true:false),
                              TicField(widget.gameRef, myMap["7"] == ""? Icons.crop_square: myMap["7"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["7"] == ""? Colors.grey: myMap["7"] == "x" ? Colors.red:Colors.green, 7, myMap["7"] == ""? true:false),
                              TicField(widget.gameRef, myMap["8"] == ""? Icons.crop_square: myMap["8"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["8"] == ""? Colors.grey: myMap["8"] == "x" ? Colors.red:Colors.green, 8, myMap["8"] == ""? true:false),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                );
              } else {
                return Text('NO DATA');
              }
            },
          )
        ],
      ),
    ));
  }

  Widget TicField(DocumentReference ref, IconData iconData, Color color,
      int index, bool isEnabled) {
    Map<String, dynamic> myMap;
    Function ternaryFunction() {
      return () async{
        await ref.get().then((value) {myMap = value.data();});
        myMap['$index'] = 'o'; //TODO: change this
        await ref.set(myMap);
      };
    }
    return IconButton(
      onPressed: isEnabled ? ternaryFunction() : null,
      icon: Icon(
        iconData,
        color: color,
        size: 50,
      ),
    );
  }
}

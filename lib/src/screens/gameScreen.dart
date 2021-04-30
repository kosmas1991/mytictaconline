import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mytictaconline/src/google_auth.dart';

class GameScreen extends StatefulWidget {
  final DocumentReference player1GameRef;
  final DocumentReference player2GameRef;
  final GoogleSignInAccount googleSignInAccount;

  const GameScreen({Key key, this.player1GameRef, this.player2GameRef, this.googleSignInAccount}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final String player1Symbol = 'o';
  final String player2Symbol = 'x';
  bool amIPlayer1;

  @override
  void initState() {
    widget.player1GameRef.get().then((value) {
      if (value.data()["player1"] == FirebaseAuth.instance.currentUser.uid) {
        amIPlayer1 = true;
        print('am player 1');
      }  else{
        amIPlayer1 = false;
        print('am player 2');
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: widget.player1GameRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> myMap = snapshot.data.data();
                checkWinAnytime(myMap);     //Anytime check for win
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["0"] == ""? Icons.crop_square: myMap["0"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["0"] == ""? Colors.grey: myMap["0"] == "x" ? Colors.red:Colors.green, 0, myMap["0"] == ""? true:false),
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["1"] == ""? Icons.crop_square: myMap["1"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["1"] == ""? Colors.grey: myMap["1"] == "x" ? Colors.red:Colors.green, 1, myMap["1"] == ""? true:false),
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["2"] == ""? Icons.crop_square: myMap["2"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["2"] == ""? Colors.grey: myMap["2"] == "x" ? Colors.red:Colors.green, 2, myMap["2"] == ""? true:false),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["3"] == ""? Icons.crop_square: myMap["3"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["3"] == ""? Colors.grey: myMap["3"] == "x" ? Colors.red:Colors.green, 3, myMap["3"] == ""? true:false),
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["4"] == ""? Icons.crop_square: myMap["4"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["4"] == ""? Colors.grey: myMap["4"] == "x" ? Colors.red:Colors.green, 4, myMap["4"] == ""? true:false),
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["5"] == ""? Icons.crop_square: myMap["5"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["5"] == ""? Colors.grey: myMap["5"] == "x" ? Colors.red:Colors.green, 5, myMap["5"] == ""? true:false),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["6"] == ""? Icons.crop_square: myMap["6"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["6"] == ""? Colors.grey: myMap["6"] == "x" ? Colors.red:Colors.green, 6, myMap["6"] == ""? true:false),
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["7"] == ""? Icons.crop_square: myMap["7"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["7"] == ""? Colors.grey: myMap["7"] == "x" ? Colors.red:Colors.green, 7, myMap["7"] == ""? true:false),
                          TicField(widget.player2GameRef,widget.player1GameRef, myMap["8"] == ""? Icons.crop_square: myMap["8"] == "x" ? Icons.cancel_outlined:Icons.circle, myMap["8"] == ""? Colors.grey: myMap["8"] == "x" ? Colors.red:Colors.green, 8, myMap["8"] == ""? true:false),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Text('NO DATA');
              }
            },
          ),
        ],
      ),
    ));
  }

  Widget TicField(DocumentReference opRef,DocumentReference myRef, IconData iconData, Color color,
      int index, bool isEnabled) {
    Map<String, dynamic> myMap;
    Map<String, dynamic> opMap;
    Function ternaryFunction() {
      return () async{
        await myRef.get().then((value) {myMap = value.data();});  //GET MAP
        int player1counter = 0;
        int player2counter = 0;
        for(int i=0; i<9; i++){
          if (myMap[i.toString()] == player1Symbol) {
            player1counter++;
          }  else if(myMap[i.toString()] == player2Symbol) {
            player2counter++;
          }
        }
        if (amIPlayer1 && player1counter<=player2counter) { //CHECK IF PLAYER 1 CAN PLAY
          myMap['$index'] = amIPlayer1? player1Symbol:player2Symbol;  //ASSIGN SYMBOL
          myMap["turn"] = amIPlayer1? "player2" : "player1";  //UPDATE MAP
          await opRef.get().then((value) {opMap = value.data();});
          opMap['$index'] = amIPlayer1? player1Symbol:player2Symbol;
          myMap["turn"] = amIPlayer1? "player2" : "player1";
          await myRef.set(myMap);
          await opRef.set(opMap);
        }
        if (!amIPlayer1 && player2counter == player1counter - 1) {  //CHECK IF PLAYER2 CAN PLAY
          myMap['$index'] = amIPlayer1? player1Symbol:player2Symbol;  //ASSIGN SYMBOL
          myMap["turn"] = amIPlayer1? "player2" : "player1";  //UPDATE MAP
          await opRef.get().then((value) {opMap = value.data();});
          opMap['$index'] = amIPlayer1? player1Symbol:player2Symbol;
          myMap["turn"] = amIPlayer1? "player2" : "player1";
          await myRef.set(myMap);
          await opRef.set(opMap);
        }
      };
    }
    return IconButton(
      onPressed: isEnabled ? ternaryFunction() : null,
      icon: Icon(
        iconData,
        color: color,
        size: 40,
      ),
    );
  }

  bool checkWin(Map myMap, String pos1, String pos2, String pos3, String symbol) {
    if ((myMap[pos1].toString() == symbol && myMap[pos2].toString() == symbol && myMap[pos3].toString() == symbol)) {
      //Navigator.of(context).pop();
      return true;
    }
    return false;
  }

  void checkWinAnytime(Map<String, dynamic> myMap) {
    if (checkWin(myMap,"0","1","2",player1Symbol) ||
        checkWin(myMap,"3","4","5",player1Symbol) ||
        checkWin(myMap,"6","7","8",player1Symbol) ||
        checkWin(myMap,"0","3","6",player1Symbol) ||
        checkWin(myMap,"1","4","7",player1Symbol) ||
        checkWin(myMap,"2","5","8",player1Symbol) ||
        checkWin(myMap,"0","4","8",player1Symbol) ||
        checkWin(myMap,"2","4","6",player1Symbol)
    ) {
      print('Player 1 won');
      String returnTextForPlayer1;
      if (amIPlayer1) {
        returnTextForPlayer1 = 'You WON';
      }  else{
        returnTextForPlayer1 = 'You LOST';
      }
      Navigator.pop(context, returnTextForPlayer1);
      widget.player1GameRef.delete();
      widget.player2GameRef.delete();
    }

    if (checkWin(myMap,"0","1","2",player2Symbol) ||
        checkWin(myMap,"3","4","5",player2Symbol) ||
        checkWin(myMap,"6","7","8",player2Symbol) ||
        checkWin(myMap,"0","3","6",player2Symbol) ||
        checkWin(myMap,"1","4","7",player2Symbol) ||
        checkWin(myMap,"2","5","8",player2Symbol) ||
        checkWin(myMap,"0","4","8",player2Symbol) ||
        checkWin(myMap,"2","4","6",player2Symbol)
    ) {
      print('Player 2 won');
      String returnTextForPlayer2;
      if (!amIPlayer1) {
        returnTextForPlayer2 = 'You WON';
      }  else{
        returnTextForPlayer2 = 'You LOST';
      }
      Navigator.pop(context, returnTextForPlayer2);
      widget.player1GameRef.delete();
      widget.player2GameRef.delete();
    }
    if (myMap["0"].toString() != '' &&
        myMap["1"].toString() != '' &&
        myMap["2"].toString() != '' &&
        myMap["3"].toString() != '' &&
        myMap["4"].toString() != '' &&
        myMap["5"].toString() != '' &&
        myMap["6"].toString() != '' &&
        myMap["7"].toString() != '' &&
        myMap["8"].toString() != ''
    ) {
      print('DRAW');
      String returnTextForDraw = 'DRAW';
      Navigator.pop(context, returnTextForDraw);
      widget.player1GameRef.delete();
      widget.player2GameRef.delete();
    }
  }
}

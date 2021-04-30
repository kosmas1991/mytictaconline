import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mytictaconline/src/screens/gameScreen.dart';
import 'package:mytictaconline/src/screens/homeScreen.dart';

class ResultScreen extends StatelessWidget {
  final bool didWin;
  final bool isDraw;
  final GoogleSignInAccount googleSignInAccount;

  const ResultScreen({Key key, this.didWin, this.isDraw, this.googleSignInAccount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height *0.5,
          child: Column(
            children: [
              Text(
                isDraw
                    ? 'DRAW'
                    : didWin
                        ? 'YOU WON'
                        : 'YOU LOST',
                style: TextStyle(
                    fontSize: 50,
                    color: isDraw
                        ? Colors.grey
                        : didWin
                            ? Colors.green
                            : Colors.red),
              ),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text('back'))
              // Builder(builder: (context) => ElevatedButton(onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(googleSignInAccount: googleSignInAccount,),));
              //   }, child: Text('go at start' , style: TextStyle(fontSize: 20),)),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

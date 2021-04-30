import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytictaconline/src/screens/gameScreen.dart';

class ActiveGamesScreen extends StatefulWidget {
  @override
  _ActiveGamesScreenState createState() => _ActiveGamesScreenState();
}

class _ActiveGamesScreenState extends State<ActiveGamesScreen> {
  CollectionReference ref;
  FirebaseAuth auth;
  String uid;
  @override
  void initState() {
    auth = FirebaseAuth.instance;
    uid = auth.currentUser.uid;
    ref = FirebaseFirestore.instance.collection('users').doc(uid).collection('VS');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Text('active games screen'),
        StreamBuilder<QuerySnapshot>(
          stream: ref.snapshots(),
          builder: (context, snapshot) {
            List<DocumentReference> games = [];
            if (snapshot.hasData) {
              var data = snapshot.data.docs;
              data.forEach((element) {
                games.add(element.reference);
              });
              return Container(
                height: MediaQuery.of(context).size.height*0.75,
                child: ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    String opString = getOpIdFromVSDoc(games[index].id);
                    return InkWell(
                      onTap: () async{
                        final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameScreen(player1GameRef: FirebaseFirestore.instance.collection('users').doc(uid).collection('VS').doc('${games[index].id}'),player2GameRef: FirebaseFirestore.instance.collection('users').doc(opString).collection('VS').doc(getrevGameId('${games[index].id}')),),));
                        if (result != null) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text("$result")));
                        }
                      },
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(opString).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data.data();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    child: Image.network(data['photoUrl']),
                                  ),
                                  Text(data['name']),
                                  Icon(Icons.chevron_right,color: Colors.deepPurple,)
                                ],
                              ),
                            );
                          } else{
                            return Text('Loading');
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            } else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        )
      ],
    );
  }
  String getOpIdFromVSDoc(String docName){
    List<String> list = docName.split('VS ');
    return list[1];
  }
  String getrevGameId(String docName){
    List<String> list = docName.split(' ');
    return list[2] + ' VS ' + list[0];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final GoogleSignInAccount googleSignInAccount;

  const HomeScreen({Key key, this.googleSignInAccount}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            topBar(),
            (_selectedIndex == 0)
                ? usersTab()
                : (_selectedIndex == 1)
                    ? Text('Active games list')
                    : Text('coming soon')
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_sharp),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              label: 'Active games',
              icon: Icon(Icons.gamepad),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }

  Container usersTab() {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    return Container(
      child: Expanded(
        child: FutureBuilder(
          future: ref.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot data = snapshot.data;
              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  if (data.docs[index].id ==
                      FirebaseAuth.instance.currentUser.uid) {
                    return Container();
                  }
                  return InkWell(
                      onTap: () {
                        createGame(ref, data.docs[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                      data.docs[index].get('photoUrl'))),
                            ),
                            Text(
                              data.docs[index].get('name'),
                              style: TextStyle(fontSize: 20),
                            ),
                            IconButton(
                              icon: Icon(Icons.play_arrow),
                              color: Colors.green,
                              onPressed: () {
                                createGame(ref, data.docs[index].id);
                              },
                            )
                          ],
                        ),
                      ));
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Padding topBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GoogleUserCircleAvatar(identity: widget.googleSignInAccount),
          Text(widget.googleSignInAccount.displayName)
        ],
      ),
    );
  }

  void createGame(CollectionReference ref, String opponentId) {
    ref
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(FirebaseAuth.instance.currentUser.uid + 'VS' + opponentId)
        .add({
      "0": "",
      "1": "",
      "2": "",
      "3": "",
      "4": "",
      "5": "",
      "6": "",
      "7": "",
      "8": "",
    });
  }
}

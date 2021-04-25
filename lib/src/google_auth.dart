import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/homeScreen.dart';

FirebaseAuth auth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();
CollectionReference ref = FirebaseFirestore.instance.collection('users');

Future<bool> signInWithGoogle(BuildContext context) async {
  try {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      UserCredential userCredential =
      await auth.signInWithCredential(credential);
      User user = userCredential.user;
      var userData = {
        'name': googleSignInAccount.displayName,
        'provider': 'Google',
        'photoUrl': googleSignInAccount.photoUrl,
        'email': googleSignInAccount.email
      };
      ref.doc(user.uid).get().then((value) {
        if (value.exists) {
          //user old
          value.reference.update(userData);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(googleSignInAccount: googleSignInAccount,),
          ));
        } else {
          //user new
          value.reference.set(userData);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(googleSignInAccount: googleSignInAccount,),
          ));
        }
      });
    }
  } catch (PlatformException) {
    print(PlatformException);
    print('google sign in failed!');
  }
}
import 'dart:ui';
import 'package:flutter/material.dart';
import '../google_auth.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('images/notes.png'))),
            ),
            ClipRRect(
              // Clip it cleanly.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                  alignment: Alignment.center,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.white),
                          shadowColor: MaterialStateProperty.all(Colors.black),
                          elevation: MaterialStateProperty.all(10.0),
                          padding:
                          MaterialStateProperty.all(EdgeInsets.all(15))),
                      onPressed: () {
                        //TODO: Imple the google sign in later
                        signInWithGoogle(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Σύνδεση με Google ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'ballon'),
                          ),
                          Image.asset(
                            'images/google.png',
                            height: 30,
                          )
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
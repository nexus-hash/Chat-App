import 'package:flutter/material.dart';
import 'package:messaging/views/signin.dart';
import 'package:messaging/views/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleScreen() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleScreen);
    } else {
      return SignUp(toggleScreen);
    }
  }
}

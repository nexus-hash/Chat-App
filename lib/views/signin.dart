import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/views/forgotpassword.dart';
import 'package:messaging/views/homepage.dart';
import 'package:messaging/views/signup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _textEditingController = new TextEditingController();
  TextEditingController _textEditingController2 = new TextEditingController();
  double ratio = 1.sh / 1.sw;
  bool selected = true;
  static AppColors color = new AppColors();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 60.h,
              width: 370.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: color.textfield),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 0, top: 5.0),
                child: TextFormField(
                  controller: _textEditingController,
                  style: TextStyle(color: Color(0xff7f7f8e)),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                        color: Color(0xff7f7f8e), fontSize: ratio * 7),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 60.h,
                width: 370.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: color.textfield),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, bottom: 0, top: 5.0),
                  child: TextFormField(
                    style: TextStyle(color: Color(0xff7f7f8e)),
                    controller: _textEditingController2,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                          color: Color(0xff7f7f8e), fontSize: ratio * 7),
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ForgotPassword();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Color(0xff7f7f8e), fontSize: 1.sh / 100 * 2),
                    )),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
              child: Container(
                height: 60.h,
                width: 370.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [color.gradient1, color.gradient2]),
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "SignIn",
                    style: TextStyle(
                        fontSize: ratio * 8.5, color: Color(0xfff2f0fa)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(_createRoute());
              },
              child: Text(
                "Don't have an account? SignUp",
                style: TextStyle(
                    color: Color(0xff7f7f8e), fontSize: 1.sh / 100 * 2),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(height: 60.h)
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignUp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInToLinear;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

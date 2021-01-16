import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/views/forgotpassword.dart';
import 'package:messaging/views/homepage.dart'; 

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passwordEditingController =
      new TextEditingController();
  double ratio = 1.sh / 1.sw;
  bool selected = true;
  static AppColors color = new AppColors();
  AuthMethods authMethods = new AuthMethods();

  signMeIn() {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signInWithEmailAndPassword(
              _emailEditingController.text, _passwordEditingController.text)
          .then((value) {
        print("$value");
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(color.gradient1),
              ),
            )
          : Scaffold(
              backgroundColor: color.background,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20.h,
                  ),
                  Form(
                    key: formkey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60.h,
                          width: 370.w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: color.textfield),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 0, top: 5.0),
                            child: TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(val)
                                    ? null
                                    : "Don't do this to me .";
                              },
                              controller: _emailEditingController,
                              style: TextStyle(color: Color(0xff7f7f8e)),
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    color: Color(0xff7f7f8e),
                                    fontSize: ratio * 7),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                color: color.textfield),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 0, top: 5.0),
                              child: TextFormField(
                                style: TextStyle(color: Color(0xff7f7f8e)),
                                controller: _passwordEditingController,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Color(0xff7f7f8e),
                                      fontSize: ratio * 7),
                                  border: InputBorder.none,
                                ),
                                obscureText: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
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
                                color: Color(0xff7f7f8e),
                                fontSize: 1.sh / 100 * 2),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  FlatButton(
                    onPressed: () {
                      signMeIn(); 
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
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      child: Text(
                        "Don't have an account? SignUp",
                        style: TextStyle(
                            color: Color(0xff7f7f8e), fontSize: 1.sh / 100 * 2),
                      ),
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
}

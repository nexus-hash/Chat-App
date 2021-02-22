import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/helper/helperFunctions.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/views/homepage.dart';
import 'package:messaging/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formkey = GlobalKey<FormState>();
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _passwordEditingController =
      new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  double ratio = 1.sh / 1.sw;
  AppColors color = new AppColors();
  QuerySnapshot s;
  bool checkUsers = false;

  Future<void> initiateUser(String x) async {
    databaseMethods.getUserByUsername(x).then((val) {
      setState(() {
        s = val;
      });
    });
  }

  Future<void> checkUser(String x) async {
    await initiateUser(x);
    if (s.documents.length == 0) {
      checkUsers = false;
    } else {
      checkUsers = true;
    }
  }

  signMeUp() {
    if (formkey.currentState.validate()) {
      Fluttertoast.showToast(
          msg: "Signing Up...",
          backgroundColor: Colors.purple,
          textColor: Colors.white);
      Map<String, String> userMap = {
        "name": _nameEditingController.text,
        "email": _emailEditingController.text
      };
      try {
        HelperFunctions.saveUserEmailSharedPreference(
            _emailEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(
            _nameEditingController.text);

        setState(() {
          isLoading = true;
        });

        authMethods
            .signUpWithEmailAndPassword(
                _emailEditingController.text, _passwordEditingController.text)
            .then((value) {
          print("$value");
        });

        databaseMethods.uploadUserInfo(userMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
            msg: "Signing Up Failed",
            backgroundColor: Colors.purple,
            textColor: Colors.white);
        Fluttertoast.showToast(
            msg: "Check Connection",
            backgroundColor: Colors.purple,
            textColor: Colors.white);
        setState(() {
          isLoading = false;
        });
      }
      Fluttertoast.showToast(
          msg: "Signing Up Sucessful",
          backgroundColor: Colors.purple,
          textColor: Colors.white);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color.background,
        body: isLoading
            ? Container(
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(color.gradient1),
                )),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Container(
                    height: 0.09.sh,
                    width: 0.5.sw,
                    
                  child: Image.asset("assets/images/Gibber.png",fit: BoxFit.fill,)),
                  Spacer(),
                  Text("Sign Up",style: TextStyle(color: Color(0xff7f7f8e),fontSize: 20),),
                  SizedBox(height: 15.0,),
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
                              color: Color(0xff282945)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 0, top: 5.0),
                            child: TextFormField(
                              validator: (val) {
                                return val.isEmpty
                                    ? "You can't ignore me!!!"
                                    : val.length < 4
                                        ? "This is too short"
                                        : checkUsers
                                            ? "Username Already in use"
                                            : null;
                              },
                              controller: _nameEditingController,
                              style: TextStyle(color: Color(0xff7f7f8e)),
                              decoration: InputDecoration(
                                hintText: "Username",
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
                        Container(
                          height: 60.h,
                          width: 370.w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: Color(0xff282945)),
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
                                color: Color(0xff282945)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 0, top: 5.0),
                              child: TextFormField(
                                validator: (val) {
                                  return val.length < 8
                                      ? "Not long Enough"
                                      : RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                              .hasMatch(val)
                                          ? null
                                          : "Low strength Password";
                                },
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
                  GestureDetector(
                    onTap: () async {
                      await checkUser(_nameEditingController.text);
                      signMeUp();
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
                          "SignUp",
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
                      widget.toggle();
                    },
                    child: Text(
                      "Already have an account? Sign in",
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
}

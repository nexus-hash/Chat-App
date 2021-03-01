import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/helper/Logo.dart';
import 'package:messaging/helper/authenticate.dart';
import 'package:messaging/services/auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formkey = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();
  double ratio = 1.sh / 1.sw;
  bool selected = true;
  AppColors color = new AppColors();
  AuthMethods _authMethods = new AuthMethods();

  sendLink() {
    if (formkey.currentState.validate()) {
      try {
        _authMethods.resetPassword(_textEditingController.text);
        Fluttertoast.showToast(
            msg: "Email Has been Sent",
            textColor: Colors.white,
            backgroundColor: color.gradient2);
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error", textColor: Colors.white, backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: color.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
                  Container(

                    
                  child: AppLogo()),
                  Spacer(),
                  Text("Forgot Password",style: TextStyle(color: Color(0xff7f7f8e),fontSize: 20),),
                  SizedBox(height: 15.0,),
            Form(
              key: formkey,
                          child: Container(
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
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                              .hasMatch(val)
                          ? null
                          : "Don't do this to me .";
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(
                          color: Color(0xff7f7f8e), fontSize: ratio * 7),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            FlatButton(
              onPressed: () {
                sendLink();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Authenticate();
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
                    "Submit",
                    style: TextStyle(
                        fontSize: ratio * 8.5, color: Color(0xfff2f0fa)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(height: 100.h)
          ],
        ),
      ),
    );
  }
}

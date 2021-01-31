import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/helper/authenticate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/views/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppColors color = new AppColors();
  // This widget is the root of your application.
  final FirebaseAuth auth = FirebaseAuth.instance;
  //Widget getUser() {
    //try {
      //auth.onAuthStateChanged.listen((user) {
        //if (user == null) {
          //return Authenticate();
        //} else {
          //return HomePage();
        //}
      //});
    //} catch (k) {
      //print(k);
    //}
    //return Authenticate();
  //}

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392.72, 738.18),
      allowFontScaling: true,
      child: MaterialApp(
        theme: new ThemeData(
            backgroundColor: color.background, canvasColor: color.background),
        debugShowCheckedModeBanner: false,
        home: Authenticate(),
      ),
    );
  }
}

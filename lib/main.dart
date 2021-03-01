import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/helper/authenticate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/helper/helperFunctions.dart';
import 'package:messaging/views/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppColors color = new AppColors();

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isUserLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) => {
          setState(() {
            isUserLoggedIn = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return ScreenUtilInit(
      designSize: Size(392.72, 738.18),
      allowFontScaling: false,
      child: MaterialApp(
        theme: new ThemeData(
            backgroundColor: color.background, canvasColor: color.background),
        debugShowCheckedModeBanner: false,
        home: isUserLoggedIn ? HomePage() : Authenticate(),
      ),
    );
  }
}

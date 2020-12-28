import 'package:flutter/material.dart';
import 'package:messaging/views/signin.dart';
import 'package:messaging/views/signup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392.72, 738.18),
      allowFontScaling: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignIn(),
      ),
    );
  }
}
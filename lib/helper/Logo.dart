import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/helper/constants.dart';

class AppLogo extends StatelessWidget {
  final AppColors color = new AppColors();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(
  children: <Widget>[
    // Stroked text as border.
    Text(
        Constants.appName,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(32,allowFontScalingSelf: true),
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..color = Colors.purple[600],
            fontFamily: "Angelina"
        ),
    ),
    // Solid text as fill.
    Text(
        Constants.appName,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(32,allowFontScalingSelf: true),
          color: Colors.purpleAccent,
          fontFamily: "Angelina",
          shadows: [Shadow(
            color: Colors.purple[200],
            blurRadius: 10.0
          )]
        ),
    ),
  ],
),
      )
    );
  }
}

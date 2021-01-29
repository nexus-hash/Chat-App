import 'package:flutter/material.dart';
import 'package:messaging/colors/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTile extends StatelessWidget {
  final String userName, userEmail;

  SearchTile({this.userName, this.userEmail});
  final AppColors color = new AppColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 12.0),
      height: 70.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.w,
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                       Text(userName,style: TextStyle(color: Colors.white),),
                       Spacer(),
                       Container(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text("Email: "+userEmail,style: TextStyle(color: Colors.white)))),
                    ],
                  ),
          ),
          Spacer(),
          Center(
            child: MaterialButton(
              onPressed: (){},
                          child: Container(
                height: 40.h,
                width: 80.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    color.gradient1,
                    color.gradient2
                  ]),
                  borderRadius: BorderRadius.circular(50.w)
                  ),
                child: 
                Center(child: Text("Message",style: TextStyle(color: Colors.white),)),
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}

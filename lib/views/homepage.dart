import 'package:flutter/material.dart';
import 'package:messaging/colors/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/helper/authenticate.dart';
import 'package:messaging/helper/constants.dart';
import 'package:messaging/helper/helperFunctions.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/views/search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppColors color = AppColors();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  AuthMethods authMethods = new AuthMethods();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  signMeOut() {
    try {
      authMethods.signout();
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      HelperFunctions.saveUserEmailSharedPreference(null);
      HelperFunctions.saveUserNameSharedPreference(null);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldkey,
            backgroundColor: color.background,
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [color.gradient2, color.gradient1])),
                    child: Container(
                      width: 1.sw,
                      child: CircleAvatar(),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Center(
                      child: Text(
                        "Friends",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      signMeOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Authenticate();
                      }));
                    },
                    title: Center(
                      child: Text(
                        "LogOut",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 312.5.h),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 1.sw,
                      height: 60.h,
                      decoration: BoxDecoration(
                          gradient: RadialGradient(
                              colors: [color.gradient1, color.gradient2],
                              radius: 4)),
                      child: Center(
                        child: Text(
                          "v.0.0.1",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            appBar: new PreferredSize(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [color.gradient1, color.gradient2]),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: color.gradient1,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: color.gradient2,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _scaffoldkey.currentState.openDrawer();
                          }),
                      SizedBox(
                        width: 115.w,
                      ),
                      Text(
                        "Gibber",
                        style: TextStyle(
                            fontFamily: "Angelina",
                            color: Colors.white,
                            fontSize: 22,
                            shadows: <Shadow>[
                              Shadow(blurRadius: 5.h, color: color.background)
                            ]),
                      ),
                      SizedBox(
                        width: 120.w,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Search();
                            }));
                          })
                    ],
                  ),
                ),
              ),
              preferredSize: new Size(1.sw, 65.h),
            )));
  }
}

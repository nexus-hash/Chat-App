import 'package:flutter/material.dart';
import 'package:messaging/colors/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/helper/authenticate.dart';
import 'package:messaging/helper/constants.dart';
import 'package:messaging/helper/helperFunctions.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/services/database.dart';
import 'package:messaging/views/ChatScreen.dart';
import 'package:messaging/views/search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppColors color = AppColors();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
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

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data["users"],
                    chatRoomId:
                        snapshot.data.documents[index].data["chatroomid"],
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    color: Colors.grey,
                  );
                },
              )
            : Container();
      },
    );
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
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 1.sw,
                height: 60.h,
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        colors: [color.gradient1, color.gradient2], radius: 4)),
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
            gradient:
                LinearGradient(colors: [color.gradient1, color.gradient2]),
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
                Spacer(),
                Text(
                  "Gibber",
                  style: TextStyle(
                      fontFamily: "Angelina",
                      color: Colors.white,
                      fontSize:
                          ScreenUtil().setSp(22, allowFontScalingSelf: true),
                      shadows: <Shadow>[
                        Shadow(blurRadius: 5.h, color: color.background)
                      ]),
                ),
                Spacer(),
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
      ),
      body: Container(
        padding: EdgeInsets.only(top: .02.sh),
        child: chatRoomList(),
      ),
    ));
  }
}

class ChatRoomsTile extends StatelessWidget {
  final List<dynamic> userName;
  final String chatRoomId;
  ChatRoomsTile({this.userName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
            secondUser:
                userName[0] != Constants.myName ? userName[0] : userName[1],
            chatRoomId: chatRoomId,
          );
        }));
      },
      child: Container(
        height: .12.sh,
        padding: EdgeInsets.only(left: .01.sw),
        child: Row(
          children: <Widget>[
            Container(
                height: 65.r,
                width: 65.r,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(65.r))),
            SizedBox(
              width: .03.sw,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userName[0] == Constants.myName
                            ? userName[1]
                            : userName[0],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 17.ssp),
                      )),
                  Container(
                    child: Text(
                      "Message demo",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ])
          ],
        ),
      ),
    );
  }
}

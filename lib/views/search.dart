import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/helper/constants.dart';
import 'package:messaging/services/database.dart';
import 'package:messaging/views/ChatScreen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  AppColors color = new AppColors();
  TextEditingController _textEditingController = new TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods.getUserByUsername(_textEditingController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation(String username) {
    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];

      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChatScreen();
      }));
    } else {
      print("Hello you want to message yourself!!!");
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
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
                Text(
                  userName,
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Container(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text("Email: " + userEmail,
                            style: TextStyle(color: Colors.white)))),
              ],
            ),
          ),
          Spacer(),
          Center(
            child: MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatScreen();
                }));
              },
              child: GestureDetector(
                onTap: () {
                  createChatRoomAndStartConversation(userName);
                },
                child: Container(
                  height: 40.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [color.gradient1, color.gradient2]),
                      borderRadius: BorderRadius.circular(50.w)),
                  child: Center(
                      child: Text(
                    "Message",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? (searchSnapshot.documents.length == 0
            ? Container(
                child: Center(
                    child: Text(
                  "No User Found",
                  style: TextStyle(color: Colors.white),
                )),
              )
            : ListView.builder(
                itemCount: searchSnapshot.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return searchTile(
                    userName: searchSnapshot.documents[index].data["name"],
                    userEmail: searchSnapshot.documents[index].data["email"],
                  );
                }))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color.background,
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
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Enter Username . . . ",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none),
                  )),
                  SizedBox(
                    width: 2.w,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        initiateSearch();
                      })
                ],
              ),
            ),
          ),
          preferredSize: new Size(1.sw, 65.h),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
          child: Container(
            child: Container(child: searchList()),
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String t, String u) {
  if (t.substring(0, 1).codeUnitAt(0) > u.substring(0, 1).codeUnitAt(0)) {
    return "$u\_$t";
  } else {
    return "$t\_$u";
  }
}

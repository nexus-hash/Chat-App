import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/colors/color.dart';
import 'package:messaging/services/database.dart';
import 'package:messaging/views/searchTile.dart';

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

  Widget searchList() {
    return ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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

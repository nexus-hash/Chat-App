
import 'package:flutter/material.dart';
import 'package:messaging/colors/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/helper/constants.dart';
import 'package:messaging/services/database.dart';

class ChatScreen extends StatefulWidget {
  final String secondUser, chatRoomId;
  ChatScreen({this.secondUser, this.chatRoomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AppColors color = new AppColors();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController _messageTextEditingController =
      new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTiles(
                    message: snapshot.data.documents[index].data["Message"],
                    isSendByMe: snapshot.data.documents[index].data["sendby"]== Constants.myName,
                  );
                },
              );
      },
    );
  }

  sendMessage() {
    if (_messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "Message": _messageTextEditingController.text,
        "sendby": Constants.myName,
        "time": DateTime.now()
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
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
                    width: 15.w,
                  ),
                  Container(
                    width: 120.w,
                    child: Text(
                      widget.secondUser,
                      style: TextStyle(
                          fontFamily: "Angelina",
                          color: Colors.white,
                          fontSize: 22,
                          shadows: <Shadow>[
                            Shadow(blurRadius: 5.h, color: color.background)
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: new Size(1.sw, 65.h),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              chatMessageList(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [color.gradient1, color.gradient2])),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            child: TextField(
                              controller: _messageTextEditingController,
                              style: TextStyle(color: Color(0xffe5e5e2)),
                              decoration: InputDecoration(
                                  hintText: "Type a Message ",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Color(0xffe3e5e2),
                            ),
                            onPressed: () {
                              sendMessage();
                            })
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTiles extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTiles({this.message,this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      alignment: isSendByMe? Alignment.centerLeft:Alignment.centerRight ,
          child: Container(
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

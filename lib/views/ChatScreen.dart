import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging/colors/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/helper/Utils.dart';
import 'package:messaging/helper/constants.dart';
import 'package:messaging/services/database.dart';
import 'package:messaging/views/CallScreen.dart';

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
  ScrollController _listcontroller = ScrollController();
  Stream chatMessageStream;

  bool isWritting = false;

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickingImage(source: source);
    databaseMethods.uploadImage(
      image: selectedImage,
      chatRoomId: widget.chatRoomId,
      sendby: Constants.myName
    );
  }

  setWriting(val) {
    setState(() {
      isWritting = val;
    });
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //   _listcontroller.animateTo(
        //     _listcontroller.position.minScrollExtent,
        //     duration: Duration(milliseconds: 250),
        //     curve: Curves.easeInOut
        //   );
        // });
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                controller: _listcontroller,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return MessageTiles(
                    message: snapshot.data.documents[index].data["Message"],
                    isSendByMe: snapshot.data.documents[index].data["sendby"] ==
                        Constants.myName,
                  );
                },
              )
            : Container(
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(color.gradient1),
                )),
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
      _messageTextEditingController.text = "";
      Timer(Duration(milliseconds: 300), () {
        _listcontroller.jumpTo(_listcontroller.position.maxScrollExtent);
      });
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
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.video_call,
                      color: Colors.white,
                    ),
                    onPressed: null,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CallScreen();
                        }));
                      })
                ],
              ),
            ),
          ),
          preferredSize: new Size(1.sw, 65.h),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 10.h, bottom: 60.h),
                  child: chatMessageList()),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
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
                              onChanged: (val) {
                                (val.length > 0 && val.trim() != "")
                                    ? setWriting(true)
                                    : setWriting(false);
                              },
                            ),
                          ),
                        ),
                        isWritting
                            ? IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Color(0xffe3e5e2),
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  sendMessage();
                                  Timer(Duration(milliseconds: 300), () {
                                    _listcontroller.jumpTo(_listcontroller
                                        .position.maxScrollExtent);
                                  });
                                })
                            : Container(),
                        isWritting
                            ? Container()
                            : IconButton(
                                icon: Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                ),
                                onPressed: null),
                        isWritting
                            ? Container()
                            : IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  pickImage(source: ImageSource.camera);
                                })
                      ],
                    ),
                  ))
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  @override
  void dispose() {
    _listcontroller.dispose();
    super.dispose();
  }
}

class MessageTiles extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTiles({this.message, this.isSendByMe});
  final double width = 1.sw;
  final double height = 1.sh;
  final AppColors color = new AppColors();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1.sw,
        child: Container(
          alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: .7.sw),
            padding: EdgeInsets.symmetric(
                horizontal: width * .04, vertical: height * .02),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: isSendByMe
                        ? [color.gradient1, color.gradient2]
                        : [Color(0x1AFFFFFF), Color(0x1AFFFFFA)]),
                borderRadius: isSendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0))
                    : BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0))),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

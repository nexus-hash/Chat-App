import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging/colors/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/helper/Utils.dart';
import 'package:messaging/helper/constants.dart';
import 'package:messaging/services/database.dart';
import 'package:messaging/views/CallScreen.dart';
import 'package:messaging/views/ImageView.dart';

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
  bool isSending = false;

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickingImage(source: source);
    databaseMethods.uploadImage(
        image: selectedImage,
        chatRoomId: widget.chatRoomId,
        sendby: Constants.myName);
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
                    time: new DateFormat('H:mm a').format(
                        snapshot.data.documents[index].data["time"].toDate()),
                    photoUrl: snapshot.data.documents[index].data["photoUrl"],
                    type: snapshot.data.documents[index].data["type"],
                    index: index,
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
        "time": DateTime.now(),
        "type": "text",
        "photoUrl": ""
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      _messageTextEditingController.text = "";
      setWriting(false);
      Timer(Duration(milliseconds: 100), () {
        _listcontroller.animateTo(_listcontroller.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuad);
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
                  child: isSending
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: color.gradient2,
                          ),
                        )
                      : chatMessageList()),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    height: 60.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [color.gradient1, color.gradient2])
                            ),
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
                                  setState(() {
                                    isSending = true;
                                  });
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
  final String type;
  final String photoUrl;
  final int index;
  MessageTiles(
      {this.message,
      this.time,
      this.type,
      this.photoUrl,
      this.isSendByMe,
      this.index});
  final double width = 1.sw;
  final double height = 1.sh;
  final AppColors color = new AppColors();
  final String time;

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
            padding:type=="text"? EdgeInsets.only(
                right: width * .04,
                left: width * .04,
                top: height * .02,
                bottom: height * .017):EdgeInsets.only(
                right: width * .011,
                left: width * .011,
                top: height * .01,
                bottom: height * .017),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: isSendByMe
                        ? [color.gradient1, color.gradient2]
                        : [Color(0x1AFFFFFF), Color(0x1AFFFFFA)]),
                borderRadius: isSendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                type == "text"
                    ? Text(
                        message + "      ",
                        style: TextStyle(color: Colors.white),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ImageView(
                              url: photoUrl,
                              index: index
                            );
                          }));
                        },
                        child: Hero(
                          tag: 'imageHero_$index',
                          child: ClipRRect(
                            borderRadius: isSendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                              child: Image.network(
                            photoUrl,
                            fit: BoxFit.fill,
                          )
                          ),
                        )
                        ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey, fontSize: 8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

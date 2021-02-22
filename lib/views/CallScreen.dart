import 'package:flutter/material.dart';
import 'package:messaging/colors/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Timer _timerinstance;
  int _start = 0;
  String _timer = "";

  void startTimer() {
    var oneSec = Duration(seconds: 1);
    _timerinstance = Timer.periodic(
        oneSec,
        (Timer timer) => {
              setState(() {
                if (_start < 0) {
                  _timerinstance.cancel();
                } else {
                  _start = _start + 1;
                  _timer = getTimerTime(_start);
                }
              })
            });
  }

  String getTimerTime(int start) {
    String sMinute = "";
    String sSecond = "";
    String sHour = "";

    int hours = (start ~/ 60) % 60;

    if (hours != 0) {
      if (hours.toString().length == 1) {
        sHour = "0" + hours.toString();
      } else {
        sHour = hours.toString();
      }
    }

    int minutes = (start ~/ 60);

    if (minutes.toString().length == 1) {
      sMinute = "0" + minutes.toString();
    } else {
      sMinute = minutes.toString();
    }
    int seconds = start % 60;
    if (seconds.toString().length == 1) {
      sSecond = "0" + seconds.toString();
    } else {
      sSecond = seconds.toString();
    }

    return sHour == ""
        ? sMinute + ":" + sSecond
        : sHour + ":" + sMinute + ":" + sSecond;
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  AppColors color = new AppColors();
  bool isMuted = false;
  bool isSpeaker = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: color.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 0.05.sh,
              ),
              Center(
                child: Text(
                  "VOICE CALL",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
              SizedBox(
                height: 0.05.sh,
              ),
              Text(
                "Name",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 0.1.sh,
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              Text(_timer,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300)),
              SizedBox(
                height: 0.07.sh,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            isMuted = !isMuted;
                          });
                        },
                        elevation: 20.0,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        fillColor: Colors.purple,
                        shape: CircleBorder(),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [color.gradient1, color.gradient2]),
                              borderRadius: BorderRadius.circular(.2.sw)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.mic_off,
                              size: isMuted ? 27.0 : 24.0,
                              color: isMuted ? Colors.lightBlue : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(
                          isMuted ? "Unmute" : "Mute",
                          style: TextStyle(
                              color: isMuted ? Colors.lightBlue : Colors.white),
                        )),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            isSpeaker = !isSpeaker;
                          });
                        },
                        elevation: 20.0,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        fillColor: Colors.purple,
                        shape: CircleBorder(),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [color.gradient1, color.gradient2]),
                              borderRadius: BorderRadius.circular(.2.sw)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.phone_in_talk,
                              size: isSpeaker ? 27.0 : 24.0,
                              color:
                                  isSpeaker ? Colors.lightBlue : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(
                          isSpeaker ? "Earpiece" : "Speaker",
                          style: TextStyle(
                              color:
                                  isSpeaker ? Colors.lightBlue : Colors.white),
                        )),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {},
                        elevation: 20.0,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        fillColor: Colors.purple,
                        shape: CircleBorder(),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [color.gradient1, color.gradient2]),
                              borderRadius: BorderRadius.circular(.2.sw)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.videocam,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(
                          "Video Call",
                          style: TextStyle(color: Colors.white),
                        )),
                      )
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      _timerinstance.cancel();
                      Navigator.pop(context);
                    },
                    elevation: 20.0,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    fillColor: Colors.purple,
                    shape: CircleBorder(),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(.2.sw)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.call_end,
                          size: 0.08.sw,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        child: Text(
                      "End Call",
                      style: TextStyle(color: Colors.white),
                    )),
                  )
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageMap {
  String message, sendby, type, photoUrl,chatRoomId;
  Timestamp time;
  MessageMap.imageMessage(
      {this.message, this.sendby, this.time, this.type, this.photoUrl,this.chatRoomId});

  Map toImageMap() {
    var map = Map<String, dynamic>();

    map["Message"] = this.message;
    map["sendby"] = this.sendby;
    map["time"] = this.time;
    map["type"] = this.type;
    map["photoUrl"] = this.photoUrl;

    return map;
  }
}

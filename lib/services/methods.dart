import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messaging/model/messageMap.dart';

class FirebaseMethods{
  StorageReference _storageReference;
  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setImageMsg(String url, String sendBy, String chatRoomId) {
    MessageMap _messageMap = new MessageMap.imageMessage(
        photoUrl: url,
        sendby: sendBy,
        type: "image",
        chatRoomId: chatRoomId,
        time: Timestamp.now(),
        message: "IMAGE");
    var map = _messageMap.toImageMap();
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(map)
        .catchError((e) {
      print(e.toString());
    });
  }

  void uploadImage(File image, String sendby, String chatRoomId) async {
    String url = await uploadImageToStorage(image);
    setImageMsg(url, sendby, chatRoomId);
  }
}
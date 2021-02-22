import 'dart:io';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class Utils {
  static final picker = ImagePicker();
  static Future<File> pickingImage({@required ImageSource source}) async {
    PickedFile selectedImage = await picker.getImage(source: source);
    return compressImage(File(selectedImage.path));
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);
    return new File('$path/img_$random.jpg')..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
}

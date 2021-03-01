import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageView extends StatefulWidget {
  final String url;
  final int index;
  ImageView({this.url, this.index});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool k = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: new PreferredSize(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
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
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.video_call,
                    color: Colors.white,
                  ),
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
        preferredSize: new Size(1.sw, .08.sh),
      ),
      body: GestureDetector(
          onHorizontalDragDown: (DragDownDetails dragDownDetails) {
            var h = dragDownDetails.localPosition;
            if (h.dx >= 20.0 && h.dy >= 20.0) {
              Navigator.pop(context);
            }
          },
          onDoubleTap: () {
            setState(() {
              k = !k;
            });
          },
          child: Hero(
            tag: 'imageHero_${widget.index}',
            child: Container(
              height: 82.sh,
              child: Image.network(
                widget.url,
                fit: k ? BoxFit.fill : BoxFit.cover,
              ),
            ),
          )),
    ));
  }
}

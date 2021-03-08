import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CroppedImage extends StatefulWidget {
  final UI.Image image;
  const CroppedImage({
    Key key,
    @required this.image,
  }) : super(key: key);

  @override
  _CroppedImageState createState() => _CroppedImageState(image);
}

class _CroppedImageState extends State<CroppedImage> {
  ByteData imageData;
  UI.Image img;
  bool isImageLoaded = false;

  _CroppedImageState(UI.Image img) {
    this.img = img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cropped Item"),
        backgroundColor: Color(0xff716969),
      ),
      body: Center(
        child: FittedBox(
            child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                width: img.width.toDouble(),
                // height: MediaQuery.of(context).size.height,
                height: img.height.toDouble(),
                child: CustomPaint(
                  painter: DisplayImage(img),
                ))),
      ),
    );
  }
}

class DisplayImage extends CustomPainter {
  UI.Image im;

  DisplayImage(this.im);
  @override
  void paint(UI.Canvas canvas, UI.Size size) {
    canvas.drawColor(Color(0xffBCABAE), BlendMode.src);
    canvas.drawImage(im, new Offset(0, 0), new Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

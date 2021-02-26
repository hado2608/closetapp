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

  // Future<Uint8List> getImage() async {
  //   final Completer<Uint8List> completer = Completer();

  //   ByteData bytedata = await img.toByteData();
  //   Bitmap bitmap = Bitmap.fromHeadless(
  //       img.width, img.height, bytedata.buffer.asUint8List());

  //   Uint8List headedIntList = bitmap.buildHeaded();
  //   return completer.future;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cropped Item"),
      ),
      body: Center(
        child: CustomPaint(
          painter: DisplayImage(img),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}

class DisplayImage extends CustomPainter {
  UI.Image im;

  DisplayImage(this.im);
  @override
  void paint(UI.Canvas canvas, UI.Size size) {
    canvas.drawColor(Colors.blue, BlendMode.src);
    canvas.drawImage(im, new Offset(0, 0), new Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

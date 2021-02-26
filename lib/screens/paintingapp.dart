import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as UI;

import 'package:camera/camera.dart';
import 'package:closetapp/screens/croppedimage.dart';
import 'package:flutter/material.dart';

const int dashWidth = 4;
const int dashSpace = 4;
Path path = Path();
Path path2 = Path()..fillType = PathFillType.evenOdd;
final pathOffsets = <Offset>[];

class PaintingApp extends StatefulWidget {
  final XFile fileImage;

  const PaintingApp({
    Key key,
    @required this.fileImage,
  }) : super(key: key);

  @override
  _PaintingAppState createState() => _PaintingAppState(fileImage);
}

class _PaintingAppState extends State<PaintingApp> {
  XFile fileImage;
  UI.Image image;
  bool isImageLoaded = false;
  final _cropPaths = <Path>[];
  final clearBrush = Paint()
    ..color = Color(0xFFFFFFF)
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  _PaintingAppState(XFile fi) {
    this.fileImage = fi;
  }

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    final Uint8List data = await fileImage.readAsBytes();
    image = await getImage(data);
  }

  Future<UI.Image> getImage(Uint8List img) {
    final Completer<UI.Image> completer = Completer();
    UI.decodeImageFromList(img, (UI.Image img) {
      setState(() {
        isImageLoaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<UI.Image> cropSelection() async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

  //   final picture = recorder.endRecording();
  //   final img = picture.toImage(1000, 1000);
  //   return img;
  // }

  // runCrop() {
  //   cropSelection().then((value) => Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => CroppedImage(image: value))));
  // }

  @override
  Widget build(BuildContext context) {
    if (this.isImageLoaded) {
      return Scaffold(
        body: GestureDetector(
          onPanStart: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            setState(() {
              _cropPaths
                  .add(Path()..moveTo(localPosition.dx, localPosition.dy));
            });
          },
          onPanUpdate: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            setState(() {
              _cropPaths.last.lineTo(localPosition.dx, localPosition.dy);
            });
          },
          onPanEnd: (details) {
            setState(() {
              _cropPaths.last.close();
            });
          },
          child: Center(
            child: CustomPaint(
              painter: CropMarkPainter(_cropPaths, image),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            runCrop();
          },
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}

class CropMarkPainter extends CustomPainter {
  UI.Image im;
  final List<Path> cropPaths;
  final brush = Paint()
    ..color = Colors.red
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;

  CropMarkPainter(this.cropPaths, this.im);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(im, new Offset(25, 200), new Paint());

    for (var path in cropPaths) {
      canvas.drawPath(path, brush);
    }
  }
}

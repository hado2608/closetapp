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
  final _offsets = <Offset>[];
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

    Painter painter = Painter(_offsets, image);
    var size = context.size;
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final img = picture.toImage(1000, 1000);
    return img;
  }

  runCrop() {
    cropSelection().then((value) => Navigator.push(context,
        MaterialPageRoute(builder: (context) => CroppedImage(image: value))));
  }

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
              _offsets.add(localPosition);
            });
          },
          onPanUpdate: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            setState(() {
              _offsets.add(localPosition);
            });
          },
          onPanEnd: (details) {
            setState(() {
              for (var i = 0; i < dashWidth; i++) {
                _offsets.add(null);
              }
            });
          },
          child: Center(
            child: CustomPaint(
              painter: Painter(_offsets, image),
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

class Painter extends CustomPainter {
  UI.Image im;
  final offsets;
  final brush = Paint()
    ..color = Colors.red
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;

  final brush2 = Paint()
    // ..color = Color(0xFFFFFFF)
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOut;

  final brush3 = Paint()
    ..color = Color(0xFFFFFFF)
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  Painter(this.offsets, this.im);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    canvas.drawImage(im, new Offset(25, 200), new Paint());

    Path tempPath = Path()..fillType = PathFillType.evenOdd;

    for (var i = 0; i < offsets.length; i++) {
      if (offsets[i] != null) {
        if (i == 0) {
          tempPath.moveTo(offsets[i].dx, offsets[i].dy);
        }
        tempPath.lineTo(offsets[i].dx, offsets[i].dy);
        // canvas.drawPath(tempPath, brush3);
      }
      // canvas.drawPath(tempPath, brush2);
    }
    canvas.save();

    canvas.restore();

    canvas.drawImage(im.clone(), new Offset(25, 200), new Paint());

    for (var i = 0; i < offsets.length - dashWidth; i++) {
      if (offsets[i] != null && offsets[i + dashWidth] != null) {
        path.moveTo(offsets[i].dx, offsets[i].dy);
        path.lineTo(offsets[i + dashWidth].dx, offsets[i + dashWidth].dy);
        i += dashWidth + dashSpace;
        // } else if (offsets[i] != null && offsets[i + dashWidth] == null) {
        //   // canvas.drawPoints(PointMode.points, [offsets[i]], brush);
        //   path.lineTo(offsets[i].dx, offsets[i].dy);
        // }
      }
    }

    canvas.drawPath(path, brush);
    canvas.saveLayer(
        Rect.fromLTWH(0, 0, tempPath.getBounds().size.width,
            tempPath.getBounds().size.height),
        Paint()..blendMode = BlendMode.dstIn);
    canvas.restore();
  }
}

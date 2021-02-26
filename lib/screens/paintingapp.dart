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
  Path pathInProgress;
  Path cropArea = Path();
  var pathsToPaint = <Path>[];
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

    canvas.drawImage(image, new Offset(0, 0), new Paint());

    Path wholeImagePath = Path()
      ..addRect(
          Offset.zero & Size(image.width.toDouble(), image.height.toDouble()));
    Path areaToCrop =
        Path.combine(PathOperation.difference, wholeImagePath, cropArea);
    canvas.drawPath(
        areaToCrop,
        Paint()
          ..color = Colors.transparent
          ..blendMode = BlendMode.clear);

    final picture = recorder.endRecording();
    return picture.toImage(image.width, image.height);
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
              pathInProgress = Path()
                ..moveTo(localPosition.dx, localPosition.dy);
              pathsToPaint.add(pathInProgress);
            });
          },
          onPanUpdate: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            setState(() {
              pathInProgress.lineTo(localPosition.dx, localPosition.dy);
            });
          },
          onPanEnd: (details) {
            setState(() {
              pathInProgress.close();
              cropArea =
                  Path.combine(PathOperation.union, pathInProgress, cropArea);
              pathsToPaint.clear();
              pathsToPaint.add(cropArea);
            });
          },
          child: Center(
            child: CustomPaint(
              painter: CropMarkPainter(pathsToPaint, image),
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
    canvas.drawImage(im, new Offset(0, 0), new Paint());

    for (var path in cropPaths) {
      canvas.drawPath(path, brush);
    }
  }
}

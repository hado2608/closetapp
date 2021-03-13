import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as UI;

import 'package:camera/camera.dart';
import 'package:closetapp/clothingdatabase.dart';
import 'package:closetapp/screens/clothingitemsave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const int dashWidth = 4;
const int dashSpace = 4;
Path path = Path();
Path path2 = Path()..fillType = PathFillType.evenOdd;
final pathOffsets = <Offset>[];

class PaintingApp extends StatefulWidget {
  final XFile fileImage;
  final ClothingDatabase clothingDatabase;

  const PaintingApp({
    Key key,
    @required this.fileImage,
    @required this.clothingDatabase,
  }) : super(key: key);

  @override
  _PaintingAppState createState() =>
      _PaintingAppState(fileImage, clothingDatabase);
}

class _PaintingAppState extends State<PaintingApp> {
  ClothingDatabase clothingDatabase;
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

  _PaintingAppState(XFile fi, ClothingDatabase clothingDatabase) {
    this.fileImage = fi;
    this.clothingDatabase = clothingDatabase;
  }

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    final Uint8List data = await fileImage.readAsBytes();
    image = await getImage(data);
  }

  /**
   * Turns typed data into a UI image
   * Adapted from https://stackoverflow.com/questions/59923245/flutter-convert-and-resize-asset-image-to-dart-ui-image
   */
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
    cropSelection().then((value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClothingItemSave(
                image: value, clothingDatabase: clothingDatabase))));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isImageLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Crop Your Item Here"),
          backgroundColor: Color(0xff716969),
        ),
        body: Center(
            child: Builder(
                builder: (context) => GestureDetector(
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
                        pathInProgress.lineTo(
                            localPosition.dx, localPosition.dy);
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        pathInProgress.close();
                        cropArea = Path.combine(
                            PathOperation.union, pathInProgress, cropArea);
                        pathsToPaint.clear();
                        pathsToPaint.add(cropArea);
                      });
                    },
                    child: CustomPaint(
                      painter: CropMarkPainter(pathsToPaint, image),
                      child: Container(
                        width: image.width.toDouble(),
                        height: image.height.toDouble(),
                      ),
                    )))),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff716969),
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
    canvas.drawImage(im, Offset.zero, new Paint());

    for (var path in cropPaths) {
      canvas.drawPath(path, brush);
    }
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as UI;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int dashWidth = 4;
const int dashSpace = 4;
List<Path> crops;

class PaintingApp extends StatefulWidget {
  @override
  _PaintingAppState createState() => _PaintingAppState();
}

class _PaintingAppState extends State<PaintingApp> {
  UI.Image image;
  bool isImageLoaded = false;
  List<CameraDescription> cameras;
  CameraDescription firstCamera;
  final _offsets = <Offset>[];
  List<Path> _paths;
  Path path;

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    firstCamera = cameras.first;
    final ByteData data =
        await rootBundle.load('assets/images/yellowshirt.jpg');
    image = await getImage(Uint8List.view(data.buffer));
  }

  Future<UI.Image> getImage(List<int> img) async {
    final Completer<UI.Image> completer = Completer();
    UI.decodeImageFromList(img, (UI.Image img) {
      setState(() {
        isImageLoaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (this.isImageLoaded) {
      return Scaffold(
          body: GestureDetector(
        onPanStart: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            _offsets.add(localPosition);
          });
        },
        onPanUpdate: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
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
      ));
    } else {
      return CircularProgressIndicator();
    }
  }
}

class Painter extends CustomPainter {
  UI.Image im;
  final offsets;
  Path path = Path();
  final brush = Paint()
    ..color = Colors.deepPurple
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;

  final clearBrush = Paint()..blendMode = BlendMode.clear;

  Painter(this.offsets, this.im);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(im, new Offset(25, 200), new Paint());

    for (var i = 0; i < offsets.length - dashWidth - 1; i++) {
      // for (PathMetric pathMetric in path.computeMetrics()) {
      // while (offsets[i] < pathMetric.length) {
      if (offsets[i] != null && offsets[i + dashWidth] != null) {
        path.moveTo(offsets[i].dx, offsets[i].dy);
        path.lineTo(offsets[i + dashWidth].dx, offsets[i + dashWidth].dy);
        // Path segment =
        //     pathMetric.extractPath(offsets[i], offsets[i + dashWidth]);
        // path.addPath(segment, Offset.zero);
        canvas.drawPath(path, brush);
        i += dashWidth + dashSpace;
      } else if (offsets[i] != null && offsets[i + dashWidth] == null) {
        canvas.drawPoints(PointMode.points, [offsets[i]], brush);
      }
    }
    // }
    // }
  }

  // croppedImage(image) {
  //   PictureRecorder recorder = PictureRecorder();
  //   Canvas canvas = Canvas(recorder);
  //   canvas.drawImage(image, new Offset(25, 200), new Paint());
  // }
}

// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: Text('View Outfits'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewOutfitsPage()),
              );
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CombineClothesPage()),
                );
              },
              child: Text('Make a New Outfit')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaintingApp()),
                );
              },
              child: Text('Add Clothes to Closet')),
        ],
      )),
    );
  }
}

class ViewOutfitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Outfits Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class CombineClothesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Combine Clothes Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

// class AddClothesToClosetPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Clothes to Closet"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

class ClosetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Painting App',
      theme: ThemeData(
        // Add the 3 lines from here...
        primaryColor: Colors.white,
      ),
      home: PaintingApp(),
    );
  }
}

const int dashWidth = 4;
const int dashSpace = 4;

class PaintingApp extends StatefulWidget {
  @override
  _PaintingAppState createState() => _PaintingAppState();
}

class _PaintingAppState extends State<PaintingApp> {
  UI.Image image;
  bool isImageLoaded = false;
  final _offsets = <Offset>[];

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
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
  final brush = Paint()
    ..color = Colors.deepPurple
    ..isAntiAlias = true
    ..strokeWidth = 3.0;

  Painter(this.offsets, this.im);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(im, new Offset(25, 200), new Paint());

    for (var i = 0; i < offsets.length - dashWidth; i++) {
      if (offsets[i] != null && offsets[i + dashWidth] != null) {
        canvas.drawLine(offsets[i], offsets[i + dashWidth], brush);
        i += dashWidth + dashSpace;
      } else if (offsets[i] != null && offsets[i + dashWidth] == null) {
        canvas.drawPoints(PointMode.points, [offsets[i]], brush);
      }
    }
  }
}

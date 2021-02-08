// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

void main() => runApp(ClosetApp());

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

class PaintingApp extends StatefulWidget {
  @override
  _PaintingAppState createState() => _PaintingAppState();
}

class _PaintingAppState extends State<PaintingApp> {
  final _offsets = <Offset>[];
  @override
  Widget build(BuildContext context) {
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
          _offsets.add(null);
        });
      },
      child: Center(
        child: CustomPaint(
          painter: Painter(_offsets),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    ));
  }
}

class Painter extends CustomPainter {
  final offsets;

  Painter(this.offsets) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..isAntiAlias = true
      ..strokeWidth = 3.0;

    for (var i = 0; i < offsets.length; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(offsets[i], offsets[i + 1], paint);
      } else if (offsets[i] != null && offsets[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [offsets[i]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

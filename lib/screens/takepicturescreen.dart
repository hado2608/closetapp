import 'dart:async';

import 'package:camera/camera.dart';
import 'package:closetapp/clothingdatabase.dart';
import 'package:closetapp/screens/paintingapp.dart';
import 'package:flutter/material.dart';

/// Adds camera functionality
/// From https://flutter.dev/docs/cookbook/plugins/picture-using-camera
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final ClothingDatabase clothingDatabase;

  const TakePictureScreen({
    Key key,
    @required this.camera,
    @required this.clothingDatabase,
  }) : super(key: key);

  @override
  _TakePictureScreenState createState() =>
      _TakePictureScreenState(clothingDatabase);
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  ClothingDatabase clothingDatabase;

  _TakePictureScreenState(ClothingDatabase clothingDatabase) {
    this.clothingDatabase = clothingDatabase;
  }

  /// Initializes the camera with settings.
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  /// Disposes the controller when the widget is disposed.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Waits for the camera to be initialized, displays the camera view, and saves image data
  /// in a cross-platform file. Passes the image file to PaintingApp.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a picture'),
        backgroundColor: Color(0xff716969),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff716969),
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaintingApp(
                    fileImage: image, clothingDatabase: clothingDatabase),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

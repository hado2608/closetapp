import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:closetapp/screens/viewoutfitspage.dart';
import 'package:closetapp/screens/combineclothespage.dart';
import 'package:closetapp/screens/takepicturescreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CameraDescription> cameras;
  CameraDescription firstCamera;

  void initState() {
    super.initState();
    cameraInit();
  }

  void cameraInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    firstCamera = cameras.first;
  }

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
                  MaterialPageRoute(
                      builder: (context) =>
                          TakePictureScreen(camera: firstCamera)),
                );
              },
              child: Text('Add Clothes to Closet')),
        ],
      )),
    );
  }
}

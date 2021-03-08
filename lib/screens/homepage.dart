import 'package:camera/camera.dart';
import 'package:closetapp/clothingdatabase.dart';
import 'package:flutter/material.dart';

import 'package:closetapp/screens/viewoutfitspage.dart';
import 'package:closetapp/screens/combineclothespage.dart';
import 'package:closetapp/screens/takepicturescreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CameraDescription> cameras;
  CameraDescription firstCamera;
  final ClothingDatabase clothingDatabase = new ClothingDatabase();

  void initState() {
    super.initState();
    cameraInit();
    clothingDatabase.startDatabase();
  }

  void cameraInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: Text('View Outfits'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewOutfitsPage(clothingDatabase: clothingDatabase)),
              );
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewOutfitsPage()));
              },
              child: Text('Make a New Outfit')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TakePictureScreen(
                            camera: firstCamera,
                            clothingDatabase: clothingDatabase,
                          )),
                );
              },
              child: Text('Add Clothes to Closet')),
        ],
      )),
    );
  }
}

class MainButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(80, 300)
      ..lineTo(200, 180)
      ..lineTo(320, 300)
      ..lineTo(200, 420);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LeftButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(40, 200)
      ..lineTo(90, 150)
      ..lineTo(140, 200)
      ..lineTo(90, 250);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class RightButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(260, 400)
      ..lineTo(310, 350)
      ..lineTo(360, 400)
      ..lineTo(310, 450);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

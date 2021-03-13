import 'package:camera/camera.dart';
import 'package:closetapp/clothingdatabase.dart';
import 'package:flutter/material.dart';

import 'package:closetapp/screens/viewclothingitemspage.dart';
import 'package:closetapp/screens/combineclothespage.dart';
import 'package:closetapp/screens/takepicturescreen.dart';
import 'package:flutter/services.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

//The main navigation page with logo and buttons for each of the three main pages: View, mix & match, and add.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CameraDescription> cameras;
  CameraDescription firstCamera;
  final ClothingDatabase clothingDatabase = new ClothingDatabase();

  ///Initializes the states of the camera and the clothing database
  void initState() {
    super.initState();
    cameraInit();
    clothingDatabase.startDatabase();
  }

  ///Initializes the camera
  void cameraInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  /// The main widget displaying the homepage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView(
        children: [
          new Image.asset(
            'assets/images/logotitle.png',
            width: 400,
            height: 400,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xff716969)),
            child: Text(
              'View Clothing Items',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewClothingItemsPage(
                        clothingDatabase: clothingDatabase)),
              );
            },
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xff716969)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CombineClothesPage(
                          clothingDatabase: clothingDatabase)),
                );
              },
              child: Text('Make a New Outfit',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xff716969)),
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
              child: Text('Add Clothes to Closet',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      )),
    );
  }
}

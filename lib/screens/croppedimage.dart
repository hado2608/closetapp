import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:closetapp/clothingdatabase.dart';
import 'package:closetapp/clothingitem.dart';
import 'package:closetapp/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CroppedImage extends StatefulWidget {
  final UI.Image image;
  final ClothingDatabase clothingDatabase;

  const CroppedImage(
      {Key key, @required this.image, @required this.clothingDatabase})
      : super(key: key);

  @override
  _CroppedImageState createState() =>
      _CroppedImageState(image, clothingDatabase);
}

class _CroppedImageState extends State<CroppedImage> {
  final _formKey = GlobalKey<FormState>();
  ClothingDatabase clothingDatabase;
  Uint8List imageData;
  UI.Image img;
  bool isImageLoaded = false;
  String clothingName;
  String categoryName;

  _CroppedImageState(UI.Image img, ClothingDatabase clothingDatabase) {
    this.img = img;
    this.clothingDatabase = clothingDatabase;

    initState();
  }

  void initState() {
    super.initState();
    uiImageToUint8List();
  }

  void uiImageToUint8List() async {
    ByteData bd = await img.toByteData();
    imageData = bd.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cropped Item"),
        ),
        body: Column(children: <Widget>[
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please name your clothing item.';
                      } else {
                        clothingName = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(labelText: 'Clothing Name')),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please categorize your clothing item.';
                    } else {
                      categoryName = value;
                      return null;
                    }
                  },
                  decoration: InputDecoration(labelText: 'Category Name'),
                ),
              ])),
          CustomPaint(painter: DisplayImage(img), child: Container()),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                clothingDatabase.insert(new ClothingItem(
                    id: "$clothingName" +
                        (new Random().nextInt(1000)).toString(),
                    name: clothingName,
                    category: categoryName,
                    image: imageData));
                // Scaffold.of(context)
                //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                return null;
              }
            },
            child: Text('Save'),
          )
        ]));
  }
}

class DisplayImage extends CustomPainter {
  UI.Image im;

  DisplayImage(this.im);
  @override
  void paint(UI.Canvas canvas, UI.Size size) {
    canvas.drawImage(im, Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

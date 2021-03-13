import 'dart:math';
import 'dart:ui' as UI;

import 'package:closetapp/clothingdatabase.dart';
import 'package:closetapp/clothingitem.dart';
import 'package:closetapp/helpers.dart';
import 'package:closetapp/screens/homepage.dart';
import 'package:flutter/material.dart';

/// Represents the screen allowing the user to save the clothingItem
/// in the database.
class ClothingItemSave extends StatefulWidget {
  final UI.Image image;
  final ClothingDatabase clothingDatabase;

  const ClothingItemSave(
      {Key key, @required this.image, @required this.clothingDatabase})
      : super(key: key);

  @override
  _ClothingItemSaveState createState() =>
      _ClothingItemSaveState(image, clothingDatabase);
}

class _ClothingItemSaveState extends State<ClothingItemSave> {
  final _formKey = GlobalKey<FormState>();
  ClothingDatabase clothingDatabase;
  UI.Image img;
  bool isImageLoaded = false;
  String clothingName;
  String categoryName = 'Shirt';
  String itemPath;

  _ClothingItemSaveState(UI.Image img, ClothingDatabase clothingDatabase) {
    this.img = img;
    this.clothingDatabase = clothingDatabase;
  }

  /// Writes the cropped image data to its file.
  void createImageFile() async {
    itemPath = generateImageName();
    final imageFile = await pathForImage(itemPath);
    final bytes = await img.toByteData(format: UI.ImageByteFormat.png);
    await imageFile.writeAsBytes(bytes.buffer.asUint8List());
  }

  /// Displays the cropped image, clothing name TextFormField, category drop down menu,
  /// and save button in that order.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cropped Item"),
          backgroundColor: Color(0xff716969),
        ),
        body: Stack(children: <Widget>[
          CustomPaint(
            painter: DisplayImage(img),
            child: Center(),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Form(
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
                        decoration:
                            InputDecoration(labelText: 'Clothing Name')),
                    DropdownButton(
                        value: categoryName,
                        items: [
                          DropdownMenuItem(
                            child: Text('Shirt'),
                            value: 'Shirt',
                          ),
                          DropdownMenuItem(
                            child: Text('Bottoms'),
                            value: 'Bottoms',
                          ),
                          DropdownMenuItem(child: Text('Shoes'), value: 'Shoes')
                        ],
                        onChanged: (value) {
                          setState(() {
                            categoryName = value;
                          });
                        }),
                  ]))),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xff716969)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    createImageFile();
                    clothingDatabase.insert(new ClothingItem(
                        id: "$clothingName" +
                            (new Random().nextInt(1000)).toString(),
                        name: clothingName,
                        category: categoryName,
                        imagePath: itemPath));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    return null;
                  }
                },
                child: Text('Save'),
              ))
        ]));
  }
}

class DisplayImage extends CustomPainter {
  UI.Image im;

  DisplayImage(this.im);

  /// Draws the cropped image on to the screen.
  @override
  void paint(UI.Canvas canvas, UI.Size size) {
    canvas.drawImage(im, new Offset(0, 0), new Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:io';
import 'dart:typed_data';

import 'package:closetapp/clothingdatabase.dart';
import 'package:closetapp/screens/viewclothingitemspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Displays the combined clothing items into a widget

// ignore: must_be_immutable
class DisplayOutfit extends StatefulWidget {
  List<File> imageList;
  ClothingDatabase clothingDatabase;
  DisplayOutfit(
      {Key key,
      @required List<File> imageList,
      @required ClothingDatabase clothingDatabase})
      : super(key: key);

  @override
  _DisplayOutfitState createState() =>
      _DisplayOutfitState(imageList, clothingDatabase);
}

class _DisplayOutfitState extends State<DisplayOutfit> {
  List<File> imageList = [];
  ClothingDatabase clothingDatabase;

  _DisplayOutfitState(List<File> imageList, ClothingDatabase clothingDatabase) {
    this.imageList = imageList;
    this.clothingDatabase = clothingDatabase;
  }

  ///The widget contains the displayed image and a save button to save the
  ///image in the database
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saved outfit'),
        ),
        body: Stack(
          children: [
            Image.file(imageList[0]),
            Image.file(imageList[1]),
            Image.file(imageList[2]),
            FloatingActionButton(
              // style: ElevatedButton.styleFrom(primary: Color(0xff716969)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewClothingItemsPage(
                            clothingDatabase: clothingDatabase,
                          )),
                );
              },
              child: Text('Save'),
            )
          ],
        ));
  }
}

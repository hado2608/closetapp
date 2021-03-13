import 'dart:io';
import 'package:flutter/material.dart';
import 'package:closetapp/screens/clothingList.dart';
import 'package:closetapp/clothingdatabase.dart';

import 'displayoutfit.dart';

///Combines items of clothing by displaying them in scrolling lists based on
///their categories
class CombineClothesPage extends StatefulWidget {
  final ClothingDatabase clothingDatabase;
  CombineClothesPage({Key key, @required this.clothingDatabase})
      : super(key: key);

  @override
  _CombineClothesPageState createState() =>
      _CombineClothesPageState(clothingDatabase);
}

class _CombineClothesPageState extends State<CombineClothesPage> {
  File shirt;
  File bottom;
  File shoes;
  ClothingDatabase clothingDatabase;
  _CombineClothesPageState(ClothingDatabase clothingDatabase) {
    this.clothingDatabase = clothingDatabase;
  }

  ///The widget that displays scrolling lists and save the chosen items to
  ///DisplayOutfit class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('What outfit are you creating?'),
          backgroundColor: Color(0xff716969),
        ),
        body: Stack(children: [
          ClothingList(
            clothingDatabase: clothingDatabase,
            onOutfitChanged: (shirt, bottoms, shoes) {
              shirt = shirt;
              bottom = bottom;
              shoes = shoes;
            },
          ),
          Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: FloatingActionButton(
                backgroundColor: Color(0xff716969),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayOutfit(
                            imageList: [shirt, bottom, shoes],
                            clothingDatabase: clothingDatabase)),
                  );
                },
                child: Text('Save'),
              ))
        ]));
  }
}

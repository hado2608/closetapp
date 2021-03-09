import 'package:closetapp/screens/viewoutfitspage.dart';
import 'package:flutter/material.dart';
import 'package:closetapp/screens/clothingList.dart';
import 'package:closetapp/clothingdatabase.dart';

import 'displayoutfit.dart';

class CombineClothesPage extends StatefulWidget {
  final ClothingDatabase clothingDatabase;
  CombineClothesPage({Key key, @required this.clothingDatabase})
      : super(key: key);

  @override
  _CombineClothesPageState createState() =>
      _CombineClothesPageState(clothingDatabase);
}

class _CombineClothesPageState extends State<CombineClothesPage> {
  ClothingDatabase clothingDatabase;
  _CombineClothesPageState(ClothingDatabase clothingDatabase) {
    this.clothingDatabase = clothingDatabase;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('What outfit are you creating?'),
        ),
        body: Stack(children: [
          ClothingList(clothingDatabase: clothingDatabase),
          FloatingActionButton(
            // style: ElevatedButton.styleFrom(primary: Color(0xff716969)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplayOutfit()),
              );
            },
            child: Text('Save'),
          )
        ]));
  }
}

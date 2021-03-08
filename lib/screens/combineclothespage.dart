

import 'package:flutter/material.dart';
import 'package:closetapp/screens/clothingList.dart';
import 'package:closetapp/clothingdatabase.dart';

class CombineClothesPage extends StatefulWidget {

  final ClothingDatabase clothingDatabase;
  CombineClothesPage({Key key, @required this.clothingDatabase}) : super(key: key);

  @override
  _CombineClothesPageState createState() => _CombineClothesPageState(clothingDatabase);

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
      body: ClothingList(clothingDatabase: clothingDatabase),
    );
  }
}



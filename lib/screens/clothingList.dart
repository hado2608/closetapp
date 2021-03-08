import 'dart:math';

import 'package:closetapp/clothingitem.dart';
import 'package:closetapp/screens/dynamicList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../clothingdatabase.dart';

class ClothingList extends StatefulWidget {
  final ClothingDatabase clothingDatabase;
  ClothingList({Key key, @required this.clothingDatabase}) : super(key: key);

  @override
  _ClothingListState createState() => _ClothingListState(clothingDatabase);
}

class _ClothingListState extends State<ClothingList> {
  ClothingDatabase clothingDatabase;
  _ClothingListState(ClothingDatabase clothingDatabase) {
    this.clothingDatabase = clothingDatabase;
  }

  List<ClothingItem> shirts;
  List<ClothingItem> bottoms;
  List<ClothingItem> shoes;

  @override
  void initState() {
    super.initState();
    initClothingItemList();
  }

  void initClothingItemList() async {
    shirts = await clothingDatabase.getClothingCategoryItems("Shirt");
    bottoms = await clothingDatabase.getClothingCategoryItems("Bottoms");
    shoes = await clothingDatabase.getClothingCategoryItems("Shoes");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          Flexible(
            child: DynamicList(clothingItemList: shirts),
          ),
          Flexible(
            child: DynamicList(clothingItemList: bottoms),
          ),
          Flexible(
            child: DynamicList(clothingItemList: shoes),
          ),
        ]),
      ),
    );
  }
}

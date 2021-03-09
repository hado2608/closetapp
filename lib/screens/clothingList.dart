import 'dart:io';

import 'package:closetapp/clothingitem.dart';
import 'package:closetapp/helpers.dart';
import 'package:closetapp/screens/categoryswipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../clothingdatabase.dart';

class ClothingList extends StatefulWidget {
  final ClothingDatabase clothingDatabase;
  ClothingList({Key key, @required this.clothingDatabase}) : super(key: key);

  @override
  _ClothingListState createState() => _ClothingListState(clothingDatabase);
}

class _ClothingListState extends State<ClothingList> {
  List<ClothingItem> shirts = [];
  List<ClothingItem> bottoms = [];
  List<ClothingItem> shoes = [];

  ClothingDatabase clothingDatabase;
  _ClothingListState(ClothingDatabase clothingDatabase) {
    this.clothingDatabase = clothingDatabase;
  }

  @override
  void initState() {
    super.initState();
    initClothingItemList();
  }

  void initClothingItemList() async {
    clothingDatabase
        .getClothingCategoryItems("Shirt")
        .then((value) => setState(() {
              shirts = value;
              print(shirts);
            }));
    clothingDatabase
        .getClothingCategoryItems("Bottoms")
        .then((value) => setState(() {
              bottoms = value;
              print(bottoms);
            }));
    clothingDatabase
        .getClothingCategoryItems("Shoes")
        .then((value) => setState(() {
              shoes = value;
              print(shoes);
            }));
  }

  Future<List<File>> getClothingItemImageHelper(List<ClothingItem> c) async {
    List<File> a = [];
    for (ClothingItem i in c) {
      a.add(await pathForImage(i.imagePath));
    }
    //NEVER DELETE THIS
    print(a[0]);

    return a;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      FutureBuilder(
          future: getClothingItemImageHelper(shirts),
          builder: (context, AsyncSnapshot<List<File>> snapshot) {
            if (snapshot.hasData) {
              return Flexible(
                child: CategorySwipe(clothingItemList: snapshot.data),
              );
            } else {
              return Container();
            }
          }),
      FutureBuilder(
          future: getClothingItemImageHelper(bottoms),
          builder: (context, AsyncSnapshot<List<File>> snapshot) {
            if (snapshot.hasData) {
              return Flexible(
                child: CategorySwipe(clothingItemList: snapshot.data),
              );
            } else {
              return Container();
            }
          }),
      FutureBuilder(
          future: getClothingItemImageHelper(shoes),
          builder: (context, AsyncSnapshot<List<File>> snapshot) {
            if (snapshot.hasData) {
              return Flexible(
                child: CategorySwipe(clothingItemList: snapshot.data),
              );
            } else {
              return Container();
            }
          }),
    ])));
  }
}

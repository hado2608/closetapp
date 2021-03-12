import 'dart:io';

import 'package:closetapp/clothingitem.dart';
import 'package:closetapp/helpers.dart';
import 'package:closetapp/screens/categoryswipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../clothingdatabase.dart';

class ClothingList extends StatefulWidget {
  final ClothingDatabase clothingDatabase;
  final void Function(File, File, File) onOutfitChanged;
  ClothingList(
      {Key key,
      @required this.clothingDatabase,
      @required this.onOutfitChanged})
      : super(key: key);

  @override
  _ClothingListState createState() =>
      _ClothingListState(clothingDatabase, onOutfitChanged);
}

class _ClothingListState extends State<ClothingList> {
  List<ClothingItem> shirts = [];
  List<ClothingItem> bottoms = [];
  List<ClothingItem> shoes = [];
  File selectedShirt;
  File selectedBottoms;
  File selectedShoes;
  void Function(File, File, File) onOutfitChanged;

  ClothingDatabase clothingDatabase;
  _ClothingListState(ClothingDatabase clothingDatabase,
      void Function(File, File, File) onOutfitChanged) {
    this.clothingDatabase = clothingDatabase;
    this.onOutfitChanged = onOutfitChanged;
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
            }));
    clothingDatabase
        .getClothingCategoryItems("Bottoms")
        .then((value) => setState(() {
              bottoms = value;
            }));
    clothingDatabase
        .getClothingCategoryItems("Shoes")
        .then((value) => setState(() {
              shoes = value;
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

  void _doOutfitChangeCallback() {
    if (onOutfitChanged != null) {
      onOutfitChanged(selectedShirt, selectedBottoms, selectedShoes);
    }
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
                child: CategorySwipe(
                    clothingItemList: snapshot.data,
                    onItemSelected: (file) {
                      selectedShirt = file;
                      _doOutfitChangeCallback();
                    }),
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
                child: CategorySwipe(
                    clothingItemList: snapshot.data,
                    onItemSelected: (file) {
                      selectedBottoms = file;
                      _doOutfitChangeCallback();
                    }),
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
                child: CategorySwipe(
                    clothingItemList: snapshot.data,
                    onItemSelected: (file) {
                      selectedShoes = file;
                      _doOutfitChangeCallback();
                    }),
              );
            } else {
              return Container();
            }
          }),
    ])));
  }
}

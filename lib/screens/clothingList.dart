import 'dart:math';

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

  List<int> data = [];
  int _focusedIndex = 0;
  int n = 30;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < n; i++) {
      data.add(Random().nextInt(100) + 1);
    }
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              Flexible(
                child: DynamicList(),
              ),
              Flexible(
                child: DynamicList(),
              ),
              Flexible(
                child: DynamicList(),
              ),
            ]
          ),
        ),
    );
  }

}




import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../helpers.dart';

class CategorySwipe extends StatefulWidget {
  final List<File> clothingItemList;

  const CategorySwipe({
    Key key,
    @required this.clothingItemList,
  }) : super(key: key);

  @override
  _CategorySwipeState createState() => _CategorySwipeState(clothingItemList);
}

class _CategorySwipeState extends State<CategorySwipe> {
  List<File> clothingItemList;
  List<int> data = [];
  int _focusedIndex = 0;
  int n = 30;

  _CategorySwipeState(List<File> clothingItemList) {
    this.clothingItemList = clothingItemList;
  }

  Future<File> getClothingItemImageHelper(String itemPath) async {
    return pathForImage(itemPath);
  }

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

  Widget _buildItemDetail() {
    if (data.length > _focusedIndex)
      return Flexible(
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Text("index $_focusedIndex: ${data[_focusedIndex]}"),
        ),
      );

    return Flexible(
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        child: Text("No Data"),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    //horizontal
    return Container(
      width: _itemWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Container(
              width: _itemWidth(context),
              height: _itemHeight(context),
              color: Colors.lightBlueAccent,
              child: Image.file(clothingItemList[index]),
            ),
          ),
        ],
      ),
    );
  }

  double _itemHeight(BuildContext context) =>
      MediaQuery.of(context).size.height / 4;

  double _itemWidth(BuildContext context) =>
      MediaQuery.of(context).size.width / 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      // title: 'Horizontal List Demo',
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text("Horizontal List"),
      //   ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ScrollSnapList(
              onItemFocus: _onItemFocus,
              itemSize: _itemWidth(context),
              itemBuilder: _buildListItem,
              itemCount: clothingItemList.length,
              dynamicItemOpacity: 0.3,
              dynamicItemSize: true,
              // dynamicSizeEquation: customEquation, //optional
            ),
          ),
          _buildItemDetail(),
        ],
      ),
    );
  }
}

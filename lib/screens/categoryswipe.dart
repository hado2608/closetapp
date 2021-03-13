import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../helpers.dart';

/// Create a scrolling list of files based on the category of the files
class CategorySwipe extends StatefulWidget {
  final List<File> clothingItemList;
  final void Function(File) onItemSelected;

  const CategorySwipe(
      {Key key, @required this.clothingItemList, this.onItemSelected})
      : super(key: key);

  @override
  _CategorySwipeState createState() =>
      _CategorySwipeState(clothingItemList, onItemSelected);
}

class _CategorySwipeState extends State<CategorySwipe> {
  List<File> clothingItemList;
  List<int> data = [];
  List<File> highlightedItems = [];
  void Function(File) onItemSelected;
  int _focusedIndex = 0;

  _CategorySwipeState(
      List<File> clothingItemList, void Function(File) onItemSelected) {
    this.clothingItemList = clothingItemList;
    this.onItemSelected = onItemSelected;
    _doItemSelectedCallback();
  }

  Future<File> getClothingItemImageHelper(String itemPath) async {
    return pathForImage(itemPath);
  }

  @override
  void initState() {
    super.initState();
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
      _doItemSelectedCallback();
    });
  }

  void _doItemSelectedCallback() {
    if (onItemSelected != null) {
      onItemSelected(clothingItemList[_focusedIndex]);
    }
  }

  Widget _buildItemDetail() {
    return Flexible(
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        // child: Text("index $_focusedIndex"),
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
              color: Colors.white,
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

  /// Creates a dynamic list of clothing items.
  /// Adapted from https://pub.dev/packages/scroll_snap_list

  @override
  Widget build(BuildContext context) {
    return Container(
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
            ),
          ),
          _buildItemDetail(),
        ],
      ),
    );
  }
}

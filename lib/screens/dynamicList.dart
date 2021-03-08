
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class DynamicList extends StatefulWidget {
  @override
  _DynamicListState createState() => _DynamicListState();
}

class _DynamicListState extends State<DynamicList> {
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

  Widget _buildItemDetail() {
    if (data.length > _focusedIndex)
      return Flexible(
          child: Container(
              height: MediaQuery.of(context).size.height/4,
              child: Text("index $_focusedIndex: ${data[_focusedIndex]}"),
              ),
      );

    return Flexible(
        child: Container(
            height: MediaQuery.of(context).size.height/4,
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
                            child: Text("i:$index\n${data[index]}"),
                          ),
              ),
             ],
          ),
    );
  }

  double _itemHeight(BuildContext context) => MediaQuery.of(context).size.height/4;

  double _itemWidth(BuildContext context) => MediaQuery.of(context).size.width/5;

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
                  itemCount: data.length,
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

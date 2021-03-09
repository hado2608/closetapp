import 'dart:typed_data';

import 'package:closetapp/screens/viewoutfitspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayOutfit extends StatefulWidget {
  List<Uint8List> imageList;
  DisplayOutfit({Key key, @required List<Uint8List> imageList})
      : super(key: key);

  @override
  _DisplayOutfitState createState() => _DisplayOutfitState(imageList);
}

class _DisplayOutfitState extends State<DisplayOutfit> {
  List<Uint8List> imageList;

  _DisplayOutfitState(List<Uint8List> imageList) {
    this.imageList = imageList;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saved outfit'),
        ),
        body: Stack(children: [
          Image.memory(imageList[0]),
          Image.memory(imageList[1]),
          Image.memory(imageList[2]),
          FloatingActionButton(
            // style: ElevatedButton.styleFrom(primary: Color(0xff716969)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewOutfitsPage()),
              );
            },
            child: Text('Save'),
          )
        ]));
  }
}

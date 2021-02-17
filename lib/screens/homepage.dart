import 'package:flutter/material.dart';

import 'package:closetapp/screens/viewoutfitspage.dart';
import 'package:closetapp/screens/combineclothespage.dart';
import 'package:closetapp/screens/paintingapp.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: Text('View Outfits'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewOutfitsPage()),
              );
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CombineClothesPage()),
                );
              },
              child: Text('Make a New Outfit')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaintingApp()),
                );
              },
              child: Text('Add Clothes to Closet')),
        ],
      )),
    );
  }
}

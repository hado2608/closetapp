import 'package:flutter/material.dart';
import 'dart:io';
import 'package:closetapp/clothingdatabase.dart';
import 'dart:ui' as UI;
import 'package:closetapp/clothingitem.dart';
import 'dart:math';
import 'homepage.dart';
import 'package:closetapp/helpers.dart';
import 'details_page.dart';

class CategoryScreen extends StatefulWidget {
  @override
  // ignore: missing_required_param
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  ClothingDatabase clothingDatabase;
  ClothingItem clothingItem;
  UI.Image img;
  bool isImageLoaded = false;

  _CategoryScreenState(
      {@required this.clothingItem, @required this.clothingDatabase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cropped Item"),
        ),
        body: Column(children: <Widget>[
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please name your clothing item.';
                      } else {
                        clothingItem.name = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Clothing Name',
                    )),
                DropdownButton(
                    value: clothingItem.category,
                    items: [
                      DropdownMenuItem(
                        child: Text('Shirt'),
                        value: 'Shirt',
                      ),
                      DropdownMenuItem(
                        child: Text('Bottoms'),
                        value: 'Bottoms',
                      ),
                      DropdownMenuItem(child: Text('Shoes'), value: 'Shoes')
                    ],
                    onChanged: (value) {
                      setState(() {
                        clothingItem.name = value;
                      });
                    }),
              ])),
          ElevatedButton(
            onPressed: () {
              print("!!!!!!" + clothingItem.name);
              // clothingDatabase.updateClothingItem(clothingItem);
              // if (_formKey.currentState.validate()) {
              //   createImageFile();
              //   clothingDatabase.insert(new ClothingItem(
              //       id: "$clothingName" +
              //           (new Random().nextInt(1000)).toString(),
              //       name: clothingName,
              //       category: categoryName,
              //       imagePath: itemPath));
              // Scaffold.of(context)
              //     .showSnackBar(SnackBar(content: Text('Processing Data')));
              Navigator.pop(context);
              // } else {
              //   return null;
            },
            child: Text('Save'),
          )
        ]));
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:closetapp/clothingdatabase.dart';
import 'dart:ui' as UI;
import 'package:closetapp/clothingitem.dart';
import 'dart:math';
import 'homepage.dart';
import 'package:closetapp/helpers.dart';

class CategoryScreen extends StatefulWidget {
  @override
  // ignore: missing_required_param
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final File image;
  final String name;
  final String category;
  final String id;
  final _formKey = GlobalKey<FormState>();
  ClothingDatabase clothingDatabase;
  UI.Image img;
  bool isImageLoaded = false;
  String clothingName;
  String categoryName;
  String itemPath;
  _CategoryScreenState(
      {@required this.image,
      @required this.name,
      @required this.category,
      @required this.id});

//   int _value = 1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Edit'),
//         ),
//         body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: <Widget>[
//                 TextField(
//                     decoration: InputDecoration(
//                         labelText: 'Title',
//                         hintText: 'Give the clothes a name')),
//                 new DropdownButton(
//                     value: _value,
//                     items: [
//                       DropdownMenuItem(
//                         child: Text("Shirts"),
//                         value: 1,
//                       ),
//                       DropdownMenuItem(
//                         child: Text("Pants"),
//                         value: 2,
//                       ),
//                       DropdownMenuItem(child: Text("Accessories"), value: 3),
//                       DropdownMenuItem(child: Text("Other"), value: 4)
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         _value = value;
//                       });
//                     }),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 RaisedButton(
//                   onPressed: () {},
//                   color: Colors.blue,
//                   child: Text(
//                     'Save',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             )));
//   }
// }
  void createImageFile() async {
    itemPath = generateImageName();
    final imageFile = await pathForImage(itemPath);
    final bytes = await img.toByteData(format: UI.ImageByteFormat.png);
    await imageFile.writeAsBytes(bytes.buffer.asUint8List());
  }

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
                      clothingName = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please categorize your clothing item.';
                    } else {
                      categoryName = value;
                      return null;
                    }
                  },
                  decoration: InputDecoration(labelText: 'Category Name'),
                ),
              ])),
          CustomPaint(painter: DisplayImage(img), child: Container()),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                createImageFile();
                clothingDatabase.insert(new ClothingItem(
                    id: "$clothingName" +
                        (new Random().nextInt(1000)).toString(),
                    name: clothingName,
                    category: categoryName,
                    imagePath: itemPath));
                // Scaffold.of(context)
                //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                return null;
              }
            },
            child: Text('Save'),
          )
        ]));
  }
}

class DisplayImage extends CustomPainter {
  UI.Image im;

  DisplayImage(this.im);
  @override
  void paint(UI.Canvas canvas, UI.Size size) {
    canvas.drawColor(Colors.white, BlendMode.src);
    canvas.drawImage(im, new Offset(0, 0), new Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

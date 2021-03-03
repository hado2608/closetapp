import 'package:closetapp/clothingdatabase.dart';
import 'package:closetapp/clothingitem.dart';
import 'package:flutter/material.dart';
import 'details_page.dart';

//https://github.com/kaycobad/gallery_app

class ViewOutfitsPage extends StatefulWidget {
  final ClothingDatabase clothingDatabase;

  ViewOutfitsPage({Key key, @required this.clothingDatabase}) : super(key: key);

  @override
  _ViewOutfitsPageState createState() =>
      _ViewOutfitsPageState(clothingDatabase);
}

class _ViewOutfitsPageState extends State<ViewOutfitsPage> {
  ClothingDatabase clothingDatabase;
  List<ClothingItem> clothingItems;

  _ViewOutfitsPageState(ClothingDatabase clothingDatabase) {
    this.clothingDatabase = clothingDatabase;

    initClothingItems();
  }

  void initClothingItems() async {
    clothingDatabase.getClothingItems().then((value) => setState(() {
          clothingItems = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              'Closet',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: GridView.builder(
                    itemCount: (clothingItems ?? []).length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return RawMaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                image: clothingItems[index].image,
                                name: clothingItems[index].name,
                                category: clothingItems[index].category,
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'logo$index',
                          child: Container(
                              child: Text(clothingItems[index].name)
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(15),
                              //   image: DecorationImage(
                              //     image: MemoryImage(clothingItems[index].image),
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class ImageDetails {
//   final String imagePath;
//   final String title;
//   final String details;
//   ImageDetails({
//     @required this.imagePath,
//     @required this.title,
//     @required this.details,
//   });
// }

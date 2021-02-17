// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:closetapp/screens/homepage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HomePage(),
  ));
}

// class AddClothesToClosetPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Clothes to Closet"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

// class ClosetApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Painting App',
//       theme: ThemeData(
//         // Add the 3 lines from here...
//         primaryColor: Colors.white,
//       ),
//       home: PaintingApp(),
//     );
//   }
// }

// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:closetapp/screens/homepage.dart';

/// This app lets users take a picture of an item of clothing, crop the part that
/// they want to display, and save it in the database. It also helps mix and match
/// the items the way you want, and save the combination for later uses.
/// Author: Ha Do, Steven Mai, Mikayla Brunner, Leah Robotham
void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffBCABAE), fontFamily: 'Jura'),
    home: HomePage(),
  ));
}

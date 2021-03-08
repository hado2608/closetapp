// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:closetapp/screens/homepage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffBCABAE), fontFamily: 'Jura'),
    home: HomePage(),
  ));
}

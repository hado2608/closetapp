import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

String generateImageName() {
  return Uuid().v4() + '.png';
}

/// Gets the corresponding image file from the directory.
Future<File> pathForImage(String imgFileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path + '/clothing';
  await new Directory(path).create(recursive: true);
  return new File('$path/$imgFileName');
}

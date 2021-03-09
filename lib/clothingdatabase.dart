import 'dart:io';

import 'package:closetapp/clothingitem.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ClothingDatabase {
  Database database;

  void startDatabase() async {
    // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // deleteDatabase(join(await getDatabasesPath(), 'clothes_database.db'));
// Open the database and store the reference.
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'clothes_database.db'),
      // When the database is first created, create a table to store ClothingItems.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE clothes(id TEXT PRIMARY KEY, name TEXT, category TEXT, imagePath TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insert(ClothingItem clothingItem) async {
    // Get a reference to the database.
    final Database db = database;

    // Insert the ClothingItem into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same ClothingItem is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'clothes',
      clothingItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the ClothingItems from the ClothingItems table.
  Future<List<ClothingItem>> getClothingItems() async {
    // Get a reference to the database.
    final Database db = database;

    // Query the table for all The ClothingItems.
    // final List<Map<String, dynamic>> maps = await db.query('clothes');

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT id, name, category, imagePath FROM clothes');

    // Convert the List<Map<String, dynamic> into a List<ClothingItem>.
    return List.generate(maps.length, (i) {
      return ClothingItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
        category: maps[i]['category'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  // A method that retrieves all the ClothingItems of a given category from the ClothingItems table.
  Future<List<ClothingItem>> getClothingCategoryItems(String category) async {
    // Get a reference to the database.
    final Database db = database;

    // Query the table for all The ClothingItems of the given category.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT id, name, category, imagePath FROM clothes GROUP BY category, id HAVING category = ('$category')");

    // Convert the List<Map<String, dynamic> into a List<ClothingItem>.
    return List.generate(maps.length, (i) {
      return ClothingItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
        category: maps[i]['category'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  Future<File> getClothingItemImage(String name, String category) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    String itemPath = '$path/$name/$category.jpg';
    return File(itemPath);
  }

  Future<void> updateClothingItem(ClothingItem clothingItem) async {
    // Get a reference to the database.
    final db = database;

    // Update the given ClothingItem.
    await db.update(
      'clothes',
      clothingItem.toMap(),
      // Ensure that the ClothingItem has a matching id.
      where: "id = ?",
      // Pass the ClothingItem's id as a whereArg to prevent SQL injection.
      whereArgs: [clothingItem.id],
    );
  }

  Future<void> deleteClothingItem() async {
    // Get a reference to the database.
    final db = database;

    // Remove the ClothingItem from the Database.
    await db.delete(
      'clothes',
      // Use a `where` clause to delete a specific ClothingItem.
      where: "1",
      // Pass the ClothingItem's id as a whereArg to prevent SQL injection.
    );
  }
}

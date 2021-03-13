import 'package:closetapp/clothingitem.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Enables storage of clothingItems.
/// From https://flutter.dev/docs/cookbook/persistence/sqlite
class ClothingDatabase {
  Database database;

  /// Initializes the database with one table for clothingItems.
  void startDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    database = await openDatabase(
      join(await getDatabasesPath(), 'clothes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE clothes(id TEXT PRIMARY KEY, name TEXT, category TEXT, imagePath TEXT)",
        );
      },
      version: 1,
    );
  }

  /// Adds the give clothingItem to the clothes table of the database,
  /// replacing it if it already exists.
  Future<void> insert(ClothingItem clothingItem) async {
    final Database db = database;

    await db.insert(
      'clothes',
      clothingItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves all the ClothingItems from the ClothingItems table.
  Future<List<ClothingItem>> getClothingItems() async {
    final Database db = database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT id, name, category, imagePath FROM clothes');

    return List.generate(maps.length, (i) {
      return ClothingItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
        category: maps[i]['category'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  /// Retrieves all the ClothingItems of a given category from the ClothingItems table.
  Future<List<ClothingItem>> getClothingCategoryItems(String category) async {
    final Database db = database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT id, name, category, imagePath FROM clothes GROUP BY category, id HAVING category = ('$category')");

    return List.generate(maps.length, (i) {
      return ClothingItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
        category: maps[i]['category'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  /// Updates the corresponding ClothingItem in the clothes table of the database
  /// with a new ClothingItem.
  Future<void> updateClothingItem(ClothingItem clothingItem) async {
    final db = database;

    await db.update(
      'clothes',
      clothingItem.toMap(),
      where: "id = ?",
      whereArgs: [clothingItem.id],
    );
  }

  /// Deletes a given ClothingItem from the clothes table of the database.
  Future<void> deleteClothingItem(ClothingItem clothingItem) async {
    final db = database;

    await db.delete(
      'clothes',
      where: "id = ?",
      whereArgs: [clothingItem.id],
    );
  }
}

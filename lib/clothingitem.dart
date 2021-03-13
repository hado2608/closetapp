/// Represents a clothing item to be stored in the database.
class ClothingItem {
  String id;
  String name;
  String category;
  String imagePath;

  ClothingItem({this.id, this.name, this.category, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
    };
  }

  @override
  String toString() {
    return 'ClothingItem{id: $id, name: $name, category: $category, imagePath: $imagePath}';
  }
}

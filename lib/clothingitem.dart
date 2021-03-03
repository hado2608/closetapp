import 'dart:typed_data';

class ClothingItem {
  String id;
  String name;
  String category;
  Uint8List image;

  ClothingItem({this.id, this.name, this.category, this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'ClothingItem{id: $id, name: $name, category: $category, image: $image}';
  }
}

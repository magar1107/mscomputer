// lib/models/product.dart
class Product {
  final String id;
  final String nameMarathi;
  final int price;
  final String category;
  final String descriptionMarathi;
  final bool inStock;
  final String imageUrl;

  Product({
    required this.id,
    required this.nameMarathi,
    required this.price,
    required this.category,
    required this.descriptionMarathi,
    required this.inStock,
    required this.imageUrl,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      nameMarathi: data['name_marathi'] ?? '',
      price: data['price'] ?? 0,
      category: data['category'] ?? '',
      descriptionMarathi: data['description_marathi'] ?? '',
      inStock: data['inStock'] ?? false,
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name_marathi': nameMarathi,
      'price': price,
      'category': category,
      'description_marathi': descriptionMarathi,
      'inStock': inStock,
      'imageUrl': imageUrl,
    };
  }
}

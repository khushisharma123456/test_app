class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final bool isInStock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.isInStock = true,
  });
}

class ShopListItem {
  final String id;
  final String name;
  final String category;
  final bool isCompleted;
  final DateTime dateAdded;

  ShopListItem({
    required this.id,
    required this.name,
    required this.category,
    this.isCompleted = false,
    required this.dateAdded,
  });
}

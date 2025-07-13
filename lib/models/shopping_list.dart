class ShoppingListItem {
  final String id;
  final String name;
  final String? description;
  final int quantity;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? category;
  final double? estimatedPrice;

  ShoppingListItem({
    required this.id,
    required this.name,
    this.description,
    this.quantity = 1,
    this.isCompleted = false,
    DateTime? createdAt,
    this.completedAt,
    this.category,
    this.estimatedPrice,
  }) : createdAt = createdAt ?? DateTime.now();

  ShoppingListItem copyWith({
    String? id,
    String? name,
    String? description,
    int? quantity,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    String? category,
    double? estimatedPrice,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      category: category ?? this.category,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'category': category,
      'estimatedPrice': estimatedPrice,
    };
  }

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'] ?? 1,
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      category: json['category'],
      estimatedPrice: json['estimatedPrice']?.toDouble(),
    );
  }
}

class ShoppingList {
  final String id;
  final String name;
  final String? description;
  final String createdBy;
  final List<String> sharedWith;
  final List<ShoppingListItem> items;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? category;

  ShoppingList({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    List<String>? sharedWith,
    List<ShoppingListItem>? items,
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
    this.category,
  }) : sharedWith = sharedWith ?? [],
       items = items ?? [],
       createdAt = createdAt ?? DateTime.now();

  ShoppingList copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    List<String>? sharedWith,
    List<ShoppingListItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? category,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      sharedWith: sharedWith ?? this.sharedWith,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      category: category ?? this.category,
    );
  }

  int get completedItemsCount => items.where((item) => item.isCompleted).length;
  
  int get totalItemsCount => items.length;
  
  double get completionPercentage => 
      totalItemsCount == 0 ? 0.0 : (completedItemsCount / totalItemsCount) * 100;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'sharedWith': sharedWith,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'category': category,
    };
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['createdBy'],
      sharedWith: List<String>.from(json['sharedWith'] ?? []),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => ShoppingListItem.fromJson(item))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      category: json['category'],
    );
  }
}

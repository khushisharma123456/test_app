import '../models/user_models.dart';

class ShoppingListService {
  // Demo implementation - in a real app, this would connect to a backend
  static final Map<String, ShoppingList> _demoLists = {};
  static int _nextId = 1;

  // Create a new shopping list
  Future<String?> createShoppingList({
    required String name,
    required String createdBy,
    List<String>? sharedWith,
    DateTime? reminderTime,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      
      final String id = _nextId.toString();
      _nextId++;
      
      final list = ShoppingList(
        id: id,
        name: name,
        ownerId: createdBy,
        sharedWith: sharedWith ?? [],
        items: [],
        createdAt: DateTime.now(),
        isCompleted: false,
      );
      
      _demoLists[id] = list;
      return id;
    } catch (e) {
      print('Error creating shopping list: $e');
      return null;
    }
  }

  // Get shopping lists for a user
  Future<List<ShoppingList>> getUserShoppingLists(String userId) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      
      return _demoLists.values
          .where((list) => list.ownerId == userId && !list.isCompleted)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error getting shopping lists: $e');
      return [];
    }
  }

  // Get shared shopping lists for a user
  Future<List<ShoppingList>> getSharedShoppingLists(String userId) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      
      return _demoLists.values
          .where((list) => list.sharedWith.contains(userId) && !list.isCompleted)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error getting shared lists: $e');
      return [];
    }
  }

  // Add item to shopping list
  Future<bool> addItemToList({
    required String listId,
    required String itemName,
    required String category,
    required String addedBy,
    String? translatedName,
    String? notes,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      
      final list = _demoLists[listId];
      if (list != null) {
        final item = ShoppingListItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: itemName,
          category: category,
          addedBy: addedBy,
          createdAt: DateTime.now(),
          notes: notes,
        );
        
        final updatedItems = List<ShoppingListItem>.from(list.items);
        updatedItems.add(item);
        
        _demoLists[listId] = list.copyWith(items: updatedItems);
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding item to list: $e');
      return false;
    }
  }

  // Update item in shopping list
  Future<bool> updateItemInList({
    required String listId,
    required ShoppingListItem updatedItem,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      
      final list = _demoLists[listId];
      if (list != null) {
        final updatedItems = list.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();
        
        _demoLists[listId] = list.copyWith(items: updatedItems);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating item in list: $e');
      return false;
    }
  }

  // Remove item from shopping list
  Future<bool> removeItemFromList({
    required String listId,
    required String itemId,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      
      final list = _demoLists[listId];
      if (list != null) {
        final updatedItems = list.items.where((item) => item.id != itemId).toList();
        _demoLists[listId] = list.copyWith(items: updatedItems);
        return true;
      }
      return false;
    } catch (e) {
      print('Error removing item from list: $e');
      return false;
    }
  }

  // Share shopping list with another user
  Future<bool> shareListWithUser({
    required String listId,
    required String userEmail,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      
      final list = _demoLists[listId];
      if (list != null && !list.sharedWith.contains(userEmail)) {
        final updatedSharedWith = List<String>.from(list.sharedWith);
        updatedSharedWith.add(userEmail);
        
        _demoLists[listId] = list.copyWith(sharedWith: updatedSharedWith);
        return true;
      }
      return false;
    } catch (e) {
      print('Error sharing list with user: $e');
      return false;
    }
  }

  // Delete shopping list
  Future<bool> deleteShoppingList(String listId) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      
      final list = _demoLists[listId];
      if (list != null) {
        _demoLists[listId] = list.copyWith(isCompleted: true);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting shopping list: $e');
      return false;
    }
  }

  // Get a specific shopping list
  Future<ShoppingList?> getShoppingList(String listId) async {
    try {
      await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
      return _demoLists[listId];
    } catch (e) {
      print('Error getting shopping list: $e');
      return null;
    }
  }
}

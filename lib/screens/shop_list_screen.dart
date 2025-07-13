import 'package:flutter/material.dart';
import '../models/product.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final List<ShopListItem> _shopItems = [
    ShopListItem(
      id: '1',
      name: 'Milk',
      category: 'Dairy',
      dateAdded: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ShopListItem(
      id: '2',
      name: 'Bread',
      category: 'Bakery',
      dateAdded: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ShopListItem(
      id: '3',
      name: 'Apples',
      category: 'Fruits',
      isCompleted: true,
      dateAdded: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ShopListItem(
      id: '4',
      name: 'Chicken',
      category: 'Meat',
      dateAdded: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ShopListItem(
      id: '5',
      name: 'Rice',
      category: 'Grains',
      dateAdded: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ];

  final TextEditingController _itemController = TextEditingController();
  String _selectedCategory = 'Groceries';
  final List<String> _categories = [
    'Groceries',
    'Dairy',
    'Bakery',
    'Fruits',
    'Vegetables',
    'Meat',
    'Electronics',
    'Clothing',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4A90E2),
                  const Color(0xFF4A90E2).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total Items',
                  _shopItems.length.toString(),
                  Icons.list_alt,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white30,
                ),
                _buildSummaryItem(
                  'Completed',
                  _shopItems.where((item) => item.isCompleted).length.toString(),
                  Icons.check_circle,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white30,
                ),
                _buildSummaryItem(
                  'Remaining',
                  _shopItems.where((item) => !item.isCompleted).length.toString(),
                  Icons.pending,
                ),
              ],
            ),
          ),
          
          // List Items
          Expanded(
            child: _shopItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _shopItems.length,
                    itemBuilder: (context, index) {
                      final item = _shopItems[index];
                      return _buildShopListItem(item, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildShopListItem(ShopListItem item, int index) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 8),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _shopItems.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} removed from list'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _shopItems.insert(index, item);
                });
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: item.isCompleted ? Colors.green : Colors.grey.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          leading: Checkbox(
            value: item.isCompleted,
            onChanged: (bool? value) {
              setState(() {
                _shopItems[index] = ShopListItem(
                  id: item.id,
                  name: item.name,
                  category: item.category,
                  isCompleted: value ?? false,
                  dateAdded: item.dateAdded,
                );
              });
            },
            activeColor: const Color(0xFF4A90E2),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              color: item.isCompleted ? Colors.grey : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getCategoryColor(item.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getCategoryColor(item.category).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  item.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getCategoryColor(item.category),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDateTime(item.dateAdded),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.drag_handle,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your shopping list is empty',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first item',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'Item name',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _itemController.clear();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_itemController.text.isNotEmpty) {
                      setState(() {
                        _shopItems.add(
                          ShopListItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: _itemController.text,
                            category: _selectedCategory,
                            dateAdded: DateTime.now(),
                          ),
                        );
                      });
                      Navigator.of(context).pop();
                      _itemController.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Name (A-Z)'),
                onTap: () {
                  setState(() {
                    _shopItems.sort((a, b) => a.name.compareTo(b.name));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Category'),
                onTap: () {
                  setState(() {
                    _shopItems.sort((a, b) => a.category.compareTo(b.category));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Date Added'),
                onTap: () {
                  setState(() {
                    _shopItems.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Completion Status'),
                onTap: () {
                  setState(() {
                    _shopItems.sort((a, b) => a.isCompleted ? 1 : -1);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Dairy':
        return Colors.blue;
      case 'Bakery':
        return Colors.orange;
      case 'Fruits':
        return Colors.green;
      case 'Vegetables':
        return Colors.lightGreen;
      case 'Meat':
        return Colors.red;
      case 'Electronics':
        return Colors.purple;
      case 'Clothing':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }
}

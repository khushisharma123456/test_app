import 'package:flutter/material.dart';
import '../../services/voice_service.dart';

class ElderlyShoppingList extends StatefulWidget {
  const ElderlyShoppingList({super.key});

  @override
  State<ElderlyShoppingList> createState() => _ElderlyShoppingListState();
}

class _ElderlyShoppingListState extends State<ElderlyShoppingList> {
  final VoiceService _voiceService = VoiceService();
  
  // Sample shopping list items
  final List<Map<String, dynamic>> _items = [
    {'name': 'Milk', 'completed': false},
    {'name': 'Bread', 'completed': true},
    {'name': 'Apples', 'completed': false},
    {'name': 'Eggs', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        title: const Text(
          'My Shopping List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, size: 32),
            onPressed: _readListAloud,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Shopping Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProgressItem(
                      'Total Items',
                      _items.length.toString(),
                      Icons.list_alt,
                    ),
                    _buildProgressItem(
                      'Completed',
                      _items.where((item) => item['completed']).length.toString(),
                      Icons.check_circle,
                    ),
                    _buildProgressItem(
                      'Remaining',
                      _items.where((item) => !item['completed']).length.toString(),
                      Icons.pending,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // List Items
          Expanded(
            child: _items.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _buildListItem(item, index);
                    },
                  ),
          ),
          
          // Add Item Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton.icon(
                onPressed: _addNewItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.add, size: 32),
                label: const Text(
                  'Add New Item',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item['completed'] ? Colors.green : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: GestureDetector(
          onTap: () => _toggleItemCompletion(index),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item['completed'] ? Colors.green : Colors.transparent,
              border: Border.all(
                color: item['completed'] ? Colors.green : Colors.grey,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: item['completed']
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
        ),
        title: Text(
          item['name'],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            decoration: item['completed'] ? TextDecoration.lineThrough : null,
            color: item['completed'] ? Colors.grey : Colors.black,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 28,
          ),
          onPressed: () => _deleteItem(index),
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
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Your shopping list is empty',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap "Add New Item" to get started',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleItemCompletion(int index) {
    setState(() {
      _items[index]['completed'] = !_items[index]['completed'];
    });
    
    // Provide audio feedback
    if (_items[index]['completed']) {
      _voiceService.speak('${_items[index]['name']} marked as completed');
    } else {
      _voiceService.speak('${_items[index]['name']} unmarked');
    }
  }

  void _deleteItem(int index) {
    final itemName = _items[index]['name'];
    setState(() {
      _items.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName removed from list'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _items.insert(index, {'name': itemName, 'completed': false});
            });
          },
        ),
      ),
    );
  }

  void _addNewItem() {
    showDialog(
      context: context,
      builder: (context) {
        String newItemName = '';
        return AlertDialog(
          title: const Text(
            'Add New Item',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              hintText: 'Enter item name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              newItemName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (newItemName.isNotEmpty) {
                  setState(() {
                    _items.add({'name': newItemName, 'completed': false});
                  });
                  Navigator.pop(context);
                  _voiceService.speak('$newItemName added to your list');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _readListAloud() async {
    if (_items.isEmpty) {
      await _voiceService.speak('Your shopping list is empty');
      return;
    }

    String listText = 'Your shopping list has: ';
    for (int i = 0; i < _items.length; i++) {
      if (!_items[i]['completed']) {
        listText += _items[i]['name'];
        if (i < _items.length - 1) {
          listText += ', ';
        }
      }
    }
    
    await _voiceService.speak(listText);
  }
}

import 'package:flutter/material.dart';
import '../../services/shopping_list_service.dart';
import '../../models/user_models.dart';

class CaregiverLists extends StatefulWidget {
  const CaregiverLists({super.key});

  @override
  State<CaregiverLists> createState() => _CaregiverListsState();
}

class _CaregiverListsState extends State<CaregiverLists> {
  final ShoppingListService _listService = ShoppingListService();
  List<ShoppingList> _lists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  void _loadLists() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading lists
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _lists = [
          ShoppingList(
            id: '1',
            name: 'Mom\'s Grocery List',
            items: [
              ShoppingListItem(
                id: '1',
                name: 'Milk',
                isCompleted: false,
                category: 'Dairy',
                addedBy: 'mom@example.com',
                dateAdded: DateTime.now().subtract(const Duration(hours: 1)),
              ),
              ShoppingListItem(
                id: '2',
                name: 'Bread',
                isCompleted: true,
                category: 'Bakery',
                addedBy: 'mom@example.com',
                dateAdded: DateTime.now().subtract(const Duration(hours: 2)),
              ),
              ShoppingListItem(
                id: '3',
                name: 'Eggs',
                isCompleted: false,
                category: 'Dairy',
                addedBy: 'mom@example.com',
                dateAdded: DateTime.now().subtract(const Duration(minutes: 30)),
              ),
            ],
            createdBy: 'mom@example.com',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          ShoppingList(
            id: '2',
            name: 'Dad\'s Weekly Shopping',
            items: [
              ShoppingListItem(
                id: '4',
                name: 'Coffee',
                isCompleted: false,
                category: 'Beverages',
                addedBy: 'dad@example.com',
                dateAdded: DateTime.now().subtract(const Duration(hours: 12)),
              ),
              ShoppingListItem(
                id: '5',
                name: 'Newspaper',
                isCompleted: true,
                category: 'Other',
                addedBy: 'dad@example.com',
                dateAdded: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ],
            createdBy: 'dad@example.com',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          ShoppingList(
            id: '3',
            name: 'Emergency Supplies',
            items: [
              ShoppingListItem(
                id: '6',
                name: 'First Aid Kit',
                isCompleted: false,
                category: 'Health',
                addedBy: 'caregiver@example.com',
                dateAdded: DateTime.now().subtract(const Duration(days: 2)),
              ),
              ShoppingListItem(
                id: '7',
                name: 'Flashlight',
                isCompleted: false,
                category: 'Other',
                addedBy: 'caregiver@example.com',
                dateAdded: DateTime.now().subtract(const Duration(days: 2)),
              ),
              ShoppingListItem(
                id: '8',
                name: 'Batteries',
                isCompleted: true,
                category: 'Other',
                addedBy: 'caregiver@example.com',
                dateAdded: DateTime.now().subtract(const Duration(days: 3)),
              ),
            ],
            createdBy: 'caregiver@example.com',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ];
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter and Search
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search lists...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      // Implement search functionality
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Lists Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Family Shopping Lists',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_lists.length} lists',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Lists Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _lists.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _lists.length,
                        itemBuilder: (context, index) {
                          return _buildListCard(_lists[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(ShoppingList list) {
    final completedItems = list.items.where((item) => item.isCompleted).length;
    final totalItems = list.items.length;
    final progress = totalItems > 0 ? completedItems / totalItems : 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created by ${_getCreatorName(list.createdBy)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              _buildListMenu(list),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '$completedItems/$totalItems items',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress == 1.0 ? Colors.green : const Color(0xFF2196F3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Recent Items Preview
          if (list.items.isNotEmpty) ...[
            Text(
              'Recent Items:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: list.items.take(3).map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: item.isCompleted
                          ? Colors.green.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 16,
                        color: item.isCompleted
                            ? Colors.green
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: item.isCompleted
                              ? Colors.green[700]
                              : Colors.grey[700],
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (list.items.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${list.items.length - 3} more items',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _viewList(list),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareList(list),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListMenu(ShoppingList list) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _editList(list);
            break;
          case 'duplicate':
            _duplicateList(list);
            break;
          case 'delete':
            _deleteList(list);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              Icon(Icons.copy, size: 18),
              SizedBox(width: 8),
              Text('Duplicate'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No shopping lists yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first list to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _getCreatorName(String email) {
    if (email.contains('mom')) return 'Mom';
    if (email.contains('dad')) return 'Dad';
    if (email.contains('caregiver')) return 'You';
    return email.split('@').first;
  }

  void _viewList(ShoppingList list) {
    // Navigate to list detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${list.name}')),
    );
  }

  void _shareList(ShoppingList list) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Share ${list.name}'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'The person will receive an invitation to view and edit this list.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invitation sent!')),
                );
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _editList(ShoppingList list) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${list.name} feature coming soon!')),
    );
  }

  void _duplicateList(ShoppingList list) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Duplicated ${list.name}')),
    );
  }

  void _deleteList(ShoppingList list) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete List'),
          content: Text('Are you sure you want to delete "${list.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _lists.removeWhere((l) => l.id == list.id);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted ${list.name}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/user_models.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';

class FamilyMemberCard extends StatelessWidget {
  final AppUser member;
  final VoidCallback? onTap;
  final VoidCallback? onReminder;

  const FamilyMemberCard({
    super.key,
    required this.member,
    this.onTap,
    this.onReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: member.role == UserRole.elderly 
                    ? Colors.orange.shade100 
                    : Colors.blue.shade100,
                child: Icon(
                  member.role == UserRole.elderly 
                      ? Icons.elderly 
                      : Icons.person,
                  size: 30,
                  color: member.role == UserRole.elderly 
                      ? Colors.orange.shade700 
                      : Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 16),
              
              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: member.role == UserRole.elderly 
                            ? Colors.orange.shade50 
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: member.role == UserRole.elderly 
                              ? Colors.orange.shade200 
                              : Colors.blue.shade200,
                        ),
                      ),
                      child: Text(
                        member.role == UserRole.elderly ? 'Senior' : 'Caregiver',
                        style: TextStyle(
                          fontSize: 12,
                          color: member.role == UserRole.elderly 
                              ? Colors.orange.shade700 
                              : Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                children: [
                  IconButton(
                    onPressed: onReminder,
                    icon: const Icon(Icons.notifications),
                    color: Colors.orange.shade600,
                    tooltip: 'Set Reminder',
                  ),
                  IconButton(
                    onPressed: onTap,
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.blue.shade600,
                    tooltip: 'View Lists',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddFamilyMemberDialog extends StatefulWidget {
  const AddFamilyMemberDialog({super.key});

  @override
  State<AddFamilyMemberDialog> createState() => _AddFamilyMemberDialogState();
}

class _AddFamilyMemberDialogState extends State<AddFamilyMemberDialog> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  UserRole _selectedRole = UserRole.elderly;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Family Member'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: UserRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role == UserRole.elderly ? 'Senior' : 'Caregiver'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addMember,
          child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _addMember() async {
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In demo mode, just show success
      await Future.delayed(const Duration(seconds: 1));
      
      Navigator.of(context).pop({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole,
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitation sent to ${_emailController.text.trim()}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding family member: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

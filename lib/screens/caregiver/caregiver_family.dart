import 'package:flutter/material.dart';
import '../../models/user_models.dart';

class CaregiverFamily extends StatefulWidget {
  const CaregiverFamily({super.key});

  @override
  State<CaregiverFamily> createState() => _CaregiverFamilyState();
}

class _CaregiverFamilyState extends State<CaregiverFamily> {
  List<AppUser> _familyMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFamilyMembers();
  }

  void _loadFamilyMembers() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading family members
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _familyMembers = [
          AppUser(
            id: '1',
            name: 'Mom',
            email: 'mom@example.com',
            role: UserRole.elderly,
            preferredLanguage: Language.english,
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          AppUser(
            id: '2',
            name: 'Dad',
            email: 'dad@example.com',
            role: UserRole.elderly,
            preferredLanguage: Language.english,
            createdAt: DateTime.now().subtract(const Duration(days: 25)),
          ),
          AppUser(
            id: '3',
            name: 'Grandma',
            email: 'grandma@example.com',
            role: UserRole.elderly,
            preferredLanguage: Language.spanish,
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Family Members',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _inviteFamilyMember,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('Invite'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Family Members List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _familyMembers.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _familyMembers.length,
                        itemBuilder: (context, index) {
                          return _buildFamilyMemberCard(_familyMembers[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(AppUser member) {
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
        children: [
          // Member Header
          Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    member.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: member.role == UserRole.elderly
                                ? Colors.purple.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            member.role == UserRole.elderly ? 'Elder' : 'Caregiver',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: member.role == UserRole.elderly
                                  ? Colors.purple[700]
                                  : Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getLanguageName(member.preferredLanguage),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Member Menu
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      _viewMemberDetails(member);
                      break;
                    case 'edit':
                      _editMember(member);
                      break;
                    case 'remove':
                      _removeMember(member);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 18),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
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
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.remove_circle, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Remove', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Member Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Active Lists', '2', Icons.list_alt),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Items Added', '15', Icons.add_circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Last Active', '2h ago', Icons.access_time),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _sendMessage(member),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2196F3),
                    side: const BorderSide(color: Color(0xFF2196F3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.message, size: 18),
                  label: const Text('Message'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareListWithMember(member),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share List'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF2196F3),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No family members yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Invite family members to start sharing lists',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _inviteFamilyMember,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            icon: const Icon(Icons.person_add),
            label: const Text('Invite Family Member'),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(Language language) {
    switch (language) {
      case Language.english:
        return 'English';
      case Language.spanish:
        return 'Spanish';
      case Language.french:
        return 'French';
      case Language.german:
        return 'German';
      case Language.chinese:
        return 'Chinese';
      case Language.arabic:
        return 'Arabic';
      case Language.hindi:
        return 'Hindi';
    }
  }

  void _inviteFamilyMember() {
    showDialog(
      context: context,
      builder: (context) {
        String email = '';
        String name = '';
        return AlertDialog(
          title: const Text('Invite Family Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) => email = value,
              ),
              const SizedBox(height: 16),
              const Text(
                'They will receive an invitation to join your family group.',
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
                if (email.isNotEmpty && name.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invitation sent to $name')),
                  );
                }
              },
              child: const Text('Send Invitation'),
            ),
          ],
        );
      },
    );
  }

  void _viewMemberDetails(AppUser member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${member.name} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Email', member.email),
              _buildDetailRow('Role', member.role == UserRole.elderly ? 'Elder' : 'Caregiver'),
              _buildDetailRow('Language', _getLanguageName(member.preferredLanguage)),
              _buildDetailRow('Member Since', _formatDate(member.createdAt)),
              _buildDetailRow('Shared Lists', member.sharedLists.length.toString()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  void _editMember(AppUser member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${member.name} feature coming soon!')),
    );
  }

  void _removeMember(AppUser member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Family Member'),
          content: Text('Are you sure you want to remove ${member.name} from your family group?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _familyMembers.removeWhere((m) => m.id == member.id);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Removed ${member.name} from family')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage(AppUser member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message ${member.name} feature coming soon!')),
    );
  }

  void _shareListWithMember(AppUser member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Share List with ${member.name}'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select a list to share:'),
              SizedBox(height: 16),
              // Add list selection widget here
              Text('• Mom\'s Grocery List'),
              Text('• Dad\'s Weekly Shopping'),
              Text('• Emergency Supplies'),
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
                  SnackBar(content: Text('List shared with ${member.name}')),
                );
              },
              child: const Text('Share'),
            ),
          ],
        );
      },
    );
  }
}

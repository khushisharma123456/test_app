import 'package:flutter/material.dart';
import '../../models/user_models.dart';
import '../../services/care_relationship_service.dart';
import 'caregiver_requests_screen.dart';

class MyEldersScreen extends StatefulWidget {
  final String caregiverId;

  const MyEldersScreen({
    super.key,
    required this.caregiverId,
  });

  @override
  State<MyEldersScreen> createState() => _MyEldersScreenState();
}

class _MyEldersScreenState extends State<MyEldersScreen> {
  List<AppUser> _elders = [];
  List<CareRelationship> _pendingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() => _isLoading = true);
    
    try {
      _elders = CareRelationshipService.getEldersForCaregiver(widget.caregiverId);
      _pendingRequests = CareRelationshipService.getPendingRequestsForCaregiver(widget.caregiverId);
    } catch (e) {
      debugPrint('Error loading elders: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeElderRelationship(String elderId) async {
    final relationships = CareRelationshipService.getAcceptedRelationships(widget.caregiverId);
    final relationship = relationships.firstWhere(
      (rel) => rel.elderId == elderId && rel.caregiverId == widget.caregiverId,
    );

    try {
      await CareRelationshipService.removeRelationship(relationship.id);
      _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Care relationship ended successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to end relationship: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRemoveDialog(AppUser elder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Care Relationship'),
        content: Text('Are you sure you want to end your care relationship with ${elder.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeElderRelationship(elder.id);
            },
            child: const Text(
              'End Relationship',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showElderDetails(AppUser elder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(elder.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.email, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(elder.email)),
              ],
            ),
            if (elder.phoneNumber != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(elder.phoneNumber!)),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text('Member since ${_formatDate(elder.createdAt)}')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'My Elders',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Notification badge for pending requests
          if (_pendingRequests.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaregiverRequestsScreen(
                          caregiverId: widget.caregiverId,
                        ),
                      ),
                    );
                    _loadData(); // Refresh data when returning
                  },
                  icon: const Icon(Icons.notifications),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_pendingRequests.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )
          else
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaregiverRequestsScreen(
                      caregiverId: widget.caregiverId,
                    ),
                  ),
                );
                _loadData(); // Refresh data when returning
              },
              icon: const Icon(Icons.notifications_none),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2196F3),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pending requests notification
                  if (_pendingRequests.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You have ${_pendingRequests.length} pending care request${_pendingRequests.length == 1 ? '' : 's'}',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CaregiverRequestsScreen(
                                    caregiverId: widget.caregiverId,
                                  ),
                                ),
                              );
                              _loadData();
                            },
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Connected Elders Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Under My Care',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_elders.length} Elder${_elders.length == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Elders List
                  if (_elders.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.elderly,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No elders under your care yet',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Elders will appear here when they add you as their caregiver',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(_elders.length, (index) {
                      final elder = _elders[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xFF2196F3),
                                child: Text(
                                  elder.name.isNotEmpty
                                      ? elder.name[0].toUpperCase()
                                      : 'E',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      elder.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      elder.email,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (elder.phoneNumber != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        elder.phoneNumber!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Actions
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'details') {
                                    _showElderDetails(elder);
                                  } else if (value == 'remove') {
                                    _showRemoveDialog(elder);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'details',
                                    child: Row(
                                      children: [
                                        Icon(Icons.info, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('View Details'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'remove',
                                    child: Row(
                                      children: [
                                        Icon(Icons.remove_circle, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('End Care'),
                                      ],
                                    ),
                                  ),
                                ],
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

import 'package:flutter/material.dart';
import '../../models/user_models.dart';
import '../../services/care_relationship_service.dart';
import 'add_caregiver_screen.dart';

class MyCaregiverScreen extends StatefulWidget {
  final String elderId;

  const MyCaregiverScreen({
    super.key,
    required this.elderId,
  });

  @override
  State<MyCaregiverScreen> createState() => _MyCaregiverScreenState();
}

class _MyCaregiverScreenState extends State<MyCaregiverScreen> {
  List<AppUser> _caregivers = [];
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
      _caregivers = CareRelationshipService.getCaregiversForElder(widget.elderId);
      _pendingRequests = CareRelationshipService.getPendingRequestsFromElder(widget.elderId);
    } catch (e) {
      debugPrint('Error loading caregivers: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeCaregiverRelationship(String caregiverId) async {
    final relationships = CareRelationshipService.getAcceptedRelationships(widget.elderId);
    final relationship = relationships.firstWhere(
      (rel) => rel.caregiverId == caregiverId && rel.elderId == widget.elderId,
    );

    try {
      await CareRelationshipService.removeRelationship(relationship.id);
      _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Caregiver removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove caregiver: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRemoveDialog(AppUser caregiver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Caregiver'),
        content: Text('Are you sure you want to remove ${caregiver.name} as your caregiver?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeCaregiverRelationship(caregiver.id);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
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
          'My Caregivers',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4CAF50),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Connected Caregivers',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCaregiverScreen(
                                elderId: widget.elderId,
                              ),
                            ),
                          );
                          _loadData(); // Refresh data when returning
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Connected Caregivers
                  if (_caregivers.isEmpty)
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
                            Icons.person_add,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No caregivers connected yet',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap "Add" to connect with your caregivers',
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
                    ...List.generate(_caregivers.length, (index) {
                      final caregiver = _caregivers[index];
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
                                backgroundColor: const Color(0xFF4CAF50),
                                child: Text(
                                  caregiver.name.isNotEmpty
                                      ? caregiver.name[0].toUpperCase()
                                      : 'C',
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
                                      caregiver.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      caregiver.email,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (caregiver.phoneNumber != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        caregiver.phoneNumber!,
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
                                  if (value == 'remove') {
                                    _showRemoveDialog(caregiver);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'remove',
                                    child: Row(
                                      children: [
                                        Icon(Icons.remove_circle, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Remove'),
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

                  // Pending Requests Section
                  if (_pendingRequests.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    const Text(
                      'Pending Requests',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(_pendingRequests.length, (index) {
                      final request = _pendingRequests[index];
                      final caregiver = CareRelationshipService.getUserById(request.caregiverId);
                      
                      if (caregiver == null) return const SizedBox.shrink();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.orange[300],
                                child: Text(
                                  caregiver.name.isNotEmpty
                                      ? caregiver.name[0].toUpperCase()
                                      : 'C',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
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
                                      caregiver.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Request sent • Waiting for response',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Status indicator
                              Icon(
                                Icons.access_time,
                                color: Colors.orange[600],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
    );
  }
}

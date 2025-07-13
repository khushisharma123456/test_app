import '../models/user_models.dart';

class CareRelationshipService {
  // In a real app, this would connect to a database
  // For now, we'll use in-memory storage
  static final List<CareRelationship> _relationships = [];
  static final List<AppUser> _users = [];

  // Initialize with some sample users for testing
  static void initializeSampleData() {
    if (_users.isEmpty) {
      _users.addAll([
        AppUser(
          id: 'elder1',
          name: 'John Smith',
          email: 'john.smith@email.com',
          role: UserRole.elderly,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          phoneNumber: '+1234567890',
        ),
        AppUser(
          id: 'elder2',
          name: 'Mary Johnson',
          email: 'mary.johnson@email.com',
          role: UserRole.elderly,
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
          phoneNumber: '+1234567891',
        ),
        AppUser(
          id: 'caregiver1',
          name: 'Sarah Williams',
          email: 'sarah.williams@email.com',
          role: UserRole.caregiver,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          phoneNumber: '+1234567892',
        ),
        AppUser(
          id: 'caregiver2',
          name: 'Michael Brown',
          email: 'michael.brown@email.com',
          role: UserRole.caregiver,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          phoneNumber: '+1234567893',
        ),
      ]);
    }
  }

  // Get all users
  static List<AppUser> getAllUsers() {
    initializeSampleData();
    return _users;
  }

  // Get user by ID
  static AppUser? getUserById(String userId) {
    initializeSampleData();
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Get all caregivers
  static List<AppUser> getAllCaregivers() {
    initializeSampleData();
    return _users.where((user) => user.role == UserRole.caregiver).toList();
  }

  // Get all elders
  static List<AppUser> getAllElders() {
    initializeSampleData();
    return _users.where((user) => user.role == UserRole.elderly).toList();
  }

  // Search caregivers by name or email
  static List<AppUser> searchCaregivers(String query) {
    if (query.isEmpty) return getAllCaregivers();
    
    return getAllCaregivers()
        .where((caregiver) =>
            caregiver.name.toLowerCase().contains(query.toLowerCase()) ||
            caregiver.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Create a relationship request
  static Future<CareRelationship> createRelationshipRequest({
    required String elderId,
    required String caregiverId,
    String relationshipType = 'caregiver',
  }) async {
    final relationship = CareRelationship(
      id: 'rel_${DateTime.now().millisecondsSinceEpoch}',
      elderId: elderId,
      caregiverId: caregiverId,
      status: RelationshipStatus.pending,
      createdAt: DateTime.now(),
      relationshipType: relationshipType,
    );

    _relationships.add(relationship);
    return relationship;
  }

  // Accept a relationship request
  static Future<CareRelationship> acceptRelationshipRequest(String relationshipId) async {
    final index = _relationships.indexWhere((rel) => rel.id == relationshipId);
    if (index == -1) {
      throw Exception('Relationship not found');
    }

    final updatedRelationship = _relationships[index].copyWith(
      status: RelationshipStatus.accepted,
      acceptedAt: DateTime.now(),
    );

    _relationships[index] = updatedRelationship;

    // Update user relationships
    final elderIndex = _users.indexWhere((user) => user.id == updatedRelationship.elderId);
    final caregiverIndex = _users.indexWhere((user) => user.id == updatedRelationship.caregiverId);

    if (elderIndex != -1) {
      final elder = _users[elderIndex];
      final updatedCaregiverIds = List<String>.from(elder.caregiverIds);
      if (!updatedCaregiverIds.contains(updatedRelationship.caregiverId)) {
        updatedCaregiverIds.add(updatedRelationship.caregiverId);
      }
      _users[elderIndex] = elder.copyWith(caregiverIds: updatedCaregiverIds);
    }

    if (caregiverIndex != -1) {
      final caregiver = _users[caregiverIndex];
      final updatedElderIds = List<String>.from(caregiver.elderIds);
      if (!updatedElderIds.contains(updatedRelationship.elderId)) {
        updatedElderIds.add(updatedRelationship.elderId);
      }
      _users[caregiverIndex] = caregiver.copyWith(elderIds: updatedElderIds);
    }

    return updatedRelationship;
  }

  // Decline a relationship request
  static Future<CareRelationship> declineRelationshipRequest(String relationshipId) async {
    final index = _relationships.indexWhere((rel) => rel.id == relationshipId);
    if (index == -1) {
      throw Exception('Relationship not found');
    }

    final updatedRelationship = _relationships[index].copyWith(
      status: RelationshipStatus.declined,
    );

    _relationships[index] = updatedRelationship;
    return updatedRelationship;
  }

  // Get relationships for a user
  static List<CareRelationship> getRelationshipsForUser(String userId) {
    return _relationships
        .where((rel) => rel.elderId == userId || rel.caregiverId == userId)
        .toList();
  }

  // Get pending relationship requests for a caregiver
  static List<CareRelationship> getPendingRequestsForCaregiver(String caregiverId) {
    return _relationships
        .where((rel) => 
            rel.caregiverId == caregiverId && 
            rel.status == RelationshipStatus.pending)
        .toList();
  }

  // Get pending relationship requests sent by an elder
  static List<CareRelationship> getPendingRequestsFromElder(String elderId) {
    return _relationships
        .where((rel) => 
            rel.elderId == elderId && 
            rel.status == RelationshipStatus.pending)
        .toList();
  }

  // Get accepted relationships for a user
  static List<CareRelationship> getAcceptedRelationships(String userId) {
    return _relationships
        .where((rel) => 
            (rel.elderId == userId || rel.caregiverId == userId) && 
            rel.status == RelationshipStatus.accepted)
        .toList();
  }

  // Get caregivers for an elder
  static List<AppUser> getCaregiversForElder(String elderId) {
    final acceptedRelationships = getAcceptedRelationships(elderId)
        .where((rel) => rel.elderId == elderId)
        .toList();
    
    return acceptedRelationships
        .map((rel) => getUserById(rel.caregiverId))
        .where((user) => user != null)
        .cast<AppUser>()
        .toList();
  }

  // Get elders for a caregiver
  static List<AppUser> getEldersForCaregiver(String caregiverId) {
    final acceptedRelationships = getAcceptedRelationships(caregiverId)
        .where((rel) => rel.caregiverId == caregiverId)
        .toList();
    
    return acceptedRelationships
        .map((rel) => getUserById(rel.elderId))
        .where((user) => user != null)
        .cast<AppUser>()
        .toList();
  }

  // Remove a relationship
  static Future<void> removeRelationship(String relationshipId) async {
    final index = _relationships.indexWhere((rel) => rel.id == relationshipId);
    if (index == -1) {
      throw Exception('Relationship not found');
    }

    final relationship = _relationships[index];
    _relationships.removeAt(index);

    // Update user relationships
    final elderIndex = _users.indexWhere((user) => user.id == relationship.elderId);
    final caregiverIndex = _users.indexWhere((user) => user.id == relationship.caregiverId);

    if (elderIndex != -1) {
      final elder = _users[elderIndex];
      final updatedCaregiverIds = List<String>.from(elder.caregiverIds);
      updatedCaregiverIds.remove(relationship.caregiverId);
      _users[elderIndex] = elder.copyWith(caregiverIds: updatedCaregiverIds);
    }

    if (caregiverIndex != -1) {
      final caregiver = _users[caregiverIndex];
      final updatedElderIds = List<String>.from(caregiver.elderIds);
      updatedElderIds.remove(relationship.elderId);
      _users[caregiverIndex] = caregiver.copyWith(elderIds: updatedElderIds);
    }
  }
}

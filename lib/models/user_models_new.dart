enum UserRole { elderly, caregiver }

enum Language { english, spanish, hindi, french, german, chinese, arabic }

// Relationship status between elderly and caregiver
enum RelationshipStatus { pending, accepted, declined }

// Relationship model to manage elder-caregiver connections
class CareRelationship {
  final String id;
  final String elderId;
  final String caregiverId;
  final RelationshipStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final String relationshipType; // e.g., "family", "professional", "friend"

  CareRelationship({
    required this.id,
    required this.elderId,
    required this.caregiverId,
    this.status = RelationshipStatus.pending,
    required this.createdAt,
    this.acceptedAt,
    this.relationshipType = "caregiver",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'elderId': elderId,
      'caregiverId': caregiverId,
      'status': status.toString(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'acceptedAt': acceptedAt?.millisecondsSinceEpoch,
      'relationshipType': relationshipType,
    };
  }

  static CareRelationship fromMap(Map<String, dynamic> map) {
    return CareRelationship(
      id: map['id'] ?? '',
      elderId: map['elderId'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
      status: RelationshipStatus.values.firstWhere(
        (status) => status.toString() == map['status'],
        orElse: () => RelationshipStatus.pending,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      acceptedAt: map['acceptedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['acceptedAt'])
          : null,
      relationshipType: map['relationshipType'] ?? 'caregiver',
    );
  }

  CareRelationship copyWith({
    String? id,
    String? elderId,
    String? caregiverId,
    RelationshipStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    String? relationshipType,
  }) {
    return CareRelationship(
      id: id ?? this.id,
      elderId: elderId ?? this.elderId,
      caregiverId: caregiverId ?? this.caregiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      relationshipType: relationshipType ?? this.relationshipType,
    );
  }
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final Language preferredLanguage;
  final List<String> sharedLists;
  final DateTime createdAt;
  // New fields for relationships
  final List<String> caregiverIds; // For elderly users - their caregivers
  final List<String> elderIds; // For caregiver users - their elders
  final String? phoneNumber;
  final String? profileImageUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.preferredLanguage = Language.english,
    this.sharedLists = const [],
    required this.createdAt,
    this.caregiverIds = const [],
    this.elderIds = const [],
    this.phoneNumber,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString(),
      'preferredLanguage': preferredLanguage.toString(),
      'sharedLists': sharedLists,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'caregiverIds': caregiverIds,
      'elderIds': elderIds,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
    };
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.toString() == map['role'],
        orElse: () => UserRole.elderly,
      ),
      preferredLanguage: Language.values.firstWhere(
        (lang) => lang.toString() == map['preferredLanguage'],
        orElse: () => Language.english,
      ),
      sharedLists: List<String>.from(map['sharedLists'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      caregiverIds: List<String>.from(map['caregiverIds'] ?? []),
      elderIds: List<String>.from(map['elderIds'] ?? []),
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
    );
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    Language? preferredLanguage,
    List<String>? sharedLists,
    DateTime? createdAt,
    List<String>? caregiverIds,
    List<String>? elderIds,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      sharedLists: sharedLists ?? this.sharedLists,
      createdAt: createdAt ?? this.createdAt,
      caregiverIds: caregiverIds ?? this.caregiverIds,
      elderIds: elderIds ?? this.elderIds,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

class ShoppingListItem {
  final String id;
  final String name;
  final String category;
  final bool isCompleted;
  final String addedBy;
  final DateTime dateAdded;
  final String? translatedName;
  final String? notes;

  ShoppingListItem({
    required this.id,
    required this.name,
    required this.category,
    this.isCompleted = false,
    required this.addedBy,
    required this.dateAdded,
    this.translatedName,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'isCompleted': isCompleted,
      'addedBy': addedBy,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
      'translatedName': translatedName,
      'notes': notes,
    };
  }

  static ShoppingListItem fromMap(Map<String, dynamic> map) {
    return ShoppingListItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      addedBy: map['addedBy'] ?? '',
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded'] ?? 0),
      translatedName: map['translatedName'],
      notes: map['notes'],
    );
  }

  ShoppingListItem copyWith({
    String? id,
    String? name,
    String? category,
    bool? isCompleted,
    String? addedBy,
    DateTime? dateAdded,
    String? translatedName,
    String? notes,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      addedBy: addedBy ?? this.addedBy,
      dateAdded: dateAdded ?? this.dateAdded,
      translatedName: translatedName ?? this.translatedName,
      notes: notes ?? this.notes,
    );
  }
}

class ShoppingList {
  final String id;
  final String name;
  final String createdBy;
  final List<String> sharedWith;
  final List<ShoppingListItem> items;
  final DateTime createdAt;
  final DateTime? reminderTime;
  final bool isActive;

  ShoppingList({
    required this.id,
    required this.name,
    required this.createdBy,
    this.sharedWith = const [],
    this.items = const [],
    required this.createdAt,
    this.reminderTime,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdBy': createdBy,
      'sharedWith': sharedWith,
      'items': items.map((item) => item.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'reminderTime': reminderTime?.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  ShoppingList copyWith({
    String? id,
    String? name,
    String? createdBy,
    List<String>? sharedWith,
    List<ShoppingListItem>? items,
    DateTime? createdAt,
    DateTime? reminderTime,
    bool? isActive,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      sharedWith: sharedWith ?? this.sharedWith,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      reminderTime: reminderTime ?? this.reminderTime,
      isActive: isActive ?? this.isActive,
    );
  }

  static ShoppingList fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      createdBy: map['createdBy'] ?? '',
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      items: (map['items'] as List? ?? [])
          .map((item) => ShoppingListItem.fromMap(item))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      reminderTime: map['reminderTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reminderTime'])
          : null,
      isActive: map['isActive'] ?? true,
    );
  }
}

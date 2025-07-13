enum RelationshipStatus { pending, accepted, declined }

class CareRelationship {
  final String id;
  final String elderId;
  final String caregiverId;
  final RelationshipStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? declinedAt;
  final String? notes;

  CareRelationship({
    required this.id,
    required this.elderId,
    required this.caregiverId,
    required this.status,
    DateTime? createdAt,
    this.acceptedAt,
    this.declinedAt,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  CareRelationship copyWith({
    String? id,
    String? elderId,
    String? caregiverId,
    RelationshipStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? declinedAt,
    String? notes,
  }) {
    return CareRelationship(
      id: id ?? this.id,
      elderId: elderId ?? this.elderId,
      caregiverId: caregiverId ?? this.caregiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      declinedAt: declinedAt ?? this.declinedAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'elderId': elderId,
      'caregiverId': caregiverId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'declinedAt': declinedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory CareRelationship.fromJson(Map<String, dynamic> json) {
    return CareRelationship(
      id: json['id'],
      elderId: json['elderId'],
      caregiverId: json['caregiverId'],
      status: RelationshipStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
      declinedAt: json['declinedAt'] != null ? DateTime.parse(json['declinedAt']) : null,
      notes: json['notes'],
    );
  }
}

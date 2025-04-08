class Slot {
  final String id;
  final String? kafeType;
  final DateTime? plantedAt;
  final bool harvested;

  Slot({
    required this.id,
    this.kafeType,
    this.plantedAt,
    this.harvested = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kafeType': kafeType,
      'plantedAt': plantedAt?.toIso8601String(),
      'harvested': harvested,
    };
  }

  factory Slot.fromMap(Map<String, dynamic> map) {
    return Slot(
      id: map['id'],
      kafeType: map['kafeType'],
      plantedAt: map['plantedAt'] != null ? DateTime.parse(map['plantedAt']) : null,
      harvested: map['harvested'] ?? false,
    );
  }
}

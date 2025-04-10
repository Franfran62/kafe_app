import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/game/game_config.dart';

class Slot {
  final String id;
  final String? kafeType;
  final DateTime? plantedAt;

  Slot({
    required this.id,
    this.kafeType,
    this.plantedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kafeType': kafeType,
      'plantedAt': plantedAt?.toIso8601String(),
    };
  }

  factory Slot.fromMap(Map<String, dynamic> map) {
    return Slot(
      id: map['id'],
      kafeType: map['kafeType'],
      plantedAt: map['plantedAt'] != null ? DateTime.parse(map['plantedAt']) : null,
    );
  }

  Slot copyWith({
    String? id,
    String? kafeType,
    bool clearKafeType = false,
    DateTime? plantedAt,
    bool clearPlantedAt = false,
  }) {
    return Slot(
      id: id ?? this.id,
      kafeType: clearKafeType ? null : kafeType ?? this.kafeType,
      plantedAt: clearPlantedAt ? null : plantedAt ?? this.plantedAt,
    );
  }

  @override
  String toString() {
    return 'Slot(id: $id, kafeType: $kafeType, plantedAt: $plantedAt)';
  }
}

extension SlotExtension on Slot {
  bool get isPlanted => kafeType != null && plantedAt != null;

  Duration growthTime(FieldSpecialty specialty) {
    final baseTime = GameConfig.growthTimeFor(kafeType!);
    return baseTime * specialty.growthFactor;
  }

  DateTime? readyAt(FieldSpecialty specialty) {
    if (!isPlanted) return null;
    return plantedAt!.add(growthTime(specialty));
  }

  bool isReady(FieldSpecialty specialty) {
    final date = readyAt(specialty);
    return date != null && DateTime.now().isAfter(date);
  }

  Duration? timeRemaining(FieldSpecialty specialty) {
    final date = readyAt(specialty);
    if (date == null) return null;
    return date.difference(DateTime.now());
  }
}

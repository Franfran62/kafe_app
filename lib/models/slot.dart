import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/game/game_config.dart';

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

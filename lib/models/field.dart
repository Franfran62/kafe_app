import 'package:kafe_app/models/enums/specialty.dart';
import 'slot.dart';

class Field {
  final String id;
  final String playerId;
  final Specialty specialty;
  final List<Slot> slots;

  Field({
    required this.id,
    required this.playerId,
    required this.specialty,
    required this.slots,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerId': playerId,
      'specialty': specialty.toFirestore(),
      'slots': slots.map((s) => s.toMap()).toList(),
    };
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    return Field(
      id: map['id'],
      playerId: map['playerId'],
      specialty: SpecialtyExtension.fromString(map['specialty']),
      slots: (map['slots'] as List).map((s) => Slot.fromMap(s)).toList(),
    );
  }
}

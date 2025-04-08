import 'package:kafe_app/models/enums/field_specialty.dart';
import 'slot.dart';

class Field {
  final String id;
  final String name;
  final String playerId;
  final FieldSpecialty specialty;
  final List<Slot> slots;

  Field({
    required this.id,
    required this.name,
    required this.playerId,
    required this.specialty,
    required this.slots,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'playerId': playerId,
      'specialty': specialty.toFirestore(),
      'slots': slots.map((s) => s.toMap()).toList(),
    };
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    return Field(
      id: map['id'],
      name: map['name'],
      playerId: map['playerId'],
      specialty: FieldSpecialtyExtension.fromString(map['specialty']),
      slots: (map['slots'] as List).map((s) => Slot.fromMap(s)).toList(),
    );
  }
}

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import '../models/field.dart';
import '../models/slot.dart';

class FieldService {
  final _db = FirebaseFirestore.instance;

  Future<void> createInitialField(String playerId, String fieldName) async {
    final specialties = FieldSpecialty.values;
    final random = Random();
    final specialty = specialties[random.nextInt(specialties.length)];

    final doc = _db.collection('fields').doc();

    final slots = List.generate(4, (i) => Slot(id: '${doc.id}_$i'));

    final field = Field(
      id: doc.id,
      name: fieldName,
      playerId: playerId,
      specialty: specialty,
      slots: slots,
    );

    await doc.set(field.toMap());
  }


  Future<List<Field>> getFieldsByPlayer(String playerId) async {
  final snapshot = await _db
      .collection('fields')
      .where('playerId', isEqualTo: playerId)
      .get();

  return snapshot.docs
      .map((doc) => Field.fromMap(doc.data()))
      .toList();
}
}

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe_app/models/enums/specialty.dart';
import '../models/field.dart';
import '../models/slot.dart';

class FieldService {
  final _db = FirebaseFirestore.instance;

  Future<void> createInitialField(String playerId) async {
    final specialties = Specialty.values;
    final random = Random();
    final specialty = specialties[random.nextInt(specialties.length)];

    final doc = _db.collection('fields').doc();

    final slots = List.generate(4, (i) => Slot(id: '${doc.id}_$i'));

    final field = Field(
      id: doc.id,
      playerId: playerId,
      specialty: specialty,
      slots: slots,
    );

    await doc.set(field.toMap());
  }
}

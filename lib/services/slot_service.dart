import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import '../models/field.dart';
import '../models/slot.dart';

class SlotService {

  final _db = FirebaseFirestore.instance;

  Future<void> updateSlot({required Field field, required int slotIndex, required KafeType kafeType}) async {
    final List<Slot> slots = field.slots;
    final updatedSlot = slots[slotIndex].copyWith(
      kafeType: kafeType.name,
      plantedAt: DateTime.now(),
    );

    final updatedSlots = [...slots];
    updatedSlots[slotIndex] = updatedSlot;

    await _db.collection('fields').doc(field.id).update({
      'slots': updatedSlots.map((slot) => slot.toMap()).toList(),
    });
  }

  Future<void> clearSlot(Field field, int slotIndex) async {
   final clearedSlot = field.slots[slotIndex].copyWith(
    clearKafeType: true,
    clearPlantedAt: true,
  );

    final updatedSlots = [...field.slots];
    updatedSlots[slotIndex] = clearedSlot;

    await _db.collection('fields').doc(field.id).update({
      'slots': updatedSlots.map((s) => s.toMap()).toList(),
    });
  }
}
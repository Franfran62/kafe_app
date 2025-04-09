import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe_app/models/blend.dart';

class BlendService {
  final _db = FirebaseFirestore.instance;

  Future<void> createBlend(Blend blend) async {
    await _db.collection("blends").add(blend.toMap());
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> createPlayer(Player player) async {
    await _db.collection('players').doc(player.uid).set(player.toMap());
  }

  Future<Player?> getPlayer(String uid) async {
    final doc = await _db.collection('players').doc(uid).get();
    if (doc.exists) {
      return Player.fromMap(doc.data()!);
    }
    return null;
  }
}

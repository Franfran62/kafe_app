import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class PlayerService {
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

  Future<void> updatePlayer(Player player) async {
    final data = <String, dynamic>{};
    if (player.name.isNotEmpty) data['name'] = player.name;
    if (player.firstname.isNotEmpty) data['firstname'] = player.firstname;
    if (player.email.isNotEmpty) data['email'] = player.email;
    if (player.deevee != data['deevee']) data['deevee'] = player.deevee;
    if (player.avatarUrl != null && player.avatarUrl != data['avatarUrl']) data['avatarUrl'] = player.avatarUrl;

    await _db.collection('players').doc(player.uid).update(data);
  }

  Future<void> updateAvatar(String uid, String avatarUrl) async {
    await _db.collection('players').doc(uid).update({'avatarUrl': avatarUrl});
  }

  Future<void> decrementDeevee(Player player, int amount) async {
    final updatedPlayer = player.copyWith(deevee: player.deevee - amount);
    await updatePlayer(updatedPlayer);
  }
}

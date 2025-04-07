import 'package:flutter/material.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/services/firestore_service.dart';

class PlayerProvider with ChangeNotifier {
  final _firestore = FirestoreService();

  Player? _player;
  Player? get player => _player;

  bool get isLoaded => _player != null;

  Future<void> loadPlayer(String uid) async {
    _player = await _firestore.getPlayer(uid);
    notifyListeners();
  }

  void clear() {
    _player = null;
    notifyListeners();
  }
}

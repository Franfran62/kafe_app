import 'package:flutter/material.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/services/player_service.dart';

class PlayerProvider with ChangeNotifier {
  final _playerService = PlayerService();

  Player? _player;
  Player? get player => _player;

  bool get isLoaded => _player != null;

  Future<void> loadPlayer(String uid) async {
    _player = await _playerService.getPlayer(uid);
    notifyListeners();
  }

  void clear() {
    _player = null;
    notifyListeners();
  }
}

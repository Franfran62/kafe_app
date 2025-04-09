import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/providers/user_provider.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/services/player_service.dart';
import 'package:kafe_app/services/stock_service.dart';
import 'package:kafe_app/services/user_service.dart';
import 'package:provider/provider.dart';

class AuthGameController {
  final UserService _userService = UserService();
  final PlayerService _playerService = PlayerService();
  final StockService _stockService = StockService();
  final FieldService _fieldService = FieldService();

  Future<bool> registerFlow({required BuildContext context, required String email, required String password, required String name, required String firstname, required String fieldName}) async {
    final uid = await _userService.createAccount(email, password);
    await _playerService.createPlayer(Player(
      uid: uid,
      name: name,
      firstname: firstname,
      email: email,
    ));
    await _stockService.initStock(uid);
    await _fieldService.createInitialField(uid, fieldName);
    return await loginFlow(context: context, email: email, password: password);
  }

  Future<bool> loginFlow({required BuildContext context, required String email, required String password}) async {
    await _userService.login(email, password);
    final uid = await _userService.getCurrentUserId();
    if (uid != null) {
      await Provider.of<PlayerProvider>(context, listen: false).loadPlayer(uid);
      return true;
    }
    return false;
  }

  Future<void> logout({required BuildContext context}) async {
    await _userService.logout();
    Provider.of<PlayerProvider>(context, listen: false).clear();
  }

  Future<void> updateProfileFlow({required BuildContext context, required String email, String? password, required String name, required String firstname}) async {
    
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final existingPlayer = playerProvider.player;
    if (existingPlayer == null) return;

    final updatedPlayer = existingPlayer.copyWith(
      name: name,
      firstname: firstname,
      email: email,
    );

    if (email != existingPlayer.email || (password != null && password.isNotEmpty)) {
      await _userService.updateCredentials(
        newEmail: email,
        newPassword: password,
      );
    }

    await _playerService.updatePlayer(updatedPlayer);
    await playerProvider.loadPlayer(existingPlayer.uid);
  }

  Future<void> updateAvatar({required BuildContext context, required File file}) async {
    final url = await _userService.uploadAvatar(file);
    if (url == null) return;
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final player = playerProvider.player;
    if (player == null) return;

    await _playerService.updateAvatar(player.uid, url);
    await playerProvider.loadPlayer(player.uid);
  }
}

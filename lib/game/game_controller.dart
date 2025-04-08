import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_config.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/providers/field_provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/services/player_service.dart';
import 'package:provider/provider.dart';

class GameController {
  final FieldService _fieldService = FieldService();
  final PlayerService _playerService = PlayerService();

  Future<void> purchaseField({required BuildContext context, required String fieldName}) async {
    final player = context.read<PlayerProvider>().player;
    if (player == null) {
      return;
    }
    if (player.deevee < GameConfig.fieldPurchaseCost) {
      return;
    }

    final specialty = FieldSpecialty.values[
      Random().nextInt(FieldSpecialty.values.length)
    ];

    await _playerService.decrementDeevee(player, GameConfig.fieldPurchaseCost);
    await _fieldService.createField(
      playerId: player.uid,
      fieldName: fieldName,
      slotsPerFields: GameConfig.slotsPerField,
      specialty: specialty,
    );
    await context.read<FieldProvider>().reloadFields(player.uid);
    await context.read<PlayerProvider>().loadPlayer(player.uid);
  }

  Future<void> plantAndRefresh({required BuildContext context, required String fieldId, required int slotIndex, required KafeType kafeType,
  }) async {
    final player = context.read<PlayerProvider>().player;
    if (player == null) {
      return;
    }

    final cost = GameConfig.costFor(kafeType);
    if (player.deevee < cost) {
      return;
    }

    await _playerService.decrementDeevee(player, cost);
    await _fieldService.updateSlot(
      fieldId: fieldId,
      slotIndex: slotIndex,
      kafeType: kafeType,
    );

    await context.read<FieldProvider>().reloadFields(player.uid);
    await context.read<PlayerProvider>().loadPlayer(player.uid);
  }
}

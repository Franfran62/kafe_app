import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_config.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/models/slot.dart';
import 'package:kafe_app/models/wrapper/harvest_result.dart';
import 'package:kafe_app/providers/field_provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/providers/stock_provider.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/services/player_service.dart';
import 'package:kafe_app/services/slot_service.dart';
import 'package:kafe_app/services/stock_service.dart';
import 'package:provider/provider.dart';

class GameController {

  final FieldService _fieldService = FieldService();
  final PlayerService _playerService = PlayerService();
  final SlotService _slotService = SlotService();
  final StockService _stockService = StockService();

  Future<void> purchaseField({required BuildContext context, required String fieldName}) async {

    final player = context.read<PlayerProvider>().player;
    final stock = context.read<StockProvider>().stock;
    if (stock == null || player == null || stock.deevee < GameConfig.fieldPurchaseCost) return;

    final specialty = FieldSpecialty.values[
      Random().nextInt(FieldSpecialty.values.length)
    ];

    await context.read<StockProvider>().decrementDeevee(player.uid, GameConfig.fieldPurchaseCost);
    await _fieldService.createField(
      playerId: player.uid,
      fieldName: fieldName,
      slotsPerFields: GameConfig.slotsPerField,
      specialty: specialty,
    );
    await context.read<FieldProvider>().reloadFields(player.uid);
    await context.read<PlayerProvider>().loadPlayer(player.uid);
  }

  Future<void> plantAndRefresh({required BuildContext context, required Field field, required int slotIndex, required KafeType kafeType,
  }) async {
    final player = context.read<PlayerProvider>().player;
    final stock = context.read<StockProvider>().stock;
    final cost = GameConfig.costFor(kafeType);
    if (stock == null || player == null || stock.deevee < cost) return;

    await context.read<StockProvider>().decrementDeevee(player.uid, GameConfig.fieldPurchaseCost);
    await _slotService.updateSlot(
      field: field,
      slotIndex: slotIndex,
      kafeType: kafeType,
    );

    await context.read<FieldProvider>().reloadFields(player.uid);
    await context.read<PlayerProvider>().loadPlayer(player.uid);
  }

  Future<HarvestResult?> harvestAndRefresh({required BuildContext context, required Field field, required int slotIndex}) async {
    final player = context.read<PlayerProvider>().player;
    if (player == null) return null;

    final slot = field.slots[slotIndex];
    if (!slot.isPlanted) return null;

    final growthDuration = slot.growthTime(field.specialty);
    final elapsed = DateTime.now().difference(slot.plantedAt!);
    final ratio = (elapsed.inSeconds - growthDuration.inSeconds) / growthDuration.inSeconds;
    print(ratio);
    double penalty;
    if (ratio <= 1.0) {
      penalty = 1.0;
    } else if (ratio <= 3.0) {
      penalty = GameConfig.harvestLowPenalty;
    } else if (ratio <= 5.0) {
      penalty = GameConfig.harvestMediumPenalty;
    } else {
      penalty = GameConfig.harvestHardPenalty;
    }

    final kafeType = KafeTypeExtension.fromString(slot.kafeType!);
    double weight = GameConfig.fruitWeight(kafeType) * penalty;
    if (field.specialty == FieldSpecialty.yieldDouble) {
      weight *= GameConfig.yieldMultiplier;
    }

    await _slotService.clearSlot(field, slotIndex);
    await _stockService.addFruit(player.uid, kafeType, weight);
    await context.read<FieldProvider>().reloadFields(player.uid);

    return HarvestResult(
      type: kafeType,
      weight: weight,
      penalty: penalty,
      timeRatio: ratio,
    );
  }
}

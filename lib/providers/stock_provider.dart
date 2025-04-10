import 'package:flutter/material.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/models/stock.dart';
import 'package:kafe_app/services/stock_service.dart';

class StockProvider extends ChangeNotifier {

  final StockService _stockService = StockService();

  Stock? _stock;
  Stock? get stock => _stock;

  Future<void> loadStock(String playerId) async {
    _stock = await _stockService.getStock(playerId);
    notifyListeners();
  }

  Future<void> decrementDeevee(String playerId, int amount) async {
    if (_stock == null) return;
    final newDeevee = _stock!.deevee - amount;
    _stock = _stock!.copyWith(deevee: newDeevee);
    await _stockService.updateDeevee(playerId, newDeevee);
    notifyListeners();

  }

  Future<void> incrementDeevee(String playerId, int amount) async {
    if (_stock == null) return;
    final newDeevee = _stock!.deevee + amount;
    _stock = _stock!.copyWith(deevee: newDeevee);
    await _stockService.updateDeevee(playerId, newDeevee);
    notifyListeners();
  }

  Future<void> addFruit(String playerId, KafeType type, double amount) async {
    await _stockService.addFruit(playerId, type, amount);
    await loadStock(playerId);
  }

  Future<void> removeFruit(String playerId, KafeType type, double amount) async {
    await _stockService.removeFruit(playerId, type, amount);
    await loadStock(playerId);
  }

  Future<void> addGrain(String playerId, KafeType type, double amount) async {
    await _stockService.addGrain(playerId, type, amount);
    await loadStock(playerId);
  }

  Future<void> removeGrain(String playerId, KafeType type, double amount) async {
    await _stockService.removeGrain(playerId, type, amount);
    await loadStock(playerId);
  }
}

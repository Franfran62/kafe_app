import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/models/stock.dart';

class StockService {
  final _db = FirebaseFirestore.instance;

  Future<void> initStock(String playerId) async {
    final initial = Stock(
      fruits: {},
      grains: {},
      deevee: 10,
      goldGrains: 0,
    );
    await _db.collection('stocks').doc(playerId).set(initial.toMap());
  }

  Future<Stock> getStock(String playerId) async {
    final doc = await _db.collection('stocks').doc(playerId).get();
    if (!doc.exists) {
      final stock = Stock(fruits: {}, grains: {}, deevee: 10, goldGrains: 0);
      await _db.collection('stocks').doc(playerId).set(stock.toMap());
      return stock;
    }
    return Stock.fromMap(doc.data()!);
  }

  Future<void> addFruit(String playerId, KafeType type, double amount) async {
    final docRef = _db.collection('stocks').doc(playerId);
    final doc = await docRef.get();

    Map<String, dynamic> fruits = {};
    if (doc.exists && doc.data()!.containsKey('fruits')) {
      fruits = Map<String, dynamic>.from(doc.data()!['fruits']);
    }

    final current = (fruits[type.name] as num?)?.toDouble() ?? 0.0;
    fruits[type.name] = current + amount;

    await docRef.set({'fruits': fruits}, SetOptions(merge: true));
  }

  Future<void> updateDeevee(String playerId, int newAmount) async {
    await _db.collection('stocks').doc(playerId).update({
      'deevee': newAmount,
    });
  }

  Future<void> removeFruit(String playerId, KafeType type, double amount) async {
    final docRef = _db.collection('stocks').doc(playerId);
    final doc = await docRef.get();
    final fruits = Map<String, dynamic>.from(doc.data()!["fruits"]);
    final current = (fruits[type.name] as num).toDouble();
    fruits[type.name] = (current - amount).clamp(0, double.infinity);

    await docRef.update({"fruits": fruits});
  }

  Future<void> addGrain(String playerId, KafeType type, double amount) async {
    final docRef = _db.collection('stocks').doc(playerId);
    final doc = await docRef.get();
    final grains = Map<String, dynamic>.from(doc.data()!["grains"]);
    final current = (grains[type.name] as num?)?.toDouble() ?? 0.0;
    grains[type.name] = current + amount;

    await docRef.set({"grains": grains}, SetOptions(merge: true));
  }
}

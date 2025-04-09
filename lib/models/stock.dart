import 'package:kafe_app/models/enums/kafe_type.dart';

class Stock {
  final Map<KafeType, double> fruits;
  final Map<KafeType, double> grains;
  final int deevee;
  final int goldGrains;

  Stock({
    required this.fruits,
    required this.grains,
    required this.deevee,
    required this.goldGrains,
  });

  Map<String, dynamic> toMap() {
    return {
      'fruits': fruits.map((k, v) => MapEntry(k.name, v)),
      'grains': grains.map((k, v) => MapEntry(k.name, v)),
      'deevee': deevee,
      'goldGrains': goldGrains,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      fruits: (map['fruits'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(KafeTypeExtension.fromString(k), (v as num).toDouble()),
      ),
      grains: (map['grains'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(KafeTypeExtension.fromString(k), (v as num).toDouble()),
      ),
      deevee: (map['deevee'] as num?)?.toInt() ?? 0,
      goldGrains: (map['goldGrains'] as num?)?.toInt() ?? 0,
    );
  }

  Stock copyWith({
    Map<KafeType, double>? fruits,
    Map<KafeType, double>? grains,
    int? deevee,
    int? goldGrains,
  }) {
    return Stock(
      fruits: fruits ?? this.fruits,
      grains: grains ?? this.grains,
      deevee: deevee ?? this.deevee,
      goldGrains: goldGrains ?? this.goldGrains,
    );
  }
}

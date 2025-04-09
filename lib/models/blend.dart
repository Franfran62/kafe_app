import 'package:kafe_app/models/wrapper/gato_stats.dart';

class Blend {
  final String id;
  final String ownerId;
  final double totalWeight;
  final GatoStats stats;
  final DateTime createdAt;
  final bool submitted;

  const Blend({
    required this.id,
    required this.ownerId,
    required this.totalWeight,
    required this.stats,
    required this.createdAt,
    required this.submitted,
  });

  Map<String, dynamic> toMap() => {
    'ownerId': ownerId,
    'totalWeight': totalWeight,
    'stats': stats.toMap(),
    'createdAt': createdAt.toIso8601String(),
    'submitted': submitted,
  };

  factory Blend.fromMap(String id, Map<String, dynamic> map) => Blend(
    id: id,
    ownerId: map['ownerId'],
    totalWeight: (map['totalWeight'] as num).toDouble(),
    stats: GatoStats.fromMap(map['stats']),
    createdAt: DateTime.parse(map['createdAt']),
    submitted: map['submitted'] ?? false,
  );
}
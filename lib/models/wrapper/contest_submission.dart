import 'package:kafe_app/models/wrapper/gato_stats.dart';

class ContestSubmission {
  final String playerId;
  final GatoStats stats;
  final DateTime submittedAt;

  ContestSubmission({
    required this.playerId,
    required this.stats,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() => {
    'playerId': playerId,
    'stats': stats.toMap(),
    'submittedAt': submittedAt.toIso8601String(),
  };

  factory ContestSubmission.fromMap(Map<String, dynamic> map) => ContestSubmission(
    playerId: map['playerId'],
    stats: GatoStats.fromMap(map['stats']),
    submittedAt: DateTime.parse(map['submittedAt']),
  );
}
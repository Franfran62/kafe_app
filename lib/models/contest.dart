import 'package:kafe_app/models/wrapper/contest_submission.dart';

class Contest {
  final String id;
  final DateTime date;
  final bool completed;
  final String? winnerId;
  final String? winnerName;
  final List<ContestSubmission> participants;
  final List<String>? trialNames; 

  Contest({
    required this.id,
    required this.date,
    required this.completed,
    required this.winnerId,
    required this.winnerName,
    required this.participants,
    this.trialNames,
  });

  factory Contest.fromMap(String id, Map<String, dynamic> map, List<ContestSubmission> participations) {
    return Contest(
      id: id,
      date: DateTime.parse(id),
      completed: map['completed'],
      winnerId: map['winnerId'],
      winnerName: map['winnerName'],
      participants: participations,
      trialNames: List<String>.from(map['trialNames'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'completed': completed,
    'winnerId': winnerId,
    'winnerName': winnerName,
    'trialNames': trialNames,
  };

  Contest copyWith({
    bool? completed,
    String? winnerId,
    String? winnerName,
    List<String>? trialNames,
  }) {
    return Contest(
      id: id,
      date: date,
      completed: completed ?? this.completed,
      winnerId: winnerId ?? this.winnerId,
      winnerName: winnerName ?? this.winnerName,
      trialNames: trialNames ?? this.trialNames,
      participants: participants,
    );
  }
}

import 'package:kafe_app/models/wrapper/contest_submission.dart';

class Contest {
  final String id;
  final DateTime date;
  final bool completed;
  final String? winnerId;
  final String? winnerName;
  final List<ContestSubmission> participants;
  final List<String>? trialNames;
  final bool modalShownToWinner;

  Contest({
    required this.id,
    required this.date,
    required this.completed,
    required this.winnerId,
    required this.winnerName,
    required this.participants,
    this.trialNames,
    required this.modalShownToWinner,
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
      modalShownToWinner: map['modalShownToWinner'],
    );
  }

  Map<String, dynamic> toMap() => {
    'completed': completed,
    'winnerId': winnerId,
    'winnerName': winnerName,
    'trialNames': trialNames,
    'modalShownToWinner': modalShownToWinner,
  };

  Contest copyWith({
    bool? completed,
    String? winnerId,
    String? winnerName,
    List<String>? trialNames,
    bool? modalShownToWinner,  
  }) {
    return Contest(
      id: id,
      date: date,
      completed: completed ?? this.completed,
      winnerId: winnerId ?? this.winnerId,
      winnerName: winnerName ?? this.winnerName,
      trialNames: trialNames ?? this.trialNames,
      participants: participants,
      modalShownToWinner: modalShownToWinner ?? this.modalShownToWinner,
    );
  }
}

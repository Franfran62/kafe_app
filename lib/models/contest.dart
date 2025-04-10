import 'package:kafe_app/models/wrapper/contest_submission.dart';

class Contest {
  final DateTime hour;
  final List<ContestSubmission> participants;

  Contest({required this.hour, required this.participants});

  String get id => hour.toIso8601String();
}
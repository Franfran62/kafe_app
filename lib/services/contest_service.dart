import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe_app/models/wrapper/contest_submission.dart';

class ContestService {

  final _db = FirebaseFirestore.instance;

  String _getCurrentContestId() {
  final now = DateTime.now().toUtc();
  final base = DateTime.utc(now.year, now.month, now.day, now.hour, 19);
  final contestTime = now.isBefore(base)
      ? base
      : base.add(const Duration(hours: 1));

  return contestTime.toIso8601String();
}

  Future<void> submit(String playerId, ContestSubmission submission) async {
    final contestId = _getCurrentContestId();
    await _db
        .collection('contests')
        .doc(contestId)
        .collection('participants')
        .doc(playerId)
        .set(submission.toMap());
  }

  Future<ContestSubmission?> getSubmission(String playerId) async {
    final contestId = _getCurrentContestId();
    final doc = await _db
        .collection('contests')
        .doc(contestId)
        .collection('participants')
        .doc(playerId)
        .get();
    if (!doc.exists) return null;
    return ContestSubmission.fromMap(doc.data()!);
  }
}
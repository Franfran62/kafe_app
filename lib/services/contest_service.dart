import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe_app/models/contest.dart';
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

    final contestRef = _db.collection('contests').doc(contestId);
    final contestSnap = await contestRef.get();
    if (!contestSnap.exists) {
      await contestRef.set({
        'date': DateTime.parse(contestId),
        'completed': false,
        'winnerId': null,
        'winnerName': null,
        'modalShownToWinner': false
      });
    }

    await contestRef
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

  Future<List<Contest>> getAllContests() async {
    final snapshot = await _db.collection('contests').get();

    return Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data();
      final participationsSnap = await doc.reference.collection('participants').get();
      final participations = participationsSnap.docs.map((p) => ContestSubmission.fromMap(p.data())).toList();

      return Contest(
        id: doc.id,
        date: (data['date'] as Timestamp).toDate(),
        completed: data['completed'],
        winnerId: data['winnerId'],
        winnerName: data['winnerName'],
        participants: participations,
        modalShownToWinner: data['modalShownToWinner'],
      );
    }));
  }

  Future<void> saveContest(Contest contest) async {
    final docRef = _db.collection('contests').doc(contest.id);
    await docRef.update({
      'completed': contest.completed,
      'winnerId': contest.winnerId,
      'winnerName': contest.winnerName,
      'trialNames': contest.trialNames,
    });
  }

  Future<void> markModalAsShown(String contestId) async {
    await _db.collection('contests').doc(contestId).update({
      'modalShownToWinner': true,
    });
  }
}

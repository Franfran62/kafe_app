import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_config.dart';
import 'package:kafe_app/models/contest.dart';
import 'package:kafe_app/providers/stock_provider.dart';
import 'package:kafe_app/services/contest_service.dart';
import 'package:provider/provider.dart';

class GameContest {
  final ContestService _contestService = ContestService();

  Future<Contest?> checkAndRewardContest(BuildContext context, String playerId) async {
    final contest = await _findContestToJudge();
    if (contest == null || contest.participants.isEmpty) return null;
    
    final selectedTrials = _drawTrials();
    final scores = _computeAllScores(contest.participants, selectedTrials);
    final winnerId = _selectWinnerId(scores);
    final winner = _getParticipant(contest, winnerId);

    await _rewardWinner(context, winnerId);

    final updatedContest = _buildUpdatedContest(contest, winnerId, winner.playerId, selectedTrials);
    await _contestService.saveContest(updatedContest);

    return updatedContest;
  }

  /// Récupère le premier concours non terminé et déjà échu.
  Future<Contest?> _findContestToJudge() async {
    final now = DateTime.now();
    final contests = await _contestService.getAllContests();
    try { 
      return contests.firstWhere(
      (c) => !c.completed && c.date.isBefore(now)
    );
    } catch (e) {
      return null;
    }
  }

  /// Tire aléatoirement deux épreuves parmi les disponibles.
  List<String> _drawTrials() {
    final trials = [...GameConfig.contestTrials]..shuffle();
    return trials.take(2).toList();
  }

  /// Calcule les scores de chaque participant sur les deux épreuves.
  Map<String, double> _computeAllScores(List participants, List<String> trials) {
    return {
      for (var p in participants)
        p.playerId: trials.fold<double>(0, (sum, t) => sum + GameConfig.computeScore(t, p.stats))
    };
  }

  /// Retourne l'identifiant du joueur avec le score le plus élevé.
  String _selectWinnerId(Map<String, double> scores) {
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Trouve la soumission correspondant à un playerId.
  dynamic _getParticipant(Contest contest, String playerId) {
    return contest.participants.firstWhere((p) => p.playerId == playerId);
  }

  /// Récompense le joueur avec des DeeVee et de l'or.
  Future<void> _rewardWinner(BuildContext context, String playerId) async {
    final stock = context.read<StockProvider>();
    await stock.incrementDeevee(playerId, GameConfig.deeVeeForWinner);
    await stock.incrementGold(playerId, GameConfig.goldForWinner);
  }

  /// Construit une nouvelle instance du concours avec les infos mises à jour.
  Contest _buildUpdatedContest(
    Contest contest,
    String winnerId,
    String winnerName,
    List<String> trials,
  ) {
    return contest.copyWith(
      completed: true,
      winnerId: winnerId,
      winnerName: winnerName,
      trialNames: trials,
    );
  }
}

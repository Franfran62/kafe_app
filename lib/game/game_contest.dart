import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_config.dart';
import 'package:kafe_app/models/contest.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/providers/stock_provider.dart';
import 'package:kafe_app/services/contest_service.dart';
import 'package:kafe_app/services/player_service.dart';
import 'package:provider/provider.dart';

class GameContest {
  final ContestService _contestService = ContestService();

  Future<Contest?> checkAndRewardContest(BuildContext context) async {
    
    final player = context.read<PlayerProvider>().player;
    if (player == null) return null;

    final contest = await _findContestToJudge(player.uid);
    if (contest == null || contest.participants.isEmpty) return null;

    if (contest.completed) {
      if (contest.winnerId == player.uid && !contest.modalShownToWinner) {
        await _contestService.markModalAsShown(contest.id);
        return contest;
      }
      return null;
    }
  
    final selectedTrials = _drawTrials();
    final scores = _computeAllScores(contest.participants, selectedTrials);
    
    final winnerId = _selectWinnerId(scores);
    if (player.uid != winnerId) return null;

    final updatedContest = _buildUpdatedContest(contest, player, selectedTrials);
    await _contestService.saveContest(updatedContest);
    await _rewardWinner(context, winnerId);

    return updatedContest;
  }

  ///  Cherche un concours non jugé
  ///  Et cherche un concours gagné par le joueur, mais dont le modal n'a pas été montré.
  Future<Contest?> _findContestToJudge(String playerId) async {
    final now = DateTime.now();
    final contests = await _contestService.getAllContests();

    try {
      return contests.firstWhere(
        (c) => !c.completed && c.date.isBefore(now),
      );
    } catch (_) {}
    try {
      return contests.firstWhere(
        (c) => c.completed && c.winnerId == playerId && !c.modalShownToWinner,
      );
    } catch (_) {}

    return null;
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

  /// Récompense le joueur avec des DeeVee et de l'or.
  Future<void> _rewardWinner(BuildContext context, String playerId) async {
    final stock = context.read<StockProvider>();
    await stock.incrementDeevee(playerId, GameConfig.deeVeeForWinner);
    await stock.incrementGold(playerId, GameConfig.goldForWinner);
  }

  /// Construit une nouvelle instance du concours avec les infos mises à jour.
  Contest _buildUpdatedContest(
    Contest contest,
    Player winner,
    List<String> trials,
  ) {
    return contest.copyWith(
      completed: true,
      winnerId: winner.uid,
      winnerName: "${winner.name} ${winner.firstname}",
      trialNames: trials,
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_contest.dart';
import 'package:kafe_app/widgets/modals/contest_result_modal.dart';
import 'package:provider/provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:kafe_app/main.dart';

class ContestChecker extends StatefulWidget {
  const ContestChecker({super.key});

  @override
  State<ContestChecker> createState() => _ContestCheckerState();
}

class _ContestCheckerState extends State<ContestChecker> {
  Timer? _timer;
  bool _isChecking = false;
  final GameContest _gameContest = GameContest();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _check());
    SchedulerBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    if (_isChecking || !mounted) return;
    _isChecking = true;
    try {
        final contest = await _gameContest.checkAndRewardContest(context);
        if (contest != null) {
          _showWinnerDialog(contest.trialNames ?? []);
        }
    } finally {
      _isChecking = false;
    }
  }


 void _showWinnerDialog(List<String> trials) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => ContestResultModal(trials: trials),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

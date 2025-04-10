// 📁 screens/contest_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/models/wrapper/contest_submission.dart';
import 'package:provider/provider.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/services/contest_service.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/services/helper/clean_double.dart';
import 'package:kafe_app/game/game_asset.dart';

class ContestScreen extends StatefulWidget {
  const ContestScreen({super.key});

  @override
  State<ContestScreen> createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  ContestSubmission? _submission;
  Duration _timeUntilNext = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    _updateTimer();
  }

  void _updateTimer() {
    final now = DateTime.now();
    final next = DateTime(now.year, now.month, now.day, now.hour, 19);
    final nextSlot = now.isAfter(next) ? next.add(const Duration(hours: 1)) : next;
    setState(() {
      _timeUntilNext = nextSlot.difference(now);
      _timer = Timer.periodic(const Duration(seconds: 60), (_) => _updateTimer());
    });
  }

  Future<void> _load() async {
    final player = context.read<PlayerProvider>().player;
    if (player == null) return;
    final submission = await ContestService().getSubmission(player.uid);
    setState(() => _submission = submission);
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Concours ${GameAsset.contestEmoji}", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text("Prochain concours dans : ${_timeUntilNext.inMinutes} min", style: Theme.of(context).textTheme.bodyLarge),
           const SizedBox(height: 12),
          Text("Ta participation ${GameAsset.kafeEmoji}", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          if (_submission != null) ...[
            Text("Ta participation :", style: Theme.of(context).textTheme.titleMedium),
            ...{
              'Goût': _submission!.stats.gout,
              'Amertume': _submission!.stats.amertume,
              'Teneur': _submission!.stats.teneur,
              'Odorat': _submission!.stats.odorat,
            }.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 90, child: Text(e.key)),
                  Text(e.value.toCleanString(), style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ))
          ] else
            const Text("Tu n'as pas encore participé au concours actuel."),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => GoRouter.of(context).go('/?tab=2'),
                icon: const Icon(Icons.coffee),
                label: const Text("Assembler un kafé"),
              ),
            ),
        ],
      ),
    );
  }
}

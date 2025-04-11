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

    if (!mounted) return;
    setState(() {
      _timeUntilNext = nextSlot.difference(now);
      _timer = Timer.periodic(const Duration(seconds: 60), (_) => _updateTimer());
    });
  }

  Future<void> _load() async {
    if (_submission != null) return; 

    final player = context.read<PlayerProvider>().player;
    if (player == null) return;

    final submission = await ContestService().getSubmission(player.uid);
    if (mounted) {
      setState(() => _submission = submission);
    }
  }

  Duration timeUntilNextContest() {
    final now = DateTime.now();
    final currentHour = DateTime(now.year, now.month, now.day, now.hour, 19);
    
    if (now.isBefore(currentHour)) {
      return currentHour.difference(now);
    } else {
      final nextHour = currentHour.add(const Duration(hours: 1));
      return nextHour.difference(now); 
    }
  }

  @override
  Widget build(BuildContext context) {

    final remaining = timeUntilNextContest();
    final minutes = remaining.inMinutes;
    String message = remaining.inSeconds < 60
         ? "⏳ Concours imminent..."
         : "Prochain concours dans $minutes minute${minutes > 1 ? 's' : ''}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text("Concours ${GameAsset.contestEmoji}", style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text("Ta participation ${GameAsset.kafeEmoji}", style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 12),
          if (_submission != null) ...[
            ...{
              'Goût': _submission!.stats.gout,
              'Amertume': _submission!.stats.amertume,
              'Teneur': _submission!.stats.teneur,
              'Odorat': _submission!.stats.odorat,
            }.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 90, child: Text(e.key)),
                    Text("${e.value.toCleanString()} / 100", style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            )
          ] else 
            Column(
              children: [
                const Text("Tu n'as pas encore participé au concours actuel."),
                const Text("Assemble un Kafé pour participer !")
              ],
            ),
        ],
      ),
    );
  }
}

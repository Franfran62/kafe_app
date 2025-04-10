import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';

class ContestResultModal extends StatelessWidget {
  final List<String> trials;

  const ContestResultModal({
    super.key,
    required this.trials,
  });

  String _formatTrialName(String raw) {
    return raw[0].toUpperCase() + raw.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final formattedTrials = trials.map(_formatTrialName).toList();

    return AlertDialog(
      title: const Text("🏆 Bravo !"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ton Kafé a remporté le concours ! ${GameAsset.contestWinnerEmoji}"),
          const SizedBox(height: 8),
          const Text("${GameAsset.deeveeEmoji} 3 DeeVee"),
          const Text("${GameAsset.goldGrainEmoji} 2 grains d’or"),
          const SizedBox(height: 12),
          const Text("Épreuves du concours :"),
          for (final trial in formattedTrials) Text("- $trial"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        )
      ],
    );
  }
}

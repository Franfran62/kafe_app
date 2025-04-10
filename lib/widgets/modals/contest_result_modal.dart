import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:lottie/lottie.dart';

class ContestResultModal extends StatelessWidget {
  final List<String> trials;

  const ContestResultModal({
    super.key,
    required this.trials,
  });

  String _formatTrial(String raw) {
    return raw[0].toUpperCase() + raw.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final formattedTrials = trials.map(_formatTrial).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/trophy.json',
              height: 160,
              repeat: false,
            ),

            const SizedBox(height: 8),
            const Text(
              "Bravo !",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              "Ton Kafé a remporté le concours !",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Row(
                    children: [
                      Text(GameAsset.deeveeEmoji, style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Text("3 DeeVee"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(GameAsset.goldGrainEmoji, style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Text("2 grains d’or"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Épreuves du concours :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            ...formattedTrials.map((t) => Align(
              alignment: Alignment.centerLeft,
              child: Text("• $t"),
            )),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Continuer"),
            )
          ],
        ),
      ),
    );
  }
}

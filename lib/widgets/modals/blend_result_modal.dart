import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/game/game_controller.dart';
import 'package:kafe_app/models/blend.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/services/contest_service.dart';
import 'package:kafe_app/services/helper/clean_double.dart';
import 'package:provider/provider.dart';

Future<void> showBlendResultModal(BuildContext context, Blend blend) async {

  final GameController _gameController = GameController();
  final player = context.read<PlayerProvider>().player;

  bool alreadySubmitted = false;
  if (player != null) {
    final contestService = ContestService();
    final submission = await contestService.getSubmission(player.uid);
    alreadySubmitted = submission != null;
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Center(child: Text("Kafé créé avec succès !", style: Theme.of(context).textTheme.titleLarge)),
            const SizedBox(height: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                for (final entry in {
                  'Goût': blend.stats.gout,
                  'Amertume': blend.stats.amertume,
                  'Teneur': blend.stats.teneur,
                  'Odorat': blend.stats.odorat,
                }.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Row(
                      children: [
                        Text("${entry.key} :", style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(width: 12),
                        Text("${entry.value.toCleanString()}", style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.emoji_events),
                      label: Text(alreadySubmitted ? "Déjà soumis" : "Soumettre au concours"),
                      onPressed: alreadySubmitted ? null : () async {
                        _gameController.submitBlendToContest(context: context, blend: blend);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kafé soumis au concours")),
                        );
                      }, 
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.sell),
                      label: Text("Vendre +3 DeeVee ${GameAsset.deeveeEmoji}"),
                      onPressed: () async {
                        await _gameController.sellBlend(context: context, blend: blend);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kafé vendu (+3 DeeVee)"),
                          ),
                        );
                      }, 
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
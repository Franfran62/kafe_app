import 'package:flutter/material.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/rules/game_config.dart';
import 'package:kafe_app/styles/game_asset.dart';

Future<KafeType?> showPlantingModal(BuildContext context) async {
  return await showModalBottomSheet<KafeType>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${GameAsset.FruitEmoji} Choisis un fruit à planter",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...KafeType.values.map((type) {
              final cost = GameConfig.costFor(type);
              final time = GameConfig.growthTimes[type]!;
              final duration = _formatDuration(time);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  onTap: () => Navigator.of(context).pop(type),
                  title: Text(type.label),
                  subtitle: Text("Temps de pousse : $duration"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("$cost ${GameAsset.deeveeEmoji}", style: Theme.of(context).textTheme.bodyMedium,),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    },
  );
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;

  if (minutes == 0) return "$seconds sec";
  return "$minutes min${seconds > 0 ? " $seconds sec" : ""}";
}

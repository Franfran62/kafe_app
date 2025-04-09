import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/game/game_config.dart';

Future<double?> showDryingModal({
  required BuildContext context,
  required KafeType type,
  required double availableAmount,
}) async {
  final controller =
      TextEditingController(text: availableAmount.toStringAsFixed(2));
  double previewOutput = availableAmount * (1 - GameConfig.dryingLossRatio);

  return await showModalBottomSheet<double>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                        "Séchage de ${type.label} ${GameAsset.FruitEmoji}",
                        style: Theme.of(context).textTheme.headlineSmall)),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                      "Une perte de 4,58% de matière est appliquée lors du séchage."),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: "Quantité à sécher (g)"),
                    onChanged: (value) {
                      final input =
                          double.tryParse(value.replaceAll(',', '.')) ?? 0;
                      setState(() {
                        previewOutput =
                            input * (1 - GameConfig.dryingLossRatio);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                      "Quantité disponible : ${availableAmount.toStringAsFixed(2)} g"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                      "Résultat estimé : ${previewOutput.toStringAsFixed(2)} g"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text("Annuler"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text("Sécher"),
                        onPressed: () {
                          final input = double.tryParse(
                                  controller.text.replaceAll(',', '.')) ??
                              0;
                          if (input > 0 && input <= availableAmount) {
                            Navigator.of(context).pop(input);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

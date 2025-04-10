import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/game/game_config.dart';
import 'package:kafe_app/game/game_controller.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/providers/stock_provider.dart';
import 'package:kafe_app/services/helper/round_double.dart';
import 'package:kafe_app/widgets/modals/drying_modal.dart';
import 'package:kafe_app/widgets/modals/drying_result_modal.dart';
import 'package:provider/provider.dart';

class DryingScreen extends StatelessWidget {
  const DryingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>().stock;
    if (stock == null) return const Center(child: CircularProgressIndicator());

    final fruits = stock.fruits.entries;
    final grains = stock.grains.entries;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (fruits.isEmpty)
          const Center(child: Text("Aucun fruit à sécher.")),

        if (fruits.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              "Stock de Fruits ${GameAsset.FruitEmoji}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ...fruits.map((entry) {
            final type = entry.key;
            final amount = entry.value;
            final isEnough = roundDouble(amount) > 0.01;

            return Card(
              child: ListTile(
                title: Text("${GameAsset.FruitEmoji} ${type.label}"),
                subtitle: Text(
                  !isEnough
                      ? "Pas de stock"
                      : "${amount.toStringAsFixed(2)} kg disponible",
                ),
                trailing: isEnough
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "À sécher",
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
                onTap: () async {
                  if (isEnough) {
                    final toDry = await showDryingModal(
                      context: context,
                      type: type,
                      availableAmount: amount,
                    );

                    if (toDry != null) {
                      await GameController().dryFruit(
                        context: context,
                        type: type,
                        amount: toDry,
                      );

                      final finalAmount =
                          toDry * (1 - GameConfig.dryingLossRatio);
                      showDialog(
                        context: context,
                        builder: (_) => DryingResultModal(
                          type: type,
                          resultAmount: finalAmount,
                        ),
                      );
                    }
                  }
                },
              ),
            );
          }),
        ],

        const SizedBox(height: 32),
        Text(
          "Stock de Grains ${GameAsset.GrainEmoji}",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        ...grains.map((entry) {
          final type = entry.key;
          final available = entry.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(type.label),
              Text(
                "${available.toStringAsFixed(2)} kg",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          );
        }),
      ],
    );
  }
}
